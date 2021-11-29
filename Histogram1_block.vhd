LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Histogram1_block IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        in0                               :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        in1_hStart                        :   IN    std_logic;
        in1_hEnd                          :   IN    std_logic;
        in1_vStart                        :   IN    std_logic;
        in1_vEnd                          :   IN    std_logic;
        in1_valid                         :   IN    std_logic;
        in2                               :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        in3                               :   IN    std_logic;
        out0                              :   OUT   std_logic_vector(5 DOWNTO 0);  -- ufix6
        out1                              :   OUT   std_logic;
        out2                              :   OUT   std_logic
        );
END Histogram1_block;


ARCHITECTURE rtl OF Histogram1_block IS

  -- Component Declarations
  COMPONENT HistController_block2
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          hstartIn                        :   IN    std_logic;
          hendIn                          :   IN    std_logic;
          vstartIn                        :   IN    std_logic;
          vendIn                          :   IN    std_logic;
          validIn                         :   IN    std_logic;
          binReset                        :   IN    std_logic;
          resetRAM                        :   OUT   std_logic;
          cmptHist                        :   OUT   std_logic;
          readOut                         :   OUT   std_logic;
          waddr                           :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
          );
  END COMPONENT;

  COMPONENT HistCore_block2
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          dataIn                          :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          resetRAM                        :   IN    std_logic;
          cmptHist                        :   IN    std_logic;
          readOut                         :   IN    std_logic;
          rstwaddr                        :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          binaddr                         :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          histVal                         :   OUT   std_logic_vector(5 DOWNTO 0);  -- ufix6
          readRDY                         :   OUT   std_logic;
          validOut                        :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : HistController_block2
    USE ENTITY work.HistController_block2(rtl);

  FOR ALL : HistCore_block2
    USE ENTITY work.HistCore_block2(rtl);

  -- Signals
  SIGNAL in0_unsigned                     : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL dataInReg                        : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL hStartInReg                      : std_logic;
  SIGNAL hendInReg                        : std_logic;
  SIGNAL vendInReg                        : std_logic;
  SIGNAL validInReg                       : std_logic;
  SIGNAL resetRAM                         : std_logic;
  SIGNAL cmptHist                         : std_logic;
  SIGNAL readOut                          : std_logic;
  SIGNAL wraddr                           : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL histVal                          : std_logic_vector(5 DOWNTO 0);  -- ufix6
  SIGNAL readRDY                          : std_logic;
  SIGNAL vldOut                           : std_logic;
  SIGNAL readReady                        : std_logic;
  SIGNAL validOut                         : std_logic;

BEGIN
  u_hctNet_inst : HistController_block2
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              hstartIn => hStartInReg,
              hendIn => hendInReg,
              vstartIn => in1_vStart,
              vendIn => vendInReg,
              validIn => validInReg,
              binReset => in3,
              resetRAM => resetRAM,
              cmptHist => cmptHist,
              readOut => readOut,
              waddr => wraddr  -- ufix10
              );

  u_hcpNet_inst : HistCore_block2
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              dataIn => std_logic_vector(dataInReg),  -- ufix10
              resetRAM => resetRAM,
              cmptHist => cmptHist,
              readOut => readOut,
              rstwaddr => wraddr,  -- ufix10
              binaddr => in2,  -- ufix10
              histVal => histVal,  -- ufix6
              readRDY => readRDY,
              validOut => vldOut
              );

  in0_unsigned <= unsigned(in0);

  reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        dataInReg <= to_unsigned(16#000#, 10);
      ELSIF enb = '1' THEN
        dataInReg <= in0_unsigned;
      END IF;
    END IF;
  END PROCESS reg_process;


  reg_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        hStartInReg <= '0';
      ELSIF enb = '1' THEN
        hStartInReg <= in1_hStart;
      END IF;
    END IF;
  END PROCESS reg_1_process;


  reg_2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        hendInReg <= '0';
      ELSIF enb = '1' THEN
        hendInReg <= in1_hEnd;
      END IF;
    END IF;
  END PROCESS reg_2_process;


  reg_3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        vendInReg <= '0';
      ELSIF enb = '1' THEN
        vendInReg <= in1_vEnd;
      END IF;
    END IF;
  END PROCESS reg_3_process;


  reg_4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        validInReg <= '0';
      ELSIF enb = '1' THEN
        validInReg <= in1_valid;
      END IF;
    END IF;
  END PROCESS reg_4_process;


  
  readReady <= '1' WHEN readRDY /= '0' ELSE
      '0';

  
  validOut <= '1' WHEN vldOut /= '0' ELSE
      '0';

  out0 <= histVal;

  out1 <= readReady;

  out2 <= validOut;

END rtl;
