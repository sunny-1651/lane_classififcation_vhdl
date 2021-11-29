LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY PaddingController IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        PrePadFlag                        :   IN    std_logic;
        OnLineFlag                        :   IN    std_logic;
        alphaPostPadFlag                  :   IN    std_logic;
        DumpingFlag                       :   IN    std_logic;
        BlankingFlag                      :   IN    std_logic;
        processData                       :   OUT   std_logic;
        countReset                        :   OUT   std_logic;
        countEn                           :   OUT   std_logic;
        dumpControl                       :   OUT   std_logic;
        PrePadding                        :   OUT   std_logic
        );
END PaddingController;


ARCHITECTURE rtl OF PaddingController IS

  -- Signals
  SIGNAL PaddingController_FSMState       : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL PaddingController_FSMState_next  : unsigned(2 DOWNTO 0);  -- ufix3

BEGIN
  -- Padding Controller
  PaddingController_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        PaddingController_FSMState <= to_unsigned(16#0#, 3);
      ELSIF enb = '1' THEN
        PaddingController_FSMState <= PaddingController_FSMState_next;
      END IF;
    END IF;
  END PROCESS PaddingController_1_process;

  PaddingController_1_output : PROCESS (BlankingFlag, DumpingFlag, OnLineFlag, PaddingController_FSMState, PrePadFlag,
       alphaPostPadFlag)
  BEGIN
    PaddingController_FSMState_next <= PaddingController_FSMState;
    CASE PaddingController_FSMState IS
      WHEN "000" =>
        processData <= '0';
        countReset <= '1';
        countEn <= '0';
        dumpControl <= '0';
        PrePadding <= '0';
        IF PrePadFlag /= '0' THEN 
          PaddingController_FSMState_next <= to_unsigned(16#1#, 3);
        ELSE 
          PaddingController_FSMState_next <= to_unsigned(16#0#, 3);
        END IF;
      WHEN "001" =>
        processData <= '1';
        countReset <= '0';
        countEn <= '1';
        dumpControl <= '0';
        PrePadding <= '1';
        IF OnLineFlag /= '0' THEN 
          PaddingController_FSMState_next <= to_unsigned(16#2#, 3);
        ELSE 
          PaddingController_FSMState_next <= to_unsigned(16#1#, 3);
        END IF;
      WHEN "010" =>
        processData <= '1';
        countReset <= '0';
        countEn <= '0';
        dumpControl <= '0';
        PrePadding <= '0';
        IF DumpingFlag /= '0' THEN 
          PaddingController_FSMState_next <= to_unsigned(16#3#, 3);
        ELSE 
          PaddingController_FSMState_next <= to_unsigned(16#2#, 3);
        END IF;
      WHEN "011" =>
        processData <= '1';
        countReset <= '0';
        countEn <= '0';
        dumpControl <= '1';
        PrePadding <= '0';
        IF alphaPostPadFlag /= '0' THEN 
          PaddingController_FSMState_next <= to_unsigned(16#4#, 3);
        ELSE 
          PaddingController_FSMState_next <= to_unsigned(16#3#, 3);
        END IF;
      WHEN "100" =>
        processData <= '1';
        countReset <= '0';
        countEn <= '1';
        dumpControl <= '1';
        PrePadding <= '0';
        IF BlankingFlag /= '0' THEN 
          PaddingController_FSMState_next <= to_unsigned(16#0#, 3);
        ELSE 
          PaddingController_FSMState_next <= to_unsigned(16#4#, 3);
        END IF;
      WHEN OTHERS => 
        processData <= '0';
        countReset <= '0';
        countEn <= '0';
        dumpControl <= '0';
        PrePadding <= '0';
    END CASE;
  END PROCESS PaddingController_1_output;


END rtl;

