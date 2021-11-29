LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.HDLLaneDetector_pkg.ALL;

ENTITY Discrete_FIR_Filter IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        Discrete_FIR_Filter_in            :   IN    std_logic_vector(13 DOWNTO 0);  -- sfix14
        Discrete_FIR_Filter_enable        :   IN    std_logic;
        Discrete_FIR_Filter_out           :   OUT   std_logic_vector(30 DOWNTO 0)  -- sfix31_En10
        );
END Discrete_FIR_Filter;


ARCHITECTURE rtl OF Discrete_FIR_Filter IS

  -- Signals
  SIGNAL Discrete_FIR_Filter_in_signed    : signed(13 DOWNTO 0);  -- sfix14
  SIGNAL enb_gated                        : std_logic;
  SIGNAL delay_pipeline_1                 : vector_of_signed14(0 TO 6);  -- sfix14 [7]
  SIGNAL delay_pipeline_6                 : signed(13 DOWNTO 0);  -- sfix14
  SIGNAL delay_pipeline_6_in_pipe_reg     : vector_of_signed14(0 TO 1);  -- sfix14 [2]
  SIGNAL delay_pipeline_6_1               : signed(13 DOWNTO 0);  -- sfix14
  SIGNAL gain_in0                         : signed(14 DOWNTO 0);  -- sfix15
  SIGNAL product8                         : signed(27 DOWNTO 0);  -- sfix28_En10
  SIGNAL product8_out_pipe_reg            : vector_of_signed28(0 TO 1);  -- sfix28 [2]
  SIGNAL product8_out_pipe_1              : signed(27 DOWNTO 0);  -- sfix28_En10
  SIGNAL delay_pipeline_5                 : signed(13 DOWNTO 0);  -- sfix14
  SIGNAL delay_pipeline_5_in_pipe_reg     : vector_of_signed14(0 TO 1);  -- sfix14 [2]
  SIGNAL delay_pipeline_5_1               : signed(13 DOWNTO 0);  -- sfix14
  SIGNAL product7                         : signed(27 DOWNTO 0);  -- sfix28_En10
  SIGNAL product7_out_pipe_reg            : vector_of_signed28(0 TO 1);  -- sfix28 [2]
  SIGNAL product7_out_pipe_1              : signed(27 DOWNTO 0);  -- sfix28_En10
  SIGNAL adder_add_cast                   : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL adder_add_cast_1                 : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL sum1_1                           : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL sum1_1_1                         : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL delay_pipeline_4                 : signed(13 DOWNTO 0);  -- sfix14
  SIGNAL delay_pipeline_4_in_pipe_reg     : vector_of_signed14(0 TO 1);  -- sfix14 [2]
  SIGNAL delay_pipeline_4_1               : signed(13 DOWNTO 0);  -- sfix14
  SIGNAL coeff6                           : signed(13 DOWNTO 0);  -- sfix14_En10
  SIGNAL product6                         : signed(27 DOWNTO 0);  -- sfix28_En10
  SIGNAL product6_out_pipe_reg            : vector_of_signed28(0 TO 1);  -- sfix28 [2]
  SIGNAL product6_out_pipe_1              : signed(27 DOWNTO 0);  -- sfix28_En10
  SIGNAL delay_pipeline_3                 : signed(13 DOWNTO 0);  -- sfix14
  SIGNAL delay_pipeline_3_in_pipe_reg     : vector_of_signed14(0 TO 1);  -- sfix14 [2]
  SIGNAL delay_pipeline_3_1               : signed(13 DOWNTO 0);  -- sfix14
  SIGNAL product5                         : signed(27 DOWNTO 0);  -- sfix28_En10
  SIGNAL product5_out_pipe_reg            : vector_of_signed28(0 TO 1);  -- sfix28 [2]
  SIGNAL product5_out_pipe_1              : signed(27 DOWNTO 0);  -- sfix28_En10
  SIGNAL adder1_add_cast                  : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL adder1_add_cast_1                : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL sum1_2                           : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL sum1_2_1                         : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL adder4_add_cast                  : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL adder4_add_cast_1                : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL adder4_add_temp                  : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL sum2_1                           : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL sum2_1_1                         : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL delay_pipeline_2                 : signed(13 DOWNTO 0);  -- sfix14
  SIGNAL delay_pipeline_2_in_pipe_reg     : vector_of_signed14(0 TO 1);  -- sfix14 [2]
  SIGNAL delay_pipeline_2_1               : signed(13 DOWNTO 0);  -- sfix14
  SIGNAL product4                         : signed(27 DOWNTO 0);  -- sfix28_En10
  SIGNAL product4_out_pipe_reg            : vector_of_signed28(0 TO 1);  -- sfix28 [2]
  SIGNAL product4_out_pipe_1              : signed(27 DOWNTO 0);  -- sfix28_En10
  SIGNAL delay_pipeline_1_1               : signed(13 DOWNTO 0);  -- sfix14
  SIGNAL delay_pipeline_1_in_pipe_reg     : vector_of_signed14(0 TO 1);  -- sfix14 [2]
  SIGNAL delay_pipeline_1_2               : signed(13 DOWNTO 0);  -- sfix14
  SIGNAL coeff3                           : signed(13 DOWNTO 0);  -- sfix14_En10
  SIGNAL product3                         : signed(27 DOWNTO 0);  -- sfix28_En10
  SIGNAL product3_out_pipe_reg            : vector_of_signed28(0 TO 1);  -- sfix28 [2]
  SIGNAL product3_out_pipe_1              : signed(27 DOWNTO 0);  -- sfix28_En10
  SIGNAL adder2_add_cast                  : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL adder2_add_cast_1                : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL sum1_3                           : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL sum1_3_1                         : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL delay_pipeline_0                 : signed(13 DOWNTO 0);  -- sfix14
  SIGNAL delay_pipeline_0_in_pipe_reg     : vector_of_signed14(0 TO 1);  -- sfix14 [2]
  SIGNAL delay_pipeline_0_1               : signed(13 DOWNTO 0);  -- sfix14
  SIGNAL product2                         : signed(27 DOWNTO 0);  -- sfix28_En10
  SIGNAL product2_out_pipe_reg            : vector_of_signed28(0 TO 1);  -- sfix28 [2]
  SIGNAL product2_out_pipe_1              : signed(27 DOWNTO 0);  -- sfix28_En10
  SIGNAL Discrete_FIR_Filter_in_in_pipe_reg : vector_of_signed14(0 TO 1);  -- sfix14 [2]
  SIGNAL Discrete_FIR_Filter_in_1         : signed(13 DOWNTO 0);  -- sfix14
  SIGNAL product1                         : signed(27 DOWNTO 0);  -- sfix28_En10
  SIGNAL product1_out_pipe_reg            : vector_of_signed28(0 TO 1);  -- sfix28 [2]
  SIGNAL product1_out_pipe_1              : signed(27 DOWNTO 0);  -- sfix28_En10
  SIGNAL adder3_add_cast                  : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL adder3_add_cast_1                : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL sum1_4                           : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL sum1_4_1                         : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL adder5_add_cast                  : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL adder5_add_cast_1                : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL adder5_add_temp                  : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL sum2_2                           : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL sum2_2_1                         : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL adder6_add_cast                  : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL adder6_add_cast_1                : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL adder6_add_temp                  : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL sum3_1                           : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL sum3_1_1                         : signed(30 DOWNTO 0);  -- sfix31_En10

