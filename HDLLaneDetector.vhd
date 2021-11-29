LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.HDLLaneDetector_pkg.ALL;

ENTITY HDLLaneDetector IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        clk_enable                        :   IN    std_logic;
        pixelIn                           :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        ctrlIn_hStart                     :   IN    std_logic;
        ctrlIn_hEnd                       :   IN    std_logic;
        ctrlIn_vStart                     :   IN    std_logic;
        ctrlIn_vEnd                       :   IN    std_logic;
        ctrlIn_valid                      :   IN    std_logic;
        swStart                           :   IN    std_logic;
        ce_out                            :   OUT   std_logic;
        LeftLane                          :   OUT   vector_of_std_logic_vector16(0 TO 39);  -- uint16 [40]
        RightLane                         :   OUT   vector_of_std_logic_vector16(0 TO 39);  -- uint16 [40]
        dataReady                         :   OUT   std_logic
        );
END HDLLaneDetector;


ARCHITECTURE rtl OF HDLLaneDetector IS

  -- Component Declarations
  COMPONENT Birds_Eye_View
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          in0                             :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          in1_hStart                      :   IN    std_logic;
          in1_hEnd                        :   IN    std_logic;
          in1_vStart                      :   IN    std_logic;
          in1_valid                       :   IN    std_logic;
          out0                            :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
          out1_hStart                     :   OUT   std_logic;
          out1_hEnd                       :   OUT   std_logic;
          out1_vStart                     :   OUT   std_logic;
          out1_vEnd                       :   OUT   std_logic;
          out1_valid                      :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT LaneDetection
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          pixelIn                         :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          ctrlIn_hStart                   :   IN    std_logic;
          ctrlIn_hEnd                     :   IN    std_logic;
          ctrlIn_vStart                   :   IN    std_logic;
          ctrlIn_vEnd                     :   IN    std_logic;
          ctrlIn_valid                    :   IN    std_logic;
          enable                          :   OUT   std_logic;
          lane1                           :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane2                           :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane3                           :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane4                           :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane5                           :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane6                           :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane7                           :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          frameStart                      :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT ComputeEgoLanes
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          laneCapture                     :   IN    std_logic;
          lane1In                         :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane2In                         :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane3In                         :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane4In                         :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane5In                         :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane6In                         :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane7In                         :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          frameStart                      :   IN    std_logic;
          LaneLeft                        :   OUT   std_logic_vector(15 DOWNTO 0);  -- uint16
          LaneRight                       :   OUT   std_logic_vector(15 DOWNTO 0);  -- uint16
          enable                          :   OUT   std_logic;
          start                           :   OUT   std_logic;
          done                            :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT CtrlInterface
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          LaneLeftin                      :   IN    std_logic_vector(15 DOWNTO 0);  -- uint16
          LaneRightin                     :   IN    std_logic_vector(15 DOWNTO 0);  -- uint16
          enable                          :   IN    std_logic;
          hwStart                         :   IN    std_logic;
          hwDone                          :   IN    std_logic;
          swStart                         :   IN    std_logic;
          LaneLeftout                     :   OUT   vector_of_std_logic_vector16(0 TO 39);  -- uint16 [40]
          LaneRightout                    :   OUT   vector_of_std_logic_vector16(0 TO 39);  -- uint16 [40]
          dataReady                       :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : Birds_Eye_View
    USE ENTITY work.Birds_Eye_View(rtl);

  FOR ALL : LaneDetection
    USE ENTITY work.LaneDetection(rtl);

  FOR ALL : ComputeEgoLanes
    USE ENTITY work.ComputeEgoLanes(rtl);

  FOR ALL : CtrlInterface
    USE ENTITY work.CtrlInterface(rtl);

  -- Signals
  SIGNAL Birds_Eye_View_out1              : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL Birds_Eye_View_out2_hStart       : std_logic;
  SIGNAL Birds_Eye_View_out2_hEnd         : std_logic;
  SIGNAL Birds_Eye_View_out2_vStart       : std_logic;
  SIGNAL Birds_Eye_View_out2_vEnd         : std_logic;
  SIGNAL Birds_Eye_View_out2_valid        : std_logic;
  SIGNAL LaneDetection_out1               : std_logic;
  SIGNAL LaneDetection_out2               : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL LaneDetection_out3               : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL LaneDetection_out4               : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL LaneDetection_out5               : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL LaneDetection_out6               : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL LaneDetection_out7               : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL LaneDetection_out8               : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL LaneDetection_out9               : std_logic;
  SIGNAL ComputeEgoLanes_out1             : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL ComputeEgoLanes_out2             : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL ComputeEgoLanes_out3             : std_logic;
  SIGNAL ComputeEgoLanes_out4             : std_logic;
  SIGNAL ComputeEgoLanes_out5             : std_logic;
  SIGNAL LaneLeftout                      : vector_of_std_logic_vector16(0 TO 39);  -- ufix16 [40]
  SIGNAL LaneRightout                     : vector_of_std_logic_vector16(0 TO 39);  -- ufix16 [40]
  SIGNAL dataReady_1                      : std_logic;
  SIGNAL LaneLeftout_unsigned             : vector_of_unsigned16(0 TO 39);  -- uint16 [40]
  SIGNAL LaneLeftout_1                    : vector_of_unsigned16(0 TO 39);  -- uint16 [40]
  SIGNAL LaneRightout_unsigned            : vector_of_unsigned16(0 TO 39);  -- uint16 [40]
  SIGNAL LaneRightout_1                   : vector_of_unsigned16(0 TO 39);  -- uint16 [40]

