LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.HDLLaneDetector_pkg.ALL;

ENTITY VerticallyOrientatedFilter IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        in0                               :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        in1_hStart                        :   IN    std_logic;
        in1_hEnd                          :   IN    std_logic;
        in1_vStart                        :   IN    std_logic;
        in1_vEnd                          :   IN    std_logic;
        in1_valid                         :   IN    std_logic;
        out0                              :   OUT   std_logic_vector(23 DOWNTO 0);  -- sfix24_En15
        out1_hStart                       :   OUT   std_logic;
        out1_hEnd                         :   OUT   std_logic;
        out1_vStart                       :   OUT   std_logic;
        out1_vEnd                         :   OUT   std_logic;
        out1_valid                        :   OUT   std_logic
        );
END VerticallyOrientatedFilter;


ARCHITECTURE rtl OF VerticallyOrientatedFilter IS

  -- Component Declarations
  COMPONENT LineBuffer
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          dataIn                          :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          hStartIn                        :   IN    std_logic;
          hEndIn                          :   IN    std_logic;
          vStartIn                        :   IN    std_logic;
          vEndIn                          :   IN    std_logic;
          validIn                         :   IN    std_logic;
          dataOut                         :   OUT   vector_of_std_logic_vector8(0 TO 15);  -- uint8 [16]
          hStartOut                       :   OUT   std_logic;
          hEndOut                         :   OUT   std_logic;
          vStartOut                       :   OUT   std_logic;
          vEndOut                         :   OUT   std_logic;
          validOut                        :   OUT   std_logic;
          processDataOut                  :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT FIR2DKernel
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          dataIn                          :   IN    vector_of_std_logic_vector8(0 TO 15);  -- uint8 [16]
          vStartIn                        :   IN    std_logic;
          vEndIn                          :   IN    std_logic;
          hStartIn                        :   IN    std_logic;
          hEndIn                          :   IN    std_logic;
          validIn                         :   IN    std_logic;
          processData                     :   IN    std_logic;
          dataOut                         :   OUT   std_logic_vector(23 DOWNTO 0);  -- sfix24_En15
          vStartOut                       :   OUT   std_logic;
          vEndOut                         :   OUT   std_logic;
          hStartOut                       :   OUT   std_logic;
          hEndOut                         :   OUT   std_logic;
          validOut                        :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : LineBuffer
    USE ENTITY work.LineBuffer(rtl);

  FOR ALL : FIR2DKernel
    USE ENTITY work.FIR2DKernel(rtl);

  -- Signals
  SIGNAL in0_unsigned                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataInReg                        : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL hStartInReg                      : std_logic;
  SIGNAL hendInReg                        : std_logic;
  SIGNAL vStartInReg                      : std_logic;
  SIGNAL vendInReg                        : std_logic;
  SIGNAL validInReg                       : std_logic;
  SIGNAL LMKDataOut                       : vector_of_std_logic_vector8(0 TO 15);  -- ufix8 [16]
  SIGNAL LMKhStartOut                     : std_logic;
  SIGNAL LMKhEndOut                       : std_logic;
  SIGNAL LMKvStartOut                     : std_logic;
  SIGNAL LMKvEndOut                       : std_logic;
  SIGNAL LMKvalidOut                      : std_logic;
  SIGNAL LMKprocessOut                    : std_logic;
  SIGNAL preFilterDataOut                 : std_logic_vector(23 DOWNTO 0);  -- ufix24
  SIGNAL prehStartOut                     : std_logic;
  SIGNAL prehEndOut                       : std_logic;
  SIGNAL prevStartOut                     : std_logic;
  SIGNAL prevEndOut                       : std_logic;
  SIGNAL preValidOut                      : std_logic;
  SIGNAL zeroOut_1                        : signed(23 DOWNTO 0);  -- sfix24_En15
  SIGNAL preFilterDataOut_signed          : signed(23 DOWNTO 0);  -- sfix24_En15
  SIGNAL preDataOut                       : signed(23 DOWNTO 0);  -- sfix24_En15
  SIGNAL intdelay_reg                     : vector_of_signed24(0 TO 3);  -- sfix24 [4]
  SIGNAL dataOut                          : signed(23 DOWNTO 0);  -- sfix24_En15
  SIGNAL intdelay_reg_1                   : std_logic_vector(0 TO 3);  -- ufix1 [4]
  SIGNAL hStartOut                        : std_logic;
  SIGNAL intdelay_reg_2                   : std_logic_vector(0 TO 3);  -- ufix1 [4]
  SIGNAL hEndOut                          : std_logic;
  SIGNAL intdelay_reg_3                   : std_logic_vector(0 TO 3);  -- ufix1 [4]
  SIGNAL vStartOut                        : std_logic;
  SIGNAL intdelay_reg_4                   : std_logic_vector(0 TO 3);  -- ufix1 [4]
  SIGNAL vEndOut                          : std_logic;
  SIGNAL intdelay_reg_5                   : std_logic_vector(0 TO 3);  -- ufix1 [4]
  SIGNAL validOut                         : std_logic;

