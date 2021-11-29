LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.HDLLaneDetector_pkg.ALL;

ENTITY Vertical_Padder IS
  PORT( dataVectorIn                      :   IN    vector_of_std_logic_vector8(0 TO 15);  -- uint8 [16]
        verPadCount                       :   IN    std_logic_vector(10 DOWNTO 0);  -- ufix11
        dataVectorOut                     :   OUT   vector_of_std_logic_vector8(0 TO 15)  -- uint8 [16]
        );
END Vertical_Padder;


ARCHITECTURE rtl OF Vertical_Padder IS

  -- Signals
  SIGNAL verPadCount_unsigned             : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL dataVectorIn_0                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataVectorIn_1                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataVectorIn_3                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataVectorIn_5                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataVectorIn_7                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataVectorIn_9                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataVectorIn_11                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataVectorIn_13                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataVectorIn_15                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL DataLineOut1                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataVectorIn_2                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataVectorIn_4                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataVectorIn_6                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataVectorIn_8                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataVectorIn_10                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataVectorIn_12                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataVectorIn_14                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL DataLineOut2                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL DataLineOut3                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL DataLineOut4                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL DataLineOut5                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL DataLineOut6                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL DataLineOut7                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL DataLineOut8                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL DataLineOut10                    : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL DataLineOut11                    : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL DataLineOut12                    : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL DataLineOut13                    : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL DataLineOut14                    : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL DataLineOut15                    : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL DataLineOut16                    : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataVectorOut_tmp                : vector_of_unsigned8(0 TO 15);  -- uint8 [16]

