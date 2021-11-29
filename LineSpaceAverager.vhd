LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY LineSpaceAverager IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        InBetween                         :   IN    std_logic;
        InLine                            :   IN    std_logic;
        LineSpaceAverage                  :   OUT   std_logic_vector(15 DOWNTO 0)  -- ufix16
        );
END LineSpaceAverager;


ARCHITECTURE rtl OF LineSpaceAverager IS

  -- Signals
  SIGNAL LineSpaceCounter                 : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL LineSpaceCounterD1               : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL LineSpaceCounterD2               : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL AddTerm1                         : unsigned(16 DOWNTO 0);  -- ufix17
  SIGNAL AddTerm1REG                      : unsigned(16 DOWNTO 0);  -- ufix17
  SIGNAL LineSpaceCounterD3               : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL LineSpaceCounterD4               : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL AddTerm2                         : unsigned(16 DOWNTO 0);  -- ufix17
  SIGNAL AddTerm2REG                      : unsigned(16 DOWNTO 0);  -- ufix17
  SIGNAL AddTerm3                         : unsigned(17 DOWNTO 0);  -- ufix18
  SIGNAL AddTerm3REG                      : unsigned(17 DOWNTO 0);  -- ufix18
  SIGNAL AddTerm3_1                       : unsigned(17 DOWNTO 0);  -- ufix18
  SIGNAL AddTerm3REG_1                    : unsigned(17 DOWNTO 0);  -- ufix18
  SIGNAL LineSpaceAverage_tmp             : unsigned(15 DOWNTO 0);  -- ufix16

BEGIN
  -- Free running, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  Read_Count_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        LineSpaceCounter <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' THEN
        IF InLine = '1' THEN 
          LineSpaceCounter <= to_unsigned(16#0000#, 16);
        ELSIF InBetween = '1' THEN 
          LineSpaceCounter <= LineSpaceCounter + to_unsigned(16#0001#, 16);
        END IF;
      END IF;
    END IF;
  END PROCESS Read_Count_process;


  reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        LineSpaceCounterD1 <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' AND InLine = '1' THEN
        LineSpaceCounterD1 <= LineSpaceCounter;
      END IF;
    END IF;
  END PROCESS reg_process;


  reg_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        LineSpaceCounterD2 <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' AND InLine = '1' THEN
        LineSpaceCounterD2 <= LineSpaceCounterD1;
      END IF;
    END IF;
  END PROCESS reg_1_process;


  AddTerm1 <= resize(LineSpaceCounterD1, 17) + resize(LineSpaceCounterD2, 17);

  reg_2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        AddTerm1REG <= to_unsigned(16#00000#, 17);
      ELSIF enb = '1' THEN
        AddTerm1REG <= AddTerm1;
      END IF;
    END IF;
  END PROCESS reg_2_process;


  reg_3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        LineSpaceCounterD3 <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' AND InLine = '1' THEN
        LineSpaceCounterD3 <= LineSpaceCounterD2;
      END IF;
    END IF;
  END PROCESS reg_3_process;


  reg_4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        LineSpaceCounterD4 <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' AND InLine = '1' THEN
        LineSpaceCounterD4 <= LineSpaceCounterD3;
      END IF;
    END IF;
  END PROCESS reg_4_process;


  AddTerm2 <= resize(LineSpaceCounterD3, 17) + resize(LineSpaceCounterD4, 17);

  reg_5_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        AddTerm2REG <= to_unsigned(16#00000#, 17);
      ELSIF enb = '1' THEN
        AddTerm2REG <= AddTerm2;
      END IF;
    END IF;
  END PROCESS reg_5_process;


  AddTerm3 <= resize(AddTerm1REG, 18) + resize(AddTerm2REG, 18);

  reg_6_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        AddTerm3REG <= to_unsigned(16#00000#, 18);
      ELSIF enb = '1' THEN
        AddTerm3REG <= AddTerm3;
      END IF;
    END IF;
  END PROCESS reg_6_process;


  AddTerm3_1 <= AddTerm3REG srl 2;

  reg_7_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        AddTerm3REG_1 <= to_unsigned(16#00000#, 18);
      ELSIF enb = '1' THEN
        AddTerm3REG_1 <= AddTerm3_1;
      END IF;
    END IF;
  END PROCESS reg_7_process;


  LineSpaceAverage_tmp <= AddTerm3REG_1(15 DOWNTO 0);

  LineSpaceAverage <= std_logic_vector(LineSpaceAverage_tmp);

END rtl;

