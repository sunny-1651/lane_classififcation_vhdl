LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Vertical_Padding_Counter IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        frameEnd                          :   IN    std_logic;
        unloading                         :   IN    std_logic;
        running                           :   IN    std_logic;
        lineStart                         :   IN    std_logic;
        VCount                            :   OUT   std_logic_vector(10 DOWNTO 0)  -- ufix11
        );
END Vertical_Padding_Counter;


ARCHITECTURE rtl OF Vertical_Padding_Counter IS

  -- Signals
  SIGNAL runningStart                     : std_logic;
  SIGNAL unloadingStart                   : std_logic;
  SIGNAL VerticalPadCounter               : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL prePad                           : std_logic;
  SIGNAL runCountEn                       : std_logic;
  SIGNAL verCountEn                       : std_logic;

BEGIN
  runningStart <= running AND lineStart;

  unloadingStart <= unloading AND lineStart;

  
  prePad <= '1' WHEN VerticalPadCounter < to_unsigned(16#007#, 11) ELSE
      '0';

  runCountEn <= runningStart AND prePad;

  verCountEn <= runCountEn OR unloadingStart;

  -- Free running, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  Vertical_Counter_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        VerticalPadCounter <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' THEN
        IF frameEnd = '1' THEN 
          VerticalPadCounter <= to_unsigned(16#000#, 11);
        ELSIF verCountEn = '1' THEN 
          VerticalPadCounter <= VerticalPadCounter + to_unsigned(16#001#, 11);
        END IF;
      END IF;
    END IF;
  END PROCESS Vertical_Counter_process;


  VCount <= std_logic_vector(VerticalPadCounter);

END rtl;

