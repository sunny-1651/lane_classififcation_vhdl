LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.HDLLaneDetector_pkg.ALL;

ENTITY UpdateLaneWidth IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        rightwidth                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En18
        RightOffset                       :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
        CaptureLane                       :   IN    std_logic;
        LeftOffset                        :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
        leftwidth                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En18
        LaneWidth                         :   OUT   std_logic_vector(17 DOWNTO 0)  -- sfix18
        );
END UpdateLaneWidth;


ARCHITECTURE rtl OF UpdateLaneWidth IS

  -- Signals
  SIGNAL RightOffset_signed               : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay7_out1                      : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL LeftOffset_signed                : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay6_out1                      : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Add_out1                         : signed(12 DOWNTO 0);  -- sfix13
  SIGNAL Abs2_y                           : signed(13 DOWNTO 0);  -- sfix14
  SIGNAL Abs2_out1                        : unsigned(13 DOWNTO 0);  -- ufix14
  SIGNAL delayMatch_reg                   : std_logic_vector(0 TO 6);  -- ufix1 [7]
  SIGNAL CaptureLane_1                    : std_logic;
  SIGNAL Delay8_out1                      : unsigned(13 DOWNTO 0);  -- ufix14
  SIGNAL Compare_To_Constant2_out1        : std_logic;
  SIGNAL Logical_Operator_out1            : std_logic;
  SIGNAL rightwidth_signed                : signed(31 DOWNTO 0);  -- sfix32_En18
  SIGNAL Data_Type_Conversion1_out1       : unsigned(11 DOWNTO 0);  -- ufix12
  SIGNAL Delay10_out1                     : unsigned(11 DOWNTO 0);  -- ufix12
  SIGNAL leftwidth_signed                 : signed(31 DOWNTO 0);  -- sfix32_En18
  SIGNAL Data_Type_Conversion3_out1       : unsigned(11 DOWNTO 0);  -- ufix12
  SIGNAL Delay9_out1                      : unsigned(11 DOWNTO 0);  -- ufix12
  SIGNAL Add1_out1                        : unsigned(12 DOWNTO 0);  -- ufix13
  SIGNAL Gain1_cast                       : unsigned(25 DOWNTO 0);  -- ufix26_En13
  SIGNAL Gain1_out1                       : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Delay11_out1                     : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Delay1_out1                      : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Gain2_mul_temp                   : unsigned(31 DOWNTO 0);  -- ufix32_En15
  SIGNAL Gain2_out1                       : signed(17 DOWNTO 0);  -- sfix18
  SIGNAL Delay12_reg                      : vector_of_signed18(0 TO 1);  -- sfix18 [2]
  SIGNAL Delay12_out1                     : signed(17 DOWNTO 0);  -- sfix18

