LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.HDLLaneDetector_pkg.ALL;

ENTITY DATA_MEMORY IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        Unloading                         :   IN    std_logic;
        pixelIn                           :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        hStartIn                          :   IN    std_logic;
        hEndIn                            :   IN    std_logic;
        validIn                           :   IN    std_logic;
        popEn                             :   IN    std_logic_vector(7 DOWNTO 0);  -- ufix8
        dataVectorOut                     :   OUT   vector_of_std_logic_vector8(0 TO 15);  -- uint8 [16]
        popOut                            :   OUT   std_logic;
        AllAtEnd                          :   OUT   std_logic
        );
END DATA_MEMORY;


ARCHITECTURE rtl OF DATA_MEMORY IS

  -- Component Declarations
  COMPONENT PushPopCounterOne
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          hStartIn                        :   IN    std_logic;
          popIn                           :   IN    std_logic;
          popEnable                       :   IN    std_logic;
          hEndIn                          :   IN    std_logic;
          wrAddr                          :   OUT   std_logic_vector(10 DOWNTO 0);  -- ufix11
          pushOut                         :   OUT   std_logic;
          rdAddr                          :   OUT   std_logic_vector(10 DOWNTO 0);  -- ufix11
          popOut                          :   OUT   std_logic;
          EndofLine                       :   OUT   std_logic
          );
  END COMPONENT;

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

  COMPONENT PushPopCounter
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          hStartIn                        :   IN    std_logic;
          popIn                           :   IN    std_logic;
          popEnable                       :   IN    std_logic;
          hEndIn                          :   IN    std_logic;
          writeCountPrev                  :   IN    std_logic_vector(10 DOWNTO 0);  -- ufix11
          wrAddr                          :   OUT   std_logic_vector(10 DOWNTO 0);  -- ufix11
          pushOut                         :   OUT   std_logic;
          rdAddr                          :   OUT   std_logic_vector(10 DOWNTO 0);  -- ufix11
          popOut                          :   OUT   std_logic;
          EndofLine                       :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : PushPopCounterOne
    USE ENTITY work.PushPopCounterOne(rtl);

  FOR ALL : SimpleDualPortRAM_generic
    USE ENTITY work.SimpleDualPortRAM_generic(rtl);

  FOR ALL : PushPopCounter
    USE ENTITY work.PushPopCounter(rtl);

  -- Signals
  SIGNAL pixelIn_unsigned                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL intdelay_reg                     : vector_of_unsigned8(0 TO 3);  -- ufix8 [4]
  SIGNAL pixelColumn_0                    : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL validREG                         : std_logic;
  SIGNAL unloadPop                        : std_logic;
  SIGNAL hEndREG                          : std_logic;
  SIGNAL hEndREGT                         : std_logic;
  SIGNAL unloadPopT                       : std_logic;
  SIGNAL validPop                         : std_logic;
  SIGNAL popEn_unsigned                   : unsigned(7 DOWNTO 0);  -- ufix8
  SIGNAL PopEnSL                          : std_logic;
  SIGNAL writeAddr1                       : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL pushFIFO2                        : std_logic;
  SIGNAL readAddr2                        : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL popFIFO_2                        : std_logic;
  SIGNAL EndofLine1                       : std_logic;
  SIGNAL writeAddr1_unsigned              : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL writeAddrREG1                    : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL pushOutREG1                      : std_logic;
  SIGNAL pixelColumn1                     : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL PopEnSL_1                        : std_logic;
  SIGNAL writeAddr2                       : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL pushFIFO3                        : std_logic;
  SIGNAL readAddr3                        : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL popFIFO_3                        : std_logic;
  SIGNAL EndofLine2                       : std_logic;
  SIGNAL writeAddr2_unsigned              : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL writeAddrREG2                    : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL pushOutREG2                      : std_logic;
  SIGNAL pixelColumn2                     : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL PopEnSL_2                        : std_logic;
  SIGNAL writeAddr3                       : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL pushFIFO4                        : std_logic;
  SIGNAL readAddr4                        : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL popFIFO_4                        : std_logic;
  SIGNAL EndofLine3                       : std_logic;
  SIGNAL writeAddr3_unsigned              : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL writeAddrREG3                    : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL pushOutREG3                      : std_logic;
  SIGNAL pixelColumn3                     : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL PopEnSL_3                        : std_logic;
  SIGNAL writeAddr4                       : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL pushFIFO5                        : std_logic;
  SIGNAL readAddr5                        : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL popFIFO_5                        : std_logic;
  SIGNAL EndofLine4                       : std_logic;
  SIGNAL writeAddr4_unsigned              : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL writeAddrREG4                    : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL pushOutREG4                      : std_logic;
  SIGNAL pixelColumn4                     : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL PopEnSL_4                        : std_logic;
  SIGNAL writeAddr5                       : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL pushFIFO6                        : std_logic;
  SIGNAL readAddr6                        : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL popFIFO_6                        : std_logic;
  SIGNAL EndofLine5                       : std_logic;
  SIGNAL writeAddr5_unsigned              : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL writeAddrREG5                    : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL pushOutREG5                      : std_logic;
  SIGNAL pixelColumn5                     : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL PopEnSL_5                        : std_logic;
  SIGNAL writeAddr6                       : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL pushFIFO7                        : std_logic;
  SIGNAL readAddr7                        : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL popFIFO_7                        : std_logic;
  SIGNAL EndofLine6                       : std_logic;
  SIGNAL writeAddr6_unsigned              : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL writeAddrREG6                    : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL pushOutREG6                      : std_logic;
  SIGNAL pixelColumn6                     : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL PopEnSL_6                        : std_logic;
  SIGNAL writeAddr7                       : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL pushFIFO8                        : std_logic;
  SIGNAL readAddr8                        : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL popFIFO_8                        : std_logic;
  SIGNAL EndofLine7                       : std_logic;
  SIGNAL writeAddr7_unsigned              : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL writeAddrREG7                    : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL pushOutREG7                      : std_logic;
  SIGNAL pixelColumn7                     : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL PopEnSL_7                        : std_logic;
  SIGNAL writeAddr8                       : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL pushFIFO9                        : std_logic;
  SIGNAL readAddr9                        : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL popFIFO_9                        : std_logic;
  SIGNAL EndofLine8                       : std_logic;
  SIGNAL writeAddr8_unsigned              : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL writeAddrREG8                    : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL pushOutREG8                      : std_logic;
  SIGNAL pixelColumn8                     : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL PopEnSL_8                        : std_logic;
  SIGNAL writeAddr9                       : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL pushFIFO10                       : std_logic;
  SIGNAL readAddr10                       : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL popFIFO_10                       : std_logic;
  SIGNAL EndofLine9                       : std_logic;
  SIGNAL writeAddr9_unsigned              : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL writeAddrREG9                    : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL pushOutREG9                      : std_logic;
  SIGNAL pixelColumn9                     : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL PopEnSL_9                        : std_logic;
  SIGNAL writeAddr10                      : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL pushFIFO11                       : std_logic;
  SIGNAL readAddr11                       : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL popFIFO_11                       : std_logic;
  SIGNAL EndofLine10                      : std_logic;
  SIGNAL writeAddr10_unsigned             : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL writeAddrREG10                   : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL pushOutREG10                     : std_logic;
  SIGNAL pixelColumn10                    : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL PopEnSL_10                       : std_logic;
  SIGNAL writeAddr11                      : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL pushFIFO12                       : std_logic;
  SIGNAL readAddr12                       : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL popFIFO_12                       : std_logic;
  SIGNAL EndofLine11                      : std_logic;
  SIGNAL writeAddr11_unsigned             : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL writeAddrREG11                   : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL pushOutREG11                     : std_logic;
  SIGNAL pixelColumn11                    : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL PopEnSL_11                       : std_logic;
  SIGNAL writeAddr12                      : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL pushFIFO13                       : std_logic;
  SIGNAL readAddr13                       : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL popFIFO_13                       : std_logic;
  SIGNAL EndofLine12                      : std_logic;
  SIGNAL writeAddr12_unsigned             : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL writeAddrREG12                   : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL pushOutREG12                     : std_logic;
  SIGNAL pixelColumn12                    : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL PopEnSL_12                       : std_logic;
  SIGNAL writeAddr13                      : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL pushFIFO14                       : std_logic;
  SIGNAL readAddr14                       : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL popFIFO_14                       : std_logic;
  SIGNAL EndofLine13                      : std_logic;
  SIGNAL writeAddr13_unsigned             : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL writeAddrREG13                   : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL pushOutREG13                     : std_logic;
  SIGNAL pixelColumn13                    : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL PopEnSL_13                       : std_logic;
  SIGNAL writeAddr14                      : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL pushFIFO15                       : std_logic;
  SIGNAL readAddr15                       : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL popFIFO_15                       : std_logic;
  SIGNAL EndofLine14                      : std_logic;
  SIGNAL writeAddr14_unsigned             : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL writeAddrREG14                   : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL pushOutREG14                     : std_logic;
  SIGNAL pixelColumn14                    : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL PopEnSL_14                       : std_logic;
  SIGNAL writeAddr15                      : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL pushFIFO16                       : std_logic;
  SIGNAL readAddr16                       : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL popFIFO_16                       : std_logic;
  SIGNAL EndofLine15                      : std_logic;
  SIGNAL writeAddr15_unsigned             : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL writeAddrREG15                   : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL pushOutREG15                     : std_logic;
  SIGNAL pixelColumn15                    : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL dataVecInt                       : vector_of_unsigned8(0 TO 15);  -- uint8 [16]

