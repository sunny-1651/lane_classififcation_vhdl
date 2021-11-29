LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY HistogramColumnCount IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        pixelIn                           :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En15
        controlIn_hStart                  :   IN    std_logic;
        controlIn_hEnd                    :   IN    std_logic;
        controlIn_vStart                  :   IN    std_logic;
        controlIn_vEnd                    :   IN    std_logic;
        controlIn_valid                   :   IN    std_logic;
        PositiveHistogramCount            :   OUT   std_logic_vector(5 DOWNTO 0);  -- ufix6
        HistogramValid                    :   OUT   std_logic;
        HistogramAddress                  :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        NegativeHistogramCount            :   OUT   std_logic_vector(5 DOWNTO 0)  -- ufix6
        );
END HistogramColumnCount;


ARCHITECTURE rtl OF HistogramColumnCount IS

  -- Component Declarations
  COMPONENT ColumnCountPos
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          pixelIn                         :   IN    std_logic;
          controlIn_hStart                :   IN    std_logic;
          controlIn_hEnd                  :   IN    std_logic;
          controlIn_vStart                :   IN    std_logic;
          controlIn_vEnd                  :   IN    std_logic;
          controlIn_valid                 :   IN    std_logic;
          PositiveHistogramCount          :   OUT   std_logic_vector(5 DOWNTO 0);  -- ufix6
          HistogramValid                  :   OUT   std_logic;
          HistogramAddress                :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
          );
  END COMPONENT;

  COMPONENT ColumnCountNeg
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          pixelIn                         :   IN    std_logic;
          controlIn_hStart                :   IN    std_logic;
          controlIn_hEnd                  :   IN    std_logic;
          controlIn_vStart                :   IN    std_logic;
          controlIn_vEnd                  :   IN    std_logic;
          controlIn_valid                 :   IN    std_logic;
          NegativeHistogramCount          :   OUT   std_logic_vector(5 DOWNTO 0)  -- ufix6
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : ColumnCountPos
    USE ENTITY work.ColumnCountPos(rtl);

  FOR ALL : ColumnCountNeg
    USE ENTITY work.ColumnCountNeg(rtl);

  -- Signals
  SIGNAL pixelIn_signed                   : signed(23 DOWNTO 0);  -- sfix24_En15
  SIGNAL Compare_To_Constant_out1         : std_logic;
  SIGNAL ColumnCountPos_out1              : std_logic_vector(5 DOWNTO 0);  -- ufix6
  SIGNAL ColumnCountPos_out2              : std_logic;
  SIGNAL ColumnCountPos_out3              : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL Compare_To_Constant1_out1        : std_logic;
  SIGNAL ColumnCountNeg_out1              : std_logic_vector(5 DOWNTO 0);  -- ufix6

BEGIN
  u_ColumnCountPos : ColumnCountPos
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              pixelIn => Compare_To_Constant_out1,
              controlIn_hStart => controlIn_hStart,
              controlIn_hEnd => controlIn_hEnd,
              controlIn_vStart => controlIn_vStart,
              controlIn_vEnd => controlIn_vEnd,
              controlIn_valid => controlIn_valid,
              PositiveHistogramCount => ColumnCountPos_out1,  -- ufix6
              HistogramValid => ColumnCountPos_out2,
              HistogramAddress => ColumnCountPos_out3  -- ufix10
              );

  u_ColumnCountNeg : ColumnCountNeg
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              pixelIn => Compare_To_Constant1_out1,
              controlIn_hStart => controlIn_hStart,
              controlIn_hEnd => controlIn_hEnd,
              controlIn_vStart => controlIn_vStart,
              controlIn_vEnd => controlIn_vEnd,
              controlIn_valid => controlIn_valid,
              NegativeHistogramCount => ColumnCountNeg_out1  -- ufix6
              );

  pixelIn_signed <= signed(pixelIn);

  
  Compare_To_Constant_out1 <= '1' WHEN pixelIn_signed > to_signed(16#003333#, 24) ELSE
      '0';

  
  Compare_To_Constant1_out1 <= '1' WHEN pixelIn_signed < to_signed(-16#003333#, 24) ELSE
      '0';

  PositiveHistogramCount <= ColumnCountPos_out1;

  HistogramValid <= ColumnCountPos_out2;

  HistogramAddress <= ColumnCountPos_out3;

  NegativeHistogramCount <= ColumnCountNeg_out1;

END rtl;

