LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.HDLLaneDetector_pkg.ALL;

ENTITY OutlierRemoval IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        LaneCapture                       :   IN    std_logic;
        RightLaneOffset                   :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
        RightLaneVal                      :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        LeftLaneOffset                    :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
        LeftLaneVal                       :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        LaneRight                         :   OUT   std_logic_vector(15 DOWNTO 0);  -- uint16
        LaneLeft                          :   OUT   std_logic_vector(15 DOWNTO 0)  -- uint16
        );
END OutlierRemoval;


ARCHITECTURE rtl OF OutlierRemoval IS

  -- Component Declarations
  COMPONENT AverageRightWidth
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          data                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          Enable                          :   IN    std_logic;
          average                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En18
          );
  END COMPONENT;

  COMPONENT AverageLeftWidth
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          data                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          Enable                          :   IN    std_logic;
          average                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En18
          );
  END COMPONENT;

  COMPONENT UpdateLaneWidth
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          rightwidth                      :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En18
          RightOffset                     :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          CaptureLane                     :   IN    std_logic;
          LeftOffset                      :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          leftwidth                       :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En18
          LaneWidth                       :   OUT   std_logic_vector(17 DOWNTO 0)  -- sfix18
          );
  END COMPONENT;

  COMPONENT RemoveOutlier
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          laneVal                         :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          offsetVal                       :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          width                           :   IN    std_logic_vector(17 DOWNTO 0);  -- sfix18
          Inlier                          :   OUT   std_logic_vector(15 DOWNTO 0)  -- uint16
          );
  END COMPONENT;

  COMPONENT RemoveOutlier1
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          laneVal                         :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          offsetVal                       :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          width                           :   IN    std_logic_vector(17 DOWNTO 0);  -- sfix18
          Inlier                          :   OUT   std_logic_vector(15 DOWNTO 0)  -- uint16
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : AverageRightWidth
    USE ENTITY work.AverageRightWidth(rtl);

  FOR ALL : AverageLeftWidth
    USE ENTITY work.AverageLeftWidth(rtl);

  FOR ALL : UpdateLaneWidth
    USE ENTITY work.UpdateLaneWidth(rtl);

  FOR ALL : RemoveOutlier
    USE ENTITY work.RemoveOutlier(rtl);

  FOR ALL : RemoveOutlier1
    USE ENTITY work.RemoveOutlier1(rtl);

  -- Signals
  SIGNAL RightLaneVal_unsigned            : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL RightLaneOffset_signed           : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay3_reg                       : vector_of_unsigned10(0 TO 8);  -- ufix10 [9]
  SIGNAL Delay3_out1                      : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay2_reg                       : vector_of_signed12(0 TO 8);  -- sfix12 [9]
  SIGNAL Delay2_out1                      : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL AverageRightWidth_out1           : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL AverageLeftWidth_out1            : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL UpdateLaneWidth_out1             : std_logic_vector(17 DOWNTO 0);  -- ufix18
  SIGNAL RemoveOutlier_out1               : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL LeftLaneVal_unsigned             : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL LeftLaneOffset_signed            : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay5_reg                       : vector_of_unsigned10(0 TO 8);  -- ufix10 [9]
  SIGNAL Delay5_out1                      : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay4_reg                       : vector_of_signed12(0 TO 8);  -- sfix12 [9]
  SIGNAL Delay4_out1                      : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL RemoveOutlier1_out1              : std_logic_vector(15 DOWNTO 0);  -- ufix16

BEGIN
  u_AverageRightWidth : AverageRightWidth
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              data => RightLaneOffset,  -- sfix12
              Enable => LaneCapture,
              average => AverageRightWidth_out1  -- sfix32_En18
              );

  u_AverageLeftWidth : AverageLeftWidth
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              data => LeftLaneOffset,  -- sfix12
              Enable => LaneCapture,
              average => AverageLeftWidth_out1  -- sfix32_En18
              );

  u_UpdateLaneWidth : UpdateLaneWidth
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              rightwidth => AverageRightWidth_out1,  -- sfix32_En18
              RightOffset => RightLaneOffset,  -- sfix12
              CaptureLane => LaneCapture,
              LeftOffset => LeftLaneOffset,  -- sfix12
              leftwidth => AverageLeftWidth_out1,  -- sfix32_En18
              LaneWidth => UpdateLaneWidth_out1  -- sfix18
              );

  u_RemoveOutlier : RemoveOutlier
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              laneVal => std_logic_vector(Delay3_out1),  -- ufix10
              offsetVal => std_logic_vector(Delay2_out1),  -- sfix12
              width => UpdateLaneWidth_out1,  -- sfix18
              Inlier => RemoveOutlier_out1  -- uint16
              );

  u_RemoveOutlier1 : RemoveOutlier1
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              laneVal => std_logic_vector(Delay5_out1),  -- ufix10
              offsetVal => std_logic_vector(Delay4_out1),  -- sfix12
              width => UpdateLaneWidth_out1,  -- sfix18
              Inlier => RemoveOutlier1_out1  -- uint16
              );

  RightLaneVal_unsigned <= unsigned(RightLaneVal);

  RightLaneOffset_signed <= signed(RightLaneOffset);

  Delay3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay3_reg <= (OTHERS => to_unsigned(16#000#, 10));
      ELSIF enb = '1' THEN
        Delay3_reg(0) <= RightLaneVal_unsigned;
        Delay3_reg(1 TO 8) <= Delay3_reg(0 TO 7);
      END IF;
    END IF;
  END PROCESS Delay3_process;

  Delay3_out1 <= Delay3_reg(8);

  Delay2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay2_reg <= (OTHERS => to_signed(16#000#, 12));
      ELSIF enb = '1' THEN
        Delay2_reg(0) <= RightLaneOffset_signed;
        Delay2_reg(1 TO 8) <= Delay2_reg(0 TO 7);
      END IF;
    END IF;
  END PROCESS Delay2_process;

  Delay2_out1 <= Delay2_reg(8);

  LeftLaneVal_unsigned <= unsigned(LeftLaneVal);

  LeftLaneOffset_signed <= signed(LeftLaneOffset);

  Delay5_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay5_reg <= (OTHERS => to_unsigned(16#000#, 10));
      ELSIF enb = '1' THEN
        Delay5_reg(0) <= LeftLaneVal_unsigned;
        Delay5_reg(1 TO 8) <= Delay5_reg(0 TO 7);
      END IF;
    END IF;
  END PROCESS Delay5_process;

  Delay5_out1 <= Delay5_reg(8);

  Delay4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay4_reg <= (OTHERS => to_signed(16#000#, 12));
      ELSIF enb = '1' THEN
        Delay4_reg(0) <= LeftLaneOffset_signed;
        Delay4_reg(1 TO 8) <= Delay4_reg(0 TO 7);
      END IF;
    END IF;
  END PROCESS Delay4_process;

  Delay4_out1 <= Delay4_reg(8);

  LaneRight <= RemoveOutlier_out1;

  LaneLeft <= RemoveOutlier1_out1;

END rtl;

