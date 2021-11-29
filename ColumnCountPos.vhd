LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ColumnCountPos IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        pixelIn                           :   IN    std_logic;
        controlIn_hStart                  :   IN    std_logic;
        controlIn_hEnd                    :   IN    std_logic;
        controlIn_vStart                  :   IN    std_logic;
        controlIn_vEnd                    :   IN    std_logic;
        controlIn_valid                   :   IN    std_logic;
        PositiveHistogramCount            :   OUT   std_logic_vector(5 DOWNTO 0);  -- ufix6
        HistogramValid                    :   OUT   std_logic;
        HistogramAddress                  :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
        );
END ColumnCountPos;


ARCHITECTURE rtl OF ColumnCountPos IS

  -- Component Declarations
  COMPONENT TiledROIExractor_block
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          controlIn_hStart                :   IN    std_logic;
          controlIn_hEnd                  :   IN    std_logic;
          controlIn_vStart                :   IN    std_logic;
          controlIn_vEnd                  :   IN    std_logic;
          controlIn_valid                 :   IN    std_logic;
          pixelIn                         :   IN    std_logic;
          regionStart                     :   OUT   std_logic;
          pixelOut                        :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          controlOut_hStart               :   OUT   std_logic;
          controlOut_hEnd                 :   OUT   std_logic;
          controlOut_vStart               :   OUT   std_logic;
          controlOut_vEnd                 :   OUT   std_logic;
          controlOut_valid                :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT Subsystem_block
    PORT( Out1_hStart                     :   OUT   std_logic;
          Out1_hEnd                       :   OUT   std_logic;
          Out1_vStart                     :   OUT   std_logic;
          Out1_vEnd                       :   OUT   std_logic;
          Out1_valid                      :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT Histogram2_block
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          in0                             :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          in1_hStart                      :   IN    std_logic;
          in1_hEnd                        :   IN    std_logic;
          in1_vStart                      :   IN    std_logic;
          in1_vEnd                        :   IN    std_logic;
          in1_valid                       :   IN    std_logic;
          in2                             :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          in3                             :   IN    std_logic;
          out0                            :   OUT   std_logic_vector(5 DOWNTO 0);  -- ufix6
          out1                            :   OUT   std_logic;
          out2                            :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT Subsystem1_block1
    PORT( Out1_hStart                     :   OUT   std_logic;
          Out1_hEnd                       :   OUT   std_logic;
          Out1_vStart                     :   OUT   std_logic;
          Out1_vEnd                       :   OUT   std_logic;
          Out1_valid                      :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT Histogram1_block
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          in0                             :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          in1_hStart                      :   IN    std_logic;
          in1_hEnd                        :   IN    std_logic;
          in1_vStart                      :   IN    std_logic;
          in1_vEnd                        :   IN    std_logic;
          in1_valid                       :   IN    std_logic;
          in2                             :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          in3                             :   IN    std_logic;
          out0                            :   OUT   std_logic_vector(5 DOWNTO 0);  -- ufix6
          out1                            :   OUT   std_logic;
          out2                            :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : TiledROIExractor_block
    USE ENTITY work.TiledROIExractor_block(rtl);

  FOR ALL : Subsystem_block
    USE ENTITY work.Subsystem_block(rtl);

  FOR ALL : Histogram2_block
    USE ENTITY work.Histogram2_block(rtl);

  FOR ALL : Subsystem1_block1
    USE ENTITY work.Subsystem1_block1(rtl);

  FOR ALL : Histogram1_block
    USE ENTITY work.Histogram1_block(rtl);

  -- Signals
  SIGNAL TiledROIExractor_out1            : std_logic;
  SIGNAL TiledROIExractor_out2            : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL TiledROIExractor_out3_hStart     : std_logic;
  SIGNAL TiledROIExractor_out3_hEnd       : std_logic;
  SIGNAL TiledROIExractor_out3_vStart     : std_logic;
  SIGNAL TiledROIExractor_out3_vEnd       : std_logic;
  SIGNAL TiledROIExractor_out3_valid      : std_logic;
  SIGNAL Delay4_out1                      : std_logic;
  SIGNAL Logical_Operator6_out1           : std_logic;
  SIGNAL Logical_Operator4_out1           : std_logic;
  SIGNAL Delay2_out1                      : std_logic;
  SIGNAL Subsystem_out1_hStart            : std_logic;
  SIGNAL Subsystem_out1_hEnd              : std_logic;
  SIGNAL Subsystem_out1_vStart            : std_logic;
  SIGNAL Subsystem_out1_vEnd              : std_logic;
  SIGNAL Subsystem_out1_valid             : std_logic;
  SIGNAL Pixel_Switch1_out1_hStart        : std_logic;
  SIGNAL Pixel_Switch1_out1_hEnd          : std_logic;
  SIGNAL Pixel_Switch1_out1_vStart        : std_logic;
  SIGNAL Pixel_Switch1_out1_vEnd          : std_logic;
  SIGNAL Pixel_Switch1_out1_valid         : std_logic;
  SIGNAL HistogramReadOut_out1            : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Compare_To_Constant3_out1        : std_logic;
  SIGNAL Histogram2_out2                  : std_logic;
  SIGNAL Histogram2_out1                  : std_logic_vector(5 DOWNTO 0);  -- ufix6
  SIGNAL Histogram2_out3                  : std_logic;
  SIGNAL Histogram2_out1_unsigned         : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL Logical_Operator7_out1           : std_logic;
  SIGNAL Delay3_reg                       : std_logic_vector(0 TO 3);  -- ufix1 [4]
  SIGNAL Delay3_out1                      : std_logic;
  SIGNAL Subsystem1_out1_hStart           : std_logic;
  SIGNAL Subsystem1_out1_hEnd             : std_logic;
  SIGNAL Subsystem1_out1_vStart           : std_logic;
  SIGNAL Subsystem1_out1_vEnd             : std_logic;
  SIGNAL Subsystem1_out1_valid            : std_logic;
  SIGNAL Pixel_Switch3_out1_hStart        : std_logic;
  SIGNAL Pixel_Switch3_out1_hEnd          : std_logic;
  SIGNAL Pixel_Switch3_out1_vStart        : std_logic;
  SIGNAL Pixel_Switch3_out1_vEnd          : std_logic;
  SIGNAL Pixel_Switch3_out1_valid         : std_logic;
  SIGNAL HistogramReadOut1_out1           : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Compare_To_Constant4_out1        : std_logic;
  SIGNAL Histogram1_out2                  : std_logic;
  SIGNAL Histogram1_out1                  : std_logic_vector(5 DOWNTO 0);  -- ufix6
  SIGNAL Histogram1_out3                  : std_logic;
  SIGNAL Histogram1_out1_unsigned         : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL Pixel_Switch_out1                : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL Valid_Switch_out1                : std_logic;
  SIGNAL Delay1_out1                      : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay_out1                       : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Valid_Switch1_out1               : unsigned(9 DOWNTO 0);  -- ufix10

BEGIN
  u_TiledROIExractor : TiledROIExractor_block
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              controlIn_hStart => controlIn_hStart,
              controlIn_hEnd => controlIn_hEnd,
              controlIn_vStart => controlIn_vStart,
              controlIn_vEnd => controlIn_vEnd,
              controlIn_valid => controlIn_valid,
              pixelIn => pixelIn,
              regionStart => TiledROIExractor_out1,
              pixelOut => TiledROIExractor_out2,  -- ufix10
              controlOut_hStart => TiledROIExractor_out3_hStart,
              controlOut_hEnd => TiledROIExractor_out3_hEnd,
              controlOut_vStart => TiledROIExractor_out3_vStart,
              controlOut_vEnd => TiledROIExractor_out3_vEnd,
              controlOut_valid => TiledROIExractor_out3_valid
              );

  u_Subsystem : Subsystem_block
    PORT MAP( Out1_hStart => Subsystem_out1_hStart,
              Out1_hEnd => Subsystem_out1_hEnd,
              Out1_vStart => Subsystem_out1_vStart,
              Out1_vEnd => Subsystem_out1_vEnd,
              Out1_valid => Subsystem_out1_valid
              );

  u_Histogram2 : Histogram2_block
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              in0 => TiledROIExractor_out2,  -- ufix10
              in1_hStart => Pixel_Switch1_out1_hStart,
              in1_hEnd => Pixel_Switch1_out1_hEnd,
              in1_vStart => Pixel_Switch1_out1_vStart,
              in1_vEnd => Pixel_Switch1_out1_vEnd,
              in1_valid => Pixel_Switch1_out1_valid,
              in2 => std_logic_vector(HistogramReadOut_out1),  -- ufix10
              in3 => Compare_To_Constant3_out1,
              out0 => Histogram2_out1,  -- ufix6
              out1 => Histogram2_out2,
              out2 => Histogram2_out3
              );

  u_Subsystem1 : Subsystem1_block1
    PORT MAP( Out1_hStart => Subsystem1_out1_hStart,
              Out1_hEnd => Subsystem1_out1_hEnd,
              Out1_vStart => Subsystem1_out1_vStart,
              Out1_vEnd => Subsystem1_out1_vEnd,
              Out1_valid => Subsystem1_out1_valid
              );

  u_Histogram1 : Histogram1_block
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              in0 => TiledROIExractor_out2,  -- ufix10
              in1_hStart => Pixel_Switch3_out1_hStart,
              in1_hEnd => Pixel_Switch3_out1_hEnd,
              in1_vStart => Pixel_Switch3_out1_vStart,
              in1_vEnd => Pixel_Switch3_out1_vEnd,
              in1_valid => Pixel_Switch3_out1_valid,
              in2 => std_logic_vector(HistogramReadOut1_out1),  -- ufix10
              in3 => Compare_To_Constant4_out1,
              out0 => Histogram1_out1,  -- ufix6
              out1 => Histogram1_out2,
              out2 => Histogram1_out3
              );

  Logical_Operator6_out1 <=  NOT Delay4_out1;

  Delay4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay4_out1 <= '0';
      ELSIF enb = '1' AND TiledROIExractor_out1 = '1' THEN
        Delay4_out1 <= Logical_Operator6_out1;
      END IF;
    END IF;
  END PROCESS Delay4_process;


  Logical_Operator4_out1 <=  NOT Delay4_out1;

  Delay2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay2_out1 <= '0';
      ELSIF enb = '1' THEN
        Delay2_out1 <= Delay4_out1;
      END IF;
    END IF;
  END PROCESS Delay2_process;


  
  Pixel_Switch1_out1_hStart <= TiledROIExractor_out3_hStart WHEN Delay2_out1 = '0' ELSE
      Subsystem_out1_hStart;

  
  Pixel_Switch1_out1_hEnd <= TiledROIExractor_out3_hEnd WHEN Delay2_out1 = '0' ELSE
      Subsystem_out1_hEnd;

  
  Pixel_Switch1_out1_vStart <= TiledROIExractor_out3_vStart WHEN Delay2_out1 = '0' ELSE
      Subsystem_out1_vStart;

  
  Pixel_Switch1_out1_vEnd <= TiledROIExractor_out3_vEnd WHEN Delay2_out1 = '0' ELSE
      Subsystem_out1_vEnd;

  
  Pixel_Switch1_out1_valid <= TiledROIExractor_out3_valid WHEN Delay2_out1 = '0' ELSE
      Subsystem_out1_valid;

  
  Compare_To_Constant3_out1 <= '1' WHEN HistogramReadOut_out1 = to_unsigned(16#2BC#, 10) ELSE
      '0';

  -- Free running, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  HistogramReadOut_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        HistogramReadOut_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        IF Compare_To_Constant3_out1 = '1' THEN 
          HistogramReadOut_out1 <= to_unsigned(16#000#, 10);
        ELSIF Histogram2_out2 = '1' THEN 
          HistogramReadOut_out1 <= HistogramReadOut_out1 + to_unsigned(16#001#, 10);
        END IF;
      END IF;
    END IF;
  END PROCESS HistogramReadOut_process;


  Histogram2_out1_unsigned <= unsigned(Histogram2_out1);

  Logical_Operator7_out1 <=  NOT Delay4_out1;

  Delay3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay3_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        Delay3_reg(0) <= Logical_Operator7_out1;
        Delay3_reg(1 TO 3) <= Delay3_reg(0 TO 2);
      END IF;
    END IF;
  END PROCESS Delay3_process;

  Delay3_out1 <= Delay3_reg(3);

  
  Pixel_Switch3_out1_hStart <= TiledROIExractor_out3_hStart WHEN Delay3_out1 = '0' ELSE
      Subsystem1_out1_hStart;

  
  Pixel_Switch3_out1_hEnd <= TiledROIExractor_out3_hEnd WHEN Delay3_out1 = '0' ELSE
      Subsystem1_out1_hEnd;

  
  Pixel_Switch3_out1_vStart <= TiledROIExractor_out3_vStart WHEN Delay3_out1 = '0' ELSE
      Subsystem1_out1_vStart;

  
  Pixel_Switch3_out1_vEnd <= TiledROIExractor_out3_vEnd WHEN Delay3_out1 = '0' ELSE
      Subsystem1_out1_vEnd;

  
  Pixel_Switch3_out1_valid <= TiledROIExractor_out3_valid WHEN Delay3_out1 = '0' ELSE
      Subsystem1_out1_valid;

  
  Compare_To_Constant4_out1 <= '1' WHEN HistogramReadOut1_out1 = to_unsigned(16#2BC#, 10) ELSE
      '0';

  -- Free running, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  HistogramReadOut1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        HistogramReadOut1_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        IF Compare_To_Constant4_out1 = '1' THEN 
          HistogramReadOut1_out1 <= to_unsigned(16#000#, 10);
        ELSIF Histogram1_out2 = '1' THEN 
          HistogramReadOut1_out1 <= HistogramReadOut1_out1 + to_unsigned(16#001#, 10);
        END IF;
      END IF;
    END IF;
  END PROCESS HistogramReadOut1_process;


  Histogram1_out1_unsigned <= unsigned(Histogram1_out1);

  
  Pixel_Switch_out1 <= Histogram2_out1_unsigned WHEN Logical_Operator4_out1 = '0' ELSE
      Histogram1_out1_unsigned;

  PositiveHistogramCount <= std_logic_vector(Pixel_Switch_out1);

  
  Valid_Switch_out1 <= Histogram2_out3 WHEN Logical_Operator4_out1 = '0' ELSE
      Histogram1_out3;

  Delay1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay1_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        Delay1_out1 <= HistogramReadOut_out1;
      END IF;
    END IF;
  END PROCESS Delay1_process;


  Delay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        Delay_out1 <= HistogramReadOut1_out1;
      END IF;
    END IF;
  END PROCESS Delay_process;


  
  Valid_Switch1_out1 <= Delay1_out1 WHEN Logical_Operator4_out1 = '0' ELSE
      Delay_out1;

  HistogramAddress <= std_logic_vector(Valid_Switch1_out1);

  HistogramValid <= Valid_Switch_out1;

END rtl;

