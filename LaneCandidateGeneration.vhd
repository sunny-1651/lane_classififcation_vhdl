LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.HDLLaneDetector_pkg.ALL;

ENTITY LaneCandidateGeneration IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        pixelIn                           :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En15
        crtlIn_hStart                     :   IN    std_logic;
        crtlIn_hEnd                       :   IN    std_logic;
        crtlIn_vStart                     :   IN    std_logic;
        crtlIn_vEnd                       :   IN    std_logic;
        crtlIn_valid                      :   IN    std_logic;
        lane1                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane2                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane3                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane4                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane5                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane6                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane7                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        laneCapture                       :   OUT   std_logic;
        frameStart                        :   OUT   std_logic
        );
END LaneCandidateGeneration;


ARCHITECTURE rtl OF LaneCandidateGeneration IS

  -- Component Declarations
  COMPONENT HistogramColumnCount
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          pixelIn                         :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En15
          controlIn_hStart                :   IN    std_logic;
          controlIn_hEnd                  :   IN    std_logic;
          controlIn_vStart                :   IN    std_logic;
          controlIn_vEnd                  :   IN    std_logic;
          controlIn_valid                 :   IN    std_logic;
          PositiveHistogramCount          :   OUT   std_logic_vector(5 DOWNTO 0);  -- ufix6
          HistogramValid                  :   OUT   std_logic;
          HistogramAddress                :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          NegativeHistogramCount          :   OUT   std_logic_vector(5 DOWNTO 0)  -- ufix6
          );
  END COMPONENT;

  COMPONENT OverlapandMultiply
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          posHistCount                    :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          negHistCount                    :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          matchedHist                     :   OUT   std_logic_vector(11 DOWNTO 0)  -- ufix12
          );
  END COMPONENT;

  COMPONENT ZeroCrossingFilter
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          In1                             :   IN    std_logic_vector(11 DOWNTO 0);  -- ufix12
          In2                             :   IN    std_logic;
          Out1                            :   OUT   std_logic_vector(30 DOWNTO 0)  -- sfix31_En10
          );
  END COMPONENT;

  COMPONENT StoreDominantLanes
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          LaneCapture                     :   IN    std_logic;
          PeakFIlterAddress               :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          PeakFIlterData                  :   IN    std_logic_vector(30 DOWNTO 0);  -- sfix31_En10
          laneAddress                     :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane1                           :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane2                           :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane3                           :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane4                           :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane5                           :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane6                           :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          lane7                           :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : HistogramColumnCount
    USE ENTITY work.HistogramColumnCount(rtl);

  FOR ALL : OverlapandMultiply
    USE ENTITY work.OverlapandMultiply(rtl);

  FOR ALL : ZeroCrossingFilter
    USE ENTITY work.ZeroCrossingFilter(rtl);

  FOR ALL : StoreDominantLanes
    USE ENTITY work.StoreDominantLanes(rtl);

  -- Signals
  SIGNAL HistogramColumnCount_out1        : std_logic_vector(5 DOWNTO 0);  -- ufix6
  SIGNAL HistogramColumnCount_out2        : std_logic;
  SIGNAL HistogramColumnCount_out3        : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL HistogramColumnCount_out4        : std_logic_vector(5 DOWNTO 0);  -- ufix6
  SIGNAL HistogramColumnCount_out3_unsigned : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL DelayBalance2_reg                : vector_of_unsigned10(0 TO 11);  -- ufix10 [12]
  SIGNAL DelayBalance2_out1               : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay9_out1                      : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Compare_To_Constant2_out1        : std_logic;
  SIGNAL OverlapandMultiply_out1          : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL DelayBalance1_reg                : std_logic_vector(0 TO 11);  -- ufix1 [12]
  SIGNAL DelayBalance1_out1               : std_logic;
  SIGNAL ZeroCrossingFilter_out1          : std_logic_vector(30 DOWNTO 0);  -- ufix31
  SIGNAL ZeroCrossingFilter_out1_signed   : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL Delay_out1                       : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL StoreDominantLanes_out1          : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL StoreDominantLanes_out2          : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL StoreDominantLanes_out3          : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL StoreDominantLanes_out4          : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL StoreDominantLanes_out5          : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL StoreDominantLanes_out6          : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL StoreDominantLanes_out7          : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL vStart                           : std_logic;
  SIGNAL DelayBalance3_reg                : std_logic_vector(0 TO 11);  -- ufix1 [12]
  SIGNAL DelayBalance3_out1               : std_logic;

