LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ZeroCrossingFilter IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        In1                               :   IN    std_logic_vector(11 DOWNTO 0);  -- ufix12
        In2                               :   IN    std_logic;
        Out1                              :   OUT   std_logic_vector(30 DOWNTO 0)  -- sfix31_En10
        );
END ZeroCrossingFilter;


ARCHITECTURE rtl OF ZeroCrossingFilter IS

  -- Component Declarations
  COMPONENT Discrete_FIR_Filter
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          Discrete_FIR_Filter_in          :   IN    std_logic_vector(13 DOWNTO 0);  -- sfix14
          Discrete_FIR_Filter_enable      :   IN    std_logic;
          Discrete_FIR_Filter_out         :   OUT   std_logic_vector(30 DOWNTO 0)  -- sfix31_En10
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : Discrete_FIR_Filter
    USE ENTITY work.Discrete_FIR_Filter(rtl);

  -- Signals
  SIGNAL In1_unsigned                     : unsigned(11 DOWNTO 0);  -- ufix12
  SIGNAL Data_Type_Conversion1_out1       : signed(13 DOWNTO 0);  -- sfix14
  SIGNAL outport1                         : std_logic_vector(30 DOWNTO 0);  -- ufix31

BEGIN
  u_Discrete_FIR_Filter : Discrete_FIR_Filter
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              Discrete_FIR_Filter_in => std_logic_vector(Data_Type_Conversion1_out1),  -- sfix14
              Discrete_FIR_Filter_enable => In2,
              Discrete_FIR_Filter_out => outport1  -- sfix31_En10
              );

  In1_unsigned <= unsigned(In1);

  Data_Type_Conversion1_out1 <= signed(resize(In1_unsigned, 14));

  Out1 <= outport1;

END rtl;

