LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY InputControlValidation IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        hStartIn                          :   IN    std_logic;
        hEndIn                            :   IN    std_logic;
        vStartIn                          :   IN    std_logic;
        vEndIn                            :   IN    std_logic;
        validIn                           :   IN    std_logic;
        hStartOut                         :   OUT   std_logic;
        hEndOut                           :   OUT   std_logic;
        vStartOut                         :   OUT   std_logic;
        vEndOut                           :   OUT   std_logic;
        validOut                          :   OUT   std_logic;
        InBetweenOut                      :   OUT   std_logic
        );
END InputControlValidation;


ARCHITECTURE rtl OF InputControlValidation IS

  -- Signals
  SIGNAL LineBuffervEndInv                : std_logic;  -- ufix1
  SIGNAL LineBufferinFrame2Term           : std_logic;  -- ufix1
  SIGNAL LineBufferValidInv               : std_logic;  -- ufix1
  SIGNAL LineBufferinFrame                : std_logic;  -- ufix1
  SIGNAL LineBufferinFrame3Term           : std_logic;  -- ufix1
  SIGNAL LineBufferinFrame1Term           : std_logic;  -- ufix1
  SIGNAL LineBufferinFrameNext            : std_logic;  -- ufix1
  SIGNAL LineBufferhEndInv                : std_logic;  -- ufix1
  SIGNAL LineBufferinLine2Term            : std_logic;  -- ufix1
  SIGNAL LineBufferinFrameInv             : std_logic;  -- ufix1
  SIGNAL LineBufferinLine                 : std_logic;  -- ufix1
  SIGNAL LineBufferinLineInv              : std_logic;  -- ufix1
  SIGNAL LineBufferinLine6Term            : std_logic;  -- ufix1
  SIGNAL LineBufferinLine5Term            : std_logic;  -- ufix1
  SIGNAL LineBufferinLine4Term            : std_logic;  -- ufix1
  SIGNAL LineBufferinLine3Term            : std_logic;  -- ufix1
  SIGNAL LineBufferinLine1Term            : std_logic;  -- ufix1
  SIGNAL LineBufferinLineNext             : std_logic;  -- ufix1
  SIGNAL InFrameInLine_1                  : std_logic;  -- ufix1
  SIGNAL hStartReg                        : std_logic;  -- ufix1
  SIGNAL vStartReg                        : std_logic;  -- ufix1
  SIGNAL validReg                         : std_logic;  -- ufix1
  SIGNAL validPre                         : std_logic;  -- ufix1
  SIGNAL LineBufferinFramePrev            : std_logic;  -- ufix1
  SIGNAL LineBufferinLinePrev             : std_logic;  -- ufix1
  SIGNAL InFrameInLinePrev                : std_logic;  -- ufix1
  SIGNAL validPost                        : std_logic;  -- ufix1
  SIGNAL LineBufferNotInLine              : std_logic;  -- ufix1
  SIGNAL LineBufferInBetween              : std_logic;  -- ufix1

BEGIN
  LineBuffervEndInv <=  NOT vEndIn;

  LineBufferinFrame2Term <= validIn AND vStartIn;

  LineBufferValidInv <=  NOT validIn;

  LineBufferinFrame3Term <= LineBufferValidInv AND LineBufferinFrame;

  LineBufferinFrame1Term <= LineBuffervEndInv AND LineBufferinFrame;

  LineBufferinFrameNext <= LineBufferinFrame3Term OR (LineBufferinFrame1Term OR LineBufferinFrame2Term);

  inFReg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        LineBufferinFrame <= '0';
      ELSIF enb = '1' THEN
        LineBufferinFrame <= LineBufferinFrameNext;
      END IF;
    END IF;
  END PROCESS inFReg_process;


  LineBufferhEndInv <=  NOT hEndIn;

  LineBufferinLine2Term <= vStartIn AND (validIn AND hStartIn);

  LineBufferinFrameInv <=  NOT LineBufferinFrame;

  LineBufferinLineInv <=  NOT LineBufferinLine;

  LineBufferinLine6Term <= LineBufferinLineInv AND (LineBufferinFrame AND (LineBuffervEndInv AND (validIn AND hStartIn)));

  LineBufferinLine5Term <= LineBufferValidInv AND LineBufferinLine;

  LineBufferinLine4Term <= LineBufferinFrameInv AND LineBufferinLine;

  LineBufferinLine3Term <= vStartIn AND LineBufferinLine;

  LineBufferinLine1Term <= LineBufferhEndInv AND LineBufferinLine;

  LineBufferinLineNext <= LineBufferinLine6Term OR (LineBufferinLine5Term OR (LineBufferinLine4Term OR (LineBufferinLine3Term OR (LineBufferinLine1Term OR LineBufferinLine2Term))));

  inLReg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        LineBufferinLine <= '0';
      ELSIF enb = '1' THEN
        LineBufferinLine <= LineBufferinLineNext;
      END IF;
    END IF;
  END PROCESS inLReg_process;


  InFrameInLine_1 <= LineBufferinFrame AND LineBufferinLine;

  reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        hStartReg <= '0';
      ELSIF enb = '1' THEN
        hStartReg <= hStartIn;
      END IF;
    END IF;
  END PROCESS reg_process;


  hStartOut <= InFrameInLine_1 AND hStartReg;

  hEndOut <= InFrameInLine_1 AND hEndIn;

  reg_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        vStartReg <= '0';
      ELSIF enb = '1' THEN
        vStartReg <= vStartIn;
      END IF;
    END IF;
  END PROCESS reg_1_process;


  vStartOut <= InFrameInLine_1 AND vStartReg;

  vEndOut <= InFrameInLine_1 AND vEndIn;

  reg_2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        validReg <= '0';
      ELSIF enb = '1' THEN
        validReg <= validIn;
      END IF;
    END IF;
  END PROCESS reg_2_process;


  validPre <= InFrameInLine_1 AND validReg;

  inFPReg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        LineBufferinFramePrev <= '0';
      ELSIF enb = '1' THEN
        LineBufferinFramePrev <= LineBufferinFrame;
      END IF;
    END IF;
  END PROCESS inFPReg_process;


  inLPReg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        LineBufferinLinePrev <= '0';
      ELSIF enb = '1' THEN
        LineBufferinLinePrev <= LineBufferinLine;
      END IF;
    END IF;
  END PROCESS inLPReg_process;


  InFrameInLinePrev <= LineBufferinFramePrev AND LineBufferinLinePrev;

  validPost <= InFrameInLinePrev AND validReg;

  validOut <= validPre OR validPost;

  LineBufferNotInLine <=  NOT LineBufferinLine;

  LineBufferInBetween <= LineBufferNotInLine AND LineBufferinFrame;

  reg_3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        InBetweenOut <= '0';
      ELSIF enb = '1' THEN
        InBetweenOut <= LineBufferInBetween;
      END IF;
    END IF;
  END PROCESS reg_3_process;


END rtl;

