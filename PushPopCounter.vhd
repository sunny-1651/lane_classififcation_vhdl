LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY PushPopCounter IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        hStartIn                          :   IN    std_logic;
        popIn                             :   IN    std_logic;
        popEnable                         :   IN    std_logic;
        hEndIn                            :   IN    std_logic;
        writeCountPrev                    :   IN    std_logic_vector(10 DOWNTO 0);  -- ufix11
        wrAddr                            :   OUT   std_logic_vector(10 DOWNTO 0);  -- ufix11
        pushOut                           :   OUT   std_logic;
        rdAddr                            :   OUT   std_logic_vector(10 DOWNTO 0);  -- ufix11
        popOut                            :   OUT   std_logic;
        EndofLine                         :   OUT   std_logic
        );
END PushPopCounter;


ARCHITECTURE rtl OF PushPopCounter IS

  -- Signals
  SIGNAL writeCountPrev_unsigned          : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL writePrevREG                     : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL InBetweenEn                      : std_logic;
  SIGNAL ConstantZero                     : std_logic;
  SIGNAL InBetweenRegIn                   : std_logic;
  SIGNAL InBetween                        : std_logic;
  SIGNAL writeCount                       : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL relop_relop1                     : std_logic;
  SIGNAL writeContinue                    : std_logic;
  SIGNAL writeEN                          : std_logic;
  SIGNAL intdelay_reg                     : std_logic_vector(0 TO 1);  -- ufix1 [2]
  SIGNAL writeStoreEn                     : std_logic;
  SIGNAL writeCountNext                   : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL writeCountCurrent                : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL readCountCompare                 : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL readCountCompare_is_not0         : std_logic;
  SIGNAL popTerm2                         : std_logic;
  SIGNAL relop_relop1_1                   : std_logic;
  SIGNAL and_bool                         : std_logic;
  SIGNAL readCountCompare_is_not0_1       : std_logic;
  SIGNAL popTerm1                         : std_logic;
  SIGNAL popCounter                       : std_logic;
  SIGNAL readReset                        : std_logic;
  SIGNAL readPop                          : std_logic;
  SIGNAL readCount                        : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL popcountless                     : std_logic;
  SIGNAL relop_relop1_2                   : std_logic;
  SIGNAL startOrEnd                       : std_logic;
  SIGNAL constantTwo                      : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL readCountAhead                   : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL relop_relop1_3                   : std_logic;

BEGIN
  writeCountPrev_unsigned <= unsigned(writeCountPrev);

  reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        writePrevREG <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' AND hStartIn = '1' THEN
        writePrevREG <= writeCountPrev_unsigned;
      END IF;
    END IF;
  END PROCESS reg_process;


  InBetweenEn <= hStartIn OR hEndIn;

  ConstantZero <= '0';

  
  InBetweenRegIn <= hEndIn WHEN hStartIn = '0' ELSE
      ConstantZero;

  reg_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        InBetween <= '0';
      ELSIF enb = '1' AND InBetweenEn = '1' THEN
        InBetween <= InBetweenRegIn;
      END IF;
    END IF;
  END PROCESS reg_1_process;


  
  relop_relop1 <= '1' WHEN writeCount <= writePrevREG ELSE
      '0';

  writeContinue <= relop_relop1 AND InBetween;

  writeEN <= writeContinue OR popIn;

  -- Free running, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  Write_Count_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        writeCount <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' THEN
        IF hStartIn = '1' THEN 
          writeCount <= to_unsigned(16#000#, 11);
        ELSIF writeEN = '1' THEN 
          writeCount <= writeCount + to_unsigned(16#001#, 11);
        END IF;
      END IF;
    END IF;
  END PROCESS Write_Count_process;


  wrAddr <= std_logic_vector(writeCount);

  pushOut <= writeEN;

  intdelay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        intdelay_reg(0) <= hEndIn;
        intdelay_reg(1) <= intdelay_reg(0);
      END IF;
    END IF;
  END PROCESS intdelay_process;

  writeStoreEn <= intdelay_reg(1);

  reg_2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        writeCountNext <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' AND writeStoreEn = '1' THEN
        writeCountNext <= writeCount;
      END IF;
    END IF;
  END PROCESS reg_2_process;


  reg_3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        writeCountCurrent <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' AND hStartIn = '1' THEN
        writeCountCurrent <= writeCountNext;
      END IF;
    END IF;
  END PROCESS reg_3_process;


  
  readCountCompare_is_not0 <= '1' WHEN readCountCompare /= to_unsigned(16#000#, 11) ELSE
      '0';

  popTerm2 <= readCountCompare_is_not0 AND InBetween;

  and_bool <= popEnable AND relop_relop1_1;

  readCountCompare <= '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & and_bool;

  
  readCountCompare_is_not0_1 <= '1' WHEN readCountCompare /= to_unsigned(16#000#, 11) ELSE
      '0';

  popTerm1 <= popIn AND readCountCompare_is_not0_1;

  popCounter <= popTerm1 OR popTerm2;

  readResetREG_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        readPop <= '0';
      ELSIF enb = '1' THEN
        IF readReset = '1' THEN
          readPop <= '0';
        ELSIF hStartIn = '1' THEN
          readPop <= hStartIn;
        END IF;
      END IF;
    END IF;
  END PROCESS readResetREG_process;


  
  relop_relop1_1 <= '1' WHEN readCount < writeCountCurrent ELSE
      '0';

  popcountless <= popCounter AND (relop_relop1_1 AND readPop);

  
  relop_relop1_2 <= '1' WHEN readCount = writeCountCurrent ELSE
      '0';

  readReset <= writeEN AND relop_relop1_2;

  startOrEnd <= hStartIn OR readReset;

  -- Free running, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  Read_Count_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        readCount <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' THEN
        IF startOrEnd = '1' THEN 
          readCount <= to_unsigned(16#000#, 11);
        ELSIF popcountless = '1' THEN 
          readCount <= readCount + to_unsigned(16#001#, 11);
        END IF;
      END IF;
    END IF;
  END PROCESS Read_Count_process;


  rdAddr <= std_logic_vector(readCount);

  popOut <= popCounter;

  constantTwo <= to_unsigned(16#005#, 11);

  readCountAhead <= readCount + constantTwo;

  
  relop_relop1_3 <= '1' WHEN readCountAhead = writeCountCurrent ELSE
      '0';

  EndofLine <= relop_relop1_3;

END rtl;