BEGIN
  verPadCount_unsigned <= unsigned(verPadCount);

  dataVectorIn_0 <= unsigned(dataVectorIn(0));

  dataVectorIn_1 <= unsigned(dataVectorIn(1));

  dataVectorIn_3 <= unsigned(dataVectorIn(3));

  dataVectorIn_5 <= unsigned(dataVectorIn(5));

  dataVectorIn_7 <= unsigned(dataVectorIn(7));

  dataVectorIn_9 <= unsigned(dataVectorIn(9));

  dataVectorIn_11 <= unsigned(dataVectorIn(11));

  dataVectorIn_13 <= unsigned(dataVectorIn(13));

  dataVectorIn_15 <= unsigned(dataVectorIn(15));

  
  DataLineOut1 <= dataVectorIn_0 WHEN verPadCount_unsigned = to_unsigned(16#000#, 11) ELSE
      dataVectorIn_0 WHEN verPadCount_unsigned = to_unsigned(16#001#, 11) ELSE
      dataVectorIn_0 WHEN verPadCount_unsigned = to_unsigned(16#002#, 11) ELSE
      dataVectorIn_0 WHEN verPadCount_unsigned = to_unsigned(16#003#, 11) ELSE
      dataVectorIn_0 WHEN verPadCount_unsigned = to_unsigned(16#004#, 11) ELSE
      dataVectorIn_0 WHEN verPadCount_unsigned = to_unsigned(16#005#, 11) ELSE
      dataVectorIn_0 WHEN verPadCount_unsigned = to_unsigned(16#006#, 11) ELSE
      dataVectorIn_0 WHEN verPadCount_unsigned = to_unsigned(16#007#, 11) ELSE
      dataVectorIn_1 WHEN verPadCount_unsigned = to_unsigned(16#008#, 11) ELSE
      dataVectorIn_3 WHEN verPadCount_unsigned = to_unsigned(16#009#, 11) ELSE
      dataVectorIn_5 WHEN verPadCount_unsigned = to_unsigned(16#00A#, 11) ELSE
      dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#00B#, 11) ELSE
      dataVectorIn_9 WHEN verPadCount_unsigned = to_unsigned(16#00C#, 11) ELSE
      dataVectorIn_11 WHEN verPadCount_unsigned = to_unsigned(16#00D#, 11) ELSE
      dataVectorIn_13 WHEN verPadCount_unsigned = to_unsigned(16#00E#, 11) ELSE
      dataVectorIn_15;

  dataVectorIn_2 <= unsigned(dataVectorIn(2));

  dataVectorIn_4 <= unsigned(dataVectorIn(4));

  dataVectorIn_6 <= unsigned(dataVectorIn(6));

  dataVectorIn_8 <= unsigned(dataVectorIn(8));

  dataVectorIn_10 <= unsigned(dataVectorIn(10));

  dataVectorIn_12 <= unsigned(dataVectorIn(12));

  dataVectorIn_14 <= unsigned(dataVectorIn(14));

  
  DataLineOut2 <= dataVectorIn_1 WHEN verPadCount_unsigned = to_unsigned(16#000#, 11) ELSE
      dataVectorIn_1 WHEN verPadCount_unsigned = to_unsigned(16#001#, 11) ELSE
      dataVectorIn_1 WHEN verPadCount_unsigned = to_unsigned(16#002#, 11) ELSE
      dataVectorIn_1 WHEN verPadCount_unsigned = to_unsigned(16#003#, 11) ELSE
      dataVectorIn_1 WHEN verPadCount_unsigned = to_unsigned(16#004#, 11) ELSE
      dataVectorIn_1 WHEN verPadCount_unsigned = to_unsigned(16#005#, 11) ELSE
      dataVectorIn_1 WHEN verPadCount_unsigned = to_unsigned(16#006#, 11) ELSE
      dataVectorIn_1 WHEN verPadCount_unsigned = to_unsigned(16#007#, 11) ELSE
      dataVectorIn_1 WHEN verPadCount_unsigned = to_unsigned(16#008#, 11) ELSE
      dataVectorIn_2 WHEN verPadCount_unsigned = to_unsigned(16#009#, 11) ELSE
      dataVectorIn_4 WHEN verPadCount_unsigned = to_unsigned(16#00A#, 11) ELSE
      dataVectorIn_6 WHEN verPadCount_unsigned = to_unsigned(16#00B#, 11) ELSE
      dataVectorIn_8 WHEN verPadCount_unsigned = to_unsigned(16#00C#, 11) ELSE
      dataVectorIn_10 WHEN verPadCount_unsigned = to_unsigned(16#00D#, 11) ELSE
      dataVectorIn_12 WHEN verPadCount_unsigned = to_unsigned(16#00E#, 11) ELSE
      dataVectorIn_14;

  
  DataLineOut3 <= dataVectorIn_2 WHEN verPadCount_unsigned = to_unsigned(16#000#, 11) ELSE
      dataVectorIn_2 WHEN verPadCount_unsigned = to_unsigned(16#001#, 11) ELSE
      dataVectorIn_2 WHEN verPadCount_unsigned = to_unsigned(16#002#, 11) ELSE
      dataVectorIn_2 WHEN verPadCount_unsigned = to_unsigned(16#003#, 11) ELSE
      dataVectorIn_2 WHEN verPadCount_unsigned = to_unsigned(16#004#, 11) ELSE
      dataVectorIn_2 WHEN verPadCount_unsigned = to_unsigned(16#005#, 11) ELSE
      dataVectorIn_2 WHEN verPadCount_unsigned = to_unsigned(16#006#, 11) ELSE
      dataVectorIn_2 WHEN verPadCount_unsigned = to_unsigned(16#007#, 11) ELSE
      dataVectorIn_2 WHEN verPadCount_unsigned = to_unsigned(16#008#, 11) ELSE
      dataVectorIn_2 WHEN verPadCount_unsigned = to_unsigned(16#009#, 11) ELSE
      dataVectorIn_3 WHEN verPadCount_unsigned = to_unsigned(16#00A#, 11) ELSE
      dataVectorIn_5 WHEN verPadCount_unsigned = to_unsigned(16#00B#, 11) ELSE
      dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#00C#, 11) ELSE
      dataVectorIn_9 WHEN verPadCount_unsigned = to_unsigned(16#00D#, 11) ELSE
      dataVectorIn_11 WHEN verPadCount_unsigned = to_unsigned(16#00E#, 11) ELSE
      dataVectorIn_13;

  
  DataLineOut4 <= dataVectorIn_3 WHEN verPadCount_unsigned = to_unsigned(16#000#, 11) ELSE
      dataVectorIn_3 WHEN verPadCount_unsigned = to_unsigned(16#001#, 11) ELSE
      dataVectorIn_3 WHEN verPadCount_unsigned = to_unsigned(16#002#, 11) ELSE
      dataVectorIn_3 WHEN verPadCount_unsigned = to_unsigned(16#003#, 11) ELSE
      dataVectorIn_3 WHEN verPadCount_unsigned = to_unsigned(16#004#, 11) ELSE
      dataVectorIn_3 WHEN verPadCount_unsigned = to_unsigned(16#005#, 11) ELSE
      dataVectorIn_3 WHEN verPadCount_unsigned = to_unsigned(16#006#, 11) ELSE
      dataVectorIn_3 WHEN verPadCount_unsigned = to_unsigned(16#007#, 11) ELSE
      dataVectorIn_3 WHEN verPadCount_unsigned = to_unsigned(16#008#, 11) ELSE
      dataVectorIn_3 WHEN verPadCount_unsigned = to_unsigned(16#009#, 11) ELSE
      dataVectorIn_3 WHEN verPadCount_unsigned = to_unsigned(16#00A#, 11) ELSE
      dataVectorIn_4 WHEN verPadCount_unsigned = to_unsigned(16#00B#, 11) ELSE
      dataVectorIn_6 WHEN verPadCount_unsigned = to_unsigned(16#00C#, 11) ELSE
      dataVectorIn_8 WHEN verPadCount_unsigned = to_unsigned(16#00D#, 11) ELSE
      dataVectorIn_10 WHEN verPadCount_unsigned = to_unsigned(16#00E#, 11) ELSE
      dataVectorIn_12;

  
  DataLineOut5 <= dataVectorIn_4 WHEN verPadCount_unsigned = to_unsigned(16#000#, 11) ELSE
      dataVectorIn_4 WHEN verPadCount_unsigned = to_unsigned(16#001#, 11) ELSE
      dataVectorIn_4 WHEN verPadCount_unsigned = to_unsigned(16#002#, 11) ELSE
      dataVectorIn_4 WHEN verPadCount_unsigned = to_unsigned(16#003#, 11) ELSE
      dataVectorIn_4 WHEN verPadCount_unsigned = to_unsigned(16#004#, 11) ELSE
      dataVectorIn_4 WHEN verPadCount_unsigned = to_unsigned(16#005#, 11) ELSE
      dataVectorIn_4 WHEN verPadCount_unsigned = to_unsigned(16#006#, 11) ELSE
      dataVectorIn_4 WHEN verPadCount_unsigned = to_unsigned(16#007#, 11) ELSE
      dataVectorIn_4 WHEN verPadCount_unsigned = to_unsigned(16#008#, 11) ELSE
      dataVectorIn_4 WHEN verPadCount_unsigned = to_unsigned(16#009#, 11) ELSE
      dataVectorIn_4 WHEN verPadCount_unsigned = to_unsigned(16#00A#, 11) ELSE
      dataVectorIn_4 WHEN verPadCount_unsigned = to_unsigned(16#00B#, 11) ELSE
      dataVectorIn_5 WHEN verPadCount_unsigned = to_unsigned(16#00C#, 11) ELSE
      dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#00D#, 11) ELSE
      dataVectorIn_9 WHEN verPadCount_unsigned = to_unsigned(16#00E#, 11) ELSE
      dataVectorIn_11;

  
  DataLineOut6 <= dataVectorIn_5 WHEN verPadCount_unsigned = to_unsigned(16#000#, 11) ELSE
      dataVectorIn_5 WHEN verPadCount_unsigned = to_unsigned(16#001#, 11) ELSE
      dataVectorIn_5 WHEN verPadCount_unsigned = to_unsigned(16#002#, 11) ELSE
      dataVectorIn_5 WHEN verPadCount_unsigned = to_unsigned(16#003#, 11) ELSE
      dataVectorIn_5 WHEN verPadCount_unsigned = to_unsigned(16#004#, 11) ELSE
      dataVectorIn_5 WHEN verPadCount_unsigned = to_unsigned(16#005#, 11) ELSE
      dataVectorIn_5 WHEN verPadCount_unsigned = to_unsigned(16#006#, 11) ELSE
      dataVectorIn_5 WHEN verPadCount_unsigned = to_unsigned(16#007#, 11) ELSE
      dataVectorIn_5 WHEN verPadCount_unsigned = to_unsigned(16#008#, 11) ELSE
      dataVectorIn_5 WHEN verPadCount_unsigned = to_unsigned(16#009#, 11) ELSE
      dataVectorIn_5 WHEN verPadCount_unsigned = to_unsigned(16#00A#, 11) ELSE
      dataVectorIn_5 WHEN verPadCount_unsigned = to_unsigned(16#00B#, 11) ELSE
      dataVectorIn_5 WHEN verPadCount_unsigned = to_unsigned(16#00C#, 11) ELSE
      dataVectorIn_6 WHEN verPadCount_unsigned = to_unsigned(16#00D#, 11) ELSE
      dataVectorIn_8 WHEN verPadCount_unsigned = to_unsigned(16#00E#, 11) ELSE
      dataVectorIn_10;

  
  DataLineOut7 <= dataVectorIn_6 WHEN verPadCount_unsigned = to_unsigned(16#000#, 11) ELSE
      dataVectorIn_6 WHEN verPadCount_unsigned = to_unsigned(16#001#, 11) ELSE
      dataVectorIn_6 WHEN verPadCount_unsigned = to_unsigned(16#002#, 11) ELSE
      dataVectorIn_6 WHEN verPadCount_unsigned = to_unsigned(16#003#, 11) ELSE
      dataVectorIn_6 WHEN verPadCount_unsigned = to_unsigned(16#004#, 11) ELSE
      dataVectorIn_6 WHEN verPadCount_unsigned = to_unsigned(16#005#, 11) ELSE
      dataVectorIn_6 WHEN verPadCount_unsigned = to_unsigned(16#006#, 11) ELSE
      dataVectorIn_6 WHEN verPadCount_unsigned = to_unsigned(16#007#, 11) ELSE
      dataVectorIn_6 WHEN verPadCount_unsigned = to_unsigned(16#008#, 11) ELSE
      dataVectorIn_6 WHEN verPadCount_unsigned = to_unsigned(16#009#, 11) ELSE
      dataVectorIn_6 WHEN verPadCount_unsigned = to_unsigned(16#00A#, 11) ELSE
      dataVectorIn_6 WHEN verPadCount_unsigned = to_unsigned(16#00B#, 11) ELSE
      dataVectorIn_6 WHEN verPadCount_unsigned = to_unsigned(16#00C#, 11) ELSE
      dataVectorIn_6 WHEN verPadCount_unsigned = to_unsigned(16#00D#, 11) ELSE
      dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#00E#, 11) ELSE
      dataVectorIn_9;

  
  DataLineOut8 <= dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#000#, 11) ELSE
      dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#001#, 11) ELSE
      dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#002#, 11) ELSE
      dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#003#, 11) ELSE
      dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#004#, 11) ELSE
      dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#005#, 11) ELSE
      dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#006#, 11) ELSE
      dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#007#, 11) ELSE
      dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#008#, 11) ELSE
      dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#009#, 11) ELSE
      dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#00A#, 11) ELSE
      dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#00B#, 11) ELSE
      dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#00C#, 11) ELSE
      dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#00D#, 11) ELSE
      dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#00E#, 11) ELSE
      dataVectorIn_8;

  
  DataLineOut10 <= dataVectorIn_8 WHEN verPadCount_unsigned = to_unsigned(16#000#, 11) ELSE
      dataVectorIn_9 WHEN verPadCount_unsigned = to_unsigned(16#001#, 11) ELSE
      dataVectorIn_9 WHEN verPadCount_unsigned = to_unsigned(16#002#, 11) ELSE
      dataVectorIn_9 WHEN verPadCount_unsigned = to_unsigned(16#003#, 11) ELSE
      dataVectorIn_9 WHEN verPadCount_unsigned = to_unsigned(16#004#, 11) ELSE
      dataVectorIn_9 WHEN verPadCount_unsigned = to_unsigned(16#005#, 11) ELSE
      dataVectorIn_9 WHEN verPadCount_unsigned = to_unsigned(16#006#, 11) ELSE
      dataVectorIn_9 WHEN verPadCount_unsigned = to_unsigned(16#007#, 11) ELSE
      dataVectorIn_9 WHEN verPadCount_unsigned = to_unsigned(16#008#, 11) ELSE
      dataVectorIn_9 WHEN verPadCount_unsigned = to_unsigned(16#009#, 11) ELSE
      dataVectorIn_9 WHEN verPadCount_unsigned = to_unsigned(16#00A#, 11) ELSE
      dataVectorIn_9 WHEN verPadCount_unsigned = to_unsigned(16#00B#, 11) ELSE
      dataVectorIn_9 WHEN verPadCount_unsigned = to_unsigned(16#00C#, 11) ELSE
      dataVectorIn_9 WHEN verPadCount_unsigned = to_unsigned(16#00D#, 11) ELSE
      dataVectorIn_9 WHEN verPadCount_unsigned = to_unsigned(16#00E#, 11) ELSE
      dataVectorIn_9;

  
  DataLineOut11 <= dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#000#, 11) ELSE
      dataVectorIn_9 WHEN verPadCount_unsigned = to_unsigned(16#001#, 11) ELSE
      dataVectorIn_10 WHEN verPadCount_unsigned = to_unsigned(16#002#, 11) ELSE
      dataVectorIn_10 WHEN verPadCount_unsigned = to_unsigned(16#003#, 11) ELSE
      dataVectorIn_10 WHEN verPadCount_unsigned = to_unsigned(16#004#, 11) ELSE
      dataVectorIn_10 WHEN verPadCount_unsigned = to_unsigned(16#005#, 11) ELSE
      dataVectorIn_10 WHEN verPadCount_unsigned = to_unsigned(16#006#, 11) ELSE
      dataVectorIn_10 WHEN verPadCount_unsigned = to_unsigned(16#007#, 11) ELSE
      dataVectorIn_10 WHEN verPadCount_unsigned = to_unsigned(16#008#, 11) ELSE
      dataVectorIn_10 WHEN verPadCount_unsigned = to_unsigned(16#009#, 11) ELSE
      dataVectorIn_10 WHEN verPadCount_unsigned = to_unsigned(16#00A#, 11) ELSE
      dataVectorIn_10 WHEN verPadCount_unsigned = to_unsigned(16#00B#, 11) ELSE
      dataVectorIn_10 WHEN verPadCount_unsigned = to_unsigned(16#00C#, 11) ELSE
      dataVectorIn_10 WHEN verPadCount_unsigned = to_unsigned(16#00D#, 11) ELSE
      dataVectorIn_10 WHEN verPadCount_unsigned = to_unsigned(16#00E#, 11) ELSE
      dataVectorIn_10;

  
  DataLineOut12 <= dataVectorIn_6 WHEN verPadCount_unsigned = to_unsigned(16#000#, 11) ELSE
      dataVectorIn_8 WHEN verPadCount_unsigned = to_unsigned(16#001#, 11) ELSE
      dataVectorIn_10 WHEN verPadCount_unsigned = to_unsigned(16#002#, 11) ELSE
      dataVectorIn_11 WHEN verPadCount_unsigned = to_unsigned(16#003#, 11) ELSE
      dataVectorIn_11 WHEN verPadCount_unsigned = to_unsigned(16#004#, 11) ELSE
      dataVectorIn_11 WHEN verPadCount_unsigned = to_unsigned(16#005#, 11) ELSE
      dataVectorIn_11 WHEN verPadCount_unsigned = to_unsigned(16#006#, 11) ELSE
      dataVectorIn_11 WHEN verPadCount_unsigned = to_unsigned(16#007#, 11) ELSE
      dataVectorIn_11 WHEN verPadCount_unsigned = to_unsigned(16#008#, 11) ELSE
      dataVectorIn_11 WHEN verPadCount_unsigned = to_unsigned(16#009#, 11) ELSE
      dataVectorIn_11 WHEN verPadCount_unsigned = to_unsigned(16#00A#, 11) ELSE
      dataVectorIn_11 WHEN verPadCount_unsigned = to_unsigned(16#00B#, 11) ELSE
      dataVectorIn_11 WHEN verPadCount_unsigned = to_unsigned(16#00C#, 11) ELSE
      dataVectorIn_11 WHEN verPadCount_unsigned = to_unsigned(16#00D#, 11) ELSE
      dataVectorIn_11 WHEN verPadCount_unsigned = to_unsigned(16#00E#, 11) ELSE
      dataVectorIn_11;

  
  DataLineOut13 <= dataVectorIn_5 WHEN verPadCount_unsigned = to_unsigned(16#000#, 11) ELSE
      dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#001#, 11) ELSE
      dataVectorIn_9 WHEN verPadCount_unsigned = to_unsigned(16#002#, 11) ELSE
      dataVectorIn_11 WHEN verPadCount_unsigned = to_unsigned(16#003#, 11) ELSE
      dataVectorIn_12 WHEN verPadCount_unsigned = to_unsigned(16#004#, 11) ELSE
      dataVectorIn_12 WHEN verPadCount_unsigned = to_unsigned(16#005#, 11) ELSE
      dataVectorIn_12 WHEN verPadCount_unsigned = to_unsigned(16#006#, 11) ELSE
      dataVectorIn_12 WHEN verPadCount_unsigned = to_unsigned(16#007#, 11) ELSE
      dataVectorIn_12 WHEN verPadCount_unsigned = to_unsigned(16#008#, 11) ELSE
      dataVectorIn_12 WHEN verPadCount_unsigned = to_unsigned(16#009#, 11) ELSE
      dataVectorIn_12 WHEN verPadCount_unsigned = to_unsigned(16#00A#, 11) ELSE
      dataVectorIn_12 WHEN verPadCount_unsigned = to_unsigned(16#00B#, 11) ELSE
      dataVectorIn_12 WHEN verPadCount_unsigned = to_unsigned(16#00C#, 11) ELSE
      dataVectorIn_12 WHEN verPadCount_unsigned = to_unsigned(16#00D#, 11) ELSE
      dataVectorIn_12 WHEN verPadCount_unsigned = to_unsigned(16#00E#, 11) ELSE
      dataVectorIn_12;

  
  DataLineOut14 <= dataVectorIn_4 WHEN verPadCount_unsigned = to_unsigned(16#000#, 11) ELSE
      dataVectorIn_6 WHEN verPadCount_unsigned = to_unsigned(16#001#, 11) ELSE
      dataVectorIn_8 WHEN verPadCount_unsigned = to_unsigned(16#002#, 11) ELSE
      dataVectorIn_10 WHEN verPadCount_unsigned = to_unsigned(16#003#, 11) ELSE
      dataVectorIn_12 WHEN verPadCount_unsigned = to_unsigned(16#004#, 11) ELSE
      dataVectorIn_13 WHEN verPadCount_unsigned = to_unsigned(16#005#, 11) ELSE
      dataVectorIn_13 WHEN verPadCount_unsigned = to_unsigned(16#006#, 11) ELSE
      dataVectorIn_13 WHEN verPadCount_unsigned = to_unsigned(16#007#, 11) ELSE
      dataVectorIn_13 WHEN verPadCount_unsigned = to_unsigned(16#008#, 11) ELSE
      dataVectorIn_13 WHEN verPadCount_unsigned = to_unsigned(16#009#, 11) ELSE
      dataVectorIn_13 WHEN verPadCount_unsigned = to_unsigned(16#00A#, 11) ELSE
      dataVectorIn_13 WHEN verPadCount_unsigned = to_unsigned(16#00B#, 11) ELSE
      dataVectorIn_13 WHEN verPadCount_unsigned = to_unsigned(16#00C#, 11) ELSE
      dataVectorIn_13 WHEN verPadCount_unsigned = to_unsigned(16#00D#, 11) ELSE
      dataVectorIn_13 WHEN verPadCount_unsigned = to_unsigned(16#00E#, 11) ELSE
      dataVectorIn_13;

  
  DataLineOut15 <= dataVectorIn_3 WHEN verPadCount_unsigned = to_unsigned(16#000#, 11) ELSE
      dataVectorIn_5 WHEN verPadCount_unsigned = to_unsigned(16#001#, 11) ELSE
      dataVectorIn_7 WHEN verPadCount_unsigned = to_unsigned(16#002#, 11) ELSE
      dataVectorIn_9 WHEN verPadCount_unsigned = to_unsigned(16#003#, 11) ELSE
      dataVectorIn_11 WHEN verPadCount_unsigned = to_unsigned(16#004#, 11) ELSE
      dataVectorIn_13 WHEN verPadCount_unsigned = to_unsigned(16#005#, 11) ELSE
      dataVectorIn_14 WHEN verPadCount_unsigned = to_unsigned(16#006#, 11) ELSE
      dataVectorIn_14 WHEN verPadCount_unsigned = to_unsigned(16#007#, 11) ELSE
      dataVectorIn_14 WHEN verPadCount_unsigned = to_unsigned(16#008#, 11) ELSE
      dataVectorIn_14 WHEN verPadCount_unsigned = to_unsigned(16#009#, 11) ELSE
      dataVectorIn_14 WHEN verPadCount_unsigned = to_unsigned(16#00A#, 11) ELSE
      dataVectorIn_14 WHEN verPadCount_unsigned = to_unsigned(16#00B#, 11) ELSE
      dataVectorIn_14 WHEN verPadCount_unsigned = to_unsigned(16#00C#, 11) ELSE
      dataVectorIn_14 WHEN verPadCount_unsigned = to_unsigned(16#00D#, 11) ELSE
      dataVectorIn_14 WHEN verPadCount_unsigned = to_unsigned(16#00E#, 11) ELSE
      dataVectorIn_14;

  
  DataLineOut16 <= dataVectorIn_2 WHEN verPadCount_unsigned = to_unsigned(16#000#, 11) ELSE
      dataVectorIn_4 WHEN verPadCount_unsigned = to_unsigned(16#001#, 11) ELSE
      dataVectorIn_6 WHEN verPadCount_unsigned = to_unsigned(16#002#, 11) ELSE
      dataVectorIn_8 WHEN verPadCount_unsigned = to_unsigned(16#003#, 11) ELSE
      dataVectorIn_10 WHEN verPadCount_unsigned = to_unsigned(16#004#, 11) ELSE
      dataVectorIn_12 WHEN verPadCount_unsigned = to_unsigned(16#005#, 11) ELSE
      dataVectorIn_14 WHEN verPadCount_unsigned = to_unsigned(16#006#, 11) ELSE
      dataVectorIn_15 WHEN verPadCount_unsigned = to_unsigned(16#007#, 11) ELSE
      dataVectorIn_15 WHEN verPadCount_unsigned = to_unsigned(16#008#, 11) ELSE
      dataVectorIn_15 WHEN verPadCount_unsigned = to_unsigned(16#009#, 11) ELSE
      dataVectorIn_15 WHEN verPadCount_unsigned = to_unsigned(16#00A#, 11) ELSE
      dataVectorIn_15 WHEN verPadCount_unsigned = to_unsigned(16#00B#, 11) ELSE
      dataVectorIn_15 WHEN verPadCount_unsigned = to_unsigned(16#00C#, 11) ELSE
      dataVectorIn_15 WHEN verPadCount_unsigned = to_unsigned(16#00D#, 11) ELSE
      dataVectorIn_15 WHEN verPadCount_unsigned = to_unsigned(16#00E#, 11) ELSE
      dataVectorIn_15;

  dataVectorOut_tmp(0) <= DataLineOut1;
  dataVectorOut_tmp(1) <= DataLineOut2;
  dataVectorOut_tmp(2) <= DataLineOut3;
  dataVectorOut_tmp(3) <= DataLineOut4;
  dataVectorOut_tmp(4) <= DataLineOut5;
  dataVectorOut_tmp(5) <= DataLineOut6;
  dataVectorOut_tmp(6) <= DataLineOut7;
  dataVectorOut_tmp(7) <= DataLineOut8;
  dataVectorOut_tmp(8) <= unsigned(dataVectorIn(8));
  dataVectorOut_tmp(9) <= DataLineOut10;
  dataVectorOut_tmp(10) <= DataLineOut11;
  dataVectorOut_tmp(11) <= DataLineOut12;
  dataVectorOut_tmp(12) <= DataLineOut13;
  dataVectorOut_tmp(13) <= DataLineOut14;
  dataVectorOut_tmp(14) <= DataLineOut15;
  dataVectorOut_tmp(15) <= DataLineOut16;

  outputgen: FOR k IN 0 TO 15 GENERATE
    dataVectorOut(k) <= std_logic_vector(dataVectorOut_tmp(k));
  END GENERATE;

END rtl;

