LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ComputeEgoLanes IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        laneCapture                       :   IN    std_logic;
        lane1In                           :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane2In                           :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane3In                           :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane4In                           :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane5In                           :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane6In                           :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane7In                           :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        frameStart                        :   IN    std_logic;
        LaneLeft                          :   OUT   std_logic_vector(15 DOWNTO 0);  -- uint16
        LaneRight                         :   OUT   std_logic_vector(15 DOWNTO 0);  -- uint16
        enable                            :   OUT   std_logic;
        start                             :   OUT   std_logic;
        done                              :   OUT   std_logic
        );
END ComputeEgoLanes;


ARCHITECTURE rtl OF ComputeEgoLanes IS

  -- Component Declarations
  COMPONENT FirstPassEgoLane
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          lane1                           :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane2                           :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane3                           :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane4                           :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane5                           :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane6                           :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane7                           :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          RightLaneOffset                 :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          RightLaneLoc                    :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          LeftLaneOffset                  :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          LeftLaneLoc                     :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
          );
  END COMPONENT;

  COMPONENT OutlierRemoval
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          LaneCapture                     :   IN    std_logic;
          RightLaneOffset                 :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          RightLaneVal                    :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          LeftLaneOffset                  :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          LeftLaneVal                     :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          LaneRight                       :   OUT   std_logic_vector(15 DOWNTO 0);  -- uint16
          LaneLeft                        :   OUT   std_logic_vector(15 DOWNTO 0)  -- uint16
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : FirstPassEgoLane
    USE ENTITY work.FirstPassEgoLane(rtl);

  FOR ALL : OutlierRemoval
    USE ENTITY work.OutlierRemoval(rtl);

  -- Signals
  SIGNAL FirstPassEgoLane_out1            : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL FirstPassEgoLane_out2            : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL FirstPassEgoLane_out3            : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL FirstPassEgoLane_out4            : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL FirstPassEgoLane_out1_signed     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay22_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Abs_y                            : signed(12 DOWNTO 0);  -- sfix13
  SIGNAL Abs_out1                         : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay25_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL FirstPassEgoLane_out3_signed     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay23_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Abs1_y                           : signed(12 DOWNTO 0);  -- sfix13
  SIGNAL Abs1_out1                        : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay24_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL OutlierRemoval_out1              : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL OutlierRemoval_out2              : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL Delay1_reg                       : std_logic_vector(0 TO 14);  -- ufix1 [15]
  SIGNAL Delay1_out1                      : std_logic;
  SIGNAL Delay_reg                        : std_logic_vector(0 TO 14);  -- ufix1 [15]
  SIGNAL Delay_out1                       : std_logic;
  SIGNAL Delay2_reg                       : std_logic_vector(0 TO 14);  -- ufix1 [15]
  SIGNAL Delay2_out1                      : std_logic;
  SIGNAL HDL_Counter_out1                 : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL Compare_To_Constant_out1         : std_logic;
  SIGNAL Delay6_reg                       : std_logic_vector(0 TO 14);  -- ufix1 [15]
  SIGNAL Delay6_out1                      : std_logic;

