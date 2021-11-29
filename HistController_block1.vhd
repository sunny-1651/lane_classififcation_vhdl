LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY HistController_block1 IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        hstartIn                          :   IN    std_logic;
        hendIn                            :   IN    std_logic;
        vstartIn                          :   IN    std_logic;
        vendIn                            :   IN    std_logic;
        validIn                           :   IN    std_logic;
        binReset                          :   IN    std_logic;
        resetRAM                          :   OUT   std_logic;
        cmptHist                          :   OUT   std_logic;
        readOut                           :   OUT   std_logic;
        waddr                             :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
        );
END HistController_block1;


ARCHITECTURE rtl OF HistController_block1 IS

  -- Signals
  SIGNAL vStartInReg                      : std_logic;
  SIGNAL dataAcq                          : std_logic;
  SIGNAL resetRAM_1                       : std_logic;
  SIGNAL rstcnt                           : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL resetDone                        : std_logic;
  SIGNAL histFSM_histState                : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL histFSM_histState_not_empty      : std_logic;
  SIGNAL histFSM_histState_next           : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL histFSM_histState_not_empty_next : std_logic;
  SIGNAL memWRFSM_inFrame                 : std_logic;
  SIGNAL memWRFSM_inLine                  : std_logic;
  SIGNAL memWRFSM_inFrame_next            : std_logic;
  SIGNAL memWRFSM_inLine_next             : std_logic;

BEGIN
  reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        vStartInReg <= '0';
      ELSIF enb = '1' THEN
        vStartInReg <= vstartIn;
      END IF;
    END IF;
  END PROCESS reg_process;


  -- Count limited, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  --  count to value  = 1023
  -- 
  -- Memory reset address counter
  counter_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        rstcnt <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        IF dataAcq = '1' THEN 
          rstcnt <= to_unsigned(16#000#, 10);
        ELSIF resetRAM_1 = '1' THEN 
          rstcnt <= rstcnt + to_unsigned(16#001#, 10);
        END IF;
      END IF;
    END IF;
  END PROCESS counter_process;


  
  resetDone <= '1' WHEN rstcnt = to_unsigned(16#3FF#, 10) ELSE
      '0';

  -- FSM that generates Histogram control signals
  histFSM_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        histFSM_histState <= to_unsigned(16#0#, 2);
        histFSM_histState_not_empty <= '0';
      ELSIF enb = '1' THEN
        histFSM_histState <= histFSM_histState_next;
        histFSM_histState_not_empty <= histFSM_histState_not_empty_next;
      END IF;
    END IF;
  END PROCESS histFSM_process;

  histFSM_output : PROCESS (binReset, histFSM_histState, histFSM_histState_not_empty, resetDone,
       vStartInReg, vendIn, vstartIn)
  BEGIN
    histFSM_histState_next <= histFSM_histState;
    histFSM_histState_not_empty_next <= histFSM_histState_not_empty;
    resetRAM_1 <= '0';
    dataAcq <= '0';
    readOut <= '0';
    IF ( NOT histFSM_histState_not_empty) = '1' THEN 
      histFSM_histState_not_empty_next <= '1';
    END IF;
    CASE histFSM_histState IS
      WHEN "00" =>
        resetRAM_1 <= '1';
        IF resetDone /= '0' THEN 
          histFSM_histState_next <= to_unsigned(16#1#, 2);
        END IF;
      WHEN "01" =>
        IF vStartInReg /= '0' THEN 
          histFSM_histState_next <= to_unsigned(16#2#, 2);
          dataAcq <= '1';
        ELSIF binReset /= '0' THEN 
          histFSM_histState_next <= to_unsigned(16#0#, 2);
          resetRAM_1 <= '1';
        END IF;
      WHEN "10" =>
        dataAcq <= '1';
        IF binReset /= '0' THEN 
          histFSM_histState_next <= to_unsigned(16#0#, 2);
          resetRAM_1 <= '1';
          dataAcq <= '0';
        ELSIF vendIn /= '0' THEN 
          histFSM_histState_next <= to_unsigned(16#3#, 2);
        END IF;
      WHEN "11" =>
        readOut <= '1';
        IF vstartIn /= '0' THEN 
          histFSM_histState_next <= to_unsigned(16#2#, 2);
          dataAcq <= '1';
          readOut <= '0';
        ELSIF binReset /= '0' THEN 
          histFSM_histState_next <= to_unsigned(16#0#, 2);
          resetRAM_1 <= '1';
          readOut <= '0';
        END IF;
      WHEN OTHERS => 
        NULL;
    END CASE;
  END PROCESS histFSM_output;


  -- FSM that generates Histogram memory w/R signals
  memWRFSM_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        memWRFSM_inFrame <= '0';
        memWRFSM_inLine <= '0';
      ELSIF enb = '1' THEN
        memWRFSM_inFrame <= memWRFSM_inFrame_next;
        memWRFSM_inLine <= memWRFSM_inLine_next;
      END IF;
    END IF;
  END PROCESS memWRFSM_process;

  memWRFSM_output : PROCESS (dataAcq, hendIn, hstartIn, memWRFSM_inFrame, memWRFSM_inLine, vStartInReg,
       validIn, vendIn)
  BEGIN
    memWRFSM_inFrame_next <= memWRFSM_inFrame;
    memWRFSM_inLine_next <= memWRFSM_inLine;
    cmptHist <= '0';
    IF (dataAcq /= '0') AND (validIn /= '0') THEN 
      IF (memWRFSM_inFrame AND memWRFSM_inLine) = '1' THEN 
        cmptHist <= '1';
      END IF;
      IF vStartInReg /= '0' THEN 
        memWRFSM_inFrame_next <= '1';
        memWRFSM_inLine_next <= '0';
        IF hstartIn /= '0' THEN 
          memWRFSM_inLine_next <= '1';
          cmptHist <= '1';
        END IF;
      ELSIF (memWRFSM_inFrame AND vendIn) = '1' THEN 
        memWRFSM_inFrame_next <= '0';
        IF hendIn /= '0' THEN 
          memWRFSM_inLine_next <= '0';
        END IF;
      ELSIF ((memWRFSM_inFrame AND memWRFSM_inLine) AND hendIn) = '1' THEN 
        memWRFSM_inLine_next <= '0';
      ELSIF (memWRFSM_inFrame AND hstartIn) = '1' THEN 
        memWRFSM_inLine_next <= '1';
        cmptHist <= '1';
      END IF;
    END IF;
  END PROCESS memWRFSM_output;


  waddr <= std_logic_vector(rstcnt);

  resetRAM <= resetRAM_1;

END rtl;

