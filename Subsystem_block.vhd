LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Subsystem_block IS
  PORT( Out1_hStart                       :   OUT   std_logic;
        Out1_hEnd                         :   OUT   std_logic;
        Out1_vStart                       :   OUT   std_logic;
        Out1_vEnd                         :   OUT   std_logic;
        Out1_valid                        :   OUT   std_logic
        );
END Subsystem_block;


ARCHITECTURE rtl OF Subsystem_block IS

  -- Component Declarations
  COMPONENT Pixel_Control_Bus_Creator1_block1
    PORT( In1                             :   IN    std_logic;
          In2                             :   IN    std_logic;
          In3                             :   IN    std_logic;
          In4                             :   IN    std_logic;
          In5                             :   IN    std_logic;
          Out1_hStart                     :   OUT   std_logic;
          Out1_hEnd                       :   OUT   std_logic;
          Out1_vStart                     :   OUT   std_logic;
          Out1_vEnd                       :   OUT   std_logic;
          Out1_valid                      :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : Pixel_Control_Bus_Creator1_block1
    USE ENTITY work.Pixel_Control_Bus_Creator1_block1(rtl);

  -- Signals
  SIGNAL Constant_out1                    : std_logic;
  SIGNAL Constant1_out1                   : std_logic;
  SIGNAL Constant2_out1                   : std_logic;
  SIGNAL Constant3_out1                   : std_logic;
  SIGNAL Constant4_out1                   : std_logic;
  SIGNAL Pixel_Control_Bus_Creator1_out1_hStart : std_logic;
  SIGNAL Pixel_Control_Bus_Creator1_out1_hEnd : std_logic;
  SIGNAL Pixel_Control_Bus_Creator1_out1_vStart : std_logic;
  SIGNAL Pixel_Control_Bus_Creator1_out1_vEnd : std_logic;
  SIGNAL Pixel_Control_Bus_Creator1_out1_valid : std_logic;

BEGIN
  u_Pixel_Control_Bus_Creator1 : Pixel_Control_Bus_Creator1_block1
    PORT MAP( In1 => Constant_out1,
              In2 => Constant1_out1,
              In3 => Constant2_out1,
              In4 => Constant3_out1,
              In5 => Constant4_out1,
              Out1_hStart => Pixel_Control_Bus_Creator1_out1_hStart,
              Out1_hEnd => Pixel_Control_Bus_Creator1_out1_hEnd,
              Out1_vStart => Pixel_Control_Bus_Creator1_out1_vStart,
              Out1_vEnd => Pixel_Control_Bus_Creator1_out1_vEnd,
              Out1_valid => Pixel_Control_Bus_Creator1_out1_valid
              );

  Constant_out1 <= '0';

  Constant1_out1 <= '0';

  Constant2_out1 <= '0';

  Constant3_out1 <= '0';

  Constant4_out1 <= '0';

  Out1_hStart <= Pixel_Control_Bus_Creator1_out1_hStart;

  Out1_hEnd <= Pixel_Control_Bus_Creator1_out1_hEnd;

  Out1_vStart <= Pixel_Control_Bus_Creator1_out1_vStart;

  Out1_vEnd <= Pixel_Control_Bus_Creator1_out1_vEnd;

  Out1_valid <= Pixel_Control_Bus_Creator1_out1_valid;

END rtl;

