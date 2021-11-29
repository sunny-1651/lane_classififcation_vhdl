LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY LineBuffer_block IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        pixel                             :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        pushIn                            :   IN    std_logic;
        readAddress                       :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16
        FrameEnd                          :   IN    std_logic;
        pixelOut                          :   OUT   std_logic_vector(7 DOWNTO 0)  -- uint8
        );
END LineBuffer_block;


ARCHITECTURE rtl OF LineBuffer_block IS

  -- Component Declarations
  COMPONENT SimpleDualPortRAM_generic
    GENERIC( AddrWidth                    : integer;
             DataWidth                    : integer
             );
    PORT( clk                             :   IN    std_logic;
          enb                             :   IN    std_logic;
          wr_din                          :   IN    std_logic_vector(DataWidth - 1 DOWNTO 0);  -- generic width
          wr_addr                         :   IN    std_logic_vector(AddrWidth - 1 DOWNTO 0);  -- generic width
          wr_en                           :   IN    std_logic;
          rd_addr                         :   IN    std_logic_vector(AddrWidth - 1 DOWNTO 0);  -- generic width
          rd_dout                         :   OUT   std_logic_vector(DataWidth - 1 DOWNTO 0)  -- generic width
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : SimpleDualPortRAM_generic
    USE ENTITY work.SimpleDualPortRAM_generic(rtl);

  -- Signals
  SIGNAL WriteCount                       : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL pixelOut_tmp                     : std_logic_vector(7 DOWNTO 0);  -- ufix8

BEGIN
  u_simpleDualPortRam_generic : SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 16,
                 DataWidth => 8
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => pixel,
              wr_addr => std_logic_vector(WriteCount),
              wr_en => pushIn,
              rd_addr => readAddress,
              rd_dout => pixelOut_tmp
              );

  -- Free running, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  Write_Count_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        WriteCount <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' THEN
        IF FrameEnd = '1' THEN 
          WriteCount <= to_unsigned(16#0000#, 16);
        ELSIF pushIn = '1' THEN 
          WriteCount <= WriteCount + to_unsigned(16#0001#, 16);
        END IF;
      END IF;
    END IF;
  END PROCESS Write_Count_process;


  pixelOut <= pixelOut_tmp;

END rtl;

