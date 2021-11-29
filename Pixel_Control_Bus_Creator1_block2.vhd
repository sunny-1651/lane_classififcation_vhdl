LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Pixel_Control_Bus_Creator1_block2 IS
  PORT( In1                               :   IN    std_logic;
        In2                               :   IN    std_logic;
        In3                               :   IN    std_logic;
        In4                               :   IN    std_logic;
        In5                               :   IN    std_logic;
        Out1_hStart                       :   OUT   std_logic;
        Out1_hEnd                         :   OUT   std_logic;
        Out1_vStart                       :   OUT   std_logic;
        Out1_vEnd                         :   OUT   std_logic;
        Out1_valid                        :   OUT   std_logic
        );
END Pixel_Control_Bus_Creator1_block2;


ARCHITECTURE rtl OF Pixel_Control_Bus_Creator1_block2 IS

BEGIN
  Out1_hStart <= In1;

  Out1_hEnd <= In2;

  Out1_vStart <= In3;

  Out1_vEnd <= In4;

  Out1_valid <= In5;

END rtl;

