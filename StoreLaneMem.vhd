LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.HDLLaneDetector_pkg.ALL;

ENTITY StoreLaneMem IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        LaneREGData                       :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        LaneREG1En                        :   IN    std_logic;
        LaneREG2En                        :   IN    std_logic;
        LaneREG3En                        :   IN    std_logic;
        LaneREG5En                        :   IN    std_logic;
        LaneREG4En                        :   IN    std_logic;
        LaneREG6En                        :   IN    std_logic;
        LaneREG7En                        :   IN    std_logic;
        laneREGRST                        :   IN    std_logic;
        lane1                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane2                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane3                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane4                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane5                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane6                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane7                             :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
        );
END StoreLaneMem;


ARCHITECTURE rtl OF StoreLaneMem IS

  -- Signals
  SIGNAL reduced_reg                      : std_logic_vector(0 TO 6);  -- ufix1 [7]
  SIGNAL laneREGRST_1                     : std_logic;
  SIGNAL LaneREGData_unsigned             : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL reduced_reg_1                    : vector_of_unsigned10(0 TO 6);  -- ufix10 [7]
  SIGNAL LaneREGData_1                    : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay10_out1                     : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay11_out1                     : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay12_out1                     : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay13_out1                     : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay14_out1                     : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay15_out1                     : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay16_out1                     : unsigned(9 DOWNTO 0);  -- ufix10

BEGIN
  reduced_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        reduced_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        reduced_reg(0) <= laneREGRST;
        reduced_reg(1 TO 6) <= reduced_reg(0 TO 5);
      END IF;
    END IF;
  END PROCESS reduced_process;

  laneREGRST_1 <= reduced_reg(6);

  LaneREGData_unsigned <= unsigned(LaneREGData);

  reduced_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        reduced_reg_1 <= (OTHERS => to_unsigned(16#000#, 10));
      ELSIF enb = '1' THEN
        reduced_reg_1(0) <= LaneREGData_unsigned;
        reduced_reg_1(1 TO 6) <= reduced_reg_1(0 TO 5);
      END IF;
    END IF;
  END PROCESS reduced_1_process;

  LaneREGData_1 <= reduced_reg_1(6);

  Delay10_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay10_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        IF laneREGRST_1 = '1' THEN
          Delay10_out1 <= to_unsigned(16#000#, 10);
        ELSIF LaneREG1En = '1' THEN
          Delay10_out1 <= LaneREGData_1;
        END IF;
      END IF;
    END IF;
  END PROCESS Delay10_process;


  lane1 <= std_logic_vector(Delay10_out1);

  Delay11_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay11_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        IF laneREGRST_1 = '1' THEN
          Delay11_out1 <= to_unsigned(16#000#, 10);
        ELSIF LaneREG2En = '1' THEN
          Delay11_out1 <= LaneREGData_1;
        END IF;
      END IF;
    END IF;
  END PROCESS Delay11_process;


  lane2 <= std_logic_vector(Delay11_out1);

  Delay12_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay12_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        IF laneREGRST_1 = '1' THEN
          Delay12_out1 <= to_unsigned(16#000#, 10);
        ELSIF LaneREG3En = '1' THEN
          Delay12_out1 <= LaneREGData_1;
        END IF;
      END IF;
    END IF;
  END PROCESS Delay12_process;


  lane3 <= std_logic_vector(Delay12_out1);

  Delay13_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay13_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        IF laneREGRST_1 = '1' THEN
          Delay13_out1 <= to_unsigned(16#000#, 10);
        ELSIF LaneREG4En = '1' THEN
          Delay13_out1 <= LaneREGData_1;
        END IF;
      END IF;
    END IF;
  END PROCESS Delay13_process;


  lane4 <= std_logic_vector(Delay13_out1);

  Delay14_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay14_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        IF laneREGRST_1 = '1' THEN
          Delay14_out1 <= to_unsigned(16#000#, 10);
        ELSIF LaneREG5En = '1' THEN
          Delay14_out1 <= LaneREGData_1;
        END IF;
      END IF;
    END IF;
  END PROCESS Delay14_process;


  lane5 <= std_logic_vector(Delay14_out1);

  Delay15_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay15_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        IF laneREGRST_1 = '1' THEN
          Delay15_out1 <= to_unsigned(16#000#, 10);
        ELSIF LaneREG6En = '1' THEN
          Delay15_out1 <= LaneREGData_1;
        END IF;
      END IF;
    END IF;
  END PROCESS Delay15_process;


  lane6 <= std_logic_vector(Delay15_out1);

  Delay16_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay16_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        IF laneREGRST_1 = '1' THEN
          Delay16_out1 <= to_unsigned(16#000#, 10);
        ELSIF LaneREG7En = '1' THEN
          Delay16_out1 <= LaneREGData_1;
        END IF;
      END IF;
    END IF;
  END PROCESS Delay16_process;


  lane7 <= std_logic_vector(Delay16_out1);

END rtl;

