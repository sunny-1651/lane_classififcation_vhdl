LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.HDLLaneDetector_pkg.ALL;

ENTITY CtrlInterface IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        LaneLeftin                        :   IN    std_logic_vector(15 DOWNTO 0);  -- uint16
        LaneRightin                       :   IN    std_logic_vector(15 DOWNTO 0);  -- uint16
        enable                            :   IN    std_logic;
        hwStart                           :   IN    std_logic;
        hwDone                            :   IN    std_logic;
        swStart                           :   IN    std_logic;
        LaneLeftout                       :   OUT   vector_of_std_logic_vector16(0 TO 39);  -- uint16 [40]
        LaneRightout                      :   OUT   vector_of_std_logic_vector16(0 TO 39);  -- uint16 [40]
        dataReady                         :   OUT   std_logic
        );
END CtrlInterface;


ARCHITECTURE rtl OF CtrlInterface IS

  -- Signals
  SIGNAL LaneLeftin_unsigned              : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL LaneRightin_unsigned             : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL delayMatch_reg                   : std_logic_vector(0 TO 6);  -- ufix1 [7]
  SIGNAL enable_1                         : std_logic;
  SIGNAL delayMatch1_reg                  : std_logic_vector(0 TO 6);  -- ufix1 [7]
  SIGNAL hwStart_1                        : std_logic;
  SIGNAL delayMatch2_reg                  : std_logic_vector(0 TO 6);  -- ufix1 [7]
  SIGNAL hwDone_1                         : std_logic;
  SIGNAL delayMatch3_reg                  : std_logic_vector(0 TO 6);  -- ufix1 [7]
  SIGNAL swStart_1                        : std_logic;
  SIGNAL LaneLeftout_tmp                  : vector_of_unsigned16(0 TO 39);  -- uint16 [40]
  SIGNAL LaneRightout_tmp                 : vector_of_unsigned16(0 TO 39);  -- uint16 [40]
  SIGNAL regLaneLeft                      : vector_of_unsigned16(0 TO 39);  -- uint16 [40]
  SIGNAL regLaneRight                     : vector_of_unsigned16(0 TO 39);  -- uint16 [40]
  SIGNAL FSMState                         : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL regLaneLeft_next                 : vector_of_unsigned16(0 TO 39);  -- uint16 [40]
  SIGNAL regLaneRight_next                : vector_of_unsigned16(0 TO 39);  -- uint16 [40]
  SIGNAL FSMState_next                    : unsigned(7 DOWNTO 0);  -- uint8

