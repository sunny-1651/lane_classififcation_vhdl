LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ZeroCrossingDetection IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        peakIndex                         :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        peakVal                           :   IN    std_logic_vector(30 DOWNTO 0);  -- sfix31_En10
        zeroCrossingTrue                  :   OUT   std_logic
        );
END ZeroCrossingDetection;


ARCHITECTURE rtl OF ZeroCrossingDetection IS

  -- Signals
  SIGNAL peakIndex_unsigned               : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Compare_To_Constant12_out1       : std_logic;
  SIGNAL Compare_To_Constant11_out1       : std_logic;
  SIGNAL peakVal_signed                   : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL delayMatch1_reg                  : std_logic_vector(0 TO 6);  -- ufix1 [7]
  SIGNAL Compare_To_Constant12_out1_1     : std_logic;
  SIGNAL delayMatch_reg                   : std_logic_vector(0 TO 6);  -- ufix1 [7]
  SIGNAL Compare_To_Constant11_out1_1     : std_logic;
  SIGNAL Compare_To_Zero_out1             : std_logic;
  SIGNAL Delay6_out1                      : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL Compare_To_Zero1_out1            : std_logic;
  SIGNAL Logical_Operator_out1            : std_logic;
  SIGNAL Logical_Operator17_out1          : std_logic;
  SIGNAL Logical_Operator18_out1          : std_logic;

BEGIN
  peakIndex_unsigned <= unsigned(peakIndex);

  
  Compare_To_Constant12_out1 <= '1' WHEN peakIndex_unsigned > to_unsigned(16#005#, 10) ELSE
      '0';

  
  Compare_To_Constant11_out1 <= '1' WHEN peakIndex_unsigned < to_unsigned(16#2BC#, 10) ELSE
      '0';

  peakVal_signed <= signed(peakVal);

  delayMatch1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        delayMatch1_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        delayMatch1_reg(0) <= Compare_To_Constant12_out1;
        delayMatch1_reg(1 TO 6) <= delayMatch1_reg(0 TO 5);
      END IF;
    END IF;
  END PROCESS delayMatch1_process;

  Compare_To_Constant12_out1_1 <= delayMatch1_reg(6);

  delayMatch_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        delayMatch_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        delayMatch_reg(0) <= Compare_To_Constant11_out1;
        delayMatch_reg(1 TO 6) <= delayMatch_reg(0 TO 5);
      END IF;
    END IF;
  END PROCESS delayMatch_process;

  Compare_To_Constant11_out1_1 <= delayMatch_reg(6);

  
  Compare_To_Zero_out1 <= '1' WHEN peakVal_signed < to_signed(16#00000000#, 31) ELSE
      '0';

  Delay6_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay6_out1 <= to_signed(16#00000000#, 31);
      ELSIF enb = '1' THEN
        Delay6_out1 <= peakVal_signed;
      END IF;
    END IF;
  END PROCESS Delay6_process;


  
  Compare_To_Zero1_out1 <= '1' WHEN Delay6_out1 >= to_signed(16#00000000#, 31) ELSE
      '0';

  Logical_Operator_out1 <= Compare_To_Zero_out1 AND Compare_To_Zero1_out1;

  Logical_Operator17_out1 <= Compare_To_Constant11_out1_1 AND Logical_Operator_out1;

  Logical_Operator18_out1 <= Compare_To_Constant12_out1_1 AND Logical_Operator17_out1;

  zeroCrossingTrue <= Logical_Operator18_out1;

END rtl;

