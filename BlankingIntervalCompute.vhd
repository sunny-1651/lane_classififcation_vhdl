LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY BlankingIntervalCompute IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        hStart                            :   IN    std_logic;
        hEnd                              :   IN    std_logic;
        FSMState                          :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
        BlankingInterval                  :   OUT   std_logic_vector(15 DOWNTO 0)  -- ufix16
        );
END BlankingIntervalCompute;


ARCHITECTURE rtl OF BlankingIntervalCompute IS

  -- Signals
  SIGNAL FSMState_unsigned                : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL StateConst                       : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL relop_relop1                     : std_logic;
  SIGNAL LockedFrame                      : std_logic;
  SIGNAL hStartGate                       : std_logic;
  SIGNAL LineEnable                       : std_logic;
  SIGNAL LogicLow                         : std_logic;
  SIGNAL MuxOut                           : std_logic;
  SIGNAL BetweenLines                     : std_logic;
  SIGNAL BetweenLinesGate                 : std_logic;
  SIGNAL BlankingIntervalCount_1          : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL REG1                             : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL REG2                             : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL SumOne                           : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL REG3                             : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL REG4                             : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL SumTwo                           : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL TotalSum                         : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL gain_cast                        : unsigned(31 DOWNTO 0);  -- ufix32_En16
  SIGNAL BlankingInterval_tmp             : unsigned(15 DOWNTO 0);  -- ufix16

BEGIN
  FSMState_unsigned <= unsigned(FSMState);

  StateConst <= to_unsigned(16#2#, 2);

  
  relop_relop1 <= '1' WHEN FSMState_unsigned = StateConst ELSE
      '0';

  LockedFrame <=  NOT relop_relop1;

  hStartGate <= hStart AND LockedFrame;

  LineEnable <= hStart OR hEnd;

  LogicLow <= '0';

  
  MuxOut <= LogicLow WHEN hEnd = '0' ELSE
      hEnd;

  reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        BetweenLines <= '0';
      ELSIF enb = '1' AND LineEnable = '1' THEN
        BetweenLines <= MuxOut;
      END IF;
    END IF;
  END PROCESS reg_process;


  BetweenLinesGate <= BetweenLines AND LockedFrame;

  -- Free running, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  -- 
  -- Blanking Interval Counter
  BlankingIntervalCount_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        BlankingIntervalCount_1 <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' THEN
        IF hStartGate = '1' THEN 
          BlankingIntervalCount_1 <= to_unsigned(16#0000#, 16);
        ELSIF BetweenLinesGate = '1' THEN 
          BlankingIntervalCount_1 <= BlankingIntervalCount_1 + to_unsigned(16#0001#, 16);
        END IF;
      END IF;
    END IF;
  END PROCESS BlankingIntervalCount_process;


  reg_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        REG1 <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' AND hStartGate = '1' THEN
        REG1 <= BlankingIntervalCount_1;
      END IF;
    END IF;
  END PROCESS reg_1_process;


  reg_2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        REG2 <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' AND hStartGate = '1' THEN
        REG2 <= REG1;
      END IF;
    END IF;
  END PROCESS reg_2_process;


  SumOne <= REG1 + REG2;

  reg_3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        REG3 <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' AND hStartGate = '1' THEN
        REG3 <= REG2;
      END IF;
    END IF;
  END PROCESS reg_3_process;


  reg_4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        REG4 <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' AND hStartGate = '1' THEN
        REG4 <= REG3;
      END IF;
    END IF;
  END PROCESS reg_4_process;


  SumTwo <= REG3 + REG4;

  TotalSum <= SumOne + SumTwo;

  gain_cast <= resize(TotalSum & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 32);
  BlankingInterval_tmp <= gain_cast(31 DOWNTO 16);

  BlankingInterval <= std_logic_vector(BlankingInterval_tmp);

END rtl;

