LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY findMin IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        peakVal1                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
        peakVal2                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
        peakVal3                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
        peakVal4                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
        peakVal5                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
        PeakVal6                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
        peakVal7                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
        minInd                            :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
        minVal                            :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En10
        );
END findMin;


ARCHITECTURE rtl OF findMin IS

  -- Signals
  SIGNAL peakVal7_signed                  : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Delay12_out1                     : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL PeakVal6_signed                  : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Delay9_out1                      : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL peakVal5_signed                  : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Delay8_out1                      : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Relational_Operator2_relop1      : std_logic;
  SIGNAL Multiport_Switch2_out1           : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Relational_Operator3_relop1      : std_logic;
  SIGNAL Multiport_Switch3_out1           : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Delay15_out1                     : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL peakVal4_signed                  : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Delay5_out1                      : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL peakVal3_signed                  : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Delay4_out1                      : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Relational_Operator1_relop1      : std_logic;
  SIGNAL Multiport_Switch1_out1           : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL peakVal2_signed                  : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Delay3_out1                      : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL peakVal1_signed                  : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Delay2_out1                      : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Relational_Operator_relop1       : std_logic;
  SIGNAL Multiport_Switch_out1            : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Relational_Operator4_relop1      : std_logic;
  SIGNAL Multiport_Switch4_out1           : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Delay13_out1                     : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Relational_Operator5_relop1      : std_logic;
  SIGNAL Constant_out1                    : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Delay_out1                       : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Constant1_out1                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Delay1_out1                      : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Multiport_Switch6_out1           : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Constant2_out1                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Delay6_out1                      : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Constant3_out1                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Delay7_out1                      : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Multiport_Switch7_out1           : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Multiport_Switch8_out1           : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Delay14_out1                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Constant4_out1                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Delay19_out1                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Constant5_out1                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Delay10_out1                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Constant6_out1                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Delay11_out1                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Multiport_Switch10_out1          : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Multiport_Switch9_out1           : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Delay16_out1                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Multiport_Switch11_out1          : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Delay18_out1                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Multiport_Switch5_out1           : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Delay17_out1                     : signed(31 DOWNTO 0);  -- sfix32_En10

