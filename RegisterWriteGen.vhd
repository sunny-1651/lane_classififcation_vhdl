LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY RegisterWriteGen IS
  PORT( regEnable                         :   IN    std_logic;
        valGreater                        :   IN    std_logic;
        minInd                            :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        enableREG1                        :   OUT   std_logic;
        enableREG2                        :   OUT   std_logic;
        enableREG3                        :   OUT   std_logic;
        enableREG4                        :   OUT   std_logic;
        enableREG5                        :   OUT   std_logic;
        enableREG6                        :   OUT   std_logic;
        enableREG7                        :   OUT   std_logic
        );
END RegisterWriteGen;


ARCHITECTURE rtl OF RegisterWriteGen IS

  -- Signals
  SIGNAL minInd_unsigned                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Compare_To_Constant3_out1        : std_logic;
  SIGNAL Logical_Operator1_out1           : std_logic;
  SIGNAL Logical_Operator9_out1           : std_logic;
  SIGNAL Compare_To_Constant4_out1        : std_logic;
  SIGNAL Logical_Operator2_out1           : std_logic;
  SIGNAL Logical_Operator10_out1          : std_logic;
  SIGNAL Compare_To_Constant5_out1        : std_logic;
  SIGNAL Logical_Operator3_out1           : std_logic;
  SIGNAL Logical_Operator11_out1          : std_logic;
  SIGNAL Compare_To_Constant6_out1        : std_logic;
  SIGNAL Logical_Operator4_out1           : std_logic;
  SIGNAL Logical_Operator12_out1          : std_logic;
  SIGNAL Compare_To_Constant7_out1        : std_logic;
  SIGNAL Logical_Operator5_out1           : std_logic;
  SIGNAL Logical_Operator13_out1          : std_logic;
  SIGNAL Compare_To_Constant8_out1        : std_logic;
  SIGNAL Logical_Operator6_out1           : std_logic;
  SIGNAL Logical_Operator14_out1          : std_logic;
  SIGNAL Compare_To_Constant9_out1        : std_logic;
  SIGNAL Logical_Operator7_out1           : std_logic;
  SIGNAL Logical_Operator15_out1          : std_logic;

BEGIN
  minInd_unsigned <= unsigned(minInd);

  
  Compare_To_Constant3_out1 <= '1' WHEN minInd_unsigned = to_unsigned(16#01#, 8) ELSE
      '0';

  Logical_Operator1_out1 <= regEnable AND Compare_To_Constant3_out1;

  Logical_Operator9_out1 <= valGreater AND Logical_Operator1_out1;

  
  Compare_To_Constant4_out1 <= '1' WHEN minInd_unsigned = to_unsigned(16#02#, 8) ELSE
      '0';

  Logical_Operator2_out1 <= regEnable AND Compare_To_Constant4_out1;

  Logical_Operator10_out1 <= valGreater AND Logical_Operator2_out1;

  
  Compare_To_Constant5_out1 <= '1' WHEN minInd_unsigned = to_unsigned(16#03#, 8) ELSE
      '0';

  Logical_Operator3_out1 <= regEnable AND Compare_To_Constant5_out1;

  Logical_Operator11_out1 <= valGreater AND Logical_Operator3_out1;

  
  Compare_To_Constant6_out1 <= '1' WHEN minInd_unsigned = to_unsigned(16#04#, 8) ELSE
      '0';

  Logical_Operator4_out1 <= regEnable AND Compare_To_Constant6_out1;

  Logical_Operator12_out1 <= valGreater AND Logical_Operator4_out1;

  
  Compare_To_Constant7_out1 <= '1' WHEN minInd_unsigned = to_unsigned(16#05#, 8) ELSE
      '0';

  Logical_Operator5_out1 <= regEnable AND Compare_To_Constant7_out1;

  Logical_Operator13_out1 <= valGreater AND Logical_Operator5_out1;

  
  Compare_To_Constant8_out1 <= '1' WHEN minInd_unsigned = to_unsigned(16#06#, 8) ELSE
      '0';

  Logical_Operator6_out1 <= regEnable AND Compare_To_Constant8_out1;

  Logical_Operator14_out1 <= valGreater AND Logical_Operator6_out1;

  
  Compare_To_Constant9_out1 <= '1' WHEN minInd_unsigned = to_unsigned(16#07#, 8) ELSE
      '0';

  Logical_Operator7_out1 <= regEnable AND Compare_To_Constant9_out1;

  Logical_Operator15_out1 <= valGreater AND Logical_Operator7_out1;

  enableREG1 <= Logical_Operator9_out1;

  enableREG2 <= Logical_Operator10_out1;

  enableREG3 <= Logical_Operator11_out1;

  enableREG4 <= Logical_Operator12_out1;

  enableREG5 <= Logical_Operator13_out1;

  enableREG6 <= Logical_Operator14_out1;

  enableREG7 <= Logical_Operator15_out1;

END rtl;

