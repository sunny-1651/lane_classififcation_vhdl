LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.HDLLaneDetector_pkg.ALL;

ENTITY ReadAddressGenerator IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        hStart                            :   IN    std_logic;
        columnCount                       :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16
        FrameReset                        :   IN    std_logic;
        readAddress                       :   OUT   std_logic_vector(15 DOWNTO 0)  -- ufix16
        );
END ReadAddressGenerator;


ARCHITECTURE rtl OF ReadAddressGenerator IS

  -- Signals
  SIGNAL columnCount_unsigned             : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL intdelay_reg                     : vector_of_unsigned16(0 TO 1);  -- ufix16 [2]
  SIGNAL ColumnCountInD                   : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL LineLUTCountD                    : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL RowMapLUTValue                   : unsigned(25 DOWNTO 0);  -- ufix26_En10
  SIGNAL LineLUTEnable0                   : std_logic;
  SIGNAL RunLengthReset                   : std_logic;
  SIGNAL RunLengthDecodeCount             : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL relop_1_cast                     : unsigned(25 DOWNTO 0);  -- ufix26_En10
  SIGNAL relop_relop1                     : std_logic;
  SIGNAL LineLUTCount_1                   : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL intdelay_reg_1                   : vector_of_unsigned16(0 TO 1);  -- ufix16 [2]
  SIGNAL GradientLUTOut                   : unsigned(25 DOWNTO 0);  -- ufix26_En10
  SIGNAL GradientLUTOutD                  : unsigned(25 DOWNTO 0);  -- ufix26_En10
  SIGNAL multiplier_mul_temp              : unsigned(41 DOWNTO 0);  -- ufix42_En10
  SIGNAL ReadAddressGradient              : unsigned(25 DOWNTO 0);  -- ufix26_En10
  SIGNAL intdelay_reg_2                   : vector_of_unsigned26(0 TO 1);  -- ufix26 [2]
  SIGNAL ReadAddressGradientD             : unsigned(25 DOWNTO 0);  -- ufix26_En10
  SIGNAL OffsetLUTValue                   : unsigned(25 DOWNTO 0);  -- ufix26_En10
  SIGNAL intdelay_reg_3                   : vector_of_unsigned26(0 TO 1);  -- ufix26 [2]
  SIGNAL OffsetLUTValueD                  : unsigned(25 DOWNTO 0);  -- ufix26_En10
  SIGNAL ReadAddressOffsetCorrected       : unsigned(25 DOWNTO 0);  -- ufix26_En10
  SIGNAL ReadAddressOffsetCorrected_1     : unsigned(25 DOWNTO 0);  -- ufix26_En10
  SIGNAL BirdsEyeActivePixels             : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL BirdsEyeActivePixelsD            : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL RunDecodeAddress                 : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL intdelay_reg_4                   : vector_of_unsigned16(0 TO 2);  -- ufix16 [3]
  SIGNAL RunDecodeAddressD                : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL adder_add_cast                   : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL readAddress_tmp                  : unsigned(15 DOWNTO 0);  -- ufix16