BEGIN
  peakVal7_signed <= signed(peakVal7);

  Delay12_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay12_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        Delay12_out1 <= peakVal7_signed;
      END IF;
    END IF;
  END PROCESS Delay12_process;


  PeakVal6_signed <= signed(PeakVal6);

  Delay9_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay9_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        Delay9_out1 <= PeakVal6_signed;
      END IF;
    END IF;
  END PROCESS Delay9_process;


  peakVal5_signed <= signed(peakVal5);

  Delay8_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay8_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        Delay8_out1 <= peakVal5_signed;
      END IF;
    END IF;
  END PROCESS Delay8_process;


  
  Relational_Operator2_relop1 <= '1' WHEN Delay9_out1 < Delay8_out1 ELSE
      '0';

  
  Multiport_Switch2_out1 <= Delay8_out1 WHEN Relational_Operator2_relop1 = '0' ELSE
      Delay9_out1;

  
  Relational_Operator3_relop1 <= '1' WHEN Delay12_out1 < Multiport_Switch2_out1 ELSE
      '0';

  
  Multiport_Switch3_out1 <= Delay12_out1 WHEN Relational_Operator3_relop1 = '0' ELSE
      Multiport_Switch2_out1;

  Delay15_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay15_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        Delay15_out1 <= Multiport_Switch3_out1;
      END IF;
    END IF;
  END PROCESS Delay15_process;


  peakVal4_signed <= signed(peakVal4);

  Delay5_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay5_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        Delay5_out1 <= peakVal4_signed;
      END IF;
    END IF;
  END PROCESS Delay5_process;


  peakVal3_signed <= signed(peakVal3);

  Delay4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay4_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        Delay4_out1 <= peakVal3_signed;
      END IF;
    END IF;
  END PROCESS Delay4_process;


  
  Relational_Operator1_relop1 <= '1' WHEN Delay5_out1 < Delay4_out1 ELSE
      '0';

  
  Multiport_Switch1_out1 <= Delay4_out1 WHEN Relational_Operator1_relop1 = '0' ELSE
      Delay5_out1;

  peakVal2_signed <= signed(peakVal2);

  Delay3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay3_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        Delay3_out1 <= peakVal2_signed;
      END IF;
    END IF;
  END PROCESS Delay3_process;


  peakVal1_signed <= signed(peakVal1);

  Delay2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay2_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        Delay2_out1 <= peakVal1_signed;
      END IF;
    END IF;
  END PROCESS Delay2_process;


  
  Relational_Operator_relop1 <= '1' WHEN Delay3_out1 < Delay2_out1 ELSE
      '0';

  
  Multiport_Switch_out1 <= Delay2_out1 WHEN Relational_Operator_relop1 = '0' ELSE
      Delay3_out1;

  
  Relational_Operator4_relop1 <= '1' WHEN Multiport_Switch1_out1 < Multiport_Switch_out1 ELSE
      '0';

  
  Multiport_Switch4_out1 <= Multiport_Switch_out1 WHEN Relational_Operator4_relop1 = '0' ELSE
      Multiport_Switch1_out1;

  Delay13_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay13_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        Delay13_out1 <= Multiport_Switch4_out1;
      END IF;
    END IF;
  END PROCESS Delay13_process;


  
  Relational_Operator5_relop1 <= '1' WHEN Delay15_out1 < Delay13_out1 ELSE
      '0';

  Constant_out1 <= to_unsigned(16#01#, 8);

  Delay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay_out1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        Delay_out1 <= Constant_out1;
      END IF;
    END IF;
  END PROCESS Delay_process;


  Constant1_out1 <= to_unsigned(16#02#, 8);

  Delay1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay1_out1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        Delay1_out1 <= Constant1_out1;
      END IF;
    END IF;
  END PROCESS Delay1_process;


  
  Multiport_Switch6_out1 <= Delay_out1 WHEN Relational_Operator_relop1 = '0' ELSE
      Delay1_out1;

  Constant2_out1 <= to_unsigned(16#03#, 8);

  Delay6_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay6_out1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        Delay6_out1 <= Constant2_out1;
      END IF;
    END IF;
  END PROCESS Delay6_process;


  Constant3_out1 <= to_unsigned(16#04#, 8);

  Delay7_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay7_out1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        Delay7_out1 <= Constant3_out1;
      END IF;
    END IF;
  END PROCESS Delay7_process;


  
  Multiport_Switch7_out1 <= Delay6_out1 WHEN Relational_Operator1_relop1 = '0' ELSE
      Delay7_out1;

  
  Multiport_Switch8_out1 <= Multiport_Switch6_out1 WHEN Relational_Operator4_relop1 = '0' ELSE
      Multiport_Switch7_out1;

  Delay14_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay14_out1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        Delay14_out1 <= Multiport_Switch8_out1;
      END IF;
    END IF;
  END PROCESS Delay14_process;


  Constant4_out1 <= to_unsigned(16#07#, 8);

  Delay19_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay19_out1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        Delay19_out1 <= Constant4_out1;
      END IF;
    END IF;
  END PROCESS Delay19_process;


  Constant5_out1 <= to_unsigned(16#05#, 8);

  Delay10_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay10_out1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        Delay10_out1 <= Constant5_out1;
      END IF;
    END IF;
  END PROCESS Delay10_process;


  Constant6_out1 <= to_unsigned(16#06#, 8);

  Delay11_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay11_out1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        Delay11_out1 <= Constant6_out1;
      END IF;
    END IF;
  END PROCESS Delay11_process;


  
  Multiport_Switch10_out1 <= Delay10_out1 WHEN Relational_Operator2_relop1 = '0' ELSE
      Delay11_out1;

  
  Multiport_Switch9_out1 <= Delay19_out1 WHEN Relational_Operator3_relop1 = '0' ELSE
      Multiport_Switch10_out1;

  Delay16_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay16_out1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        Delay16_out1 <= Multiport_Switch9_out1;
      END IF;
    END IF;
  END PROCESS Delay16_process;


  
  Multiport_Switch11_out1 <= Delay14_out1 WHEN Relational_Operator5_relop1 = '0' ELSE
      Delay16_out1;

  Delay18_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay18_out1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        Delay18_out1 <= Multiport_Switch11_out1;
      END IF;
    END IF;
  END PROCESS Delay18_process;


  minInd <= std_logic_vector(Delay18_out1);

  
  Multiport_Switch5_out1 <= Delay13_out1 WHEN Relational_Operator5_relop1 = '0' ELSE
      Delay15_out1;

  Delay17_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay17_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        Delay17_out1 <= Multiport_Switch5_out1;
      END IF;
    END IF;
  END PROCESS Delay17_process;


  minVal <= std_logic_vector(Delay17_out1);

END rtl;