BEGIN
  u_LineBuffer : LineBuffer
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              dataIn => std_logic_vector(dataInReg),  -- uint8
              hStartIn => hStartInReg,
              hEndIn => hendInReg,
              vStartIn => vStartInReg,
              vEndIn => vendInReg,
              validIn => validInReg,
              dataOut => LMKDataOut,  -- uint8 [16]
              hStartOut => LMKhStartOut,
              hEndOut => LMKhEndOut,
              vStartOut => LMKvStartOut,
              vEndOut => LMKvEndOut,
              validOut => LMKvalidOut,
              processDataOut => LMKprocessOut
              );

  u_imagekernel_inst : FIR2DKernel
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              dataIn => LMKDataOut,  -- uint8 [16]
              vStartIn => LMKhStartOut,
              vEndIn => LMKhEndOut,
              hStartIn => LMKvStartOut,
              hEndIn => LMKvEndOut,
              validIn => LMKvalidOut,
              processData => LMKprocessOut,
              dataOut => preFilterDataOut,  -- sfix24_En15
              vStartOut => prehStartOut,
              vEndOut => prehEndOut,
              hStartOut => prevStartOut,
              hEndOut => prevEndOut,
              validOut => preValidOut
              );

  in0_unsigned <= unsigned(in0);

  reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        dataInReg <= to_unsigned(16#00#, 8);
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
        vStartInReg <= '0';
      ELSIF enb = '1' THEN
        vStartInReg <= in1_vStart;
      END IF;
    END IF;
  END PROCESS reg_3_process;


  reg_4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        vendInReg <= '0';
      ELSIF enb = '1' THEN
        vendInReg <= in1_vEnd;
      END IF;
    END IF;
  END PROCESS reg_4_process;


  reg_5_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        validInReg <= '0';
      ELSIF enb = '1' THEN
        validInReg <= in1_valid;
      END IF;
    END IF;
  END PROCESS reg_5_process;


  zeroOut_1 <= to_signed(16#000000#, 24);

  preFilterDataOut_signed <= signed(preFilterDataOut);

  
  preDataOut <= zeroOut_1 WHEN preValidOut = '0' ELSE
      preFilterDataOut_signed;

  intdelay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg <= (OTHERS => to_signed(16#000000#, 24));
      ELSIF enb = '1' THEN
        intdelay_reg(0) <= preDataOut;
        intdelay_reg(1 TO 3) <= intdelay_reg(0 TO 2);
      END IF;
    END IF;
  END PROCESS intdelay_process;

  dataOut <= intdelay_reg(3);

  out0 <= std_logic_vector(dataOut);

  intdelay_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg_1 <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        intdelay_reg_1(0) <= prehStartOut;
        intdelay_reg_1(1 TO 3) <= intdelay_reg_1(0 TO 2);
      END IF;
    END IF;
  END PROCESS intdelay_1_process;

  hStartOut <= intdelay_reg_1(3);

  out1_hStart <= hStartOut;

  intdelay_2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg_2 <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        intdelay_reg_2(0) <= prehEndOut;
        intdelay_reg_2(1 TO 3) <= intdelay_reg_2(0 TO 2);
      END IF;
    END IF;
  END PROCESS intdelay_2_process;

  hEndOut <= intdelay_reg_2(3);

  out1_hEnd <= hEndOut;

  intdelay_3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg_3 <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        intdelay_reg_3(0) <= prevStartOut;
        intdelay_reg_3(1 TO 3) <= intdelay_reg_3(0 TO 2);
      END IF;
    END IF;
  END PROCESS intdelay_3_process;

  vStartOut <= intdelay_reg_3(3);

  out1_vStart <= vStartOut;

  intdelay_4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg_4 <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        intdelay_reg_4(0) <= prevEndOut;
        intdelay_reg_4(1 TO 3) <= intdelay_reg_4(0 TO 2);
      END IF;
    END IF;
  END PROCESS intdelay_4_process;

  vEndOut <= intdelay_reg_4(3);

  out1_vEnd <= vEndOut;

  intdelay_5_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg_5 <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        intdelay_reg_5(0) <= preValidOut;
        intdelay_reg_5(1 TO 3) <= intdelay_reg_5(0 TO 2);
      END IF;
    END IF;
  END PROCESS intdelay_5_process;

  validOut <= intdelay_reg_5(3);

  out1_valid <= validOut;

END rtl;

