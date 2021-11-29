LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.HDLLaneDetector_pkg.ALL;

ENTITY Birds_Eye_View IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        in0                               :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        in1_hStart                        :   IN    std_logic;
        in1_hEnd                          :   IN    std_logic;
        in1_vStart                        :   IN    std_logic;
        in1_valid                         :   IN    std_logic;
        out0                              :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
        out1_hStart                       :   OUT   std_logic;
        out1_hEnd                         :   OUT   std_logic;
        out1_vStart                       :   OUT   std_logic;
        out1_vEnd                         :   OUT   std_logic;
        out1_valid                        :   OUT   std_logic
        );
END Birds_Eye_View;


ARCHITECTURE rtl OF Birds_Eye_View IS

  -- Component Declarations
  COMPONENT BlankingIntervalCompute
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          hStart                          :   IN    std_logic;
          hEnd                            :   IN    std_logic;
          FSMState                        :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
          BlankingInterval                :   OUT   std_logic_vector(15 DOWNTO 0)  -- ufix16
          );
  END COMPONENT;

  COMPONENT dataWriteFSM
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          vEndIn                          :   IN    std_logic;
          validIn                         :   IN    std_logic;
          RowCounterIn                    :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16
          vStartIn                        :   IN    std_logic;
          push                            :   OUT   std_logic;
          LockedInFrame                   :   OUT   std_logic;
          FSMState                        :   OUT   std_logic_vector(1 DOWNTO 0)  -- ufix2
          );
  END COMPONENT;

  COMPONENT ControlSignalGeneration
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          FSMState                        :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
          BlankingInterval                :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16
          ColumnCountIn                   :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16
          hStartOut                       :   OUT   std_logic;
          hEndOut                         :   OUT   std_logic;
          vStartOut                       :   OUT   std_logic;
          vEndOut                         :   OUT   std_logic;
          validOut                        :   OUT   std_logic;
          ColumnCountEnable               :   OUT   std_logic;
          ColumnCountReset                :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT ReadAddressGenerator
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          hStart                          :   IN    std_logic;
          columnCount                     :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16
          FrameReset                      :   IN    std_logic;
          readAddress                     :   OUT   std_logic_vector(15 DOWNTO 0)  -- ufix16
          );
  END COMPONENT;

  COMPONENT LineBuffer_block
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          pixel                           :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          pushIn                          :   IN    std_logic;
          readAddress                     :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16
          FrameEnd                        :   IN    std_logic;
          pixelOut                        :   OUT   std_logic_vector(7 DOWNTO 0)  -- uint8
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : BlankingIntervalCompute
    USE ENTITY work.BlankingIntervalCompute(rtl);

  FOR ALL : dataWriteFSM
    USE ENTITY work.dataWriteFSM(rtl);

  FOR ALL : ControlSignalGeneration
    USE ENTITY work.ControlSignalGeneration(rtl);

  FOR ALL : ReadAddressGenerator
    USE ENTITY work.ReadAddressGenerator(rtl);

  FOR ALL : LineBuffer_block
    USE ENTITY work.LineBuffer_block(rtl);

  -- Signals
  SIGNAL ColumnCountReset                 : std_logic;
  SIGNAL ColumnCountEnable                : std_logic;
  SIGNAL ColumnCountOut                   : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL FSMState                         : std_logic_vector(1 DOWNTO 0);  -- ufix2
  SIGNAL BlankingCounter                  : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL BlankingCounter_unsigned         : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL BlankingCounterD                 : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL LockedInFrame                    : std_logic;
  SIGNAL NotLocked                        : std_logic;
  SIGNAL lockRow                          : std_logic;
  SIGNAL vEndOutCG                        : std_logic;
  SIGNAL rowCounterIn                     : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL vEndOutCG_1                      : std_logic;
  SIGNAL push                             : std_logic;
  SIGNAL hStartOutCG                      : std_logic;
  SIGNAL hEndOutCG                        : std_logic;
  SIGNAL vStartOutCG                      : std_logic;
  SIGNAL validOutCG                       : std_logic;
  SIGNAL in0_unsigned                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL intdelay_reg                     : vector_of_unsigned8(0 TO 2);  -- ufix8 [3]
  SIGNAL LineBufferDataOut                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL hStartOutCG_1                    : std_logic;
  SIGNAL intdelay_reg_1                   : vector_of_unsigned16(0 TO 3);  -- ufix16 [4]
  SIGNAL ColumnCountOut_1                 : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL ReadAddress                      : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL NotValid                         : std_logic;
  SIGNAL LineBufferDataOut_1              : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL LineBufferDataOut_unsigned       : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataOut                          : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL hEndOut                          : std_logic;
  SIGNAL vStartOut                        : std_logic;
  SIGNAL validOut                         : std_logic;