BEGIN
  u_FirstPassEgoLane : FirstPassEgoLane
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              lane1 => lane1In,  -- ufix10
              lane2 => lane2In,  -- ufix10
              lane3 => lane3In,  -- ufix10
              lane4 => lane4In,  -- ufix10
              lane5 => lane5In,  -- ufix10
              lane6 => lane6In,  -- ufix10
              lane7 => lane7In,  -- ufix10
              RightLaneOffset => FirstPassEgoLane_out1,  -- sfix12
              RightLaneLoc => FirstPassEgoLane_out2,  -- ufix10
              LeftLaneOffset => FirstPassEgoLane_out3,  -- sfix12
              LeftLaneLoc => FirstPassEgoLane_out4  -- ufix10
              );

  u_OutlierRemoval : OutlierRemoval
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              LaneCapture => laneCapture,
              RightLaneOffset => std_logic_vector(Delay25_out1),  -- sfix12
              RightLaneVal => FirstPassEgoLane_out2,  -- ufix10
              LeftLaneOffset => std_logic_vector(Delay24_out1),  -- sfix12
              LeftLaneVal => FirstPassEgoLane_out4,  -- ufix10
              LaneRight => OutlierRemoval_out1,  -- uint16
              LaneLeft => OutlierRemoval_out2  -- uint16
              );

  FirstPassEgoLane_out1_signed <= signed(FirstPassEgoLane_out1);

  Delay22_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay22_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay22_out1 <= FirstPassEgoLane_out1_signed;
      END IF;
    END IF;
  END PROCESS Delay22_process;


  
  Abs_y <=  - (resize(Delay22_out1, 13)) WHEN Delay22_out1 < to_signed(16#000#, 12) ELSE
      resize(Delay22_out1, 13);
  Abs_out1 <= Abs_y(11 DOWNTO 0);

  Delay25_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay25_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay25_out1 <= Abs_out1;
      END IF;
    END IF;
  END PROCESS Delay25_process;


  FirstPassEgoLane_out3_signed <= signed(FirstPassEgoLane_out3);

  Delay23_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay23_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay23_out1 <= FirstPassEgoLane_out3_signed;
      END IF;
    END IF;
  END PROCESS Delay23_process;


  
  Abs1_y <=  - (resize(Delay23_out1, 13)) WHEN Delay23_out1 < to_signed(16#000#, 12) ELSE
      resize(Delay23_out1, 13);
  Abs1_out1 <= Abs1_y(11 DOWNTO 0);

  Delay24_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay24_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay24_out1 <= Abs1_out1;
      END IF;
    END IF;
  END PROCESS Delay24_process;


  Delay1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay1_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        Delay1_reg(0) <= laneCapture;
        Delay1_reg(1 TO 14) <= Delay1_reg(0 TO 13);
      END IF;
    END IF;
  END PROCESS Delay1_process;

  Delay1_out1 <= Delay1_reg(14);

  Delay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        Delay_reg(0) <= frameStart;
        Delay_reg(1 TO 14) <= Delay_reg(0 TO 13);
      END IF;
    END IF;
  END PROCESS Delay_process;

  Delay_out1 <= Delay_reg(14);

  Delay2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay2_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        Delay2_reg(0) <= laneCapture;
        Delay2_reg(1 TO 14) <= Delay2_reg(0 TO 13);
      END IF;
    END IF;
  END PROCESS Delay2_process;

  Delay2_out1 <= Delay2_reg(14);

  -- Free running, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  HDL_Counter_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        HDL_Counter_out1 <= to_unsigned(16#00#, 6);
      ELSIF enb = '1' THEN
        IF frameStart = '1' THEN 
          HDL_Counter_out1 <= to_unsigned(16#00#, 6);
        ELSIF Delay2_out1 = '1' THEN 
          HDL_Counter_out1 <= HDL_Counter_out1 + to_unsigned(16#01#, 6);
        END IF;
      END IF;
    END IF;
  END PROCESS HDL_Counter_process;


  
  Compare_To_Constant_out1 <= '1' WHEN HDL_Counter_out1 >= to_unsigned(16#27#, 6) ELSE
      '0';

  Delay6_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay6_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        Delay6_reg(0) <= Compare_To_Constant_out1;
        Delay6_reg(1 TO 14) <= Delay6_reg(0 TO 13);
      END IF;
    END IF;
  END PROCESS Delay6_process;

  Delay6_out1 <= Delay6_reg(14);

  LaneLeft <= OutlierRemoval_out2;

  LaneRight <= OutlierRemoval_out1;

  enable <= Delay1_out1;

  start <= Delay_out1;

  done <= Delay6_out1;

END rtl;

