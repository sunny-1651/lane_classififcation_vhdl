LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY peakValueMemory IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        peakVal                           :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
        lane1En                           :   IN    std_logic;
        lane3En                           :   IN    std_logic;
        lane2En                           :   IN    std_logic;
        lane4En                           :   IN    std_logic;
        lane5En                           :   IN    std_logic;
        lane6En                           :   IN    std_logic;
        lane7En                           :   IN    std_logic;
        laneRST                           :   IN    std_logic;
        peakREG1                          :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
        peakREG2                          :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
        peakREG3                          :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
        peakREG4                          :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
        peakREG5                          :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
        peakREG6                          :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En10
        peakREG7                          :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En10
        );
END peakValueMemory;


ARCHITECTURE rtl OF peakValueMemory IS

  -- Signals
  SIGNAL peakVal_signed                   : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Delay17_out1                     : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Delay18_out1                     : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Delay19_out1                     : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Delay20_out1                     : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Delay21_out1                     : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Delay22_out1                     : signed(31 DOWNTO 0);  -- sfix32_En10
  SIGNAL Delay23_out1                     : signed(31 DOWNTO 0);  -- sfix32_En10

BEGIN
  peakVal_signed <= signed(peakVal);

  Delay17_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay17_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        IF laneRST = '1' THEN
          Delay17_out1 <= to_signed(0, 32);
        ELSIF lane1En = '1' THEN
          Delay17_out1 <= peakVal_signed;
        END IF;
      END IF;
    END IF;
  END PROCESS Delay17_process;


  peakREG1 <= std_logic_vector(Delay17_out1);

  Delay18_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay18_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        IF laneRST = '1' THEN
          Delay18_out1 <= to_signed(0, 32);
        ELSIF lane2En = '1' THEN
          Delay18_out1 <= peakVal_signed;
        END IF;
      END IF;
    END IF;
  END PROCESS Delay18_process;


  peakREG2 <= std_logic_vector(Delay18_out1);

  Delay19_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay19_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        IF laneRST = '1' THEN
          Delay19_out1 <= to_signed(0, 32);
        ELSIF lane3En = '1' THEN
          Delay19_out1 <= peakVal_signed;
        END IF;
      END IF;
    END IF;
  END PROCESS Delay19_process;


  peakREG3 <= std_logic_vector(Delay19_out1);

  Delay20_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay20_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        IF laneRST = '1' THEN
          Delay20_out1 <= to_signed(0, 32);
        ELSIF lane4En = '1' THEN
          Delay20_out1 <= peakVal_signed;
        END IF;
      END IF;
    END IF;
  END PROCESS Delay20_process;


  peakREG4 <= std_logic_vector(Delay20_out1);

  Delay21_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay21_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        IF laneRST = '1' THEN
          Delay21_out1 <= to_signed(0, 32);
        ELSIF lane5En = '1' THEN
          Delay21_out1 <= peakVal_signed;
        END IF;
      END IF;
    END IF;
  END PROCESS Delay21_process;


  peakREG5 <= std_logic_vector(Delay21_out1);

  Delay22_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay22_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        IF laneRST = '1' THEN
          Delay22_out1 <= to_signed(0, 32);
        ELSIF lane6En = '1' THEN
          Delay22_out1 <= peakVal_signed;
        END IF;
      END IF;
    END IF;
  END PROCESS Delay22_process;


  peakREG6 <= std_logic_vector(Delay22_out1);

  Delay23_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay23_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        IF laneRST = '1' THEN
          Delay23_out1 <= to_signed(0, 32);
        ELSIF lane7En = '1' THEN
          Delay23_out1 <= peakVal_signed;
        END IF;
      END IF;
    END IF;
  END PROCESS Delay23_process;


  peakREG7 <= std_logic_vector(Delay23_out1);

END rtl;

