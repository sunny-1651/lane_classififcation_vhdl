LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY LineInfoStore_block IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        hStartIn                          :   IN    std_logic;
        hEndIn                            :   IN    std_logic;
        vEndIn                            :   IN    std_logic;
        validIn                           :   IN    std_logic;
        dumpControl                       :   IN    std_logic;
        preProcess                        :   IN    std_logic;
        PrePadFlag                        :   OUT   std_logic;
        OnLineFlag                        :   OUT   std_logic;
        PostPadFlag                       :   OUT   std_logic;
        DumpingFlag                       :   OUT   std_logic;
        BlankingFlag                      :   OUT   std_logic;
        hStartOut                         :   OUT   std_logic;
        hEndOut                           :   OUT   std_logic;
        vEndOut                           :   OUT   std_logic;
        validOut                          :   OUT   std_logic
        );
END LineInfoStore_block;


ARCHITECTURE rtl OF LineInfoStore_block IS

  -- Signals
  SIGNAL validTemp1                       : std_logic;
  SIGNAL validTemp2                       : std_logic;
  SIGNAL intdelay_reg                     : std_logic_vector(0 TO 3);  -- ufix1 [4]
  SIGNAL hStartFirstTap                   : std_logic;
  SIGNAL intdelay_reg_1                   : std_logic_vector(0 TO 2);  -- ufix1 [3]
  SIGNAL hStartFinalTap                   : std_logic;
  SIGNAL hEndFirstTap                     : std_logic;
  SIGNAL intdelay_reg_2                   : std_logic_vector(0 TO 4);  -- ufix1 [5]
  SIGNAL hEndCentreTap                    : std_logic;
  SIGNAL intdelay_reg_3                   : std_logic_vector(0 TO 4);  -- ufix1 [5]
  SIGNAL hEndFinalTap                     : std_logic;
  SIGNAL intdelay_reg_4                   : std_logic_vector(0 TO 5);  -- ufix1 [6]
  SIGNAL intdelay_reg_5                   : std_logic_vector(0 TO 7);  -- ufix1 [8]
  SIGNAL validTap                         : std_logic;
  SIGNAL validGate1                       : std_logic;
  SIGNAL notPreProcess                    : std_logic;
  SIGNAL validGate2                       : std_logic;
  SIGNAL validGate3                       : std_logic;
  SIGNAL validGate4                       : std_logic;

BEGIN
  validTemp1 <= validIn OR dumpControl;

  validTemp2 <= hEndIn OR validTemp1;

  intdelay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg <= (OTHERS => '0');
      ELSIF enb = '1' AND validTemp2 = '1' THEN
        intdelay_reg(0) <= hStartIn;
        intdelay_reg(1 TO 3) <= intdelay_reg(0 TO 2);
      END IF;
    END IF;
  END PROCESS intdelay_process;

  hStartFirstTap <= intdelay_reg(3);

  PrePadFlag <= hStartFirstTap;

  intdelay_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg_1 <= (OTHERS => '0');
      ELSIF enb = '1' AND validTemp2 = '1' THEN
        intdelay_reg_1(0) <= hStartFirstTap;
        intdelay_reg_1(1 TO 2) <= intdelay_reg_1(0 TO 1);
      END IF;
    END IF;
  END PROCESS intdelay_1_process;

  hStartFinalTap <= intdelay_reg_1(2);

  OnLineFlag <= hStartFinalTap;

  reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        hEndFirstTap <= '0';
      ELSIF enb = '1' AND validTemp2 = '1' THEN
        hEndFirstTap <= hEndIn;
      END IF;
    END IF;
  END PROCESS reg_process;


  intdelay_2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg_2 <= (OTHERS => '0');
      ELSIF enb = '1' AND validTemp2 = '1' THEN
        intdelay_reg_2(0) <= hEndFirstTap;
        intdelay_reg_2(1 TO 4) <= intdelay_reg_2(0 TO 3);
      END IF;
    END IF;
  END PROCESS intdelay_2_process;

  hEndCentreTap <= intdelay_reg_2(4);

  PostPadFlag <= hEndCentreTap;

  DumpingFlag <= hEndFirstTap;

  intdelay_3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg_3 <= (OTHERS => '0');
      ELSIF enb = '1' AND validTemp2 = '1' THEN
        intdelay_reg_3(0) <= hEndCentreTap;
        intdelay_reg_3(1 TO 4) <= intdelay_reg_3(0 TO 3);
      END IF;
    END IF;
  END PROCESS intdelay_3_process;

  hEndFinalTap <= intdelay_reg_3(4);

  BlankingFlag <= hEndFinalTap;

  hStartOut <= hStartFinalTap;

  hEndOut <= hEndCentreTap;

  intdelay_4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg_4 <= (OTHERS => '0');
      ELSIF enb = '1' AND validTemp2 = '1' THEN
        intdelay_reg_4(0) <= vEndIn;
        intdelay_reg_4(1 TO 5) <= intdelay_reg_4(0 TO 4);
      END IF;
    END IF;
  END PROCESS intdelay_4_process;

  vEndOut <= intdelay_reg_4(5);

  intdelay_5_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg_5 <= (OTHERS => '0');
      ELSIF enb = '1' AND validTemp2 = '1' THEN
        intdelay_reg_5(0) <= validIn;
        intdelay_reg_5(1 TO 7) <= intdelay_reg_5(0 TO 6);
      END IF;
    END IF;
  END PROCESS intdelay_5_process;

  validTap <= intdelay_reg_5(7);

  validGate1 <= hStartFirstTap AND validTap;

  notPreProcess <=  NOT preProcess;

  validGate2 <= validTap AND notPreProcess;

  validGate3 <= validGate1 OR validGate2;

  validGate4 <= hStartFinalTap OR validGate3;

  validOut <= validGate4;

END rtl;

