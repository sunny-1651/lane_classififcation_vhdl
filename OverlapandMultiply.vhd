LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.HDLLaneDetector_pkg.ALL;

ENTITY OverlapandMultiply IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        posHistCount                      :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
        negHistCount                      :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
        matchedHist                       :   OUT   std_logic_vector(11 DOWNTO 0)  -- ufix12
        );
END OverlapandMultiply;


ARCHITECTURE rtl OF OverlapandMultiply IS

  -- Signals
  SIGNAL posHistCount_unsigned            : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL Delay8_reg                       : vector_of_unsigned6(0 TO 7);  -- ufix6 [8]
  SIGNAL Delay8_out1                      : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL Delay1_reg                       : vector_of_unsigned6(0 TO 1);  -- ufix6 [2]
  SIGNAL Delay1_out1                      : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL negHistCount_unsigned            : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL Delay2_reg                       : vector_of_unsigned6(0 TO 1);  -- ufix6 [2]
  SIGNAL Delay2_out1                      : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL Product_out1                     : unsigned(11 DOWNTO 0);  -- ufix12
  SIGNAL Delay3_reg                       : vector_of_unsigned12(0 TO 1);  -- ufix12 [2]
  SIGNAL Delay3_out1                      : unsigned(11 DOWNTO 0);  -- ufix12

BEGIN
  -- offset columns
  -- 
  -- pipelining

  posHistCount_unsigned <= unsigned(posHistCount);

  Delay8_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay8_reg <= (OTHERS => to_unsigned(16#00#, 6));
      ELSIF enb = '1' THEN
        Delay8_reg(0) <= posHistCount_unsigned;
        Delay8_reg(1 TO 7) <= Delay8_reg(0 TO 6);
      END IF;
    END IF;
  END PROCESS Delay8_process;

  Delay8_out1 <= Delay8_reg(7);

  Delay1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay1_reg <= (OTHERS => to_unsigned(16#00#, 6));
      ELSIF enb = '1' THEN
        Delay1_reg(0) <= Delay8_out1;
        Delay1_reg(1) <= Delay1_reg(0);
      END IF;
    END IF;
  END PROCESS Delay1_process;

  Delay1_out1 <= Delay1_reg(1);

  negHistCount_unsigned <= unsigned(negHistCount);

  Delay2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay2_reg <= (OTHERS => to_unsigned(16#00#, 6));
      ELSIF enb = '1' THEN
        Delay2_reg(0) <= negHistCount_unsigned;
        Delay2_reg(1) <= Delay2_reg(0);
      END IF;
    END IF;
  END PROCESS Delay2_process;

  Delay2_out1 <= Delay2_reg(1);

  Product_out1 <= Delay1_out1 * Delay2_out1;

  Delay3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay3_reg <= (OTHERS => to_unsigned(16#000#, 12));
      ELSIF enb = '1' THEN
        Delay3_reg(0) <= Product_out1;
        Delay3_reg(1) <= Delay3_reg(0);
      END IF;
    END IF;
  END PROCESS Delay3_process;

  Delay3_out1 <= Delay3_reg(1);

  matchedHist <= std_logic_vector(Delay3_out1);

END rtl;

