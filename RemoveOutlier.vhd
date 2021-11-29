LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.HDLLaneDetector_pkg.ALL;

ENTITY RemoveOutlier IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        laneVal                           :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        offsetVal                         :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
        width                             :   IN    std_logic_vector(17 DOWNTO 0);  -- sfix18
        Inlier                            :   OUT   std_logic_vector(15 DOWNTO 0)  -- uint16
        );
END RemoveOutlier;


ARCHITECTURE rtl OF RemoveOutlier IS

  -- Signals
  SIGNAL offsetVal_signed                 : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL width_signed                     : signed(17 DOWNTO 0);  -- sfix18
  SIGNAL Relational_Operator_relop1       : std_logic;
  SIGNAL Delay13_out1                     : std_logic;
  SIGNAL Constant2_out1                   : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Delay14_out1                     : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL laneVal_unsigned                 : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL delayMatch_reg                   : vector_of_unsigned16(0 TO 6);  -- ufix16 [7]
  SIGNAL Delay14_out1_1                   : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Delay15_out1                     : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay15_out1_dtc                 : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Multiport_Switch_out1            : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Delay17_out1                     : unsigned(15 DOWNTO 0);  -- uint16

BEGIN
  offsetVal_signed <= signed(offsetVal);

  width_signed <= signed(width);

  
  Relational_Operator_relop1 <= '1' WHEN resize(offsetVal_signed, 18) <= width_signed ELSE
      '0';

  Delay13_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay13_out1 <= '0';
      ELSIF enb = '1' THEN
        Delay13_out1 <= Relational_Operator_relop1;
      END IF;
    END IF;
  END PROCESS Delay13_process;


  Constant2_out1 <= to_unsigned(16#0000#, 16);

  Delay14_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay14_out1 <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay14_out1 <= Constant2_out1;
      END IF;
    END IF;
  END PROCESS Delay14_process;


  laneVal_unsigned <= unsigned(laneVal);

  delayMatch_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        delayMatch_reg <= (OTHERS => to_unsigned(16#0000#, 16));
      ELSIF enb = '1' THEN
        delayMatch_reg(0) <= Delay14_out1;
        delayMatch_reg(1 TO 6) <= delayMatch_reg(0 TO 5);
      END IF;
    END IF;
  END PROCESS delayMatch_process;

  Delay14_out1_1 <= delayMatch_reg(6);

  Delay15_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay15_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        Delay15_out1 <= laneVal_unsigned;
      END IF;
    END IF;
  END PROCESS Delay15_process;


  Delay15_out1_dtc <= resize(Delay15_out1, 16);

  
  Multiport_Switch_out1 <= Delay14_out1_1 WHEN Delay13_out1 = '0' ELSE
      Delay15_out1_dtc;

  Delay17_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay17_out1 <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay17_out1 <= Multiport_Switch_out1;
      END IF;
    END IF;
  END PROCESS Delay17_process;


  Inlier <= std_logic_vector(Delay17_out1);

END rtl;