BEGIN
  u_Birds_Eye_View : Birds_Eye_View
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              in0 => pixelIn,  -- uint8
              in1_hStart => ctrlIn_hStart,
              in1_hEnd => ctrlIn_hEnd,
              in1_vStart => ctrlIn_vStart,
              in1_valid => ctrlIn_valid,
              out0 => Birds_Eye_View_out1,  -- uint8
              out1_hStart => Birds_Eye_View_out2_hStart,
              out1_hEnd => Birds_Eye_View_out2_hEnd,
              out1_vStart => Birds_Eye_View_out2_vStart,
              out1_vEnd => Birds_Eye_View_out2_vEnd,
              out1_valid => Birds_Eye_View_out2_valid
              );

  u_LaneDetection : LaneDetection
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              pixelIn => Birds_Eye_View_out1,  -- uint8
              ctrlIn_hStart => Birds_Eye_View_out2_hStart,
              ctrlIn_hEnd => Birds_Eye_View_out2_hEnd,
              ctrlIn_vStart => Birds_Eye_View_out2_vStart,
              ctrlIn_vEnd => Birds_Eye_View_out2_vEnd,
              ctrlIn_valid => Birds_Eye_View_out2_valid,
              enable => LaneDetection_out1,
              lane1 => LaneDetection_out2,  -- ufix10
              lane2 => LaneDetection_out3,  -- ufix10
              lane3 => LaneDetection_out4,  -- ufix10
              lane4 => LaneDetection_out5,  -- ufix10
              lane5 => LaneDetection_out6,  -- ufix10
              lane6 => LaneDetection_out7,  -- ufix10
              lane7 => LaneDetection_out8,  -- ufix10
              frameStart => LaneDetection_out9
              );

  u_ComputeEgoLanes : ComputeEgoLanes
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              laneCapture => LaneDetection_out1,
              lane1In => LaneDetection_out2,  -- ufix10
              lane2In => LaneDetection_out3,  -- ufix10
              lane3In => LaneDetection_out4,  -- ufix10
              lane4In => LaneDetection_out5,  -- ufix10
              lane5In => LaneDetection_out6,  -- ufix10
              lane6In => LaneDetection_out7,  -- ufix10
              lane7In => LaneDetection_out8,  -- ufix10
              frameStart => LaneDetection_out9,
              LaneLeft => ComputeEgoLanes_out1,  -- uint16
              LaneRight => ComputeEgoLanes_out2,  -- uint16
              enable => ComputeEgoLanes_out3,
              start => ComputeEgoLanes_out4,
              done => ComputeEgoLanes_out5
              );

  u_CtrlInterface : CtrlInterface
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              LaneLeftin => ComputeEgoLanes_out1,  -- uint16
              LaneRightin => ComputeEgoLanes_out2,  -- uint16
              enable => ComputeEgoLanes_out3,
              hwStart => ComputeEgoLanes_out4,
              hwDone => ComputeEgoLanes_out5,
              swStart => swStart,
              LaneLeftout => LaneLeftout,  -- uint16 [40]
              LaneRightout => LaneRightout,  -- uint16 [40]
              dataReady => dataReady_1
              );

  outputgen3: FOR k IN 0 TO 39 GENERATE
    LaneLeftout_unsigned(k) <= unsigned(LaneLeftout(k));
  END GENERATE;

  LaneLeftout_1 <= LaneLeftout_unsigned;

  outputgen2: FOR k IN 0 TO 39 GENERATE
    LeftLane(k) <= std_logic_vector(LaneLeftout_1(k));
  END GENERATE;

  outputgen1: FOR k IN 0 TO 39 GENERATE
    LaneRightout_unsigned(k) <= unsigned(LaneRightout(k));
  END GENERATE;

  LaneRightout_1 <= LaneRightout_unsigned;

  outputgen: FOR k IN 0 TO 39 GENERATE
    RightLane(k) <= std_logic_vector(LaneRightout_1(k));
  END GENERATE;

  dataReady <= dataReady_1;

  ce_out <= clk_enable;


END rtl;

