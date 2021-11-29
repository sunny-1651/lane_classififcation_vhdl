LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ControlSignalGeneration IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        FSMState                          :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
        BlankingInterval                  :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16
        ColumnCountIn                     :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16
        hStartOut                         :   OUT   std_logic;
        hEndOut                           :   OUT   std_logic;
        vStartOut                         :   OUT   std_logic;
        vEndOut                           :   OUT   std_logic;
        validOut                          :   OUT   std_logic;
        ColumnCountEnable                 :   OUT   std_logic;
        ColumnCountReset                  :   OUT   std_logic
        );
END ControlSignalGeneration;


ARCHITECTURE rtl OF ControlSignalGeneration IS

  -- Functions
  -- HDLCODER_TO_STDLOGIC 
  FUNCTION hdlcoder_to_stdlogic(arg: boolean) RETURN std_logic IS
  BEGIN
    IF arg THEN
      RETURN '1';
    ELSE
      RETURN '0';
    END IF;
  END FUNCTION;


  -- Signals
  SIGNAL FSMState_unsigned                : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL BlankingInterval_unsigned        : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL ColumnCountIn_unsigned           : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL ControlSignalGeneration_BlankingCounter : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL ControlSignalGeneration_RowCounter : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL ControlSignalGeneration_EnableBetweenLinesREG : std_logic;
  SIGNAL ControlSignalGeneration_BlankingCounter_next : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL ControlSignalGeneration_RowCounter_next : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL ControlSignalGeneration_EnableBetweenLinesREG_next : std_logic;
  SIGNAL EnableReadCompute                : std_logic;
  SIGNAL EnableBetweenLines               : std_logic;

BEGIN
  FSMState_unsigned <= unsigned(FSMState);

  BlankingInterval_unsigned <= unsigned(BlankingInterval);

  ColumnCountIn_unsigned <= unsigned(ColumnCountIn);

  -- ControlSignalGeneration - Generate Output Control Signals
  ControlSignalGeneration_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        ControlSignalGeneration_BlankingCounter <= to_unsigned(16#0000#, 16);
        ControlSignalGeneration_RowCounter <= to_unsigned(16#0000#, 16);
        ControlSignalGeneration_EnableBetweenLinesREG <= '0';
      ELSIF enb = '1' THEN
        ControlSignalGeneration_BlankingCounter <= ControlSignalGeneration_BlankingCounter_next;
        ControlSignalGeneration_RowCounter <= ControlSignalGeneration_RowCounter_next;
        ControlSignalGeneration_EnableBetweenLinesREG <= ControlSignalGeneration_EnableBetweenLinesREG_next;
      END IF;
    END IF;
  END PROCESS ControlSignalGeneration_1_process;

  ControlSignalGeneration_1_output : PROCESS (BlankingInterval_unsigned, ColumnCountIn_unsigned,
       ControlSignalGeneration_BlankingCounter,
       ControlSignalGeneration_EnableBetweenLinesREG,
       ControlSignalGeneration_RowCounter, FSMState_unsigned)
    VARIABLE out0 : std_logic;
    VARIABLE out1 : std_logic;
    VARIABLE RowCounter_temp : unsigned(15 DOWNTO 0);
    VARIABLE EnableBetweenLinesREG_temp : std_logic;
    VARIABLE sub_temp : unsigned(16 DOWNTO 0);
    VARIABLE add_temp : unsigned(15 DOWNTO 0);
    VARIABLE sub_temp_0 : unsigned(16 DOWNTO 0);
  BEGIN
    sub_temp := to_unsigned(16#00000#, 17);
    add_temp := to_unsigned(16#0000#, 16);
    sub_temp_0 := to_unsigned(16#00000#, 17);
    ControlSignalGeneration_BlankingCounter_next <= ControlSignalGeneration_BlankingCounter;
    RowCounter_temp := ControlSignalGeneration_RowCounter;
    EnableBetweenLinesREG_temp := ControlSignalGeneration_EnableBetweenLinesREG;
    IF FSMState_unsigned = to_unsigned(16#2#, 2) THEN 
      sub_temp := resize(BlankingInterval_unsigned, 17) - to_unsigned(16#00002#, 17);
      IF (ControlSignalGeneration_EnableBetweenLinesREG AND hdlcoder_to_stdlogic(resize(ControlSignalGeneration_BlankingCounter, 17) <= sub_temp)) = '1' THEN 
        ControlSignalGeneration_BlankingCounter_next <= ControlSignalGeneration_BlankingCounter + 1;
        ColumnCountReset <= '1';
        add_temp := ControlSignalGeneration_BlankingCounter + 1;
        sub_temp_0 := resize(BlankingInterval_unsigned, 17) - to_unsigned(16#00002#, 17);
        IF resize(add_temp, 17) = sub_temp_0 THEN 
          ControlSignalGeneration_BlankingCounter_next <= to_unsigned(16#0000#, 16);
          EnableBetweenLinesREG_temp := '0';
        END IF;
      ELSE 
        ColumnCountReset <= '0';
      END IF;
      IF (( NOT EnableBetweenLinesREG_temp) AND hdlcoder_to_stdlogic(ColumnCountIn_unsigned < to_unsigned(16#0282#, 16))) = '1' THEN 
        ColumnCountEnable <= '1';
        validOut <= hdlcoder_to_stdlogic(ColumnCountIn_unsigned >= to_unsigned(16#0002#, 16));
        IF ColumnCountIn_unsigned = to_unsigned(16#0002#, 16) THEN 
          out0 := '1';
          out1 := '0';
        ELSIF ColumnCountIn_unsigned = to_unsigned(16#0281#, 16) THEN 
          out1 := '1';
          out0 := '0';
          RowCounter_temp := ControlSignalGeneration_RowCounter + 1;
          EnableBetweenLinesREG_temp := '1';
          ColumnCountReset <= '1';
          ControlSignalGeneration_BlankingCounter_next <= to_unsigned(16#0000#, 16);
        ELSE 
          out0 := '0';
          out1 := '0';
        END IF;
      ELSE 
        validOut <= '0';
        out0 := '0';
        out1 := '0';
        ColumnCountEnable <= '0';
      END IF;
      IF (hdlcoder_to_stdlogic(RowCounter_temp = to_unsigned(16#000002BC#, 16)) AND out1) = '1' THEN 
        vEndOut <= '1';
        vStartOut <= '0';
        ColumnCountReset <= '1';
        ControlSignalGeneration_BlankingCounter_next <= to_unsigned(16#0000#, 16);
        EnableBetweenLinesREG_temp := '1';
        RowCounter_temp := to_unsigned(16#0000#, 16);
      ELSIF (hdlcoder_to_stdlogic(RowCounter_temp = to_unsigned(16#00000000#, 16)) AND out0) = '1' THEN 
        vStartOut <= '1';
        vEndOut <= '0';
      ELSE 
        vEndOut <= '0';
        vStartOut <= '0';
      END IF;
    ELSE 
      validOut <= '0';
      out0 := '0';
      out1 := '0';
      vStartOut <= '0';
      vEndOut <= '0';
      EnableBetweenLinesREG_temp := '0';
      ColumnCountEnable <= '0';
      ColumnCountReset <= '0';
    END IF;
    hStartOut <= out0;
    hEndOut <= out1;
    EnableReadCompute <= '1';
    EnableBetweenLines <= EnableBetweenLinesREG_temp;
    ControlSignalGeneration_RowCounter_next <= RowCounter_temp;
    ControlSignalGeneration_EnableBetweenLinesREG_next <= EnableBetweenLinesREG_temp;
  END PROCESS ControlSignalGeneration_1_output;


END rtl;

