LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY LaneDetection IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        pixelIn                           :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        ctrlIn_hStart                     :   IN    std_logic;
        ctrlIn_hEnd                       :   IN    std_logic;
        ctrlIn_vStart                     :   IN    std_logic;
        ctrlIn_vEnd                       :   IN    std_logic;
        ctrlIn_valid                      :   IN    std_logic;
        enable                            :   OUT   std_logic;
        lane1                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane2                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane3                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane4                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane5                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane6                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane7                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        frameStart                        :   OUT   std_logic
        );
END LaneDetection;


ARCHITECTURE rtl OF LaneDetection IS

  -- Component Declarations
  COMPONENT VerticallyOrientatedFilter
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          in0                             :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          in1_hStart                      :   IN    std_logic;
          in1_hEnd                        :   IN    std_logic;
          in1_vStart                      :   IN    std_logic;
          in1_vEnd                        :   IN    std_logic;
          in1_valid                       :   IN    std_logic;
          out0                            :   OUT   std_logic_vector(23 DOWNTO 0);  -- sfix24_En15
          out1_hStart                     :   OUT   std_logic;
          out1_hEnd                       :   OUT   std_logic;
          out1_vStart                     :   OUT   std_logic;
          out1_vEnd                       :   OUT   std_logic;
          out1_valid                      :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT LaneCandidateGeneration
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          pixelIn                         :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En15
          crtlIn_hStart                   :   IN    std_logic;
          crtlIn_hEnd                     :   IN    std_logic;
          crtlIn_vStart                   :   IN    std_logic;
          crtlIn_vEnd                     :   IN    std_logic;
          crtlIn_valid                    :   IN    std_logic;
          lane1                           :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane2                           :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane3                           :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane4                           :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane5                           :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane6                           :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane7                           :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          laneCapture                     :   OUT   std_logic;
          frameStart                      :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : VerticallyOrientatedFilter
    USE ENTITY work.VerticallyOrientatedFilter(rtl);

  FOR ALL : LaneCandidateGeneration
    USE ENTITY work.LaneCandidateGeneration(rtl);

  -- Signals
  SIGNAL VerticallyOrientatedFilter_out1  : std_logic_vector(23 DOWNTO 0);  -- ufix24
  SIGNAL VerticallyOrientatedFilter_out2_hStart : std_logic;
  SIGNAL VerticallyOrientatedFilter_out2_hEnd : std_logic;
  SIGNAL VerticallyOrientatedFilter_out2_vStart : std_logic;
  SIGNAL VerticallyOrientatedFilter_out2_vEnd : std_logic;
  SIGNAL VerticallyOrientatedFilter_out2_valid : std_logic;
  SIGNAL LaneCandidateGeneration_out1     : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL LaneCandidateGeneration_out2     : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL LaneCandidateGeneration_out3     : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL LaneCandidateGeneration_out4     : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL LaneCandidateGeneration_out5     : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL LaneCandidateGeneration_out6     : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL LaneCandidateGeneration_out7     : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL LaneCandidateGeneration_out8     : std_logic;
  SIGNAL LaneCandidateGeneration_out9     : std_logic;

BEGIN
  u_VerticallyOrientatedFilter : VerticallyOrientatedFilter
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              in0 => pixelIn,  -- uint8
              in1_hStart => ctrlIn_hStart,
              in1_hEnd => ctrlIn_hEnd,
              in1_vStart => ctrlIn_vStart,
              in1_vEnd => ctrlIn_vEnd,
              in1_valid => ctrlIn_valid,
              out0 => VerticallyOrientatedFilter_out1,  -- sfix24_En15
              out1_hStart => VerticallyOrientatedFilter_out2_hStart,
              out1_hEnd => VerticallyOrientatedFilter_out2_hEnd,
              out1_vStart => VerticallyOrientatedFilter_out2_vStart,
              out1_vEnd => VerticallyOrientatedFilter_out2_vEnd,
              out1_valid => VerticallyOrientatedFilter_out2_valid
              );

  u_LaneCandidateGeneration : LaneCandidateGeneration
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              pixelIn => VerticallyOrientatedFilter_out1,  -- sfix24_En15
              crtlIn_hStart => VerticallyOrientatedFilter_out2_hStart,
              crtlIn_hEnd => VerticallyOrientatedFilter_out2_hEnd,
              crtlIn_vStart => VerticallyOrientatedFilter_out2_vStart,
              crtlIn_vEnd => VerticallyOrientatedFilter_out2_vEnd,
              crtlIn_valid => VerticallyOrientatedFilter_out2_valid,
              lane1 => LaneCandidateGeneration_out1,  -- ufix10
              lane2 => LaneCandidateGeneration_out2,  -- ufix10
              lane3 => LaneCandidateGeneration_out3,  -- ufix10
              lane4 => LaneCandidateGeneration_out4,  -- ufix10
              lane5 => LaneCandidateGeneration_out5,  -- ufix10
              lane6 => LaneCandidateGeneration_out6,  -- ufix10
              lane7 => LaneCandidateGeneration_out7,  -- ufix10
              laneCapture => LaneCandidateGeneration_out8,
              frameStart => LaneCandidateGeneration_out9
              );

  enable <= LaneCandidateGeneration_out8;

  lane1 <= LaneCandidateGeneration_out1;

  lane2 <= LaneCandidateGeneration_out2;

  lane3 <= LaneCandidateGeneration_out3;

  lane4 <= LaneCandidateGeneration_out4;

  lane5 <= LaneCandidateGeneration_out5;

  lane6 <= LaneCandidateGeneration_out6;

  lane7 <= LaneCandidateGeneration_out7;

  frameStart <= LaneCandidateGeneration_out9;

END rtl;

