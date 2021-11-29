LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.HDLLaneDetector_pkg.ALL;

ENTITY FirstPassEgoLane IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        lane1                             :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane2                             :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane3                             :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane4                             :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane5                             :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane6                             :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane7                             :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        RightLaneOffset                   :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
        RightLaneLoc                      :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        LeftLaneOffset                    :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
        LeftLaneLoc                       :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
        );
END FirstPassEgoLane;


ARCHITECTURE rtl OF FirstPassEgoLane IS

  -- Component Declarations
  COMPONENT Subsystem2
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          laneIn                          :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          RightLaneVal                    :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          LeftLaneVal                     :   OUT   std_logic_vector(11 DOWNTO 0)  -- sfix12
          );
  END COMPONENT;

  COMPONENT Subsystem1
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          laneIn                          :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          RightLaneVal                    :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          LeftLaneVal                     :   OUT   std_logic_vector(11 DOWNTO 0)  -- sfix12
          );
  END COMPONENT;

  COMPONENT rightminop
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          val1                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          val2                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          ind1                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          ind2                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          valmin                          :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          indmin                          :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
          );
  END COMPONENT;

  COMPONENT Subsystem3
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          laneIn                          :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          RightLaneVal                    :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          LeftLaneVal                     :   OUT   std_logic_vector(11 DOWNTO 0)  -- sfix12
          );
  END COMPONENT;

  COMPONENT Subsystem4
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          laneIn                          :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          RightLaneVal                    :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          LeftLaneVal                     :   OUT   std_logic_vector(11 DOWNTO 0)  -- sfix12
          );
  END COMPONENT;

  COMPONENT rightminop2
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          val1                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          val2                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          ind1                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          ind2                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          valmin                          :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          indmin                          :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
          );
  END COMPONENT;

  COMPONENT rightminop9
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          val1                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          val2                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          ind1                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          ind2                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          valmin                          :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          indmin                          :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
          );
  END COMPONENT;

  COMPONENT Subsystem5
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          laneIn                          :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          RightLaneVal                    :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          LeftLaneVal                     :   OUT   std_logic_vector(11 DOWNTO 0)  -- sfix12
          );
  END COMPONENT;

  COMPONENT Subsystem6
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          laneIn                          :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          RightLaneVal                    :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          LeftLaneVal                     :   OUT   std_logic_vector(11 DOWNTO 0)  -- sfix12
          );
  END COMPONENT;

  COMPONENT Subsystem7
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          laneIn                          :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          RightLaneVal                    :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          LeftLaneVal                     :   OUT   std_logic_vector(11 DOWNTO 0)  -- sfix12
          );
  END COMPONENT;

  COMPONENT rightminop4
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          val1                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          val2                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          ind1                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          ind2                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          valmin                          :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          indmin                          :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
          );
  END COMPONENT;

  COMPONENT rightminop7
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          val1                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          val2                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          ind1                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          ind2                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          valmin                          :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          indmin                          :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
          );
  END COMPONENT;

  COMPONENT rightminop10
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          val1                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          val2                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          ind1                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          ind2                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          valmin                          :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          indmin                          :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
          );
  END COMPONENT;

  COMPONENT rightminop1
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          val1                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          val2                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          ind1                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          ind2                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          valmin                          :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          indmin                          :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
          );
  END COMPONENT;

  COMPONENT rightminop3
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          val1                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          val2                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          ind1                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          ind2                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          valmin                          :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          indmin                          :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
          );
  END COMPONENT;

  COMPONENT rightminop8
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          val1                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          val2                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          ind1                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          ind2                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          valmin                          :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          indmin                          :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
          );
  END COMPONENT;

  COMPONENT rightminop5
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          val1                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          val2                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          ind1                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          ind2                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          valmin                          :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          indmin                          :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
          );
  END COMPONENT;

  COMPONENT rightminop6
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          val1                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          val2                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          ind1                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          ind2                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          valmin                          :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          indmin                          :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
          );
  END COMPONENT;

  COMPONENT rightminop11
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          val1                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          val2                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
          ind1                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          ind2                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          valmin                          :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
          indmin                          :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : Subsystem2
    USE ENTITY work.Subsystem2(rtl);

  FOR ALL : Subsystem1
    USE ENTITY work.Subsystem1(rtl);

  FOR ALL : rightminop
    USE ENTITY work.rightminop(rtl);

  FOR ALL : Subsystem3
    USE ENTITY work.Subsystem3(rtl);

  FOR ALL : Subsystem4
    USE ENTITY work.Subsystem4(rtl);

  FOR ALL : rightminop2
    USE ENTITY work.rightminop2(rtl);

  FOR ALL : rightminop9
    USE ENTITY work.rightminop9(rtl);

  FOR ALL : Subsystem5
    USE ENTITY work.Subsystem5(rtl);

  FOR ALL : Subsystem6
    USE ENTITY work.Subsystem6(rtl);

  FOR ALL : Subsystem7
    USE ENTITY work.Subsystem7(rtl);

  FOR ALL : rightminop4
    USE ENTITY work.rightminop4(rtl);

  FOR ALL : rightminop7
    USE ENTITY work.rightminop7(rtl);

  FOR ALL : rightminop10
    USE ENTITY work.rightminop10(rtl);

  FOR ALL : rightminop1
    USE ENTITY work.rightminop1(rtl);

  FOR ALL : rightminop3
    USE ENTITY work.rightminop3(rtl);

  FOR ALL : rightminop8
    USE ENTITY work.rightminop8(rtl);

  FOR ALL : rightminop5
    USE ENTITY work.rightminop5(rtl);

  FOR ALL : rightminop6
    USE ENTITY work.rightminop6(rtl);

  FOR ALL : rightminop11
    USE ENTITY work.rightminop11(rtl);

  -- Signals
  SIGNAL lane1_unsigned                   : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay3_out1                      : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Subsystem2_out1                  : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL Subsystem2_out2                  : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL lane2_unsigned                   : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay4_out1                      : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Subsystem1_out1                  : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL Subsystem1_out2                  : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL rightminop_out1                  : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL rightminop_out2                  : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL lane3_unsigned                   : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay5_out1                      : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Subsystem3_out1                  : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL Subsystem3_out2                  : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL lane4_unsigned                   : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay6_out1                      : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Subsystem4_out1                  : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL Subsystem4_out2                  : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL rightminop2_out1                 : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL rightminop2_out2                 : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL rightminop9_out1                 : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL rightminop9_out2                 : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL lane5_unsigned                   : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay7_out1                      : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Subsystem5_out1                  : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL Subsystem5_out2                  : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL lane6_unsigned                   : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay8_out1                      : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Subsystem6_out1                  : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL Subsystem6_out2                  : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL lane7_unsigned                   : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay9_out1                      : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Subsystem7_out1                  : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL Subsystem7_out2                  : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL Subsystem7_out1_signed           : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL rightminop4_out1                 : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL rightminop4_out2                 : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay_reg                        : vector_of_signed12(0 TO 1);  -- sfix12 [2]
  SIGNAL Delay_out1                       : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay2_reg                       : vector_of_unsigned10(0 TO 1);  -- ufix10 [2]
  SIGNAL Delay2_out1                      : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL rightminop7_out1                 : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL rightminop7_out2                 : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL rightminop10_out1                : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL rightminop10_out2                : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL rightminop1_out1                 : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL rightminop1_out2                 : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL rightminop3_out1                 : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL rightminop3_out2                 : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL rightminop8_out1                 : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL rightminop8_out2                 : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL Subsystem7_out2_signed           : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL rightminop5_out1                 : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL rightminop5_out2                 : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay1_reg                       : vector_of_signed12(0 TO 1);  -- sfix12 [2]
  SIGNAL Delay1_out1                      : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL rightminop6_out1                 : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL rightminop6_out2                 : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL rightminop11_out1                : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL rightminop11_out2                : std_logic_vector(9 DOWNTO 0);  -- ufix10

