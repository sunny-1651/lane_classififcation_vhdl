LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY rightminop3 IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        val1                              :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
        val2                              :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
        ind1                              :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        ind2                              :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        valmin                            :   OUT   std_logic_vector(11 DOWNTO 0);  -- sfix12
        indmin                            :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
        );
END rightminop3;


ARCHITECTURE rtl OF rightminop3 IS

  -- Signals
  SIGNAL val1_signed                      : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay2_out1                      : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL val2_signed                      : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay3_out1                      : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Relational_Operator_relop1       : std_logic;
  SIGNAL Multiport_Switch_out1            : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay_out1                       : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL ind2_unsigned                    : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay5_out1                      : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL ind1_unsigned                    : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay4_out1                      : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Multiport_Switch1_out1           : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Delay1_out1                      : unsigned(9 DOWNTO 0);  -- ufix10

BEGIN
  val1_signed <= signed(val1);

  Delay2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay2_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay2_out1 <= val1_signed;
      END IF;
    END IF;
  END PROCESS Delay2_process;


  val2_signed <= signed(val2);

  Delay3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay3_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay3_out1 <= val2_signed;
      END IF;
    END IF;
  END PROCESS Delay3_process;


  
  Relational_Operator_relop1 <= '1' WHEN Delay2_out1 <= Delay3_out1 ELSE
      '0';

  
  Multiport_Switch_out1 <= Delay3_out1 WHEN Relational_Operator_relop1 = '0' ELSE
      Delay2_out1;

  Delay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay_out1 <= Multiport_Switch_out1;
      END IF;
    END IF;
  END PROCESS Delay_process;


  valmin <= std_logic_vector(Delay_out1);

  ind2_unsigned <= unsigned(ind2);

  Delay5_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay5_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        Delay5_out1 <= ind2_unsigned;
      END IF;
    END IF;
  END PROCESS Delay5_process;


  ind1_unsigned <= unsigned(ind1);

  Delay4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay4_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        Delay4_out1 <= ind1_unsigned;
      END IF;
    END IF;
  END PROCESS Delay4_process;


  
  Multiport_Switch1_out1 <= Delay5_out1 WHEN Relational_Operator_relop1 = '0' ELSE
      Delay4_out1;

  Delay1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay1_out1 <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        Delay1_out1 <= Multiport_Switch1_out1;
      END IF;
    END IF;
  END PROCESS Delay1_process;


  indmin <= std_logic_vector(Delay1_out1);

END rtl;