BEGIN
  u_PushPopCounterOne : PushPopCounterOne
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              hStartIn => hStartIn,
              popIn => validPop,
              popEnable => PopEnSL,
              hEndIn => hEndREG,
              wrAddr => writeAddr1,  -- ufix11
              pushOut => pushFIFO2,
              rdAddr => readAddr2,  -- ufix11
              popOut => popFIFO_2,
              EndofLine => EndofLine1
              );

  u_SimpleDualPortRAM_Generic1 : SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 11,
                 DataWidth => 8
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => std_logic_vector(pixelColumn_0),
              wr_addr => std_logic_vector(writeAddrREG1),
              wr_en => pushOutREG1,
              rd_addr => readAddr2,
              rd_dout => pixelColumn1
              );

  u_PushPopCounter2 : PushPopCounter
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              hStartIn => hStartIn,
              popIn => validPop,
              popEnable => PopEnSL_1,
              hEndIn => hEndREG,
              writeCountPrev => writeAddr1,  -- ufix11
              wrAddr => writeAddr2,  -- ufix11
              pushOut => pushFIFO3,
              rdAddr => readAddr3,  -- ufix11
              popOut => popFIFO_3,
              EndofLine => EndofLine2
              );

  u_SimpleDualPortRAM_Generic2 : SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 11,
                 DataWidth => 8
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => pixelColumn1,
              wr_addr => std_logic_vector(writeAddrREG2),
              wr_en => pushOutREG2,
              rd_addr => readAddr3,
              rd_dout => pixelColumn2
              );

  u_PushPopCounter3 : PushPopCounter
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              hStartIn => hStartIn,
              popIn => validPop,
              popEnable => PopEnSL_2,
              hEndIn => hEndREG,
              writeCountPrev => writeAddr2,  -- ufix11
              wrAddr => writeAddr3,  -- ufix11
              pushOut => pushFIFO4,
              rdAddr => readAddr4,  -- ufix11
              popOut => popFIFO_4,
              EndofLine => EndofLine3
              );

  u_SimpleDualPortRAM_Generic3 : SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 11,
                 DataWidth => 8
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => pixelColumn2,
              wr_addr => std_logic_vector(writeAddrREG3),
              wr_en => pushOutREG3,
              rd_addr => readAddr4,
              rd_dout => pixelColumn3
              );

  u_PushPopCounter4 : PushPopCounter
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              hStartIn => hStartIn,
              popIn => validPop,
              popEnable => PopEnSL_3,
              hEndIn => hEndREG,
              writeCountPrev => writeAddr3,  -- ufix11
              wrAddr => writeAddr4,  -- ufix11
              pushOut => pushFIFO5,
              rdAddr => readAddr5,  -- ufix11
              popOut => popFIFO_5,
              EndofLine => EndofLine4
              );

  u_SimpleDualPortRAM_Generic4 : SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 11,
                 DataWidth => 8
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => pixelColumn3,
              wr_addr => std_logic_vector(writeAddrREG4),
              wr_en => pushOutREG4,
              rd_addr => readAddr5,
              rd_dout => pixelColumn4
              );

  u_PushPopCounter5 : PushPopCounter
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              hStartIn => hStartIn,
              popIn => validPop,
              popEnable => PopEnSL_4,
              hEndIn => hEndREG,
              writeCountPrev => writeAddr4,  -- ufix11
              wrAddr => writeAddr5,  -- ufix11
              pushOut => pushFIFO6,
              rdAddr => readAddr6,  -- ufix11
              popOut => popFIFO_6,
              EndofLine => EndofLine5
              );

  u_SimpleDualPortRAM_Generic5 : SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 11,
                 DataWidth => 8
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => pixelColumn4,
              wr_addr => std_logic_vector(writeAddrREG5),
              wr_en => pushOutREG5,
              rd_addr => readAddr6,
              rd_dout => pixelColumn5
              );

  u_PushPopCounter6 : PushPopCounter
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              hStartIn => hStartIn,
              popIn => validPop,
              popEnable => PopEnSL_5,
              hEndIn => hEndREG,
              writeCountPrev => writeAddr5,  -- ufix11
              wrAddr => writeAddr6,  -- ufix11
              pushOut => pushFIFO7,
              rdAddr => readAddr7,  -- ufix11
              popOut => popFIFO_7,
              EndofLine => EndofLine6
              );

  u_SimpleDualPortRAM_Generic6 : SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 11,
                 DataWidth => 8
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => pixelColumn5,
              wr_addr => std_logic_vector(writeAddrREG6),
              wr_en => pushOutREG6,
              rd_addr => readAddr7,
              rd_dout => pixelColumn6
              );

  u_PushPopCounter7 : PushPopCounter
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              hStartIn => hStartIn,
              popIn => validPop,
              popEnable => PopEnSL_6,
              hEndIn => hEndREG,
              writeCountPrev => writeAddr6,  -- ufix11
              wrAddr => writeAddr7,  -- ufix11
              pushOut => pushFIFO8,
              rdAddr => readAddr8,  -- ufix11
              popOut => popFIFO_8,
              EndofLine => EndofLine7
              );

  u_SimpleDualPortRAM_Generic7 : SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 11,
                 DataWidth => 8
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => pixelColumn6,
              wr_addr => std_logic_vector(writeAddrREG7),
              wr_en => pushOutREG7,
              rd_addr => readAddr8,
              rd_dout => pixelColumn7
              );

  u_PushPopCounter8 : PushPopCounter
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              hStartIn => hStartIn,
              popIn => validPop,
              popEnable => PopEnSL_7,
              hEndIn => hEndREG,
              writeCountPrev => writeAddr7,  -- ufix11
              wrAddr => writeAddr8,  -- ufix11
              pushOut => pushFIFO9,
              rdAddr => readAddr9,  -- ufix11
              popOut => popFIFO_9,
              EndofLine => EndofLine8
              );

  u_SimpleDualPortRAM_Generic8 : SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 11,
                 DataWidth => 8
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => pixelColumn7,
              wr_addr => std_logic_vector(writeAddrREG8),
              wr_en => pushOutREG8,
              rd_addr => readAddr9,
              rd_dout => pixelColumn8
              );

  u_PushPopCounter9 : PushPopCounter
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              hStartIn => hStartIn,
              popIn => validPop,
              popEnable => PopEnSL_8,
              hEndIn => hEndREG,
              writeCountPrev => writeAddr8,  -- ufix11
              wrAddr => writeAddr9,  -- ufix11
              pushOut => pushFIFO10,
              rdAddr => readAddr10,  -- ufix11
              popOut => popFIFO_10,
              EndofLine => EndofLine9
              );

  u_SimpleDualPortRAM_Generic9 : SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 11,
                 DataWidth => 8
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => pixelColumn8,
              wr_addr => std_logic_vector(writeAddrREG9),
              wr_en => pushOutREG9,
              rd_addr => readAddr10,
              rd_dout => pixelColumn9
              );

  u_PushPopCounter10 : PushPopCounter
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              hStartIn => hStartIn,
              popIn => validPop,
              popEnable => PopEnSL_9,
              hEndIn => hEndREG,
              writeCountPrev => writeAddr9,  -- ufix11
              wrAddr => writeAddr10,  -- ufix11
              pushOut => pushFIFO11,
              rdAddr => readAddr11,  -- ufix11
              popOut => popFIFO_11,
              EndofLine => EndofLine10
              );

  u_SimpleDualPortRAM_Generic10 : SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 11,
                 DataWidth => 8
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => pixelColumn9,
              wr_addr => std_logic_vector(writeAddrREG10),
              wr_en => pushOutREG10,
              rd_addr => readAddr11,
              rd_dout => pixelColumn10
              );

  u_PushPopCounter11 : PushPopCounter
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              hStartIn => hStartIn,
              popIn => validPop,
              popEnable => PopEnSL_10,
              hEndIn => hEndREG,
              writeCountPrev => writeAddr10,  -- ufix11
              wrAddr => writeAddr11,  -- ufix11
              pushOut => pushFIFO12,
              rdAddr => readAddr12,  -- ufix11
              popOut => popFIFO_12,
              EndofLine => EndofLine11
              );

  u_SimpleDualPortRAM_Generic11 : SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 11,
                 DataWidth => 8
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => pixelColumn10,
              wr_addr => std_logic_vector(writeAddrREG11),
              wr_en => pushOutREG11,
              rd_addr => readAddr12,
              rd_dout => pixelColumn11
              );

  u_PushPopCounter12 : PushPopCounter
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              hStartIn => hStartIn,
              popIn => validPop,
              popEnable => PopEnSL_11,
              hEndIn => hEndREG,
              writeCountPrev => writeAddr11,  -- ufix11
              wrAddr => writeAddr12,  -- ufix11
              pushOut => pushFIFO13,
              rdAddr => readAddr13,  -- ufix11
              popOut => popFIFO_13,
              EndofLine => EndofLine12
              );

  u_SimpleDualPortRAM_Generic12 : SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 11,
                 DataWidth => 8
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => pixelColumn11,
              wr_addr => std_logic_vector(writeAddrREG12),
              wr_en => pushOutREG12,
              rd_addr => readAddr13,
              rd_dout => pixelColumn12
              );

  u_PushPopCounter13 : PushPopCounter
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              hStartIn => hStartIn,
              popIn => validPop,
              popEnable => PopEnSL_12,
              hEndIn => hEndREG,
              writeCountPrev => writeAddr12,  -- ufix11
              wrAddr => writeAddr13,  -- ufix11
              pushOut => pushFIFO14,
              rdAddr => readAddr14,  -- ufix11
              popOut => popFIFO_14,
              EndofLine => EndofLine13
              );

  u_SimpleDualPortRAM_Generic13 : SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 11,
                 DataWidth => 8
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => pixelColumn12,
              wr_addr => std_logic_vector(writeAddrREG13),
              wr_en => pushOutREG13,
              rd_addr => readAddr14,
              rd_dout => pixelColumn13
              );

  u_PushPopCounter14 : PushPopCounter
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              hStartIn => hStartIn,
              popIn => validPop,
              popEnable => PopEnSL_13,
              hEndIn => hEndREG,
              writeCountPrev => writeAddr13,  -- ufix11
              wrAddr => writeAddr14,  -- ufix11
              pushOut => pushFIFO15,
              rdAddr => readAddr15,  -- ufix11
              popOut => popFIFO_15,
              EndofLine => EndofLine14
              );

  u_SimpleDualPortRAM_Generic14 : SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 11,
                 DataWidth => 8
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => pixelColumn13,
              wr_addr => std_logic_vector(writeAddrREG14),
              wr_en => pushOutREG14,
              rd_addr => readAddr15,
              rd_dout => pixelColumn14
              );

  u_PushPopCounter15 : PushPopCounter
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              hStartIn => hStartIn,
              popIn => validPop,
              popEnable => PopEnSL_14,
              hEndIn => hEndREG,
              writeCountPrev => writeAddr14,  -- ufix11
              wrAddr => writeAddr15,  -- ufix11
              pushOut => pushFIFO16,
              rdAddr => readAddr16,  -- ufix11
              popOut => popFIFO_16,
              EndofLine => EndofLine15
              );

  u_SimpleDualPortRAM_Generic15 : SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 11,
                 DataWidth => 8
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => pixelColumn14,
              wr_addr => std_logic_vector(writeAddrREG15),
              wr_en => pushOutREG15,
              rd_addr => readAddr16,
              rd_dout => pixelColumn15
              );

  pixelIn_unsigned <= unsigned(pixelIn);

  intdelay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg <= (OTHERS => to_unsigned(16#00#, 8));
      ELSIF enb = '1' THEN
        intdelay_reg(0) <= pixelIn_unsigned;
        intdelay_reg(1 TO 3) <= intdelay_reg(0 TO 2);
      END IF;
    END IF;
  END PROCESS intdelay_process;

  pixelColumn_0 <= intdelay_reg(3);

  reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        validREG <= '0';
      ELSIF enb = '1' THEN
        validREG <= validIn;
      END IF;
    END IF;
  END PROCESS reg_process;


  reg_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        unloadPop <= '0';
      ELSIF enb = '1' THEN
        unloadPop <= validREG;
      END IF;
    END IF;
  END PROCESS reg_1_process;


  reg_2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        hEndREG <= '0';
      ELSIF enb = '1' THEN
        hEndREG <= hEndIn;
      END IF;
    END IF;
  END PROCESS reg_2_process;


  reg_3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        hEndREGT <= '0';
      ELSIF enb = '1' THEN
        hEndREGT <= hEndREG;
      END IF;
    END IF;
  END PROCESS reg_3_process;


  unloadPopT <= hEndREGT AND (unloadPop AND Unloading);

  validPop <= validREG OR unloadPopT;

  popEn_unsigned <= unsigned(popEn);

  PopEnSL <= popEn_unsigned(0);

  writeAddr1_unsigned <= unsigned(writeAddr1);

  reg_4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        writeAddrREG1 <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' THEN
        writeAddrREG1 <= writeAddr1_unsigned;
      END IF;
    END IF;
  END PROCESS reg_4_process;


  reg_5_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        pushOutREG1 <= '0';
      ELSIF enb = '1' THEN
        pushOutREG1 <= pushFIFO2;
      END IF;
    END IF;
  END PROCESS reg_5_process;


  PopEnSL_1 <= popEn_unsigned(1);

  writeAddr2_unsigned <= unsigned(writeAddr2);

  reg_6_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        writeAddrREG2 <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' THEN
        writeAddrREG2 <= writeAddr2_unsigned;
      END IF;
    END IF;
  END PROCESS reg_6_process;


  reg_7_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        pushOutREG2 <= '0';
      ELSIF enb = '1' THEN
        pushOutREG2 <= pushFIFO3;
      END IF;
    END IF;
  END PROCESS reg_7_process;


  PopEnSL_2 <= popEn_unsigned(2);

  writeAddr3_unsigned <= unsigned(writeAddr3);

  reg_8_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        writeAddrREG3 <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' THEN
        writeAddrREG3 <= writeAddr3_unsigned;
      END IF;
    END IF;
  END PROCESS reg_8_process;


  reg_9_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        pushOutREG3 <= '0';
      ELSIF enb = '1' THEN
        pushOutREG3 <= pushFIFO4;
      END IF;
    END IF;
  END PROCESS reg_9_process;


  PopEnSL_3 <= popEn_unsigned(3);

  writeAddr4_unsigned <= unsigned(writeAddr4);

  reg_10_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        writeAddrREG4 <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' THEN
        writeAddrREG4 <= writeAddr4_unsigned;
      END IF;
    END IF;
  END PROCESS reg_10_process;


  reg_11_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        pushOutREG4 <= '0';
      ELSIF enb = '1' THEN
        pushOutREG4 <= pushFIFO5;
      END IF;
    END IF;
  END PROCESS reg_11_process;


  PopEnSL_4 <= popEn_unsigned(4);

  writeAddr5_unsigned <= unsigned(writeAddr5);

  reg_12_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        writeAddrREG5 <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' THEN
        writeAddrREG5 <= writeAddr5_unsigned;
      END IF;
    END IF;
  END PROCESS reg_12_process;


  reg_13_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        pushOutREG5 <= '0';
      ELSIF enb = '1' THEN
        pushOutREG5 <= pushFIFO6;
      END IF;
    END IF;
  END PROCESS reg_13_process;


  PopEnSL_5 <= popEn_unsigned(5);

  writeAddr6_unsigned <= unsigned(writeAddr6);

  reg_14_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        writeAddrREG6 <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' THEN
        writeAddrREG6 <= writeAddr6_unsigned;
      END IF;
    END IF;
  END PROCESS reg_14_process;


  reg_15_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        pushOutREG6 <= '0';
      ELSIF enb = '1' THEN
        pushOutREG6 <= pushFIFO7;
      END IF;
    END IF;
  END PROCESS reg_15_process;


  PopEnSL_6 <= popEn_unsigned(6);

  writeAddr7_unsigned <= unsigned(writeAddr7);

  reg_16_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        writeAddrREG7 <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' THEN
        writeAddrREG7 <= writeAddr7_unsigned;
      END IF;
    END IF;
  END PROCESS reg_16_process;


  reg_17_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        pushOutREG7 <= '0';
      ELSIF enb = '1' THEN
        pushOutREG7 <= pushFIFO8;
      END IF;
    END IF;
  END PROCESS reg_17_process;


  PopEnSL_7 <= popEn_unsigned(7);

  writeAddr8_unsigned <= unsigned(writeAddr8);

  reg_18_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        writeAddrREG8 <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' THEN
        writeAddrREG8 <= writeAddr8_unsigned;
      END IF;
    END IF;
  END PROCESS reg_18_process;


  reg_19_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        pushOutREG8 <= '0';
      ELSIF enb = '1' THEN
        pushOutREG8 <= pushFIFO9;
      END IF;
    END IF;
  END PROCESS reg_19_process;


  PopEnSL_8 <= popEn_unsigned(7);

  writeAddr9_unsigned <= unsigned(writeAddr9);

  reg_20_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        writeAddrREG9 <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' THEN
        writeAddrREG9 <= writeAddr9_unsigned;
      END IF;
    END IF;
  END PROCESS reg_20_process;


  reg_21_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        pushOutREG9 <= '0';
      ELSIF enb = '1' THEN
        pushOutREG9 <= pushFIFO10;
      END IF;
    END IF;
  END PROCESS reg_21_process;


  PopEnSL_9 <= popEn_unsigned(7);

  writeAddr10_unsigned <= unsigned(writeAddr10);

  reg_22_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        writeAddrREG10 <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' THEN
        writeAddrREG10 <= writeAddr10_unsigned;
      END IF;
    END IF;
  END PROCESS reg_22_process;


  reg_23_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        pushOutREG10 <= '0';
      ELSIF enb = '1' THEN
        pushOutREG10 <= pushFIFO11;
      END IF;
    END IF;
  END PROCESS reg_23_process;


  PopEnSL_10 <= popEn_unsigned(7);

  writeAddr11_unsigned <= unsigned(writeAddr11);

  reg_24_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        writeAddrREG11 <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' THEN
        writeAddrREG11 <= writeAddr11_unsigned;
      END IF;
    END IF;
  END PROCESS reg_24_process;


  reg_25_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        pushOutREG11 <= '0';
      ELSIF enb = '1' THEN
        pushOutREG11 <= pushFIFO12;
      END IF;
    END IF;
  END PROCESS reg_25_process;


  PopEnSL_11 <= popEn_unsigned(7);

  writeAddr12_unsigned <= unsigned(writeAddr12);

  reg_26_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        writeAddrREG12 <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' THEN
        writeAddrREG12 <= writeAddr12_unsigned;
      END IF;
    END IF;
  END PROCESS reg_26_process;


  reg_27_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        pushOutREG12 <= '0';
      ELSIF enb = '1' THEN
        pushOutREG12 <= pushFIFO13;
      END IF;
    END IF;
  END PROCESS reg_27_process;


  PopEnSL_12 <= popEn_unsigned(7);

  writeAddr13_unsigned <= unsigned(writeAddr13);

  reg_28_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        writeAddrREG13 <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' THEN
        writeAddrREG13 <= writeAddr13_unsigned;
      END IF;
    END IF;
  END PROCESS reg_28_process;


  reg_29_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        pushOutREG13 <= '0';
      ELSIF enb = '1' THEN
        pushOutREG13 <= pushFIFO14;
      END IF;
    END IF;
  END PROCESS reg_29_process;


  PopEnSL_13 <= popEn_unsigned(7);

  writeAddr14_unsigned <= unsigned(writeAddr14);

  reg_30_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        writeAddrREG14 <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' THEN
        writeAddrREG14 <= writeAddr14_unsigned;
      END IF;
    END IF;
  END PROCESS reg_30_process;


  reg_31_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        pushOutREG14 <= '0';
      ELSIF enb = '1' THEN
        pushOutREG14 <= pushFIFO15;
      END IF;
    END IF;
  END PROCESS reg_31_process;


  PopEnSL_14 <= popEn_unsigned(7);

  writeAddr15_unsigned <= unsigned(writeAddr15);

  reg_32_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        writeAddrREG15 <= to_unsigned(16#000#, 11);
      ELSIF enb = '1' THEN
        writeAddrREG15 <= writeAddr15_unsigned;
      END IF;
    END IF;
  END PROCESS reg_32_process;


  reg_33_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        pushOutREG15 <= '0';
      ELSIF enb = '1' THEN
        pushOutREG15 <= pushFIFO16;
      END IF;
    END IF;
  END PROCESS reg_33_process;


  dataVecInt(0) <= pixelColumn_0;
  dataVecInt(1) <= unsigned(pixelColumn1);
  dataVecInt(2) <= unsigned(pixelColumn2);
  dataVecInt(3) <= unsigned(pixelColumn3);
  dataVecInt(4) <= unsigned(pixelColumn4);
  dataVecInt(5) <= unsigned(pixelColumn5);
  dataVecInt(6) <= unsigned(pixelColumn6);
  dataVecInt(7) <= unsigned(pixelColumn7);
  dataVecInt(8) <= unsigned(pixelColumn8);
  dataVecInt(9) <= unsigned(pixelColumn9);
  dataVecInt(10) <= unsigned(pixelColumn10);
  dataVecInt(11) <= unsigned(pixelColumn11);
  dataVecInt(12) <= unsigned(pixelColumn12);
  dataVecInt(13) <= unsigned(pixelColumn13);
  dataVecInt(14) <= unsigned(pixelColumn14);
  dataVecInt(15) <= unsigned(pixelColumn15);

  outputgen: FOR k IN 0 TO 15 GENERATE
    dataVectorOut(k) <= std_logic_vector(dataVecInt(k));
  END GENERATE;

  reg_34_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        popOut <= '0';
      ELSIF enb = '1' THEN
        popOut <= popFIFO_2;
      END IF;
    END IF;
  END PROCESS reg_34_process;


  AllAtEnd <= EndofLine15 AND (EndofLine14 AND (EndofLine13 AND (EndofLine12 AND (EndofLine11 AND (EndofLine10 AND (EndofLine9 AND (EndofLine8 AND (EndofLine7 AND (EndofLine6 AND (EndofLine5 AND (EndofLine4 AND (EndofLine3 AND (EndofLine1 AND EndofLine2)))))))))))));

END rtl;