BEGIN
  Discrete_FIR_Filter_in_signed <= signed(Discrete_FIR_Filter_in);

  enb_gated <= Discrete_FIR_Filter_enable AND enb;

  Delay_Pipeline_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        delay_pipeline_1 <= (OTHERS => to_signed(16#0000#, 14));
      ELSIF enb_gated = '1' THEN
        delay_pipeline_1(0) <= Discrete_FIR_Filter_in_signed;
        delay_pipeline_1(1 TO 6) <= delay_pipeline_1(0 TO 5);
      END IF;
    END IF;
  END PROCESS Delay_Pipeline_process;


  delay_pipeline_6 <= delay_pipeline_1(6);

  delay_pipeline_6_in_pipe_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        delay_pipeline_6_in_pipe_reg <= (OTHERS => to_signed(16#0000#, 14));
      ELSIF enb = '1' THEN
        delay_pipeline_6_in_pipe_reg(0) <= delay_pipeline_6;
        delay_pipeline_6_in_pipe_reg(1) <= delay_pipeline_6_in_pipe_reg(0);
      END IF;
    END IF;
  END PROCESS delay_pipeline_6_in_pipe_process;

  delay_pipeline_6_1 <= delay_pipeline_6_in_pipe_reg(1);

  -- coeff8
  gain_in0 <=  - (resize(delay_pipeline_6_1, 15));
  product8 <= resize(gain_in0 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 28);

  product8_out_pipe_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        product8_out_pipe_reg <= (OTHERS => to_signed(16#0000000#, 28));
      ELSIF enb = '1' THEN
        product8_out_pipe_reg(0) <= product8;
        product8_out_pipe_reg(1) <= product8_out_pipe_reg(0);
      END IF;
    END IF;
  END PROCESS product8_out_pipe_process;

  product8_out_pipe_1 <= product8_out_pipe_reg(1);

  delay_pipeline_5 <= delay_pipeline_1(5);

  delay_pipeline_5_in_pipe_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        delay_pipeline_5_in_pipe_reg <= (OTHERS => to_signed(16#0000#, 14));
      ELSIF enb = '1' THEN
        delay_pipeline_5_in_pipe_reg(0) <= delay_pipeline_5;
        delay_pipeline_5_in_pipe_reg(1) <= delay_pipeline_5_in_pipe_reg(0);
      END IF;
    END IF;
  END PROCESS delay_pipeline_5_in_pipe_process;

  delay_pipeline_5_1 <= delay_pipeline_5_in_pipe_reg(1);

  -- coeff7
  -- CSD Encoding (2048) : 100000000000; Cost (Adders) = 0
  product7 <=  - (resize(delay_pipeline_5_1 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 28));

  product7_out_pipe_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        product7_out_pipe_reg <= (OTHERS => to_signed(16#0000000#, 28));
      ELSIF enb = '1' THEN
        product7_out_pipe_reg(0) <= product7;
        product7_out_pipe_reg(1) <= product7_out_pipe_reg(0);
      END IF;
    END IF;
  END PROCESS product7_out_pipe_process;

  product7_out_pipe_1 <= product7_out_pipe_reg(1);

  adder_add_cast <= resize(product8_out_pipe_1, 31);
  adder_add_cast_1 <= resize(product7_out_pipe_1, 31);
  sum1_1 <= adder_add_cast + adder_add_cast_1;

  adder_out_buff_out_pipe_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        sum1_1_1 <= to_signed(16#00000000#, 31);
      ELSIF enb = '1' THEN
        sum1_1_1 <= sum1_1;
      END IF;
    END IF;
  END PROCESS adder_out_buff_out_pipe_process;


  delay_pipeline_4 <= delay_pipeline_1(4);

  delay_pipeline_4_in_pipe_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        delay_pipeline_4_in_pipe_reg <= (OTHERS => to_signed(16#0000#, 14));
      ELSIF enb = '1' THEN
        delay_pipeline_4_in_pipe_reg(0) <= delay_pipeline_4;
        delay_pipeline_4_in_pipe_reg(1) <= delay_pipeline_4_in_pipe_reg(0);
      END IF;
    END IF;
  END PROCESS delay_pipeline_4_in_pipe_process;

  delay_pipeline_4_1 <= delay_pipeline_4_in_pipe_reg(1);

  coeff6 <= to_signed(-16#0C00#, 14);

  product6 <= delay_pipeline_4_1 * coeff6;

  product6_out_pipe_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        product6_out_pipe_reg <= (OTHERS => to_signed(16#0000000#, 28));
      ELSIF enb = '1' THEN
        product6_out_pipe_reg(0) <= product6;
        product6_out_pipe_reg(1) <= product6_out_pipe_reg(0);
      END IF;
    END IF;
  END PROCESS product6_out_pipe_process;

  product6_out_pipe_1 <= product6_out_pipe_reg(1);

  delay_pipeline_3 <= delay_pipeline_1(3);

  delay_pipeline_3_in_pipe_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        delay_pipeline_3_in_pipe_reg <= (OTHERS => to_signed(16#0000#, 14));
      ELSIF enb = '1' THEN
        delay_pipeline_3_in_pipe_reg(0) <= delay_pipeline_3;
        delay_pipeline_3_in_pipe_reg(1) <= delay_pipeline_3_in_pipe_reg(0);
      END IF;
    END IF;
  END PROCESS delay_pipeline_3_in_pipe_process;

  delay_pipeline_3_1 <= delay_pipeline_3_in_pipe_reg(1);

  -- coeff5
  -- CSD Encoding (4096) : 1000000000000; Cost (Adders) = 0
  product5 <=  - (resize(delay_pipeline_3_1 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 28));

  product5_out_pipe_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        product5_out_pipe_reg <= (OTHERS => to_signed(16#0000000#, 28));
      ELSIF enb = '1' THEN
        product5_out_pipe_reg(0) <= product5;
        product5_out_pipe_reg(1) <= product5_out_pipe_reg(0);
      END IF;
    END IF;
  END PROCESS product5_out_pipe_process;

  product5_out_pipe_1 <= product5_out_pipe_reg(1);

  adder1_add_cast <= resize(product6_out_pipe_1, 31);
  adder1_add_cast_1 <= resize(product5_out_pipe_1, 31);
  sum1_2 <= adder1_add_cast + adder1_add_cast_1;

  adder_out_buff_out_pipe1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        sum1_2_1 <= to_signed(16#00000000#, 31);
      ELSIF enb = '1' THEN
        sum1_2_1 <= sum1_2;
      END IF;
    END IF;
  END PROCESS adder_out_buff_out_pipe1_process;


  adder4_add_cast <= resize(sum1_1_1, 32);
  adder4_add_cast_1 <= resize(sum1_2_1, 32);
  adder4_add_temp <= adder4_add_cast + adder4_add_cast_1;
  
  sum2_1 <= "0111111111111111111111111111111" WHEN (adder4_add_temp(31) = '0') AND (adder4_add_temp(30) /= '0') ELSE
      "1000000000000000000000000000000" WHEN (adder4_add_temp(31) = '1') AND (adder4_add_temp(30) /= '1') ELSE
      adder4_add_temp(30 DOWNTO 0);

  adder_out_buff_out_pipe4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        sum2_1_1 <= to_signed(16#00000000#, 31);
      ELSIF enb = '1' THEN
        sum2_1_1 <= sum2_1;
      END IF;
    END IF;
  END PROCESS adder_out_buff_out_pipe4_process;


  delay_pipeline_2 <= delay_pipeline_1(2);

  delay_pipeline_2_in_pipe_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        delay_pipeline_2_in_pipe_reg <= (OTHERS => to_signed(16#0000#, 14));
      ELSIF enb = '1' THEN
        delay_pipeline_2_in_pipe_reg(0) <= delay_pipeline_2;
        delay_pipeline_2_in_pipe_reg(1) <= delay_pipeline_2_in_pipe_reg(0);
      END IF;
    END IF;
  END PROCESS delay_pipeline_2_in_pipe_process;

  delay_pipeline_2_1 <= delay_pipeline_2_in_pipe_reg(1);

  -- coeff4
  product4 <= resize(delay_pipeline_2_1 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 28);

  product4_out_pipe_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        product4_out_pipe_reg <= (OTHERS => to_signed(16#0000000#, 28));
      ELSIF enb = '1' THEN
        product4_out_pipe_reg(0) <= product4;
        product4_out_pipe_reg(1) <= product4_out_pipe_reg(0);
      END IF;
    END IF;
  END PROCESS product4_out_pipe_process;

  product4_out_pipe_1 <= product4_out_pipe_reg(1);

  delay_pipeline_1_1 <= delay_pipeline_1(1);

  delay_pipeline_1_in_pipe_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        delay_pipeline_1_in_pipe_reg <= (OTHERS => to_signed(16#0000#, 14));
      ELSIF enb = '1' THEN
        delay_pipeline_1_in_pipe_reg(0) <= delay_pipeline_1_1;
        delay_pipeline_1_in_pipe_reg(1) <= delay_pipeline_1_in_pipe_reg(0);
      END IF;
    END IF;
  END PROCESS delay_pipeline_1_in_pipe_process;

  delay_pipeline_1_2 <= delay_pipeline_1_in_pipe_reg(1);

  coeff3 <= to_signed(16#0C00#, 14);

  product3 <= delay_pipeline_1_2 * coeff3;

  product3_out_pipe_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        product3_out_pipe_reg <= (OTHERS => to_signed(16#0000000#, 28));
      ELSIF enb = '1' THEN
        product3_out_pipe_reg(0) <= product3;
        product3_out_pipe_reg(1) <= product3_out_pipe_reg(0);
      END IF;
    END IF;
  END PROCESS product3_out_pipe_process;

  product3_out_pipe_1 <= product3_out_pipe_reg(1);

  adder2_add_cast <= resize(product4_out_pipe_1, 31);
  adder2_add_cast_1 <= resize(product3_out_pipe_1, 31);
  sum1_3 <= adder2_add_cast + adder2_add_cast_1;

  adder_out_buff_out_pipe2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        sum1_3_1 <= to_signed(16#00000000#, 31);
      ELSIF enb = '1' THEN
        sum1_3_1 <= sum1_3;
      END IF;
    END IF;
  END PROCESS adder_out_buff_out_pipe2_process;


  delay_pipeline_0 <= delay_pipeline_1(0);

  delay_pipeline_0_in_pipe_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        delay_pipeline_0_in_pipe_reg <= (OTHERS => to_signed(16#0000#, 14));
      ELSIF enb = '1' THEN
        delay_pipeline_0_in_pipe_reg(0) <= delay_pipeline_0;
        delay_pipeline_0_in_pipe_reg(1) <= delay_pipeline_0_in_pipe_reg(0);
      END IF;
    END IF;
  END PROCESS delay_pipeline_0_in_pipe_process;

  delay_pipeline_0_1 <= delay_pipeline_0_in_pipe_reg(1);

  -- coeff2
  product2 <= resize(delay_pipeline_0_1 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 28);

  product2_out_pipe_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        product2_out_pipe_reg <= (OTHERS => to_signed(16#0000000#, 28));
      ELSIF enb = '1' THEN
        product2_out_pipe_reg(0) <= product2;
        product2_out_pipe_reg(1) <= product2_out_pipe_reg(0);
      END IF;
    END IF;
  END PROCESS product2_out_pipe_process;

  product2_out_pipe_1 <= product2_out_pipe_reg(1);

  Discrete_FIR_Filter_in_in_pipe_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Discrete_FIR_Filter_in_in_pipe_reg <= (OTHERS => to_signed(16#0000#, 14));
      ELSIF enb = '1' THEN
        Discrete_FIR_Filter_in_in_pipe_reg(0) <= Discrete_FIR_Filter_in_signed;
        Discrete_FIR_Filter_in_in_pipe_reg(1) <= Discrete_FIR_Filter_in_in_pipe_reg(0);
      END IF;
    END IF;
  END PROCESS Discrete_FIR_Filter_in_in_pipe_process;

  Discrete_FIR_Filter_in_1 <= Discrete_FIR_Filter_in_in_pipe_reg(1);

  -- coeff1
  product1 <= resize(Discrete_FIR_Filter_in_1 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 28);

  product1_out_pipe_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        product1_out_pipe_reg <= (OTHERS => to_signed(16#0000000#, 28));
      ELSIF enb = '1' THEN
        product1_out_pipe_reg(0) <= product1;
        product1_out_pipe_reg(1) <= product1_out_pipe_reg(0);
      END IF;
    END IF;
  END PROCESS product1_out_pipe_process;

  product1_out_pipe_1 <= product1_out_pipe_reg(1);

  adder3_add_cast <= resize(product2_out_pipe_1, 31);
  adder3_add_cast_1 <= resize(product1_out_pipe_1, 31);
  sum1_4 <= adder3_add_cast + adder3_add_cast_1;

  adder_out_buff_out_pipe3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        sum1_4_1 <= to_signed(16#00000000#, 31);
      ELSIF enb = '1' THEN
        sum1_4_1 <= sum1_4;
      END IF;
    END IF;
  END PROCESS adder_out_buff_out_pipe3_process;


  adder5_add_cast <= resize(sum1_3_1, 32);
  adder5_add_cast_1 <= resize(sum1_4_1, 32);
  adder5_add_temp <= adder5_add_cast + adder5_add_cast_1;
  
  sum2_2 <= "0111111111111111111111111111111" WHEN (adder5_add_temp(31) = '0') AND (adder5_add_temp(30) /= '0') ELSE
      "1000000000000000000000000000000" WHEN (adder5_add_temp(31) = '1') AND (adder5_add_temp(30) /= '1') ELSE
      adder5_add_temp(30 DOWNTO 0);

  adder_out_buff_out_pipe5_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        sum2_2_1 <= to_signed(16#00000000#, 31);
      ELSIF enb = '1' THEN
        sum2_2_1 <= sum2_2;
      END IF;
    END IF;
  END PROCESS adder_out_buff_out_pipe5_process;


  adder6_add_cast <= resize(sum2_1_1, 32);
  adder6_add_cast_1 <= resize(sum2_2_1, 32);
  adder6_add_temp <= adder6_add_cast + adder6_add_cast_1;
  
  sum3_1 <= "0111111111111111111111111111111" WHEN (adder6_add_temp(31) = '0') AND (adder6_add_temp(30) /= '0') ELSE
      "1000000000000000000000000000000" WHEN (adder6_add_temp(31) = '1') AND (adder6_add_temp(30) /= '1') ELSE
      adder6_add_temp(30 DOWNTO 0);

  adder_out_buff_out_pipe6_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        sum3_1_1 <= to_signed(16#00000000#, 31);
      ELSIF enb = '1' THEN
        sum3_1_1 <= sum3_1;
      END IF;
    END IF;
  END PROCESS adder_out_buff_out_pipe6_process;


  Discrete_FIR_Filter_out <= std_logic_vector(sum3_1_1);

END rtl;

