LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Subsystem1 IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        laneIn                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        RightLaneVal                      :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
        LeftLaneVal                       :   OUT   std_logic_vector(11 DOWNTO 0)  -- sfix12
        );
END Subsystem1;


ARCHITECTURE rtl OF Subsystem1 IS

  -- Signals
  SIGNAL Constant_out1                    : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL laneIn_unsigned                  : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Add_sub_cast                     : signed(12 DOWNTO 0);  -- sfix13
  SIGNAL Add_sub_temp                     : signed(12 DOWNTO 0);  -- sfix13
  SIGNAL Add_out1                         : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Compare_To_Zero_out1             : std_logic;
  SIGNAL Constant7_out1                   : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Multiport_Switch_out1            : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Abs1_y                           : signed(12 DOWNTO 0);  -- sfix13
  SIGNAL Abs1_out1                        : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay_out1                       : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Multiport_Switch1_out1           : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay1_out1                      : signed(11 DOWNTO 0);  -- sfix12

BEGIN
  Constant_out1 <= to_signed(16#140#, 12);

  laneIn_unsigned <= unsigned(laneIn);

  Add_sub_cast <= signed(resize(laneIn_unsigned, 13));
  Add_sub_temp <= resize(Constant_out1, 13) - Add_sub_cast;
  Add_out1 <= Add_sub_temp(11 DOWNTO 0);

  
  Compare_To_Zero_out1 <= '1' WHEN Add_out1 <= to_signed(16#000#, 12) ELSE
      '0';

  Constant7_out1 <= to_signed(16#3E8#, 12);

  
  Multiport_Switch_out1 <= Constant7_out1 WHEN Compare_To_Zero_out1 = '0' ELSE
      Add_out1;

  
  Abs1_y <=  - (resize(Multiport_Switch_out1, 13)) WHEN Multiport_Switch_out1 < to_signed(16#000#, 12) ELSE
      resize(Multiport_Switch_out1, 13);
  Abs1_out1 <= Abs1_y(11 DOWNTO 0);

  Delay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay_out1 <= Abs1_out1;
      END IF;
    END IF;
  END PROCESS Delay_process;


  RightLaneVal <= std_logic_vector(Delay_out1);

  
  Multiport_Switch1_out1 <= Add_out1 WHEN Compare_To_Zero_out1 = '0' ELSE
      Constant7_out1;

  Delay1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay1_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay1_out1 <= Multiport_Switch1_out1;
      END IF;
    END IF;
  END PROCESS Delay1_process;


  LeftLaneVal <= std_logic_vector(Delay1_out1);

END rtl;