BEGIN
  u_HistogramColumnCount : HistogramColumnCount
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              pixelIn => pixelIn,  -- sfix24_En15
              controlIn_hStart => crtlIn_hStart,
              controlIn_hEnd => crtlIn_hEnd,
              controlIn_vStart => crtlIn_vStart,
              controlIn_vEnd => crtlIn_vEnd,
              controlIn_valid => crtlIn_valid,
              PositiveHistogramCount => HistogramColumnCount_out1,  -- ufix6
              HistogramValid => HistogramColumnCount_out2,
              HistogramAddress => HistogramColumnCount_out3,  -- ufix10
              NegativeHistogramCount => HistogramColumnCount_out4  -- ufix6
              );

  u_OverlapandMultiply : OverlapandMultiply
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              posHistCount => HistogramColumnCount_out1,  -- ufix6
              negHistCount => HistogramColumnCount_out4,  -- ufix6
              matchedHist => OverlapandMultiply_out1  -- ufix12
              );

  u_ZeroCrossingFilter : ZeroCrossingFilter
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              In1 => OverlapandMultiply_out1,  -- ufix12
              In2 => DelayBalance1_out1,
              Out1 => ZeroCrossingFilter_out1  -- sfix31_En10
              );

  u_StoreDominantLanes : StoreDominantLanes
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              LaneCapture => Compare_To_Constant2_out1,
              PeakFIlterAddress => std_logic_vector(Delay9_out1),  -- ufix10
              PeakFIlterData => std_logic_vector(Delay_out1),  -- sfix31_En10
              laneAddress => std_logic_vector(Delay9_out1),  -- ufix10
              lane1 => StoreDominantLanes_out1,  -- ufix10
              lane2 => StoreDominantLanes_out2,  -- ufix10
              lane3 => StoreDominantLanes_out3,  -- ufix10
              lane4 => StoreDominantLanes_out4,  -- ufix10
              lane5 => StoreDominantLanes_out5,  -- ufix10
              lane6 => StoreDominantLanes_out6,  -- ufix10
              lane7 => StoreDominantLanes_out7  -- ufix10
              );

  HistogramColumnCount_out3_unsigned <= unsigned(HistogramColumnCount_out3);

  DelayBalance2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        DelayBalance2_reg <= (OTHERS => to_unsigned(16#000#, 10));
      ELSIF enb = '1' THEN
        DelayBalance2_reg(0) <= HistogramColumnCount_out3_unsigned;
        DelayBalance2_reg(1 TO 11) <= DelayBalance2_reg(0 TO 10);
      END IF;
    END IF;
  END PROCESS DelayBalance2_process;

  DelayBalance2_out1 <= DelayBalance2_reg(11);

  Delay9_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay9_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        Delay9_out1 <= DelayBalance2_out1;
      END IF;
    END IF;
  END PROCESS Delay9_process;


  
  Compare_To_Constant2_out1 <= '1' WHEN Delay9_out1 = to_unsigned(16#280#, 10) ELSE
      '0';

  DelayBalance1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        DelayBalance1_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        DelayBalance1_reg(0) <= HistogramColumnCount_out2;
        DelayBalance1_reg(1 TO 11) <= DelayBalance1_reg(0 TO 10);
      END IF;
    END IF;
  END PROCESS DelayBalance1_process;

  DelayBalance1_out1 <= DelayBalance1_reg(11);

  ZeroCrossingFilter_out1_signed <= signed(ZeroCrossingFilter_out1);

  Delay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay_out1 <= to_signed(16#00000000#, 31);
      ELSIF enb = '1' THEN
        Delay_out1 <= ZeroCrossingFilter_out1_signed;
      END IF;
    END IF;
  END PROCESS Delay_process;


  vStart <= crtlIn_vStart;

  DelayBalance3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        DelayBalance3_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        DelayBalance3_reg(0) <= vStart;
        DelayBalance3_reg(1 TO 11) <= DelayBalance3_reg(0 TO 10);
      END IF;
    END IF;
  END PROCESS DelayBalance3_process;

  DelayBalance3_out1 <= DelayBalance3_reg(11);

  lane1 <= StoreDominantLanes_out1;

  lane2 <= StoreDominantLanes_out2;

  lane3 <= StoreDominantLanes_out3;

  lane4 <= StoreDominantLanes_out4;

  lane5 <= StoreDominantLanes_out5;

  lane6 <= StoreDominantLanes_out6;

  lane7 <= StoreDominantLanes_out7;

  laneCapture <= Compare_To_Constant2_out1;

  frameStart <= DelayBalance3_out1;

END rtl;

