LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY HistCore_block IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        dataIn                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        resetRAM                          :   IN    std_logic;
        cmptHist                          :   IN    std_logic;
        readOut                           :   IN    std_logic;
        rstwaddr                          :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        binaddr                           :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        histVal                           :   OUT   std_logic_vector(5 DOWNTO 0);  -- ufix6
        readRDY                           :   OUT   std_logic
        );
END HistCore_block;


ARCHITECTURE rtl OF HistCore_block IS

  -- Component Declarations
  COMPONENT DualPortRAM_generic
    GENERIC( AddrWidth                    : integer;
             DataWidth                    : integer
             );
    PORT( clk                             :   IN    std_logic;
          enb                             :   IN    std_logic;
          wr_din                          :   IN    std_logic_vector(DataWidth - 1 DOWNTO 0);  -- generic width
          wr_addr                         :   IN    std_logic_vector(AddrWidth - 1 DOWNTO 0);  -- generic width
          wr_en                           :   IN    std_logic;
          rd_addr                         :   IN    std_logic_vector(AddrWidth - 1 DOWNTO 0);  -- generic width
          wr_dout                         :   OUT   std_logic_vector(DataWidth - 1 DOWNTO 0);  -- generic width
          rd_dout                         :   OUT   std_logic_vector(DataWidth - 1 DOWNTO 0)  -- generic width
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : DualPortRAM_generic
    USE ENTITY work.DualPortRAM_generic(rtl);

  -- Signals
  SIGNAL vdataSel                         : std_logic;
  SIGNAL finaldataSel                     : std_logic;
  SIGNAL constZero                        : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL dataIn_unsigned                  : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL histwaddr                        : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL rstwaddr_unsigned                : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL waddr                            : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL binaddr_unsigned                 : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL raddr                            : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL relop_relop1                     : std_logic;
  SIGNAL cmptHistReg                      : std_logic;
  SIGNAL firsthvalSel                     : std_logic;
  SIGNAL firsthvalSelReg                  : std_logic;
  SIGNAL relop_relop1_1                   : std_logic;
  SIGNAL repeatpixelReg                   : std_logic;
  SIGNAL constOne                         : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL wenb                             : std_logic;
  SIGNAL wdout                            : std_logic_vector(5 DOWNTO 0);  -- ufix6
  SIGNAL wdout_unsigned                   : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL rdout_unsigned                   : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL oldhist                          : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL adder_add_temp                   : unsigned(6 DOWNTO 0);  -- ufix7
  SIGNAL newhist                          : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL wdata                            : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL rdout                            : std_logic_vector(5 DOWNTO 0);  -- ufix6
  SIGNAL vldhistVal                       : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL dataOut                          : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL histVal_tmp                      : unsigned(5 DOWNTO 0);  -- ufix6

BEGIN
  u_HistMemory_generic : DualPortRAM_generic
    GENERIC MAP( AddrWidth => 10,
                 DataWidth => 6
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => std_logic_vector(wdata),
              wr_addr => std_logic_vector(waddr),
              wr_en => wenb,
              rd_addr => std_logic_vector(raddr),
              wr_dout => wdout,
              rd_dout => rdout
              );

  reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        vdataSel <= '0';
      ELSIF enb = '1' THEN
        vdataSel <= readOut;
      END IF;
    END IF;
  END PROCESS reg_process;


  alpha1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        finaldataSel <= '0';
      ELSIF enb = '1' THEN
        finaldataSel <= vdataSel;
      END IF;
    END IF;
  END PROCESS alpha1_process;


  constZero <= to_unsigned(16#00#, 6);

  dataIn_unsigned <= unsigned(dataIn);

  reg_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        histwaddr <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        histwaddr <= dataIn_unsigned;
      END IF;
    END IF;
  END PROCESS reg_1_process;


  rstwaddr_unsigned <= unsigned(rstwaddr);

  -- memory write address
  
  waddr <= histwaddr WHEN resetRAM = '0' ELSE
      rstwaddr_unsigned;

  binaddr_unsigned <= unsigned(binaddr);

  -- memory read address
  
  raddr <= dataIn_unsigned WHEN vdataSel = '0' ELSE
      binaddr_unsigned;

  
  relop_relop1 <= '1' WHEN waddr = raddr ELSE
      '0';

  reg_2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        cmptHistReg <= '0';
      ELSIF enb = '1' THEN
        cmptHistReg <= cmptHist;
      END IF;
    END IF;
  END PROCESS reg_2_process;


  firsthvalSel <= vdataSel AND (relop_relop1 AND cmptHistReg);

  reg_3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        firsthvalSelReg <= '0';
      ELSIF enb = '1' THEN
        firsthvalSelReg <= firsthvalSel;
      END IF;
    END IF;
  END PROCESS reg_3_process;


  -- handle repeated pixel values
  
  relop_relop1_1 <= '1' WHEN dataIn_unsigned = histwaddr ELSE
      '0';

  reg_4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        repeatpixelReg <= '0';
      ELSIF enb = '1' THEN
        repeatpixelReg <= relop_relop1_1;
      END IF;
    END IF;
  END PROCESS reg_4_process;


  constOne <= to_unsigned(16#01#, 6);

  wenb <= cmptHistReg OR resetRAM;

  wdout_unsigned <= unsigned(wdout);

  
  oldhist <= rdout_unsigned WHEN repeatpixelReg = '0' ELSE
      wdout_unsigned;

  -- update histogram value
  adder_add_temp <= resize(oldhist, 7) + resize(constOne, 7);
  
  newhist <= "111111" WHEN adder_add_temp(6) /= '0' ELSE
      adder_add_temp(5 DOWNTO 0);

  -- memory write data
  
  wdata <= newhist WHEN resetRAM = '0' ELSE
      constZero;

  rdout_unsigned <= unsigned(rdout);

  
  vldhistVal <= rdout_unsigned WHEN firsthvalSelReg = '0' ELSE
      wdout_unsigned;

  
  dataOut <= constZero WHEN finaldataSel = '0' ELSE
      vldhistVal;

  -- output registers
  intdelay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        histVal_tmp <= to_unsigned(16#00#, 6);
      ELSIF enb = '1' THEN
        histVal_tmp <= dataOut;
      END IF;
    END IF;
  END PROCESS intdelay_process;


  histVal <= std_logic_vector(histVal_tmp);

  
  readRDY <= '1' WHEN vdataSel /= '0' ELSE
      '0';

END rtl;

