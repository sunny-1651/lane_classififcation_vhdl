LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY TiledROIExractor_block IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        controlIn_hStart                  :   IN    std_logic;
        controlIn_hEnd                    :   IN    std_logic;
        controlIn_vStart                  :   IN    std_logic;
        controlIn_vEnd                    :   IN    std_logic;
        controlIn_valid                   :   IN    std_logic;
        pixelIn                           :   IN    std_logic;
        regionStart                       :   OUT   std_logic;
        pixelOut                          :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        controlOut_hStart                 :   OUT   std_logic;
        controlOut_hEnd                   :   OUT   std_logic;
        controlOut_vStart                 :   OUT   std_logic;
        controlOut_vEnd                   :   OUT   std_logic;
        controlOut_valid                  :   OUT   std_logic
        );
END TiledROIExractor_block;


ARCHITECTURE rtl OF TiledROIExractor_block IS

  -- Component Declarations
  COMPONENT ROI_Selector_block
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          in0                             :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          in1_hStart                      :   IN    std_logic;
          in1_hEnd                        :   IN    std_logic;
          in1_vStart                      :   IN    std_logic;
          in1_vEnd                        :   IN    std_logic;
          in1_valid                       :   IN    std_logic;
          out0                            :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          out1_hStart                     :   OUT   std_logic;
          out1_hEnd                       :   OUT   std_logic;
          out1_vStart                     :   OUT   std_logic;
          out1_vEnd                       :   OUT   std_logic;
          out1_valid                      :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : ROI_Selector_block
    USE ENTITY work.ROI_Selector_block(rtl);

  -- Signals
  SIGNAL valid                            : std_logic;
  SIGNAL Logical_Operator4_out1           : std_logic;
  SIGNAL Constant1_out1                   : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL hEnd                             : std_logic;
  SIGNAL HDL_Counter1_out1                : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Pixel_Switch1_out1               : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL ROI_Selector_out1                : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL ROI_Selector_out2_hStart         : std_logic;
  SIGNAL ROI_Selector_out2_hEnd           : std_logic;
  SIGNAL ROI_Selector_out2_vStart         : std_logic;
  SIGNAL ROI_Selector_out2_vEnd           : std_logic;
  SIGNAL ROI_Selector_out2_valid          : std_logic;
  SIGNAL vEnd                             : std_logic;

BEGIN
  u_ROI_Selector : ROI_Selector_block
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              in0 => std_logic_vector(Pixel_Switch1_out1),  -- ufix10
              in1_hStart => controlIn_hStart,
              in1_hEnd => controlIn_hEnd,
              in1_vStart => controlIn_vStart,
              in1_vEnd => controlIn_vEnd,
              in1_valid => controlIn_valid,
              out0 => ROI_Selector_out1,  -- ufix10
              out1_hStart => ROI_Selector_out2_hStart,
              out1_hEnd => ROI_Selector_out2_hEnd,
              out1_vStart => ROI_Selector_out2_vStart,
              out1_vEnd => ROI_Selector_out2_vEnd,
              out1_valid => ROI_Selector_out2_valid
              );

  valid <= controlIn_valid;

  Logical_Operator4_out1 <= pixelIn AND valid;

  Constant1_out1 <= to_unsigned(16#000#, 10);

  hEnd <= controlIn_hEnd;

  -- Free running, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  HDL_Counter1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        HDL_Counter1_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        IF hEnd = '1' THEN 
          HDL_Counter1_out1 <= to_unsigned(16#000#, 10);
        ELSIF valid = '1' THEN 
          HDL_Counter1_out1 <= HDL_Counter1_out1 + to_unsigned(16#001#, 10);
        END IF;
      END IF;
    END IF;
  END PROCESS HDL_Counter1_process;


  
  Pixel_Switch1_out1 <= Constant1_out1 WHEN Logical_Operator4_out1 = '0' ELSE
      HDL_Counter1_out1;

  vEnd <= ROI_Selector_out2_vEnd;

  regionStart <= vEnd;

  pixelOut <= ROI_Selector_out1;

  controlOut_hStart <= ROI_Selector_out2_hStart;

  controlOut_hEnd <= ROI_Selector_out2_hEnd;

  controlOut_vStart <= ROI_Selector_out2_vStart;

  controlOut_vEnd <= ROI_Selector_out2_vEnd;

  controlOut_valid <= ROI_Selector_out2_valid;

END rtl;