BEGIN
  columnCount_unsigned <= unsigned(columnCount);

  intdelay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg <= (OTHERS => to_unsigned(16#0000#, 16));
      ELSIF enb = '1' THEN
        intdelay_reg(0) <= columnCount_unsigned;
        intdelay_reg(1) <= intdelay_reg(0);
      END IF;
    END IF;
  END PROCESS intdelay_process;

  ColumnCountInD <= intdelay_reg(1);

  -- Coefficient table for Row Mapping
  RowMapLUT_output : PROCESS (LineLUTCountD)
  BEGIN
    CASE LineLUTCountD IS
      WHEN "0000000000000000" =>
        RowMapLUTValue <= to_unsigned(16#0000800#, 26);
      WHEN "0000000000000001" =>
        RowMapLUTValue <= to_unsigned(16#0005C00#, 26);
      WHEN "0000000000000010" =>
        RowMapLUTValue <= to_unsigned(16#0009800#, 26);
      WHEN "0000000000000011" =>
        RowMapLUTValue <= to_unsigned(16#0009000#, 26);
      WHEN "0000000000000100" =>
        RowMapLUTValue <= to_unsigned(16#0008400#, 26);
      WHEN "0000000000000101" =>
        RowMapLUTValue <= to_unsigned(16#0007C00#, 26);
      WHEN "0000000000000110" =>
        RowMapLUTValue <= to_unsigned(16#0007400#, 26);
      WHEN "0000000000000111" =>
        RowMapLUTValue <= to_unsigned(16#0006C00#, 26);
      WHEN "0000000000001000" =>
        RowMapLUTValue <= to_unsigned(16#0006800#, 26);
      WHEN "0000000000001001" =>
        RowMapLUTValue <= to_unsigned(16#0006000#, 26);
      WHEN "0000000000001010" =>
        RowMapLUTValue <= to_unsigned(16#0005C00#, 26);
      WHEN "0000000000001011" =>
        RowMapLUTValue <= to_unsigned(16#0005800#, 26);
      WHEN "0000000000001100" =>
        RowMapLUTValue <= to_unsigned(16#0005000#, 26);
      WHEN "0000000000001101" =>
        RowMapLUTValue <= to_unsigned(16#0005000#, 26);
      WHEN "0000000000001110" =>
        RowMapLUTValue <= to_unsigned(16#0004800#, 26);
      WHEN "0000000000001111" =>
        RowMapLUTValue <= to_unsigned(16#0004800#, 26);
      WHEN "0000000000010000" =>
        RowMapLUTValue <= to_unsigned(16#0004000#, 26);
      WHEN "0000000000010001" =>
        RowMapLUTValue <= to_unsigned(16#0004000#, 26);
      WHEN "0000000000010010" =>
        RowMapLUTValue <= to_unsigned(16#0004000#, 26);
      WHEN "0000000000010011" =>
        RowMapLUTValue <= to_unsigned(16#0003800#, 26);
      WHEN "0000000000010100" =>
        RowMapLUTValue <= to_unsigned(16#0003800#, 26);
      WHEN "0000000000010101" =>
        RowMapLUTValue <= to_unsigned(16#0003800#, 26);
      WHEN "0000000000010110" =>
        RowMapLUTValue <= to_unsigned(16#0003000#, 26);
      WHEN "0000000000010111" =>
        RowMapLUTValue <= to_unsigned(16#0003400#, 26);
      WHEN "0000000000011000" =>
        RowMapLUTValue <= to_unsigned(16#0003000#, 26);
      WHEN "0000000000011001" =>
        RowMapLUTValue <= to_unsigned(16#0002C00#, 26);
      WHEN "0000000000011010" =>
        RowMapLUTValue <= to_unsigned(16#0002C00#, 26);
      WHEN "0000000000011011" =>
        RowMapLUTValue <= to_unsigned(16#0002C00#, 26);
      WHEN "0000000000011100" =>
        RowMapLUTValue <= to_unsigned(16#0002800#, 26);
      WHEN "0000000000011101" =>
        RowMapLUTValue <= to_unsigned(16#0002800#, 26);
      WHEN "0000000000011110" =>
        RowMapLUTValue <= to_unsigned(16#0002800#, 26);
      WHEN "0000000000011111" =>
        RowMapLUTValue <= to_unsigned(16#0002400#, 26);
      WHEN "0000000000100000" =>
        RowMapLUTValue <= to_unsigned(16#0002400#, 26);
      WHEN "0000000000100001" =>
        RowMapLUTValue <= to_unsigned(16#0002400#, 26);
      WHEN "0000000000100010" =>
        RowMapLUTValue <= to_unsigned(16#0002000#, 26);
      WHEN "0000000000100011" =>
        RowMapLUTValue <= to_unsigned(16#0002000#, 26);
      WHEN "0000000000100100" =>
        RowMapLUTValue <= to_unsigned(16#0002000#, 26);
      WHEN "0000000000100101" =>
        RowMapLUTValue <= to_unsigned(16#0002000#, 26);
      WHEN "0000000000100110" =>
        RowMapLUTValue <= to_unsigned(16#0002000#, 26);
      WHEN "0000000000100111" =>
        RowMapLUTValue <= to_unsigned(16#0001C00#, 26);
      WHEN "0000000000101000" =>
        RowMapLUTValue <= to_unsigned(16#0001C00#, 26);
      WHEN "0000000000101001" =>
        RowMapLUTValue <= to_unsigned(16#0001C00#, 26);
      WHEN "0000000000101010" =>
        RowMapLUTValue <= to_unsigned(16#0001C00#, 26);
      WHEN "0000000000101011" =>
        RowMapLUTValue <= to_unsigned(16#0001800#, 26);
      WHEN "0000000000101100" =>
        RowMapLUTValue <= to_unsigned(16#0001C00#, 26);
      WHEN "0000000000101101" =>
        RowMapLUTValue <= to_unsigned(16#0001800#, 26);
      WHEN "0000000000101110" =>
        RowMapLUTValue <= to_unsigned(16#0001800#, 26);
      WHEN "0000000000101111" =>
        RowMapLUTValue <= to_unsigned(16#0001800#, 26);
      WHEN "0000000000110000" =>
        RowMapLUTValue <= to_unsigned(16#0001800#, 26);
      WHEN "0000000000110001" =>
        RowMapLUTValue <= to_unsigned(16#0001800#, 26);
      WHEN "0000000000110010" =>
        RowMapLUTValue <= to_unsigned(16#0001400#, 26);
      WHEN "0000000000110011" =>
        RowMapLUTValue <= to_unsigned(16#0001800#, 26);
      WHEN "0000000000110100" =>
        RowMapLUTValue <= to_unsigned(16#0001400#, 26);
      WHEN "0000000000110101" =>
        RowMapLUTValue <= to_unsigned(16#0001400#, 26);
      WHEN OTHERS => 
        RowMapLUTValue <= to_unsigned(16#0000000#, 26);
    END CASE;
  END PROCESS RowMapLUT_output;


  RunLengthReset <= LineLUTEnable0 OR FrameReset;

  -- Free running, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  -- 
  -- Run-Length Decode Count
  RunLengthDecodeCounter_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        RunLengthDecodeCount <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' THEN
        IF RunLengthReset = '1' THEN 
          RunLengthDecodeCount <= to_unsigned(16#0000#, 16);
        ELSIF hStart = '1' THEN 
          RunLengthDecodeCount <= RunLengthDecodeCount + to_unsigned(16#0001#, 16);
        END IF;
      END IF;
    END IF;
  END PROCESS RunLengthDecodeCounter_process;


  relop_1_cast <= RunLengthDecodeCount & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0';
  
  relop_relop1 <= '1' WHEN relop_1_cast = RowMapLUTValue ELSE
      '0';

  LineLUTEnable0 <= relop_relop1 OR FrameReset;

  -- Count limited, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  --  count to value  = 54
  -- 
  -- Line LUT Count
  LineLUTCount_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        LineLUTCount_1 <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' THEN
        IF FrameReset = '1' THEN 
          LineLUTCount_1 <= to_unsigned(16#0000#, 16);
        ELSIF LineLUTEnable0 = '1' THEN 
          IF LineLUTCount_1 >= to_unsigned(16#0036#, 16) THEN 
            LineLUTCount_1 <= to_unsigned(16#0000#, 16);
          ELSE 
            LineLUTCount_1 <= LineLUTCount_1 + to_unsigned(16#0001#, 16);
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS LineLUTCount_process;


  intdelay_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg_1 <= (OTHERS => to_unsigned(16#0000#, 16));
      ELSIF enb = '1' THEN
        intdelay_reg_1(0) <= LineLUTCount_1;
        intdelay_reg_1(1) <= intdelay_reg_1(0);
      END IF;
    END IF;
  END PROCESS intdelay_1_process;

  LineLUTCountD <= intdelay_reg_1(1);

  -- Coefficient table for Gradient Values
  GradientLUT_output : PROCESS (LineLUTCountD)
  BEGIN
    CASE LineLUTCountD IS
      WHEN "0000000000000000" =>
        GradientLUTOut <= to_unsigned(16#0000144#, 26);
      WHEN "0000000000000001" =>
        GradientLUTOut <= to_unsigned(16#000014B#, 26);
      WHEN "0000000000000010" =>
        GradientLUTOut <= to_unsigned(16#0000158#, 26);
      WHEN "0000000000000011" =>
        GradientLUTOut <= to_unsigned(16#0000164#, 26);
      WHEN "0000000000000100" =>
        GradientLUTOut <= to_unsigned(16#0000171#, 26);
      WHEN "0000000000000101" =>
        GradientLUTOut <= to_unsigned(16#000017D#, 26);
      WHEN "0000000000000110" =>
        GradientLUTOut <= to_unsigned(16#000018A#, 26);
      WHEN "0000000000000111" =>
        GradientLUTOut <= to_unsigned(16#0000196#, 26);
      WHEN "0000000000001000" =>
        GradientLUTOut <= to_unsigned(16#00001A3#, 26);
      WHEN "0000000000001001" =>
        GradientLUTOut <= to_unsigned(16#00001AF#, 26);
      WHEN "0000000000001010" =>
        GradientLUTOut <= to_unsigned(16#00001BB#, 26);
      WHEN "0000000000001011" =>
        GradientLUTOut <= to_unsigned(16#00001C7#, 26);
      WHEN "0000000000001100" =>
        GradientLUTOut <= to_unsigned(16#00001D3#, 26);
      WHEN "0000000000001101" =>
        GradientLUTOut <= to_unsigned(16#00001E0#, 26);
      WHEN "0000000000001110" =>
        GradientLUTOut <= to_unsigned(16#00001EB#, 26);
      WHEN "0000000000001111" =>
        GradientLUTOut <= to_unsigned(16#00001F7#, 26);
      WHEN "0000000000010000" =>
        GradientLUTOut <= to_unsigned(16#0000202#, 26);
      WHEN "0000000000010001" =>
        GradientLUTOut <= to_unsigned(16#000020E#, 26);
      WHEN "0000000000010010" =>
        GradientLUTOut <= to_unsigned(16#000021A#, 26);
      WHEN "0000000000010011" =>
        GradientLUTOut <= to_unsigned(16#0000225#, 26);
      WHEN "0000000000010100" =>
        GradientLUTOut <= to_unsigned(16#0000230#, 26);
      WHEN "0000000000010101" =>
        GradientLUTOut <= to_unsigned(16#000023C#, 26);
      WHEN "0000000000010110" =>
        GradientLUTOut <= to_unsigned(16#0000246#, 26);
      WHEN "0000000000010111" =>
        GradientLUTOut <= to_unsigned(16#0000252#, 26);
      WHEN "0000000000011000" =>
        GradientLUTOut <= to_unsigned(16#000025D#, 26);
      WHEN "0000000000011001" =>
        GradientLUTOut <= to_unsigned(16#0000267#, 26);
      WHEN "0000000000011010" =>
        GradientLUTOut <= to_unsigned(16#0000272#, 26);
      WHEN "0000000000011011" =>
        GradientLUTOut <= to_unsigned(16#000027D#, 26);
      WHEN "0000000000011100" =>
        GradientLUTOut <= to_unsigned(16#0000287#, 26);
      WHEN "0000000000011101" =>
        GradientLUTOut <= to_unsigned(16#0000291#, 26);
      WHEN "0000000000011110" =>
        GradientLUTOut <= to_unsigned(16#000029C#, 26);
      WHEN "0000000000011111" =>
        GradientLUTOut <= to_unsigned(16#00002A6#, 26);
      WHEN "0000000000100000" =>
        GradientLUTOut <= to_unsigned(16#00002B0#, 26);
      WHEN "0000000000100001" =>
        GradientLUTOut <= to_unsigned(16#00002BA#, 26);
      WHEN "0000000000100010" =>
        GradientLUTOut <= to_unsigned(16#00002C3#, 26);
      WHEN "0000000000100011" =>
        GradientLUTOut <= to_unsigned(16#00002CD#, 26);
      WHEN "0000000000100100" =>
        GradientLUTOut <= to_unsigned(16#00002D6#, 26);
      WHEN "0000000000100101" =>
        GradientLUTOut <= to_unsigned(16#00002E0#, 26);
      WHEN "0000000000100110" =>
        GradientLUTOut <= to_unsigned(16#00002EA#, 26);
      WHEN "0000000000100111" =>
        GradientLUTOut <= to_unsigned(16#00002F3#, 26);
      WHEN "0000000000101000" =>
        GradientLUTOut <= to_unsigned(16#00002FC#, 26);
      WHEN "0000000000101001" =>
        GradientLUTOut <= to_unsigned(16#0000305#, 26);
      WHEN "0000000000101010" =>
        GradientLUTOut <= to_unsigned(16#000030E#, 26);
      WHEN "0000000000101011" =>
        GradientLUTOut <= to_unsigned(16#0000316#, 26);
      WHEN "0000000000101100" =>
        GradientLUTOut <= to_unsigned(16#000031F#, 26);
      WHEN "0000000000101101" =>
        GradientLUTOut <= to_unsigned(16#0000327#, 26);
      WHEN "0000000000101110" =>
        GradientLUTOut <= to_unsigned(16#000032F#, 26);
      WHEN "0000000000101111" =>
        GradientLUTOut <= to_unsigned(16#0000337#, 26);
      WHEN "0000000000110000" =>
        GradientLUTOut <= to_unsigned(16#0000340#, 26);
      WHEN "0000000000110001" =>
        GradientLUTOut <= to_unsigned(16#0000348#, 26);
      WHEN "0000000000110010" =>
        GradientLUTOut <= to_unsigned(16#000034F#, 26);
      WHEN "0000000000110011" =>
        GradientLUTOut <= to_unsigned(16#0000358#, 26);
      WHEN "0000000000110100" =>
        GradientLUTOut <= to_unsigned(16#000035F#, 26);
      WHEN "0000000000110101" =>
        GradientLUTOut <= to_unsigned(16#0000000#, 26);
      WHEN OTHERS => 
        GradientLUTOut <= to_unsigned(16#0000000#, 26);
    END CASE;
  END PROCESS GradientLUT_output;


  reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        GradientLUTOutD <= to_unsigned(16#0000000#, 26);
      ELSIF enb = '1' THEN
        GradientLUTOutD <= GradientLUTOut;
      END IF;
    END IF;
  END PROCESS reg_process;


  multiplier_mul_temp <= ColumnCountInD * GradientLUTOutD;
  ReadAddressGradient <= multiplier_mul_temp(25 DOWNTO 0);

  intdelay_2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg_2 <= (OTHERS => to_unsigned(16#0000000#, 26));
      ELSIF enb = '1' THEN
        intdelay_reg_2(0) <= ReadAddressGradient;
        intdelay_reg_2(1) <= intdelay_reg_2(0);
      END IF;
    END IF;
  END PROCESS intdelay_2_process;

  ReadAddressGradientD <= intdelay_reg_2(1);

  -- Coefficient table for Offset Values
  OffsetLUT_output : PROCESS (LineLUTCountD)
  BEGIN
    CASE LineLUTCountD IS
      WHEN "0000000000000000" =>
        OffsetLUTValue <= to_unsigned(16#003687F#, 26);
      WHEN "0000000000000001" =>
        OffsetLUTValue <= to_unsigned(16#0035FE7#, 26);
      WHEN "0000000000000010" =>
        OffsetLUTValue <= to_unsigned(16#0035049#, 26);
      WHEN "0000000000000011" =>
        OffsetLUTValue <= to_unsigned(16#0034068#, 26);
      WHEN "0000000000000100" =>
        OffsetLUTValue <= to_unsigned(16#00330DD#, 26);
      WHEN "0000000000000101" =>
        OffsetLUTValue <= to_unsigned(16#003214D#, 26);
      WHEN "0000000000000110" =>
        OffsetLUTValue <= to_unsigned(16#00311D6#, 26);
      WHEN "0000000000000111" =>
        OffsetLUTValue <= to_unsigned(16#0030296#, 26);
      WHEN "0000000000001000" =>
        OffsetLUTValue <= to_unsigned(16#002F307#, 26);
      WHEN "0000000000001001" =>
        OffsetLUTValue <= to_unsigned(16#002E3E6#, 26);
      WHEN "0000000000001010" =>
        OffsetLUTValue <= to_unsigned(16#002D49C#, 26);
      WHEN "0000000000001011" =>
        OffsetLUTValue <= to_unsigned(16#002C538#, 26);
      WHEN "0000000000001100" =>
        OffsetLUTValue <= to_unsigned(16#002B69D#, 26);
      WHEN "0000000000001101" =>
        OffsetLUTValue <= to_unsigned(16#002A73C#, 26);
      WHEN "0000000000001110" =>
        OffsetLUTValue <= to_unsigned(16#00298DD#, 26);
      WHEN "0000000000001111" =>
        OffsetLUTValue <= to_unsigned(16#00289C8#, 26);
      WHEN "0000000000010000" =>
        OffsetLUTValue <= to_unsigned(16#0027BF6#, 26);
      WHEN "0000000000010001" =>
        OffsetLUTValue <= to_unsigned(16#0026D84#, 26);
      WHEN "0000000000010010" =>
        OffsetLUTValue <= to_unsigned(16#0025E68#, 26);
      WHEN "0000000000010011" =>
        OffsetLUTValue <= to_unsigned(16#00250E3#, 26);
      WHEN "0000000000010100" =>
        OffsetLUTValue <= to_unsigned(16#00242CF#, 26);
      WHEN "0000000000010101" =>
        OffsetLUTValue <= to_unsigned(16#0023424#, 26);
      WHEN "0000000000010110" =>
        OffsetLUTValue <= to_unsigned(16#002276F#, 26);
      WHEN "0000000000010111" =>
        OffsetLUTValue <= to_unsigned(16#00218EC#, 26);
      WHEN "0000000000011000" =>
        OffsetLUTValue <= to_unsigned(16#0020B38#, 26);
      WHEN "0000000000011001" =>
        OffsetLUTValue <= to_unsigned(16#001FE71#, 26);
      WHEN "0000000000011010" =>
        OffsetLUTValue <= to_unsigned(16#001F139#, 26);
      WHEN "0000000000011011" =>
        OffsetLUTValue <= to_unsigned(16#001E38A#, 26);
      WHEN "0000000000011100" =>
        OffsetLUTValue <= to_unsigned(16#001D6F7#, 26);
      WHEN "0000000000011101" =>
        OffsetLUTValue <= to_unsigned(16#001C9FD#, 26);
      WHEN "0000000000011110" =>
        OffsetLUTValue <= to_unsigned(16#001BC95#, 26);
      WHEN "0000000000011111" =>
        OffsetLUTValue <= to_unsigned(16#001B07D#, 26);
      WHEN "0000000000100000" =>
        OffsetLUTValue <= to_unsigned(16#001A40A#, 26);
      WHEN "0000000000100001" =>
        OffsetLUTValue <= to_unsigned(16#0019736#, 26);
      WHEN "0000000000100010" =>
        OffsetLUTValue <= to_unsigned(16#0018BE9#, 26);
      WHEN "0000000000100011" =>
        OffsetLUTValue <= to_unsigned(16#001804F#, 26);
      WHEN "0000000000100100" =>
        OffsetLUTValue <= to_unsigned(16#0017466#, 26);
      WHEN "0000000000100101" =>
        OffsetLUTValue <= to_unsigned(16#001682A#, 26);
      WHEN "0000000000100110" =>
        OffsetLUTValue <= to_unsigned(16#0015B98#, 26);
      WHEN "0000000000100111" =>
        OffsetLUTValue <= to_unsigned(16#00150DB#, 26);
      WHEN "0000000000101000" =>
        OffsetLUTValue <= to_unsigned(16#00145DC#, 26);
      WHEN "0000000000101001" =>
        OffsetLUTValue <= to_unsigned(16#0013A9B#, 26);
      WHEN "0000000000101010" =>
        OffsetLUTValue <= to_unsigned(16#0012F15#, 26);
      WHEN "0000000000101011" =>
        OffsetLUTValue <= to_unsigned(16#00125AA#, 26);
      WHEN "0000000000101100" =>
        OffsetLUTValue <= to_unsigned(16#00119A1#, 26);
      WHEN "0000000000101101" =>
        OffsetLUTValue <= to_unsigned(16#0010FCA#, 26);
      WHEN "0000000000101110" =>
        OffsetLUTValue <= to_unsigned(16#00105C0#, 26);
      WHEN "0000000000101111" =>
        OffsetLUTValue <= to_unsigned(16#000FB82#, 26);
      WHEN "0000000000110000" =>
        OffsetLUTValue <= to_unsigned(16#000F10F#, 26);
      WHEN "0000000000110001" =>
        OffsetLUTValue <= to_unsigned(16#000E664#, 26);
      WHEN "0000000000110010" =>
        OffsetLUTValue <= to_unsigned(16#000DE3F#, 26);
      WHEN "0000000000110011" =>
        OffsetLUTValue <= to_unsigned(16#000D330#, 26);
      WHEN "0000000000110100" =>
        OffsetLUTValue <= to_unsigned(16#000CABD#, 26);
      WHEN "0000000000110101" =>
        OffsetLUTValue <= to_unsigned(16#0000000#, 26);
      WHEN OTHERS => 
        OffsetLUTValue <= to_unsigned(16#0000000#, 26);
    END CASE;
  END PROCESS OffsetLUT_output;


  intdelay_3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg_3 <= (OTHERS => to_unsigned(16#0000000#, 26));
      ELSIF enb = '1' THEN
        intdelay_reg_3(0) <= OffsetLUTValue;
        intdelay_reg_3(1) <= intdelay_reg_3(0);
      END IF;
    END IF;
  END PROCESS intdelay_3_process;

  OffsetLUTValueD <= intdelay_reg_3(1);

  ReadAddressOffsetCorrected <= ReadAddressGradientD + OffsetLUTValueD;

  reg_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        ReadAddressOffsetCorrected_1 <= to_unsigned(16#0000000#, 26);
      ELSIF enb = '1' THEN
        ReadAddressOffsetCorrected_1 <= ReadAddressOffsetCorrected;
      END IF;
    END IF;
  END PROCESS reg_1_process;


  BirdsEyeActivePixels <= to_unsigned(16#0280#, 16);

  reg_2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        BirdsEyeActivePixelsD <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' THEN
        BirdsEyeActivePixelsD <= BirdsEyeActivePixels;
      END IF;
    END IF;
  END PROCESS reg_2_process;


  RunDecodeAddress <= resize(LineLUTCountD * BirdsEyeActivePixelsD, 16);

  intdelay_4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        intdelay_reg_4 <= (OTHERS => to_unsigned(16#0000#, 16));
      ELSIF enb = '1' THEN
        intdelay_reg_4(0) <= RunDecodeAddress;
        intdelay_reg_4(1 TO 2) <= intdelay_reg_4(0 TO 1);
      END IF;
    END IF;
  END PROCESS intdelay_4_process;

  RunDecodeAddressD <= intdelay_reg_4(2);

  adder_add_cast <= ReadAddressOffsetCorrected_1(25 DOWNTO 10);
  readAddress_tmp <= adder_add_cast + RunDecodeAddressD;

  readAddress <= std_logic_vector(readAddress_tmp);

END rtl;

