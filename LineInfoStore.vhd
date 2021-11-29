LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY LineInfoStore IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        hStartIn                          :   IN    std_logic;
        Unloading                         :   IN    std_logic;
        frameEnd                          :   IN    std_logic;
        lineStartV                        :   OUT   std_logic_vector(7 DOWNTO 0)  -- ufix8
        );
END LineInfoStore;


ARCHITECTURE rtl OF LineInfoStore IS

  -- Signals
  SIGNAL zeroConstant                     : std_logic;
  SIGNAL InputMuxOut                      : std_logic;
  SIGNAL reg_switch_delay                 : std_logic;  -- ufix1
  SIGNAL lineStart2                       : std_logic;
  SIGNAL reg_switch_delay_1               : std_logic;  -- ufix1
  SIGNAL lineStart3                       : std_logic;
  SIGNAL reg_switch_delay_2               : std_logic;  -- ufix1
  SIGNAL lineStart4                       : std_logic;
  SIGNAL reg_switch_delay_3               : std_logic;  -- ufix1
  SIGNAL lineStart5                       : std_logic;
  SIGNAL reg_switch_delay_4               : std_logic;  -- ufix1
  SIGNAL lineStart6                       : std_logic;
  SIGNAL reg_switch_delay_5               : std_logic;  -- ufix1
  SIGNAL lineStart7                       : std_logic;
  SIGNAL reg_switch_delay_6               : std_logic;  -- ufix1
  SIGNAL lineStart8                       : std_logic;
  SIGNAL reg_switch_delay_7               : std_logic;  -- ufix1
  SIGNAL lineStart9                       : std_logic;
  SIGNAL reg_switch_delay_8               : std_logic;  -- ufix1
  SIGNAL lineStart10                      : std_logic;
  SIGNAL lineStartV_tmp                   : unsigned(7 DOWNTO 0);  -- ufix8

BEGIN
  zeroConstant <= '0';

  
  InputMuxOut <= hStartIn WHEN Unloading = '0' ELSE
      zeroConstant;

  reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        reg_switch_delay <= '0';
      ELSIF enb = '1' THEN
        IF frameEnd = '1' THEN
          reg_switch_delay <= '0';
        ELSIF hStartIn = '1' THEN
          reg_switch_delay <= InputMuxOut;
        END IF;
      END IF;
    END IF;
  END PROCESS reg_process;

  
  lineStart2 <= '0' WHEN frameEnd = '1' ELSE
      reg_switch_delay;

  reg_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        reg_switch_delay_1 <= '0';
      ELSIF enb = '1' THEN
        IF frameEnd = '1' THEN
          reg_switch_delay_1 <= '0';
        ELSIF hStartIn = '1' THEN
          reg_switch_delay_1 <= lineStart2;
        END IF;
      END IF;
    END IF;
  END PROCESS reg_1_process;

  
  lineStart3 <= '0' WHEN frameEnd = '1' ELSE
      reg_switch_delay_1;

  reg_2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        reg_switch_delay_2 <= '0';
      ELSIF enb = '1' THEN
        IF frameEnd = '1' THEN
          reg_switch_delay_2 <= '0';
        ELSIF hStartIn = '1' THEN
          reg_switch_delay_2 <= lineStart3;
        END IF;
      END IF;
    END IF;
  END PROCESS reg_2_process;

  
  lineStart4 <= '0' WHEN frameEnd = '1' ELSE
      reg_switch_delay_2;

  reg_3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        reg_switch_delay_3 <= '0';
      ELSIF enb = '1' THEN
        IF frameEnd = '1' THEN
          reg_switch_delay_3 <= '0';
        ELSIF hStartIn = '1' THEN
          reg_switch_delay_3 <= lineStart4;
        END IF;
      END IF;
    END IF;
  END PROCESS reg_3_process;

  
  lineStart5 <= '0' WHEN frameEnd = '1' ELSE
      reg_switch_delay_3;

  reg_4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        reg_switch_delay_4 <= '0';
      ELSIF enb = '1' THEN
        IF frameEnd = '1' THEN
          reg_switch_delay_4 <= '0';
        ELSIF hStartIn = '1' THEN
          reg_switch_delay_4 <= lineStart5;
        END IF;
      END IF;
    END IF;
  END PROCESS reg_4_process;

  
  lineStart6 <= '0' WHEN frameEnd = '1' ELSE
      reg_switch_delay_4;

  reg_5_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        reg_switch_delay_5 <= '0';
      ELSIF enb = '1' THEN
        IF frameEnd = '1' THEN
          reg_switch_delay_5 <= '0';
        ELSIF hStartIn = '1' THEN
          reg_switch_delay_5 <= lineStart6;
        END IF;
      END IF;
    END IF;
  END PROCESS reg_5_process;

  
  lineStart7 <= '0' WHEN frameEnd = '1' ELSE
      reg_switch_delay_5;

  reg_6_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        reg_switch_delay_6 <= '0';
      ELSIF enb = '1' THEN
        IF frameEnd = '1' THEN
          reg_switch_delay_6 <= '0';
        ELSIF hStartIn = '1' THEN
          reg_switch_delay_6 <= lineStart7;
        END IF;
      END IF;
    END IF;
  END PROCESS reg_6_process;

  
  lineStart8 <= '0' WHEN frameEnd = '1' ELSE
      reg_switch_delay_6;

  reg_7_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        reg_switch_delay_7 <= '0';
      ELSIF enb = '1' THEN
        IF frameEnd = '1' THEN
          reg_switch_delay_7 <= '0';
        ELSIF hStartIn = '1' THEN
          reg_switch_delay_7 <= lineStart8;
        END IF;
      END IF;
    END IF;
  END PROCESS reg_7_process;

  
  lineStart9 <= '0' WHEN frameEnd = '1' ELSE
      reg_switch_delay_7;

  reg_8_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        reg_switch_delay_8 <= '0';
      ELSIF enb = '1' THEN
        IF frameEnd = '1' THEN
          reg_switch_delay_8 <= '0';
        ELSIF hStartIn = '1' THEN
          reg_switch_delay_8 <= lineStart9;
        END IF;
      END IF;
    END IF;
  END PROCESS reg_8_process;

  
  lineStart10 <= '0' WHEN frameEnd = '1' ELSE
      reg_switch_delay_8;

  lineStartV_tmp <= unsigned'(lineStart10 & lineStart9 & lineStart8 & lineStart7 & lineStart6 & lineStart5 & lineStart4 & lineStart3);

  lineStartV <= std_logic_vector(lineStartV_tmp);

END rtl;