BEGIN
  u_Subsystem2 : Subsystem2
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              laneIn => std_logic_vector(Delay3_out1),  -- ufix10
              RightLaneVal => Subsystem2_out1,  -- sfix12
              LeftLaneVal => Subsystem2_out2  -- sfix12
              );

  u_Subsystem1 : Subsystem1
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              laneIn => std_logic_vector(Delay4_out1),  -- ufix10
              RightLaneVal => Subsystem1_out1,  -- sfix12
              LeftLaneVal => Subsystem1_out2  -- sfix12
              );

  u_rightminop : rightminop
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              val1 => Subsystem2_out1,  -- sfix12
              val2 => Subsystem1_out1,  -- sfix12
              ind1 => std_logic_vector(Delay3_out1),  -- ufix10
              ind2 => std_logic_vector(Delay4_out1),  -- ufix10
              valmin => rightminop_out1,  -- sfix12
              indmin => rightminop_out2  -- ufix10
              );

  u_Subsystem3 : Subsystem3
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              laneIn => std_logic_vector(Delay5_out1),  -- ufix10
              RightLaneVal => Subsystem3_out1,  -- sfix12
              LeftLaneVal => Subsystem3_out2  -- sfix12
              );

  u_Subsystem4 : Subsystem4
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              laneIn => std_logic_vector(Delay6_out1),  -- ufix10
              RightLaneVal => Subsystem4_out1,  -- sfix12
              LeftLaneVal => Subsystem4_out2  -- sfix12
              );

  u_rightminop2 : rightminop2
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              val1 => Subsystem3_out1,  -- sfix12
              val2 => Subsystem4_out1,  -- sfix12
              ind1 => std_logic_vector(Delay5_out1),  -- ufix10
              ind2 => std_logic_vector(Delay6_out1),  -- ufix10
              valmin => rightminop2_out1,  -- sfix12
              indmin => rightminop2_out2  -- ufix10
              );

  u_rightminop9 : rightminop9
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              val1 => rightminop_out1,  -- sfix12
              val2 => rightminop2_out1,  -- sfix12
              ind1 => rightminop_out2,  -- ufix10
              ind2 => rightminop2_out2,  -- ufix10
              valmin => rightminop9_out1,  -- sfix12
              indmin => rightminop9_out2  -- ufix10
              );

  u_Subsystem5 : Subsystem5
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              laneIn => std_logic_vector(Delay7_out1),  -- ufix10
              RightLaneVal => Subsystem5_out1,  -- sfix12
              LeftLaneVal => Subsystem5_out2  -- sfix12
              );

  u_Subsystem6 : Subsystem6
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              laneIn => std_logic_vector(Delay8_out1),  -- ufix10
              RightLaneVal => Subsystem6_out1,  -- sfix12
              LeftLaneVal => Subsystem6_out2  -- sfix12
              );

  u_Subsystem7 : Subsystem7
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              laneIn => std_logic_vector(Delay9_out1),  -- ufix10
              RightLaneVal => Subsystem7_out1,  -- sfix12
              LeftLaneVal => Subsystem7_out2  -- sfix12
              );

  u_rightminop4 : rightminop4
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              val1 => Subsystem5_out1,  -- sfix12
              val2 => Subsystem6_out1,  -- sfix12
              ind1 => std_logic_vector(Delay7_out1),  -- ufix10
              ind2 => std_logic_vector(Delay8_out1),  -- ufix10
              valmin => rightminop4_out1,  -- sfix12
              indmin => rightminop4_out2  -- ufix10
              );

  u_rightminop7 : rightminop7
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              val1 => rightminop4_out1,  -- sfix12
              val2 => std_logic_vector(Delay_out1),  -- sfix12
              ind1 => rightminop4_out2,  -- ufix10
              ind2 => std_logic_vector(Delay2_out1),  -- ufix10
              valmin => rightminop7_out1,  -- sfix12
              indmin => rightminop7_out2  -- ufix10
              );

  u_rightminop10 : rightminop10
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              val1 => rightminop9_out1,  -- sfix12
              val2 => rightminop7_out1,  -- sfix12
              ind1 => rightminop9_out2,  -- ufix10
              ind2 => rightminop7_out2,  -- ufix10
              valmin => rightminop10_out1,  -- sfix12
              indmin => rightminop10_out2  -- ufix10
              );

  u_rightminop1 : rightminop1
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              val1 => Subsystem2_out2,  -- sfix12
              val2 => Subsystem1_out2,  -- sfix12
              ind1 => std_logic_vector(Delay3_out1),  -- ufix10
              ind2 => std_logic_vector(Delay4_out1),  -- ufix10
              valmin => rightminop1_out1,  -- sfix12
              indmin => rightminop1_out2  -- ufix10
              );

  u_rightminop3 : rightminop3
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              val1 => Subsystem3_out2,  -- sfix12
              val2 => Subsystem4_out2,  -- sfix12
              ind1 => std_logic_vector(Delay5_out1),  -- ufix10
              ind2 => std_logic_vector(Delay6_out1),  -- ufix10
              valmin => rightminop3_out1,  -- sfix12
              indmin => rightminop3_out2  -- ufix10
              );

  u_rightminop8 : rightminop8
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              val1 => rightminop1_out1,  -- sfix12
              val2 => rightminop3_out1,  -- sfix12
              ind1 => rightminop1_out2,  -- ufix10
              ind2 => rightminop3_out2,  -- ufix10
              valmin => rightminop8_out1,  -- sfix12
              indmin => rightminop8_out2  -- ufix10
              );

  u_rightminop5 : rightminop5
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              val1 => Subsystem5_out2,  -- sfix12
              val2 => Subsystem6_out2,  -- sfix12
              ind1 => std_logic_vector(Delay7_out1),  -- ufix10
              ind2 => std_logic_vector(Delay8_out1),  -- ufix10
              valmin => rightminop5_out1,  -- sfix12
              indmin => rightminop5_out2  -- ufix10
              );

  u_rightminop6 : rightminop6
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              val1 => rightminop5_out1,  -- sfix12
              val2 => std_logic_vector(Delay1_out1),  -- sfix12
              ind1 => rightminop5_out2,  -- ufix10
              ind2 => std_logic_vector(Delay2_out1),  -- ufix10
              valmin => rightminop6_out1,  -- sfix12
              indmin => rightminop6_out2  -- ufix10
              );

  u_rightminop11 : rightminop11
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              val1 => rightminop8_out1,  -- sfix12
              val2 => rightminop6_out1,  -- sfix12
              ind1 => rightminop8_out2,  -- ufix10
              ind2 => rightminop6_out2,  -- ufix10
              valmin => rightminop11_out1,  -- sfix12
              indmin => rightminop11_out2  -- ufix10
              );

  lane1_unsigned <= unsigned(lane1);

  Delay3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay3_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        Delay3_out1 <= lane1_unsigned;
      END IF;
    END IF;
  END PROCESS Delay3_process;


  lane2_unsigned <= unsigned(lane2);

  Delay4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay4_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        Delay4_out1 <= lane2_unsigned;
      END IF;
    END IF;
  END PROCESS Delay4_process;


  lane3_unsigned <= unsigned(lane3);

  Delay5_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay5_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        Delay5_out1 <= lane3_unsigned;
      END IF;
    END IF;
  END PROCESS Delay5_process;


  lane4_unsigned <= unsigned(lane4);

  Delay6_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay6_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        Delay6_out1 <= lane4_unsigned;
      END IF;
    END IF;
  END PROCESS Delay6_process;


  lane5_unsigned <= unsigned(lane5);

  Delay7_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay7_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        Delay7_out1 <= lane5_unsigned;
      END IF;
    END IF;
  END PROCESS Delay7_process;


  lane6_unsigned <= unsigned(lane6);

  Delay8_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay8_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        Delay8_out1 <= lane6_unsigned;
      END IF;
    END IF;
  END PROCESS Delay8_process;


  lane7_unsigned <= unsigned(lane7);

  Delay9_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay9_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        Delay9_out1 <= lane7_unsigned;
      END IF;
    END IF;
  END PROCESS Delay9_process;


  Subsystem7_out1_signed <= signed(Subsystem7_out1);

  Delay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay_reg <= (OTHERS => to_signed(16#000#, 12));
      ELSIF enb = '1' THEN
        Delay_reg(0) <= Subsystem7_out1_signed;
        Delay_reg(1) <= Delay_reg(0);
      END IF;
    END IF;
  END PROCESS Delay_process;

  Delay_out1 <= Delay_reg(1);

  Delay2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay2_reg <= (OTHERS => to_unsigned(16#000#, 10));
      ELSIF enb = '1' THEN
        Delay2_reg(0) <= Delay9_out1;
        Delay2_reg(1) <= Delay2_reg(0);
      END IF;
    END IF;
  END PROCESS Delay2_process;

  Delay2_out1 <= Delay2_reg(1);

  Subsystem7_out2_signed <= signed(Subsystem7_out2);

  Delay1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay1_reg <= (OTHERS => to_signed(16#000#, 12));
      ELSIF enb = '1' THEN
        Delay1_reg(0) <= Subsystem7_out2_signed;
        Delay1_reg(1) <= Delay1_reg(0);
      END IF;
    END IF;
  END PROCESS Delay1_process;

  Delay1_out1 <= Delay1_reg(1);

  RightLaneOffset <= rightminop10_out1;

  RightLaneLoc <= rightminop10_out2;

  LeftLaneOffset <= rightminop11_out1;

  LeftLaneLoc <= rightminop11_out2;

END rtl;

