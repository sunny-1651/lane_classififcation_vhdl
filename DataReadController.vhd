LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY DataReadController IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        hStartIn                          :   IN    std_logic;
        hEndIn                            :   IN    std_logic;
        vStartIn                          :   IN    std_logic;
        vEndIn                            :   IN    std_logic;
        validIn                           :   IN    std_logic;
        lineStartV                        :   IN    std_logic_vector(7 DOWNTO 0);  -- ufix8
        lineAverage                       :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16
        AllEndOfLine                      :   IN    std_logic;
        BlankCount                        :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16
        frameStart                        :   IN    std_logic;
        hStartR                           :   OUT   std_logic;
        hEndR                             :   OUT   std_logic;
        vEndR                             :   OUT   std_logic;
        validR                            :   OUT   std_logic;
        outputData                        :   OUT   std_logic;
        Unloading                         :   OUT   std_logic;
        blankCountEn                      :   OUT   std_logic;
        Running                           :   OUT   std_logic
        );
END DataReadController;


ARCHITECTURE rtl OF DataReadController IS

  -- Functions
  -- HDLCODER_TO_STDLOGIC 
  FUNCTION hdlcoder_to_stdlogic(arg: boolean) RETURN std_logic IS
  BEGIN
    IF arg THEN
      RETURN '1';
    ELSE
      RETURN '0';
    END IF;
  END FUNCTION;


  -- Signals
  SIGNAL lineStartV_unsigned              : unsigned(7 DOWNTO 0);  -- ufix8
  SIGNAL lineAverage_unsigned             : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL BlankCount_unsigned              : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL DataReadController_FSMState      : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL DataReadController_InBetween     : std_logic;
  SIGNAL DataReadController_FSMState_next : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL DataReadController_InBetween_next : std_logic;
  SIGNAL vStartR                          : std_logic;

