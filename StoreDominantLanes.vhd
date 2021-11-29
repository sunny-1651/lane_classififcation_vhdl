LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY StoreDominantLanes IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        LaneCapture                       :   IN    std_logic;
        PeakFIlterAddress                 :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        PeakFIlterData                    :   IN    std_logic_vector(30 DOWNTO 0);  -- sfix31_En10
        laneAddress                       :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane1                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane2                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane3                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane4                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane5                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane6                             :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        lane7                             :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
        );
END StoreDominantLanes;


ARCHITECTURE rtl OF StoreDominantLanes IS

  -- Component Declarations
  COMPONENT ZeroCrossingDetection
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          peakIndex                       :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          peakVal                         :   IN    std_logic_vector(30 DOWNTO 0);  -- sfix31_En10
          zeroCrossingTrue                :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT peakValueMemory
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          peakVal                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
          lane1En                         :   IN    std_logic;
          lane3En                         :   IN    std_logic;
          lane2En                         :   IN    std_logic;
          lane4En                         :   IN    std_logic;
          lane5En                         :   IN    std_logic;
          lane6En                         :   IN    std_logic;
          lane7En                         :   IN    std_logic;
          laneRST                         :   IN    std_logic;
          peakREG1                        :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
          peakREG2                        :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
          peakREG3                        :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
          peakREG4                        :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
          peakREG5                        :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
          peakREG6                        :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
          peakREG7                        :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En10
          );
  END COMPONENT;

  COMPONENT findMin
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          peakVal1                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
          peakVal2                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
          peakVal3                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
          peakVal4                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
          peakVal5                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
          PeakVal6                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
          peakVal7                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
          minInd                          :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
          minVal                          :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En10
          );
  END COMPONENT;

  COMPONENT RegisterWriteGen
    PORT( regEnable                       :   IN    std_logic;
          valGreater                      :   IN    std_logic;
          minInd                          :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          enableREG1                      :   OUT   std_logic;
          enableREG2                      :   OUT   std_logic;
          enableREG3                      :   OUT   std_logic;
          enableREG4                      :   OUT   std_logic;
          enableREG5                      :   OUT   std_logic;
          enableREG6                      :   OUT   std_logic;
          enableREG7                      :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT StoreLaneMem
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          LaneREGData                     :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          LaneREG1En                      :   IN    std_logic;
          LaneREG2En                      :   IN    std_logic;
          LaneREG3En                      :   IN    std_logic;
          LaneREG5En                      :   IN    std_logic;
          LaneREG4En                      :   IN    std_logic;
          LaneREG6En                      :   IN    std_logic;
          LaneREG7En                      :   IN    std_logic;
          laneREGRST                      :   IN    std_logic;
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
  FOR ALL : ZeroCrossingDetection
    USE ENTITY work.ZeroCrossingDetection(rtl);

  FOR ALL : peakValueMemory
    USE ENTITY work.peakValueMemory(rtl);

  FOR ALL : findMin
    USE ENTITY work.findMin(rtl);

  FOR ALL : RegisterWriteGen
    USE ENTITY work.RegisterWriteGen(rtl);

  FOR ALL : StoreLaneMem
    USE ENTITY work.StoreLaneMem(rtl);

  -- Signals
  SIGNAL ZeroCrossingDetection_out1       : std_logic;
  SIGNAL PeakFIlterData_signed            : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL Delay1_out1                      : signed(30 DOWNTO 0);  -- sfix31_En10
  SIGNAL Add_sub_cast                     : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Add_sub_cast_1                   : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Add_out1                         : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Delay7_reg                       : std_logic_vector(0 TO 9);  -- ufix1 [10]
  SIGNAL Delay7_out1                      : std_logic;
  SIGNAL delayMatch_reg                   : std_logic_vector(0 TO 6);  -- ufix1 [7]
  SIGNAL From22_out1                      : std_logic;
  SIGNAL RegisterWriteGen_out1            : std_logic;
  SIGNAL RegisterWriteGen_out3            : std_logic;
  SIGNAL RegisterWriteGen_out2            : std_logic;
  SIGNAL RegisterWriteGen_out4            : std_logic;
  SIGNAL RegisterWriteGen_out5            : std_logic;
  SIGNAL RegisterWriteGen_out6            : std_logic;
  SIGNAL RegisterWriteGen_out7            : std_logic;
  SIGNAL peakValueMemory_out1             : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL peakValueMemory_out2             : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL peakValueMemory_out3             : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL peakValueMemory_out4             : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL peakValueMemory_out5             : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL peakValueMemory_out6             : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL peakValueMemory_out7             : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL findMin_out1                     : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL findMin_out2                     : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL findMin_out2_signed              : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Relational_Operator_relop1       : std_logic;
  SIGNAL StoreLaneMem_out1                : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL StoreLaneMem_out2                : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL StoreLaneMem_out3                : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL StoreLaneMem_out4                : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL StoreLaneMem_out5                : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL StoreLaneMem_out6                : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL StoreLaneMem_out7                : std_logic_vector(9 DOWNTO 0);  -- ufix10

BEGIN
  u_ZeroCrossingDetection : ZeroCrossingDetection
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              peakIndex => PeakFIlterAddress,  -- ufix10
              peakVal => PeakFIlterData,  -- sfix31_En10
              zeroCrossingTrue => ZeroCrossingDetection_out1
              );

  u_peakValueMemory : peakValueMemory
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              peakVal => std_logic_vector(Add_out1),  -- sfix32_En10
              lane1En => RegisterWriteGen_out1,
              lane3En => RegisterWriteGen_out3,
              lane2En => RegisterWriteGen_out2,
              lane4En => RegisterWriteGen_out4,
              lane5En => RegisterWriteGen_out5,
              lane6En => RegisterWriteGen_out6,
              lane7En => RegisterWriteGen_out7,
              laneRST => From22_out1,
              peakREG1 => peakValueMemory_out1,  -- sfix32_En10
              peakREG2 => peakValueMemory_out2,  -- sfix32_En10
              peakREG3 => peakValueMemory_out3,  -- sfix32_En10
              peakREG4 => peakValueMemory_out4,  -- sfix32_En10
              peakREG5 => peakValueMemory_out5,  -- sfix32_En10
              peakREG6 => peakValueMemory_out6,  -- sfix32_En10
              peakREG7 => peakValueMemory_out7  -- sfix32_En10
              );

  u_findMin : findMin
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              peakVal1 => peakValueMemory_out1,  -- sfix32_En10
              peakVal2 => peakValueMemory_out2,  -- sfix32_En10
              peakVal3 => peakValueMemory_out3,  -- sfix32_En10
              peakVal4 => peakValueMemory_out4,  -- sfix32_En10
              peakVal5 => peakValueMemory_out5,  -- sfix32_En10
              PeakVal6 => peakValueMemory_out6,  -- sfix32_En10
              peakVal7 => peakValueMemory_out7,  -- sfix32_En10
              minInd => findMin_out1,  -- uint8
              minVal => findMin_out2  -- sfix32_En10
              );

  u_RegisterWriteGen : RegisterWriteGen
    PORT MAP( regEnable => ZeroCrossingDetection_out1,
              valGreater => Relational_Operator_relop1,
              minInd => findMin_out1,  -- uint8
              enableREG1 => RegisterWriteGen_out1,
              enableREG2 => RegisterWriteGen_out2,
              enableREG3 => RegisterWriteGen_out3,
              enableREG4 => RegisterWriteGen_out4,
              enableREG5 => RegisterWriteGen_out5,
              enableREG6 => RegisterWriteGen_out6,
              enableREG7 => RegisterWriteGen_out7
              );

  u_StoreLaneMem : StoreLaneMem
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              LaneREGData => laneAddress,  -- ufix10
              LaneREG1En => RegisterWriteGen_out1,
              LaneREG2En => RegisterWriteGen_out2,
              LaneREG3En => RegisterWriteGen_out3,
              LaneREG5En => RegisterWriteGen_out5,
              LaneREG4En => RegisterWriteGen_out4,
              LaneREG6En => RegisterWriteGen_out6,
              LaneREG7En => RegisterWriteGen_out7,
              laneREGRST => Delay7_out1,
              lane1 => StoreLaneMem_out1,  -- ufix10
              lane2 => StoreLaneMem_out2,  -- ufix10
              lane3 => StoreLaneMem_out3,  -- ufix10
              lane4 => StoreLaneMem_out4,  -- ufix10
              lane5 => StoreLaneMem_out5,  -- ufix10
              lane6 => StoreLaneMem_out6,  -- ufix10
              lane7 => StoreLaneMem_out7  -- ufix10
              );

  PeakFIlterData_signed <= signed(PeakFIlterData);

  Delay1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay1_out1 <= to_signed(16#00000000#, 31);
      ELSIF enb = '1' THEN
        Delay1_out1 <= PeakFIlterData_signed;
      END IF;
    END IF;
  END PROCESS Delay1_process;


  Add_sub_cast <= resize(Delay1_out1, 32);
  Add_sub_cast_1 <= resize(PeakFIlterData_signed, 32);
  Add_out1 <= Add_sub_cast - Add_sub_cast_1;

  Delay7_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay7_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        Delay7_reg(0) <= LaneCapture;
        Delay7_reg(1 TO 9) <= Delay7_reg(0 TO 8);
      END IF;
    END IF;
  END PROCESS Delay7_process;

  Delay7_out1 <= Delay7_reg(9);

  delayMatch_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        delayMatch_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        delayMatch_reg(0) <= Delay7_out1;
        delayMatch_reg(1 TO 6) <= delayMatch_reg(0 TO 5);
      END IF;
    END IF;
  END PROCESS delayMatch_process;

  From22_out1 <= delayMatch_reg(6);

  findMin_out2_signed <= signed(findMin_out2);

  
  Relational_Operator_relop1 <= '1' WHEN Add_out1 > findMin_out2_signed ELSE
      '0';

  lane1 <= StoreLaneMem_out1;

  lane2 <= StoreLaneMem_out2;

  lane3 <= StoreLaneMem_out3;

  lane4 <= StoreLaneMem_out4;

  lane5 <= StoreLaneMem_out5;

  lane6 <= StoreLaneMem_out6;

  lane7 <= StoreLaneMem_out7;

END rtl;