BEGIN
  RightOffset_signed <= signed(RightOffset);

  Delay7_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay7_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay7_out1 <= RightOffset_signed;
      END IF;
    END IF;
  END PROCESS Delay7_process;


  LeftOffset_signed <= signed(LeftOffset);

  Delay6_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay6_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay6_out1 <= LeftOffset_signed;
      END IF;
    END IF;
  END PROCESS Delay6_process;


  Add_out1 <= resize(Delay7_out1, 13) - resize(Delay6_out1, 13);

  
  Abs2_y <=  - (resize(Add_out1, 14)) WHEN Add_out1 < to_signed(16#0000#, 13) ELSE
      resize(Add_out1, 14);
  Abs2_out1 <= unsigned(Abs2_y);

  delayMatch_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        delayMatch_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        delayMatch_reg(0) <= CaptureLane;
        delayMatch_reg(1 TO 6) <= delayMatch_reg(0 TO 5);
      END IF;
    END IF;
  END PROCESS delayMatch_process;

  CaptureLane_1 <= delayMatch_reg(6);

  Delay8_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay8_out1 <= to_unsigned(16#0000#, 14);
      ELSIF enb = '1' THEN
        Delay8_out1 <= Abs2_out1;
      END IF;
    END IF;
  END PROCESS Delay8_process;


  
  Compare_To_Constant2_out1 <= '1' WHEN Delay8_out1 <= to_unsigned(16#001E#, 14) ELSE
      '0';

  Logical_Operator_out1 <= CaptureLane_1 AND Compare_To_Constant2_out1;

  rightwidth_signed <= signed(rightwidth);

  
  Data_Type_Conversion1_out1 <= "111111111111" WHEN ((rightwidth_signed(31) = '0') AND (rightwidth_signed(30) /= '0')) OR ((rightwidth_signed(31) = '0') AND (rightwidth_signed(29 DOWNTO 18) = "111111111111")) ELSE
      "000000000000" WHEN rightwidth_signed(31) = '1' ELSE
      unsigned(rightwidth_signed(29 DOWNTO 18)) + ('0' & (rightwidth_signed(17) AND (( NOT rightwidth_signed(31)) OR (rightwidth_signed(16) OR rightwidth_signed(15) OR rightwidth_signed(14) OR rightwidth_signed(13) OR rightwidth_signed(12) OR rightwidth_signed(11) OR rightwidth_signed(10) OR rightwidth_signed(9) OR rightwidth_signed(8) OR rightwidth_signed(7) OR rightwidth_signed(6) OR rightwidth_signed(5) OR rightwidth_signed(4) OR rightwidth_signed(3) OR rightwidth_signed(2) OR rightwidth_signed(1) OR rightwidth_signed(0)))));

  Delay10_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay10_out1 <= to_unsigned(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay10_out1 <= Data_Type_Conversion1_out1;
      END IF;
    END IF;
  END PROCESS Delay10_process;


  leftwidth_signed <= signed(leftwidth);

  
  Data_Type_Conversion3_out1 <= "111111111111" WHEN ((leftwidth_signed(31) = '0') AND (leftwidth_signed(30) /= '0')) OR ((leftwidth_signed(31) = '0') AND (leftwidth_signed(29 DOWNTO 18) = "111111111111")) ELSE
      "000000000000" WHEN leftwidth_signed(31) = '1' ELSE
      unsigned(leftwidth_signed(29 DOWNTO 18)) + ('0' & (leftwidth_signed(17) AND (( NOT leftwidth_signed(31)) OR (leftwidth_signed(16) OR leftwidth_signed(15) OR leftwidth_signed(14) OR leftwidth_signed(13) OR leftwidth_signed(12) OR leftwidth_signed(11) OR leftwidth_signed(10) OR leftwidth_signed(9) OR leftwidth_signed(8) OR leftwidth_signed(7) OR leftwidth_signed(6) OR leftwidth_signed(5) OR leftwidth_signed(4) OR leftwidth_signed(3) OR leftwidth_signed(2) OR leftwidth_signed(1) OR leftwidth_signed(0)))));

  Delay9_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay9_out1 <= to_unsigned(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay9_out1 <= Data_Type_Conversion3_out1;
      END IF;
    END IF;
  END PROCESS Delay9_process;


  Add1_out1 <= resize(Delay10_out1, 13) + resize(Delay9_out1, 13);

  Gain1_cast <= resize(Add1_out1 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 26);
  Gain1_out1 <= (resize(Gain1_cast(25 DOWNTO 13), 16)) + ('0' & Gain1_cast(12));

  Delay11_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay11_out1 <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay11_out1 <= Gain1_out1;
      END IF;
    END IF;
  END PROCESS Delay11_process;


  Delay1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay1_out1 <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' AND Logical_Operator_out1 = '1' THEN
        Delay1_out1 <= Delay11_out1;
      END IF;
    END IF;
  END PROCESS Delay1_process;


  -- CSD Encoding (40960) : 01010000000000000; Cost (Adders) = 1
  Gain2_mul_temp <= resize(Delay1_out1 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 32) + resize(Delay1_out1 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 32);
  Gain2_out1 <= signed(resize(Gain2_mul_temp(31 DOWNTO 15), 18));

  Delay12_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay12_reg <= (OTHERS => to_signed(16#00000#, 18));
      ELSIF enb = '1' THEN
        Delay12_reg(0) <= Gain2_out1;
        Delay12_reg(1) <= Delay12_reg(0);
      END IF;
    END IF;
  END PROCESS Delay12_process;

  Delay12_out1 <= Delay12_reg(1);

  LaneWidth <= std_logic_vector(Delay12_out1);

END rtl;