BEGIN
  lineStartV_unsigned <= unsigned(lineStartV);

  lineAverage_unsigned <= unsigned(lineAverage);

  BlankCount_unsigned <= unsigned(BlankCount);

  -- Data Read Controller
  DataReadController_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        DataReadController_FSMState <= to_unsigned(16#0#, 2);
        DataReadController_InBetween <= '0';
      ELSIF enb = '1' THEN
        DataReadController_FSMState <= DataReadController_FSMState_next;
        DataReadController_InBetween <= DataReadController_InBetween_next;
      END IF;
    END IF;
  END PROCESS DataReadController_1_process;

  DataReadController_1_output : PROCESS (AllEndOfLine, BlankCount_unsigned, DataReadController_FSMState,
       DataReadController_InBetween, frameStart, hEndIn, hStartIn,
       lineAverage_unsigned, lineStartV_unsigned, vEndIn, vStartIn, validIn)
  BEGIN
    DataReadController_FSMState_next <= DataReadController_FSMState;
    DataReadController_InBetween_next <= DataReadController_InBetween;
    CASE DataReadController_FSMState IS
      WHEN "00" =>
        outputData <= '0';
        hStartR <= hStartIn;
        hEndR <= hEndIn;
        vStartR <= vStartIn;
        vEndR <= '0';
        validR <= validIn;
        Unloading <= '0';
        DataReadController_InBetween_next <= '0';
        blankCountEn <= '0';
        Running <= '0';
        IF lineStartV_unsigned(7) /= '0' THEN 
          DataReadController_FSMState_next <= to_unsigned(16#1#, 2);
        ELSE 
          DataReadController_FSMState_next <= to_unsigned(16#0#, 2);
        END IF;
      WHEN "01" =>
        outputData <= '1';
        Unloading <= '0';
        Running <= '1';
        hStartR <= hStartIn;
        hEndR <= hEndIn;
        vStartR <= vStartIn;
        vEndR <= '0';
        validR <= validIn;
        IF frameStart /= '0' THEN 
          DataReadController_FSMState_next <= to_unsigned(16#0#, 2);
          DataReadController_InBetween_next <= '1';
          blankCountEn <= '0';
        ELSIF vEndIn /= '0' THEN 
          DataReadController_FSMState_next <= to_unsigned(16#2#, 2);
          DataReadController_InBetween_next <= '1';
          blankCountEn <= '1';
        ELSE 
          DataReadController_FSMState_next <= to_unsigned(16#1#, 2);
          blankCountEn <= '0';
          DataReadController_InBetween_next <= '0';
        END IF;
      WHEN "10" =>
        outputData <= '1';
        Unloading <= '1';
        Running <= '0';
        IF frameStart /= '0' THEN 
          DataReadController_FSMState_next <= to_unsigned(16#0#, 2);
          hStartR <= '0';
          hEndR <= '0';
          vStartR <= '0';
          vEndR <= '0';
          validR <= '0';
          blankCountEn <= '0';
          DataReadController_InBetween_next <= '1';
        ELSIF ((( NOT lineStartV_unsigned(6)) AND ( NOT DataReadController_InBetween)) AND AllEndOfLine) = '1' THEN 
          DataReadController_FSMState_next <= to_unsigned(16#2#, 2);
          hStartR <= '0';
          hEndR <= '1';
          vStartR <= '0';
          vEndR <= '1';
          validR <= '1';
          blankCountEn <= '0';
          DataReadController_InBetween_next <= '1';
        ELSIF ((DataReadController_InBetween AND hdlcoder_to_stdlogic(BlankCount_unsigned = lineAverage_unsigned)) AND ( NOT lineStartV_unsigned(6))) = '1' THEN 
          DataReadController_FSMState_next <= to_unsigned(16#0#, 2);
          hStartR <= '0';
          hEndR <= '0';
          vStartR <= '0';
          vEndR <= '0';
          validR <= '0';
          blankCountEn <= '0';
          DataReadController_InBetween_next <= '0';
        ELSIF (DataReadController_InBetween AND hdlcoder_to_stdlogic(BlankCount_unsigned < lineAverage_unsigned)) = '1' THEN 
          DataReadController_FSMState_next <= to_unsigned(16#2#, 2);
          hStartR <= '0';
          hEndR <= '0';
          vStartR <= '0';
          vEndR <= '0';
          validR <= '0';
          blankCountEn <= '1';
          DataReadController_InBetween_next <= '1';
        ELSIF (DataReadController_InBetween AND hdlcoder_to_stdlogic(BlankCount_unsigned = lineAverage_unsigned)) = '1' THEN 
          DataReadController_FSMState_next <= to_unsigned(16#2#, 2);
          hStartR <= '1';
          hEndR <= '0';
          vStartR <= '0';
          vEndR <= '0';
          validR <= '1';
          blankCountEn <= '0';
          DataReadController_InBetween_next <= '0';
        ELSIF (( NOT DataReadController_InBetween) AND AllEndOfLine) = '1' THEN 
          DataReadController_FSMState_next <= to_unsigned(16#2#, 2);
          hStartR <= '0';
          hEndR <= '1';
          vStartR <= '0';
          vEndR <= '0';
          validR <= '1';
          blankCountEn <= '0';
          DataReadController_InBetween_next <= '1';
        ELSIF ( NOT DataReadController_InBetween) = '1' THEN 
          DataReadController_FSMState_next <= to_unsigned(16#2#, 2);
          hStartR <= '0';
          hEndR <= '0';
          vStartR <= '0';
          vEndR <= '0';
          validR <= '1';
          blankCountEn <= '0';
          DataReadController_InBetween_next <= '0';
        ELSE 
          DataReadController_FSMState_next <= to_unsigned(16#2#, 2);
          hStartR <= '0';
          hEndR <= '0';
          vStartR <= '0';
          vEndR <= '0';
          validR <= '1';
          blankCountEn <= '0';
          DataReadController_InBetween_next <= '0';
        END IF;
      WHEN OTHERS => 
        hStartR <= hStartIn;
        hEndR <= hEndIn;
        vStartR <= vStartIn;
        vEndR <= '0';
        validR <= validIn;
        outputData <= '1';
        Unloading <= '0';
        blankCountEn <= '0';
        DataReadController_InBetween_next <= '0';
        Running <= '0';
    END CASE;
  END PROCESS DataReadController_1_output;


END rtl;

