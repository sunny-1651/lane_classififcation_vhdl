LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.HDLLaneDetector_pkg.ALL;

ENTITY ROI_Selector_block IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        in0                               :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        in1_hStart                        :   IN    std_logic;
        in1_hEnd                          :   IN    std_logic;
        in1_vStart                        :   IN    std_logic;
        in1_vEnd                          :   IN    std_logic;
        in1_valid                         :   IN    std_logic;
        out0                              :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        out1_hStart                       :   OUT   std_logic;
        out1_hEnd                         :   OUT   std_logic;
        out1_vStart                       :   OUT   std_logic;
        out1_vEnd                         :   OUT   std_logic;
        out1_valid                        :   OUT   std_logic
        );
END ROI_Selector_block;


ARCHITECTURE rtl OF ROI_Selector_block IS

  -- Constants
  CONSTANT Lookup_Table_table_data        : vector_of_unsigned5(0 TO 63) := 
    (to_unsigned(16#00#, 5), to_unsigned(16#12#, 5), to_unsigned(16#12#, 5), to_unsigned(16#12#, 5),
     to_unsigned(16#12#, 5), to_unsigned(16#12#, 5), to_unsigned(16#12#, 5), to_unsigned(16#12#, 5),
     to_unsigned(16#12#, 5), to_unsigned(16#12#, 5), to_unsigned(16#12#, 5), to_unsigned(16#12#, 5),
     to_unsigned(16#12#, 5), to_unsigned(16#12#, 5), to_unsigned(16#12#, 5), to_unsigned(16#12#, 5),
     to_unsigned(16#12#, 5), to_unsigned(16#12#, 5), to_unsigned(16#12#, 5), to_unsigned(16#12#, 5),
     to_unsigned(16#12#, 5), to_unsigned(16#12#, 5), to_unsigned(16#12#, 5), to_unsigned(16#12#, 5),
     to_unsigned(16#12#, 5), to_unsigned(16#12#, 5), to_unsigned(16#12#, 5), to_unsigned(16#12#, 5),
     to_unsigned(16#12#, 5), to_unsigned(16#12#, 5), to_unsigned(16#12#, 5), to_unsigned(16#12#, 5),
     to_unsigned(16#12#, 5), to_unsigned(16#12#, 5), to_unsigned(16#12#, 5), to_unsigned(16#12#, 5),
     to_unsigned(16#12#, 5), to_unsigned(16#12#, 5), to_unsigned(16#12#, 5), to_unsigned(16#10#, 5),
     to_unsigned(16#00#, 5), to_unsigned(16#00#, 5), to_unsigned(16#00#, 5), to_unsigned(16#00#, 5),
     to_unsigned(16#00#, 5), to_unsigned(16#00#, 5), to_unsigned(16#00#, 5), to_unsigned(16#00#, 5),
     to_unsigned(16#00#, 5), to_unsigned(16#00#, 5), to_unsigned(16#00#, 5), to_unsigned(16#00#, 5),
     to_unsigned(16#00#, 5), to_unsigned(16#00#, 5), to_unsigned(16#00#, 5), to_unsigned(16#00#, 5),
     to_unsigned(16#00#, 5), to_unsigned(16#00#, 5), to_unsigned(16#00#, 5), to_unsigned(16#00#, 5),
     to_unsigned(16#00#, 5), to_unsigned(16#00#, 5), to_unsigned(16#00#, 5), to_unsigned(16#00#, 5));  -- ufix5 [64]

  -- Signals
  SIGNAL vEndInReg                        : std_logic;  -- ufix1
  SIGNAL vEndInv                          : std_logic;  -- ufix1
  SIGNAL validInReg                       : std_logic;  -- ufix1
  SIGNAL vStartInReg                      : std_logic;  -- ufix1
  SIGNAL inFrame2Term                     : std_logic;  -- ufix1
  SIGNAL ValidInv                         : std_logic;  -- ufix1
  SIGNAL inFrame                          : std_logic;  -- ufix1
  SIGNAL inFrame3Term                     : std_logic;  -- ufix1
  SIGNAL inFrameNext                      : std_logic;  -- ufix1
  SIGNAL inFrame1Term                     : std_logic;  -- ufix1
  SIGNAL hStartInReg                      : std_logic;  -- ufix1
  SIGNAL hCountInit                       : std_logic;  -- ufix1
  SIGNAL hEndInReg                        : std_logic;  -- ufix1
  SIGNAL hEndInv                          : std_logic;  -- ufix1
  SIGNAL inLine2Term                      : std_logic;  -- ufix1
  SIGNAL inFrameInv                       : std_logic;  -- ufix1
  SIGNAL inLine                           : std_logic;  -- ufix1
  SIGNAL inLineInv                        : std_logic;  -- ufix1
  SIGNAL inLine6Term                      : std_logic;  -- ufix1
  SIGNAL inLine5Term                      : std_logic;  -- ufix1
  SIGNAL inLine4Term                      : std_logic;  -- ufix1
  SIGNAL inLine3Term                      : std_logic;  -- ufix1
  SIGNAL inLineNext                       : std_logic;  -- ufix1
  SIGNAL inLine1Term                      : std_logic;  -- ufix1
  SIGNAL hEn                              : std_logic;  -- ufix1
  SIGNAL hCount                           : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL hLeft1                           : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL relop_relop1                     : std_logic;
  SIGNAL hRight1                          : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL relop_relop1_1                   : std_logic;
  SIGNAL hEndInRegDelay3_reg              : std_logic_vector(0 TO 2);  -- ufix1 [3]
  SIGNAL vEndInRegDelay3                  : std_logic;  -- ufix1
  SIGNAL plusone                          : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL vCountReset2                     : std_logic;  -- ufix1
  SIGNAL vEn                              : std_logic;  -- ufix1
  SIGNAL vCountReset1                     : std_logic;  -- ufix1
  SIGNAL vEnIndex                         : std_logic;  -- ufix1
  SIGNAL vIndex                           : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL Lookup_Table_k                   : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL lutOutvBottom                    : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL lutOutvBottomPlus                : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL vCount                           : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL relop_relop1_2                   : std_logic;
  SIGNAL vCountInit                       : std_logic;  -- ufix1
  SIGNAL vTop1                            : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL relop_relop1_3                   : std_logic;
  SIGNAL relop_relop1_4                   : std_logic;
  SIGNAL prevalid1ROI                     : std_logic;  -- ufix1
  SIGNAL relop_relop1_5                   : std_logic;
  SIGNAL inFramePrev                      : std_logic;  -- ufix1
  SIGNAL inLinePrev                       : std_logic;  -- ufix1
  SIGNAL hEndInRegDelay                   : std_logic;  -- ufix1
  SIGNAL relop_relop1_6                   : std_logic;
  SIGNAL hEOR1ROI                         : std_logic;  -- ufix1
  SIGNAL vEndInRegDelay                   : std_logic;  -- ufix1
  SIGNAL relop_relop1_7                   : std_logic;
  SIGNAL relop_relop1_8                   : std_logic;
  SIGNAL vEOR1ROI                         : std_logic;  -- ufix1
  SIGNAL vEORDelay1ROI                    : std_logic;  -- ufix1
  SIGNAL preNormvEnd1ROI                  : std_logic;  -- ufix1
  SIGNAL finalpreValid1ROI                : std_logic;  -- ufix1
  SIGNAL prehEnd1ROI                      : std_logic;  -- ufix1
  SIGNAL preEdge3vEnd1ROI                 : std_logic;  -- ufix1
  SIGNAL prevalidedge1ROI                 : std_logic;  -- ufix1
  SIGNAL preEdge2vEnd1ROI                 : std_logic;  -- ufix1
  SIGNAL preEdge1vEnd1ROI                 : std_logic;  -- ufix1
  SIGNAL prevEnd1ROI                      : std_logic;  -- ufix1
  SIGNAL prehEnd1ROI_1                    : std_logic;  -- ufix1
  SIGNAL hendDelayInv1ROI                 : std_logic;  -- ufix1
  SIGNAL finalpreValid1ROI_1              : std_logic;  -- ufix1
  SIGNAL prehEndEdge1ROI                  : std_logic;  -- ufix1
  SIGNAL zeroconst_1                      : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL in0_unsigned                     : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL dataIDlyReg_reg                  : vector_of_unsigned10(0 TO 1);  -- ufix10 [2]
  SIGNAL dataInDlyReg                     : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL predataMux                       : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL dataOut                          : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL relop_relop1_9                   : std_logic;
  SIGNAL hSOR1ROI                         : std_logic;  -- ufix1
  SIGNAL prehStart1ROI                    : std_logic;  -- ufix1
  SIGNAL hStartOut                        : std_logic;
  SIGNAL relop_relop1_10                  : std_logic;
  SIGNAL vSOR1ROI                         : std_logic;  -- ufix1
  SIGNAL prevStart1ROI                    : std_logic;  -- ufix1
  SIGNAL vStartOut                        : std_logic;
  SIGNAL vEndOut                          : std_logic;

BEGIN
  vEIReg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        vEndInReg <= '0';
      ELSIF enb = '1' THEN
        vEndInReg <= in1_vEnd;
      END IF;
    END IF;
  END PROCESS vEIReg_process;


  vEndInv <=  NOT vEndInReg;

  valIReg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        validInReg <= '0';
      ELSIF enb = '1' THEN
        validInReg <= in1_valid;
      END IF;
    END IF;
  END PROCESS valIReg_process;


  vSIReg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        vStartInReg <= '0';
      ELSIF enb = '1' THEN
        vStartInReg <= in1_vStart;
      END IF;
    END IF;
  END PROCESS vSIReg_process;


  inFrame2Term <= validInReg AND vStartInReg;

  ValidInv <=  NOT validInReg;

  inFrame3Term <= ValidInv AND inFrame;

  inFReg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        inFrame <= '0';
      ELSIF enb = '1' THEN
        inFrame <= inFrameNext;
      END IF;
    END IF;
  END PROCESS inFReg_process;


  inFrame1Term <= vEndInv AND inFrame;

  inFrameNext <= inFrame3Term OR (inFrame1Term OR inFrame2Term);

  hSIReg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        hStartInReg <= '0';
      ELSIF enb = '1' THEN
        hStartInReg <= in1_hStart;
      END IF;
    END IF;
  END PROCESS hSIReg_process;


  hCountInit <= hStartInReg AND (inFrameNext AND validInReg);

  hEIReg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        hEndInReg <= '0';
      ELSIF enb = '1' THEN
        hEndInReg <= in1_hEnd;
      END IF;
    END IF;
  END PROCESS hEIReg_process;


  hEndInv <=  NOT hEndInReg;

  inLine2Term <= vStartInReg AND (validInReg AND hStartInReg);

  inFrameInv <=  NOT inFrame;

  inLineInv <=  NOT inLine;

  inLine6Term <= inLineInv AND (inFrame AND (vEndInv AND (validInReg AND hStartInReg)));

  inLine5Term <= ValidInv AND inLine;

  inLine4Term <= inFrameInv AND inLine;

  inLine3Term <= vStartInReg AND inLine;

  inLReg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        inLine <= '0';
      ELSIF enb = '1' THEN
        inLine <= inLineNext;
      END IF;
    END IF;
  END PROCESS inLReg_process;


  inLine1Term <= hEndInv AND inLine;

  inLineNext <= inLine6Term OR (inLine5Term OR (inLine4Term OR (inLine3Term OR (inLine1Term OR inLine2Term))));

  hEn <= validInReg AND (inFrameNext AND inLineNext);

  -- Count limited, Unsigned Counter
  --  initial value   = 1
  --  step value      = 1
  --  count to value  = 65535
  hCounter_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        hCount <= to_unsigned(16#0001#, 16);
      ELSIF enb = '1' THEN
        IF hCountInit = '1' THEN 
          hCount <= to_unsigned(16#0001#, 16);
        ELSIF hEn = '1' THEN 
          IF hCount = to_unsigned(16#FFFF#, 16) THEN 
            hCount <= to_unsigned(16#0001#, 16);
          ELSE 
            hCount <= hCount + to_unsigned(16#0001#, 16);
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS hCounter_process;


  hLeft1 <= to_unsigned(16#0001#, 16);

  
  relop_relop1 <= '1' WHEN hCount >= hLeft1 ELSE
      '0';

  hRight1 <= to_unsigned(16#0280#, 16);

  
  relop_relop1_1 <= '1' WHEN hCount <= hRight1 ELSE
      '0';

  hEndInRegDelay3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        hEndInRegDelay3_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        hEndInRegDelay3_reg(0) <= vEndInReg;
        hEndInRegDelay3_reg(1 TO 2) <= hEndInRegDelay3_reg(0 TO 1);
      END IF;
    END IF;
  END PROCESS hEndInRegDelay3_process;

  vEndInRegDelay3 <= hEndInRegDelay3_reg(2);

  plusone <= to_unsigned(16#0001#, 16);

  vCountReset2 <= vStartInReg AND (inFrameNext AND validInReg);

  vEn <= hEndInReg AND (validInReg AND (inFrameNext AND inLine));

  vEnIndex <= vStartInReg OR vCountReset1;

  -- Count limited, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  --  count to value  = 63
  vIndexCounter_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        vIndex <= to_unsigned(16#00#, 6);
      ELSIF enb = '1' THEN
        IF vEndInRegDelay3 = '1' THEN 
          vIndex <= to_unsigned(16#00#, 6);
        ELSIF vEnIndex = '1' THEN 
          vIndex <= vIndex + to_unsigned(16#01#, 6);
        END IF;
      END IF;
    END IF;
  END PROCESS vIndexCounter_process;


  -- Lookup Table
  
  Lookup_Table_k <= to_unsigned(16#00#, 6) WHEN vIndex = to_unsigned(16#00#, 6) ELSE
      to_unsigned(16#3F#, 6) WHEN vIndex = to_unsigned(16#3F#, 6) ELSE
      vIndex;
  lutOutvBottom <= resize(Lookup_Table_table_data(to_integer(Lookup_Table_k)), 16);

  lutOutvBottomPlus <= lutOutvBottom + plusone;

  
  relop_relop1_2 <= '1' WHEN vCount = lutOutvBottomPlus ELSE
      '0';

  vCountReset1 <= hStartInReg AND (relop_relop1_2 AND validInReg);

  vCountInit <= vCountReset1 OR vCountReset2;

  -- Count limited, Unsigned Counter
  --  initial value   = 1
  --  step value      = 1
  --  count to value  = 65535
  vCounter_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        vCount <= to_unsigned(16#0001#, 16);
      ELSIF enb = '1' THEN
        IF vCountInit = '1' THEN 
          vCount <= to_unsigned(16#0001#, 16);
        ELSIF vEn = '1' THEN 
          IF vCount = to_unsigned(16#FFFF#, 16) THEN 
            vCount <= to_unsigned(16#0001#, 16);
          ELSE 
            vCount <= vCount + to_unsigned(16#0001#, 16);
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS vCounter_process;


  vTop1 <= to_unsigned(16#0001#, 16);

  
  relop_relop1_3 <= '1' WHEN vCount >= vTop1 ELSE
      '0';

  
  relop_relop1_4 <= '1' WHEN vCount <= lutOutvBottom ELSE
      '0';

  prevalid1ROI <= validInReg AND (inLine AND (inFrame AND (relop_relop1_4 AND (relop_relop1_3 AND (relop_relop1 AND relop_relop1_1)))));

  
  relop_relop1_5 <= '1' WHEN vCount <= lutOutvBottomPlus ELSE
      '0';

  inFramePrevReg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        inFramePrev <= '0';
      ELSIF enb = '1' THEN
        inFramePrev <= inFrame;
      END IF;
    END IF;
  END PROCESS inFramePrevReg_process;


  inLinePrevReg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        inLinePrev <= '0';
      ELSIF enb = '1' THEN
        inLinePrev <= inLine;
      END IF;
    END IF;
  END PROCESS inLinePrevReg_process;


  hEIDReg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        hEndInRegDelay <= '0';
      ELSIF enb = '1' THEN
        hEndInRegDelay <= hEndInReg;
      END IF;
    END IF;
  END PROCESS hEIDReg_process;


  
  relop_relop1_6 <= '1' WHEN hCount = hRight1 ELSE
      '0';

  hEOR1ROI <= prevalid1ROI AND relop_relop1_6;

  vEIRegD_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        vEndInRegDelay <= '0';
      ELSIF enb = '1' THEN
        vEndInRegDelay <= vEndInReg;
      END IF;
    END IF;
  END PROCESS vEIRegD_process;


  
  relop_relop1_7 <= '1' WHEN vCount = lutOutvBottomPlus ELSE
      '0';

  
  relop_relop1_8 <= '1' WHEN vCount = lutOutvBottom ELSE
      '0';

  vEOR1ROI <= prevalid1ROI AND relop_relop1_8;

  vEORPrevReg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        vEORDelay1ROI <= '0';
      ELSIF enb = '1' THEN
        vEORDelay1ROI <= vEOR1ROI;
      END IF;
    END IF;
  END PROCESS vEORPrevReg_process;


  preNormvEnd1ROI <= vEOR1ROI AND (prevalid1ROI AND hEOR1ROI);

  preEdge3vEnd1ROI <= vEORDelay1ROI AND (finalpreValid1ROI AND prehEnd1ROI);

  preEdge2vEnd1ROI <= relop_relop1_7 AND (hEndInReg AND (finalpreValid1ROI AND prevalidedge1ROI));

  preEdge1vEnd1ROI <= vEndInRegDelay AND (finalpreValid1ROI AND prevalidedge1ROI);

  prevEnd1ROI <= preNormvEnd1ROI OR (preEdge3vEnd1ROI OR (preEdge1vEnd1ROI OR preEdge2vEnd1ROI));

  reduced_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        prehEnd1ROI_1 <= '0';
      ELSIF enb = '1' THEN
        prehEnd1ROI_1 <= prehEnd1ROI;
      END IF;
    END IF;
  END PROCESS reduced_process;


  hendDelayInv1ROI <=  NOT prehEnd1ROI_1;

  reduced_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        finalpreValid1ROI <= '0';
      ELSIF enb = '1' THEN
        finalpreValid1ROI <= finalpreValid1ROI_1;
      END IF;
    END IF;
  END PROCESS reduced_1_process;


  prevalidedge1ROI <= finalpreValid1ROI AND (inLinePrev AND (inFramePrev AND (relop_relop1_5 AND (relop_relop1_3 AND (relop_relop1 AND relop_relop1_1)))));

  prehEndEdge1ROI <= hendDelayInv1ROI AND (hEndInRegDelay AND (prevalidedge1ROI AND finalpreValid1ROI));

  prehEnd1ROI <= prehEndEdge1ROI OR hEOR1ROI;

  finalpreValid1ROI_1 <= prevEnd1ROI OR (prevalid1ROI OR prehEnd1ROI);

  zeroconst_1 <= to_unsigned(16#000#, 10);

  in0_unsigned <= unsigned(in0);

  dataIDlyReg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        dataIDlyReg_reg <= (OTHERS => to_unsigned(16#000#, 10));
      ELSIF enb = '1' THEN
        dataIDlyReg_reg(0) <= in0_unsigned;
        dataIDlyReg_reg(1) <= dataIDlyReg_reg(0);
      END IF;
    END IF;
  END PROCESS dataIDlyReg_process;

  dataInDlyReg <= dataIDlyReg_reg(1);

  
  predataMux <= zeroconst_1 WHEN finalpreValid1ROI_1 = '0' ELSE
      dataInDlyReg;

  outDReg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        dataOut <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        dataOut <= predataMux;
      END IF;
    END IF;
  END PROCESS outDReg_process;


  out0 <= std_logic_vector(dataOut);

  
  relop_relop1_9 <= '1' WHEN hCount = hLeft1 ELSE
      '0';

  hSOR1ROI <= hStartInReg OR relop_relop1_9;

  prehStart1ROI <= prevalid1ROI AND hSOR1ROI;

  outHSReg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        hStartOut <= '0';
      ELSIF enb = '1' THEN
        hStartOut <= prehStart1ROI;
      END IF;
    END IF;
  END PROCESS outHSReg_process;


  out1_hStart <= hStartOut;

  out1_hEnd <= prehEnd1ROI_1;

  
  relop_relop1_10 <= '1' WHEN vCount = vTop1 ELSE
      '0';

  vSOR1ROI <= vStartInReg OR relop_relop1_10;

  prevStart1ROI <= vSOR1ROI AND (prevalid1ROI AND hSOR1ROI);

  outVSReg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        vStartOut <= '0';
      ELSIF enb = '1' THEN
        vStartOut <= prevStart1ROI;
      END IF;
    END IF;
  END PROCESS outVSReg_process;


  out1_vStart <= vStartOut;

  outVEReg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        vEndOut <= '0';
      ELSIF enb = '1' THEN
        vEndOut <= prevEnd1ROI;
      END IF;
    END IF;
  END PROCESS outVEReg_process;


  out1_vEnd <= vEndOut;

  out1_valid <= finalpreValid1ROI;

END rtl;