BEGIN
  u_Blanking_Counter_Network : BlankingIntervalCompute
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              hStart => in1_hStart,
              hEnd => in1_hEnd,
              FSMState => FSMState,  -- ufix2
              BlankingInterval => BlankingCounter  -- ufix16
              );

  u_Birds_Eye_FSM : dataWriteFSM
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              vEndIn => vEndOutCG,
              validIn => in1_valid,
              RowCounterIn => std_logic_vector(rowCounterIn),  -- ufix16
              vStartIn => in1_vStart,
              push => push,
              LockedInFrame => LockedInFrame,
              FSMState => FSMState  -- ufix2
              );

  u_Control_Signal_Generation : ControlSignalGeneration
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              FSMState => FSMState,  -- ufix2
              BlankingInterval => std_logic_vector(BlankingCounterD),  -- ufix16
              ColumnCountIn => std_logic_vector(ColumnCountOut),  -- ufix16
              hStartOut => hStartOutCG,
              hEndOut => hEndOutCG,
              vStartOut => vStartOutCG,
              vEndOut => vEndOutCG_1,
              validOut => validOutCG,
              ColumnCountEnable => ColumnCountEnable,
              ColumnCountReset => ColumnCountReset
              );

  u_Read_Address_Generation : ReadAddressGenerator
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              hStart => hStartOutCG_1,
              columnCount => std_logic_vector(ColumnCountOut_1),  -- ufix16
              FrameReset => vEndOutCG,
              readAddress => ReadAddress  -- ufix16
              );

  u_Input_Buffer : LineBuffer_block
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              pixel => std_logic_vector(LineBufferDataOut),  -- uint8
              pushIn => push,
              readAddress => ReadAddress,  -- ufix16
              FrameEnd => vEndOutCG,
              pixelOut => LineBufferDataOut_1  -- uint8
              );

  -- Free running, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  -- 
  -- Column Count
  Column_Counter_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        ColumnCountOut <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' THEN
        IF ColumnCountReset = '1' THEN 
          ColumnCountOut <= to_unsigned(16#0000#, 16);
        ELSIF ColumnCountEnable = '1' THEN 
          ColumnCountOut <= ColumnCountOut + to_unsigned(16#0001#, 16);
        END IF;
      END IF;
    END IF;
  END PROCESS Column_Counter_process;


  BlankingCounter_unsigned <= unsigned(BlankingCounter);

  reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        BlankingCounterD <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' THEN
        BlankingCounterD <= BlankingCounter_unsigned;
      END IF;
    END IF;
  END PROCESS reg_process;


  NotLocked <=  NOT LockedInFrame;

  lockRow <= in1_hStart AND NotLocked;

  -- Free running, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  -- 
  -- Row Counter
  RunLengthDecodeCount_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        rowCounterIn <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' THEN
        IF vEndOutCG = '1' THEN 
          rowCounterIn <= to_unsigned(16#0000#, 16);
        ELSIF lockRow = '1' THEN 
          rowCounterIn <= rowCounterIn + to_unsigned(16#0001#, 16);
        END IF;
      END IF;
    END IF;
  END PROCESS RunLengthDecodeCount_process;


  reduced_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        vEndOutCG <= '0';
      ELSIF enb = '1' THEN
        vEndOutCG <= vEndOutCG_1;
      END IF;
    END IF;
  END PROCESS reduced_process;


  in0_unsigned <= unsigned(in0);

  intdelay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg <= (OTHERS => to_unsigned(16#00#, 8));
      ELSIF enb = '1' THEN
        intdelay_reg(0) <= in0_unsigned;
        intdelay_reg(1 TO 2) <= intdelay_reg(0 TO 1);
      END IF;
    END IF;
  END PROCESS intdelay_process;

  LineBufferDataOut <= intdelay_reg(2);

  reduced_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        hStartOutCG_1 <= '0';
      ELSIF enb = '1' THEN
        hStartOutCG_1 <= hStartOutCG;
      END IF;
    END IF;
  END PROCESS reduced_1_process;


  intdelay_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg_1 <= (OTHERS => to_unsigned(16#0000#, 16));
      ELSIF enb = '1' THEN
        intdelay_reg_1(0) <= ColumnCountOut;
        intdelay_reg_1(1 TO 3) <= intdelay_reg_1(0 TO 2);
      END IF;
    END IF;
  END PROCESS intdelay_1_process;

  ColumnCountOut_1 <= intdelay_reg_1(3);

  NotValid <=  NOT validOutCG;

  LineBufferDataOut_unsigned <= unsigned(LineBufferDataOut_1);

  reg_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        dataOut <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        IF NotValid = '1' THEN
          dataOut <= to_unsigned(16#00#, 8);
        ELSE 
          dataOut <= LineBufferDataOut_unsigned;
        END IF;
      END IF;
    END IF;
  END PROCESS reg_1_process;


  out0 <= std_logic_vector(dataOut);

  out1_hStart <= hStartOutCG_1;

  reg_2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        hEndOut <= '0';
      ELSIF enb = '1' THEN
        hEndOut <= hEndOutCG;
      END IF;
    END IF;
  END PROCESS reg_2_process;


  out1_hEnd <= hEndOut;

  reg_3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        vStartOut <= '0';
      ELSIF enb = '1' THEN
        vStartOut <= vStartOutCG;
      END IF;
    END IF;
  END PROCESS reg_3_process;


  out1_vStart <= vStartOut;

  out1_vEnd <= vEndOutCG;

  reg_4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        validOut <= '0';
      ELSIF enb = '1' THEN
        validOut <= validOutCG;
      END IF;
    END IF;
  END PROCESS reg_4_process;


  out1_valid <= validOut;

END rtl;