BEGIN
  LaneLeftin_unsigned <= unsigned(LaneLeftin);

  LaneRightin_unsigned <= unsigned(LaneRightin);

  delayMatch_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        delayMatch_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        delayMatch_reg(0) <= enable;
        delayMatch_reg(1 TO 6) <= delayMatch_reg(0 TO 5);
      END IF;
    END IF;
  END PROCESS delayMatch_process;

  enable_1 <= delayMatch_reg(6);

  delayMatch1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        delayMatch1_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        delayMatch1_reg(0) <= hwStart;
        delayMatch1_reg(1 TO 6) <= delayMatch1_reg(0 TO 5);
      END IF;
    END IF;
  END PROCESS delayMatch1_process;

  hwStart_1 <= delayMatch1_reg(6);

  delayMatch2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        delayMatch2_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        delayMatch2_reg(0) <= hwDone;
        delayMatch2_reg(1 TO 6) <= delayMatch2_reg(0 TO 5);
      END IF;
    END IF;
  END PROCESS delayMatch2_process;

  hwDone_1 <= delayMatch2_reg(6);

  delayMatch3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        delayMatch3_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        delayMatch3_reg(0) <= swStart;
        delayMatch3_reg(1 TO 6) <= delayMatch3_reg(0 TO 5);
      END IF;
    END IF;
  END PROCESS delayMatch3_process;

  swStart_1 <= delayMatch3_reg(6);

  CtrlInterface_1_process : PROCESS (clk)
    VARIABLE t_1 : INTEGER;
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN

        FOR t_1 IN 0 TO 39 LOOP
          regLaneLeft(t_1) <= to_unsigned(16#0000#, 16);
          regLaneRight(t_1) <= to_unsigned(16#0000#, 16);
        END LOOP;

        FSMState <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN

        FOR t_0 IN 0 TO 39 LOOP
          regLaneLeft(t_0) <= regLaneLeft_next(t_0);
          regLaneRight(t_0) <= regLaneRight_next(t_0);
        END LOOP;

        FSMState <= FSMState_next;
      END IF;
    END IF;
  END PROCESS CtrlInterface_1_process;

  CtrlInterface_1_output : PROCESS (FSMState, LaneLeftin_unsigned, LaneRightin_unsigned, enable_1, hwDone_1,
       hwStart_1, regLaneLeft, regLaneRight, swStart_1)
    VARIABLE regLaneLeft_temp : vector_of_unsigned16(0 TO 39);
    VARIABLE regLaneRight_temp : vector_of_unsigned16(0 TO 39);
  BEGIN

    FOR t_0 IN 0 TO 39 LOOP
      regLaneLeft_temp(t_0) := regLaneLeft(t_0);
      regLaneRight_temp(t_0) := regLaneRight(t_0);
    END LOOP;

    FSMState_next <= FSMState;
    -- define states
    CASE FSMState IS
      WHEN "00000000" =>
        --Wait for SW and HW to be ready
        dataReady <= '0';
        IF (swStart_1 AND hwStart_1) = '1' THEN 
          FSMState_next <= to_unsigned(16#01#, 8);
        ELSE 
          FSMState_next <= to_unsigned(16#00#, 8);
        END IF;
      WHEN "00000001" =>
        --buffer vectors
        dataReady <= '0';
        IF enable_1 = '1' THEN 
          regLaneLeft_temp(0) := LaneLeftin_unsigned;
          regLaneRight_temp(0) := LaneRightin_unsigned;

          FOR t_2 IN 0 TO 38 LOOP
            regLaneLeft_temp(t_2 + 1) := regLaneLeft(t_2);
            regLaneRight_temp(t_2 + 1) := regLaneRight(t_2);
          END LOOP;

        END IF;
        IF hwDone_1 = '1' THEN 
          FSMState_next <= to_unsigned(16#02#, 8);
        ELSE 
          FSMState_next <= to_unsigned(16#01#, 8);
        END IF;
      WHEN "00000010" =>
        -- wait for sw ack (sw ready low)
        dataReady <= '1';
        IF ( NOT swStart_1) = '1' THEN 
          FSMState_next <= to_unsigned(16#00#, 8);
        ELSE 
          FSMState_next <= to_unsigned(16#02#, 8);
        END IF;
      WHEN OTHERS => 
        dataReady <= '0';
        FSMState_next <= to_unsigned(16#00#, 8);
    END CASE;

    FOR t_1 IN 0 TO 39 LOOP
      LaneLeftout_tmp(t_1) <= regLaneLeft_temp(t_1);
      LaneRightout_tmp(t_1) <= regLaneRight_temp(t_1);
      regLaneLeft_next(t_1) <= regLaneLeft_temp(t_1);
      regLaneRight_next(t_1) <= regLaneRight_temp(t_1);
    END LOOP;

  END PROCESS CtrlInterface_1_output;


  outputgen1: FOR k IN 0 TO 39 GENERATE
    LaneLeftout(k) <= std_logic_vector(LaneLeftout_tmp(k));
  END GENERATE;

  outputgen: FOR k IN 0 TO 39 GENERATE
    LaneRightout(k) <= std_logic_vector(LaneRightout_tmp(k));
  END GENERATE;

END rtl;

