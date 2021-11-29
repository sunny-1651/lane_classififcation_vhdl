LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.HDLLaneDetector_pkg.ALL;

ENTITY FIR2DKernel IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        dataIn                            :   IN    vector_of_std_logic_vector8(0 TO 15);  -- uint8 [16]
        vStartIn                          :   IN    std_logic;
        vEndIn                            :   IN    std_logic;
        hStartIn                          :   IN    std_logic;
        hEndIn                            :   IN    std_logic;
        validIn                           :   IN    std_logic;
        processData                       :   IN    std_logic;
        dataOut                           :   OUT   std_logic_vector(23 DOWNTO 0);  -- sfix24_En15
        vStartOut                         :   OUT   std_logic;
        vEndOut                           :   OUT   std_logic;
        hStartOut                         :   OUT   std_logic;
        hEndOut                           :   OUT   std_logic;
        validOut                          :   OUT   std_logic
        );
END FIR2DKernel;


ARCHITECTURE rtl OF FIR2DKernel IS

  -- Signals
  SIGNAL dataIn_0                         : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapDelay_1_reg                   : vector_of_unsigned8(0 TO 6);  -- ufix8 [7]
  SIGNAL tapOutData_1                     : vector_of_unsigned8(0 TO 7);  -- uint8 [8]
  SIGNAL tapOutData_1_4                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd1_stage1_1                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_1_3                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd1_stage1_2                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp              : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd1_stage1_add_1             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd1_stage2_1                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL dataIn_1                         : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapDelay_2_reg                   : vector_of_unsigned8(0 TO 6);  -- ufix8 [7]
  SIGNAL tapOutData_2                     : vector_of_unsigned8(0 TO 7);  -- uint8 [8]
  SIGNAL tapOutData_2_4                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd1_stage1_3                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_2_3                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd1_stage1_4                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_1            : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd1_stage1_add_2             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd1_stage2_2                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd1_stage2_add_1             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd1_stage3_1                 : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL dataIn_14                        : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapDelay_15_reg                  : vector_of_unsigned8(0 TO 6);  -- ufix8 [7]
  SIGNAL tapOutData_15                    : vector_of_unsigned8(0 TO 7);  -- uint8 [8]
  SIGNAL tapOutData_15_4                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd1_stage1_5                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_15_3                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd1_stage1_6                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_2            : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd1_stage1_add_3             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd1_stage2_3                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL dataIn_15                        : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapDelay_16_reg                  : vector_of_unsigned8(0 TO 6);  -- ufix8 [7]
  SIGNAL tapOutData_16                    : vector_of_unsigned8(0 TO 7);  -- uint8 [8]
  SIGNAL tapOutData_16_4                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd1_stage1_7                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_16_3                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd1_stage1_8                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_3            : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd1_stage1_add_4             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd1_stage2_4                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd1_stage2_add_2             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd1_stage3_2                 : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd1_stage3_add_1             : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL preAdd1_final_reg                : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL multInDelay1_reg                 : vector_of_signed11(0 TO 1);  -- sfix11 [2]
  SIGNAL multInReg1                       : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL multOut1                         : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL multOutDelay1_reg                : vector_of_signed35(0 TO 1);  -- sfix35 [2]
  SIGNAL multOutReg1                      : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage1_1                     : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL dataIn_2                         : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapDelay_3_reg                   : vector_of_unsigned8(0 TO 6);  -- ufix8 [7]
  SIGNAL tapOutData_3                     : vector_of_unsigned8(0 TO 7);  -- uint8 [8]
  SIGNAL tapOutData_3_4                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd2_stage1_1                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_3_3                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd2_stage1_2                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_4            : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd2_stage1_add_1             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd2_stage2_1                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL dataIn_13                        : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapDelay_14_reg                  : vector_of_unsigned8(0 TO 6);  -- ufix8 [7]
  SIGNAL tapOutData_14                    : vector_of_unsigned8(0 TO 7);  -- uint8 [8]
  SIGNAL tapOutData_14_4                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd2_stage1_3                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_14_3                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd2_stage1_4                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_5            : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd2_stage1_add_2             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd2_stage2_2                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd2_stage2_add_1             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd2_final_reg                : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd2_balance_reg              : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multInDelay2_reg                 : vector_of_signed10(0 TO 1);  -- sfix10 [2]
  SIGNAL multInReg2                       : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multOut2                         : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL multOutDelay2_reg                : vector_of_signed34(0 TO 1);  -- sfix34 [2]
  SIGNAL multOutReg2                      : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL add_stage1_2                     : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL adder_add_cast                   : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL adder_add_cast_1                 : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL add_stage1_add_1                 : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL add_stage2_1                     : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL dataIn_3                         : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapDelay_4_reg                   : vector_of_unsigned8(0 TO 6);  -- ufix8 [7]
  SIGNAL tapOutData_4                     : vector_of_unsigned8(0 TO 7);  -- uint8 [8]
  SIGNAL tapOutData_4_4                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd3_stage1_1                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_4_3                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd3_stage1_2                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_6            : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd3_stage1_add_1             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd3_stage2_1                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL dataIn_12                        : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapDelay_13_reg                  : vector_of_unsigned8(0 TO 6);  -- ufix8 [7]
  SIGNAL tapOutData_13                    : vector_of_unsigned8(0 TO 7);  -- uint8 [8]
  SIGNAL tapOutData_13_4                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd3_stage1_3                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_13_3                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd3_stage1_4                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_7            : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd3_stage1_add_2             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd3_stage2_2                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd3_stage2_add_1             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd3_final_reg                : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd3_balance_reg              : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multInDelay3_reg                 : vector_of_signed10(0 TO 1);  -- sfix10 [2]
  SIGNAL multInReg3                       : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multOut3                         : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL multOutDelay3_reg                : vector_of_signed34(0 TO 1);  -- sfix34 [2]
  SIGNAL multOutReg3                      : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL add_stage1_3                     : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL dataIn_4                         : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapDelay_5_reg                   : vector_of_unsigned8(0 TO 6);  -- ufix8 [7]
  SIGNAL tapOutData_5                     : vector_of_unsigned8(0 TO 7);  -- uint8 [8]
  SIGNAL tapOutData_5_4                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd4_stage1_1                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_5_3                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd4_stage1_2                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_8            : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd4_stage1_add_1             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd4_stage2_1                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL dataIn_11                        : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapDelay_12_reg                  : vector_of_unsigned8(0 TO 6);  -- ufix8 [7]
  SIGNAL tapOutData_12                    : vector_of_unsigned8(0 TO 7);  -- uint8 [8]
  SIGNAL tapOutData_12_4                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd4_stage1_3                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_12_3                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd4_stage1_4                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_9            : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd4_stage1_add_2             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd4_stage2_2                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd4_stage2_add_1             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd4_final_reg                : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd4_balance_reg              : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multInDelay4_reg                 : vector_of_signed10(0 TO 1);  -- sfix10 [2]
  SIGNAL multInReg4                       : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multOut4                         : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL multOutDelay4_reg                : vector_of_signed34(0 TO 1);  -- sfix34 [2]
  SIGNAL multOutReg4                      : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL add_stage1_4                     : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL adder_add_cast_2                 : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL adder_add_cast_3                 : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage1_add_2                 : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage2_2                     : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL adder_add_cast_4                 : signed(36 DOWNTO 0);  -- sfix37_En15
  SIGNAL adder_add_cast_5                 : signed(36 DOWNTO 0);  -- sfix37_En15
  SIGNAL add_stage2_add_1                 : signed(36 DOWNTO 0);  -- sfix37_En15
  SIGNAL add_stage3_1                     : signed(36 DOWNTO 0);  -- sfix37_En15
  SIGNAL dataIn_5                         : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapDelay_6_reg                   : vector_of_unsigned8(0 TO 6);  -- ufix8 [7]
  SIGNAL tapOutData_6                     : vector_of_unsigned8(0 TO 7);  -- uint8 [8]
  SIGNAL tapOutData_6_4                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd5_stage1_1                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_1_2                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd5_stage1_2                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_10           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd5_stage1_add_1             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd5_stage2_1                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL dataIn_10                        : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapDelay_11_reg                  : vector_of_unsigned8(0 TO 6);  -- ufix8 [7]
  SIGNAL tapOutData_11                    : vector_of_unsigned8(0 TO 7);  -- uint8 [8]
  SIGNAL tapOutData_11_4                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd5_stage1_3                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_16_2                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd5_stage1_4                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_11           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd5_stage1_add_2             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd5_stage2_2                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd5_stage2_add_1             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd5_stage3_1                 : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL tapOutData_1_5                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd5_stage1_5                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_6_3                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd5_stage1_6                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_12           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd5_stage1_add_3             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd5_stage2_3                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_16_5                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd5_stage1_7                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_11_3                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd5_stage1_8                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_13           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd5_stage1_add_4             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd5_stage2_4                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd5_stage2_add_2             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd5_stage3_2                 : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd5_stage3_add_1             : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL preAdd5_final_reg                : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL multInDelay5_reg                 : vector_of_signed11(0 TO 1);  -- sfix11 [2]
  SIGNAL multInReg5                       : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL multOut5                         : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL multOutDelay5_reg                : vector_of_signed35(0 TO 1);  -- sfix35 [2]
  SIGNAL multOutReg5                      : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage1_5                     : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL dataIn_6                         : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapDelay_7_reg                   : vector_of_unsigned8(0 TO 6);  -- ufix8 [7]
  SIGNAL tapOutData_7                     : vector_of_unsigned8(0 TO 7);  -- uint8 [8]
  SIGNAL tapOutData_7_4                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd6_stage1_1                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_7_3                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd6_stage1_2                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_14           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd6_stage1_add_1             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd6_stage2_1                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL dataIn_7                         : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapDelay_8_reg                   : vector_of_unsigned8(0 TO 6);  -- ufix8 [7]
  SIGNAL tapOutData_8                     : vector_of_unsigned8(0 TO 7);  -- uint8 [8]
  SIGNAL tapOutData_8_4                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd6_stage1_3                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_8_3                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd6_stage1_4                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_15           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd6_stage1_add_2             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd6_stage2_2                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd6_stage2_add_1             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd6_stage3_1                 : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL dataIn_8                         : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapDelay_9_reg                   : vector_of_unsigned8(0 TO 6);  -- ufix8 [7]
  SIGNAL tapOutData_9                     : vector_of_unsigned8(0 TO 7);  -- uint8 [8]
  SIGNAL tapOutData_9_4                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd6_stage1_5                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_9_3                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd6_stage1_6                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_16           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd6_stage1_add_3             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd6_stage2_3                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL dataIn_9                         : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapDelay_10_reg                  : vector_of_unsigned8(0 TO 6);  -- ufix8 [7]
  SIGNAL tapOutData_10                    : vector_of_unsigned8(0 TO 7);  -- uint8 [8]
  SIGNAL tapOutData_10_4                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd6_stage1_7                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_10_3                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd6_stage1_8                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_17           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd6_stage1_add_4             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd6_stage2_4                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd6_stage2_add_2             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd6_stage3_2                 : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd6_stage3_add_1             : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL preAdd6_final_reg                : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL multInDelay6_reg                 : vector_of_signed11(0 TO 1);  -- sfix11 [2]
  SIGNAL multInReg6                       : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL multOut6                         : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL multOutDelay6_reg                : vector_of_signed35(0 TO 1);  -- sfix35 [2]
  SIGNAL multOutReg6                      : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage1_6                     : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL adder_add_cast_6                 : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL adder_add_cast_7                 : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL add_stage1_add_3                 : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL add_stage2_3                     : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL tapOutData_2_5                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd7_stage1_1                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_2_2                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd7_stage1_2                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_18           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd7_stage1_add_1             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd7_stage2_1                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_15_5                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd7_stage1_3                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_15_2                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd7_stage1_4                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_19           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd7_stage1_add_2             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd7_stage2_2                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd7_stage2_add_1             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd7_final_reg                : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd7_balance_reg              : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multInDelay7_reg                 : vector_of_signed10(0 TO 1);  -- sfix10 [2]
  SIGNAL multInReg7                       : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multOut7                         : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL multOutDelay7_reg                : vector_of_signed34(0 TO 1);  -- sfix34 [2]
  SIGNAL multOutReg7                      : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL add_stage1_7                     : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL tapOutData_1_6                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd8_stage1_1                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_1_1                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd8_stage1_2                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_20           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd8_stage1_add_1             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd8_stage2_1                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_16_6                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd8_stage1_3                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_16_1                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd8_stage1_4                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_21           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd8_stage1_add_2             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd8_stage2_2                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd8_stage2_add_1             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd8_final_reg                : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd8_balance_reg              : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multInDelay8_reg                 : vector_of_signed10(0 TO 1);  -- sfix10 [2]
  SIGNAL multInReg8                       : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multOut8                         : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL multOutDelay8_reg                : vector_of_signed34(0 TO 1);  -- sfix34 [2]
  SIGNAL multOutReg8                      : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL add_stage1_8                     : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL adder_add_cast_8                 : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL adder_add_cast_9                 : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage1_add_4                 : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage2_4                     : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL adder_add_cast_10                : signed(36 DOWNTO 0);  -- sfix37_En15
  SIGNAL adder_add_cast_11                : signed(36 DOWNTO 0);  -- sfix37_En15
  SIGNAL add_stage2_add_2                 : signed(36 DOWNTO 0);  -- sfix37_En15
  SIGNAL add_stage3_2                     : signed(36 DOWNTO 0);  -- sfix37_En15
  SIGNAL adder_add_cast_12                : signed(37 DOWNTO 0);  -- sfix38_En15
  SIGNAL adder_add_cast_13                : signed(37 DOWNTO 0);  -- sfix38_En15
  SIGNAL add_stage3_add_1                 : signed(37 DOWNTO 0);  -- sfix38_En15
  SIGNAL add_stage4_1                     : signed(37 DOWNTO 0);  -- sfix38_En15
  SIGNAL tapOutData_3_5                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd9_stage1_1                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_3_2                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd9_stage1_2                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_22           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd9_stage1_add_1             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd9_stage2_1                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_14_5                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd9_stage1_3                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_14_2                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd9_stage1_4                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_23           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd9_stage1_add_2             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd9_stage2_2                 : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd9_stage2_add_1             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd9_final_reg                : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd9_balance_reg              : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multInDelay9_reg                 : vector_of_signed10(0 TO 1);  -- sfix10 [2]
  SIGNAL multInReg9                       : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multOut9                         : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL multOutDelay9_reg                : vector_of_signed34(0 TO 1);  -- sfix34 [2]
  SIGNAL multOutReg9                      : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL add_stage1_9                     : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL tapOutData_1_7                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd10_stage1_1                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_1_0                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd10_stage1_2                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_24           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd10_stage1_add_1            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd10_stage2_1                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_16_7                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd10_stage1_3                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_16_0                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd10_stage1_4                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_25           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd10_stage1_add_2            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd10_stage2_2                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd10_stage2_add_1            : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd10_final_reg               : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd10_balance_reg             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multInDelay10_reg                : vector_of_signed10(0 TO 1);  -- sfix10 [2]
  SIGNAL multInReg10                      : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multOut10                        : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL multOutDelay10_reg               : vector_of_signed34(0 TO 1);  -- sfix34 [2]
  SIGNAL multOutReg10                     : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL add_stage1_10                    : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL adder_add_cast_14                : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL adder_add_cast_15                : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage1_add_5                 : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage2_5                     : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL tapOutData_4_5                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd11_stage1_1                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_2_1                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd11_stage1_2                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_26           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd11_stage1_add_1            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd11_stage2_1                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_13_5                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd11_stage1_3                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_15_1                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd11_stage1_4                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_27           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd11_stage1_add_2            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd11_stage2_2                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd11_stage2_add_1            : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd11_stage3_1                : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL tapOutData_2_6                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd11_stage1_5                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_4_2                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd11_stage1_6                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_28           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd11_stage1_add_3            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd11_stage2_3                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_15_6                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd11_stage1_7                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_13_2                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd11_stage1_8                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_29           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd11_stage1_add_4            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd11_stage2_4                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd11_stage2_add_2            : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd11_stage3_2                : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd11_stage3_add_1            : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL preAdd11_final_reg               : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL multInDelay11_reg                : vector_of_signed11(0 TO 1);  -- sfix11 [2]
  SIGNAL multInReg11                      : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL multOut11                        : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL multOutDelay11_reg               : vector_of_signed35(0 TO 1);  -- sfix35 [2]
  SIGNAL multOutReg11                     : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage1_11                    : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL tapOutData_2_7                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd12_stage1_1                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_2_0                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd12_stage1_2                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_30           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd12_stage1_add_1            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd12_stage2_1                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_15_7                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd12_stage1_3                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_15_0                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd12_stage1_4                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_31           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd12_stage1_add_2            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd12_stage2_2                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd12_stage2_add_1            : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd12_final_reg               : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd12_balance_reg             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multInDelay12_reg                : vector_of_signed10(0 TO 1);  -- sfix10 [2]
  SIGNAL multInReg12                      : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multOut12                        : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL multOutDelay12_reg               : vector_of_signed34(0 TO 1);  -- sfix34 [2]
  SIGNAL multOutReg12                     : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL add_stage1_12                    : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL adder_add_cast_16                : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL adder_add_cast_17                : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL add_stage1_add_6                 : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL add_stage2_6                     : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL adder_add_cast_18                : signed(36 DOWNTO 0);  -- sfix37_En15
  SIGNAL adder_add_cast_19                : signed(36 DOWNTO 0);  -- sfix37_En15
  SIGNAL add_stage2_add_3                 : signed(36 DOWNTO 0);  -- sfix37_En15
  SIGNAL add_stage3_3                     : signed(36 DOWNTO 0);  -- sfix37_En15
  SIGNAL tapOutData_5_5                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd13_stage1_1                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_5_2                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd13_stage1_2                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_32           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd13_stage1_add_1            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd13_stage2_1                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_12_5                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd13_stage1_3                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_12_2                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd13_stage1_4                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_33           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd13_stage1_add_2            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd13_stage2_2                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd13_stage2_add_1            : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd13_final_reg               : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd13_balance_reg             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multInDelay13_reg                : vector_of_signed10(0 TO 1);  -- sfix10 [2]
  SIGNAL multInReg13                      : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multOut13                        : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL multOutDelay13_reg               : vector_of_signed34(0 TO 1);  -- sfix34 [2]
  SIGNAL multOutReg13                     : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL add_stage1_13                    : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL tapOutData_3_6                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd14_stage1_1                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_3_1                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd14_stage1_2                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_34           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd14_stage1_add_1            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd14_stage2_1                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_14_6                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd14_stage1_3                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_14_1                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd14_stage1_4                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_35           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd14_stage1_add_2            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd14_stage2_2                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd14_stage2_add_1            : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd14_final_reg               : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd14_balance_reg             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multInDelay14_reg                : vector_of_signed10(0 TO 1);  -- sfix10 [2]
  SIGNAL multInReg14                      : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multOut14                        : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL multOutDelay14_reg               : vector_of_signed34(0 TO 1);  -- sfix34 [2]
  SIGNAL multOutReg14                     : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL add_stage1_14                    : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL adder_add_cast_20                : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL adder_add_cast_21                : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage1_add_7                 : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage2_7                     : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL tapOutData_6_5                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd15_stage1_1                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_6_2                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd15_stage1_2                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_36           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd15_stage1_add_1            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd15_stage2_1                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_11_5                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd15_stage1_3                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_11_2                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd15_stage1_4                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_37           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd15_stage1_add_2            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd15_stage2_2                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd15_stage2_add_1            : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd15_final_reg               : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd15_balance_reg             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multInDelay15_reg                : vector_of_signed10(0 TO 1);  -- sfix10 [2]
  SIGNAL multInReg15                      : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multOut15                        : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL multOutDelay15_reg               : vector_of_signed34(0 TO 1);  -- sfix34 [2]
  SIGNAL multOutReg15                     : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL add_stage1_15                    : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL tapOutData_7_5                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd16_stage1_1                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_3_0                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd16_stage1_2                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_38           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd16_stage1_add_1            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd16_stage2_1                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_10_5                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd16_stage1_3                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_14_0                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd16_stage1_4                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_39           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd16_stage1_add_2            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd16_stage2_2                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd16_stage2_add_1            : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd16_stage3_1                : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL tapOutData_3_7                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd16_stage1_5                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_7_2                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd16_stage1_6                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_40           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd16_stage1_add_3            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd16_stage2_3                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_14_7                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd16_stage1_7                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_10_2                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd16_stage1_8                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_41           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd16_stage1_add_4            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd16_stage2_4                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd16_stage2_add_2            : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd16_stage3_2                : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd16_stage3_add_1            : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL preAdd16_final_reg               : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL multInDelay16_reg                : vector_of_signed11(0 TO 1);  -- sfix11 [2]
  SIGNAL multInReg16                      : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL multOut16                        : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL multOutDelay16_reg               : vector_of_signed35(0 TO 1);  -- sfix35 [2]
  SIGNAL multOutReg16                     : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage1_16                    : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL adder_add_cast_22                : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL adder_add_cast_23                : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL add_stage1_add_8                 : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL add_stage2_8                     : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL adder_add_cast_24                : signed(36 DOWNTO 0);  -- sfix37_En15
  SIGNAL adder_add_cast_25                : signed(36 DOWNTO 0);  -- sfix37_En15
  SIGNAL add_stage2_add_4                 : signed(36 DOWNTO 0);  -- sfix37_En15
  SIGNAL add_stage3_4                     : signed(36 DOWNTO 0);  -- sfix37_En15
  SIGNAL adder_add_cast_26                : signed(37 DOWNTO 0);  -- sfix38_En15
  SIGNAL adder_add_cast_27                : signed(37 DOWNTO 0);  -- sfix38_En15
  SIGNAL add_stage3_add_2                 : signed(37 DOWNTO 0);  -- sfix38_En15
  SIGNAL add_stage4_2                     : signed(37 DOWNTO 0);  -- sfix38_En15
  SIGNAL adder_add_cast_28                : signed(38 DOWNTO 0);  -- sfix39_En15
  SIGNAL adder_add_cast_29                : signed(38 DOWNTO 0);  -- sfix39_En15
  SIGNAL add_stage4_add_1                 : signed(38 DOWNTO 0);  -- sfix39_En15
  SIGNAL add_stage5_1                     : signed(38 DOWNTO 0);  -- sfix39_En15
  SIGNAL tapOutData_8_5                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd17_stage1_1                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_4_1                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd17_stage1_2                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_42           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd17_stage1_add_1            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd17_stage2_1                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_9_5                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd17_stage1_3                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_13_1                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd17_stage1_4                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_43           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd17_stage1_add_2            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd17_stage2_2                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd17_stage2_add_1            : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd17_stage3_1                : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL tapOutData_4_6                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd17_stage1_5                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_8_2                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd17_stage1_6                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_44           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd17_stage1_add_3            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd17_stage2_3                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_13_6                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd17_stage1_7                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_9_2                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd17_stage1_8                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_45           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd17_stage1_add_4            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd17_stage2_4                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd17_stage2_add_2            : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd17_stage3_2                : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd17_stage3_add_1            : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL preAdd17_final_reg               : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL multInDelay17_reg                : vector_of_signed11(0 TO 1);  -- sfix11 [2]
  SIGNAL multInReg17                      : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL multOut17                        : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL multOutDelay17_reg               : vector_of_signed35(0 TO 1);  -- sfix35 [2]
  SIGNAL multOutReg17                     : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage1_17                    : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL tapOutData_4_7                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd18_stage1_1                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_4_0                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd18_stage1_2                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_46           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd18_stage1_add_1            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd18_stage2_1                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_13_7                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd18_stage1_3                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_13_0                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd18_stage1_4                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_47           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd18_stage1_add_2            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd18_stage2_2                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd18_stage2_add_1            : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd18_final_reg               : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd18_balance_reg             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multInDelay18_reg                : vector_of_signed10(0 TO 1);  -- sfix10 [2]
  SIGNAL multInReg18                      : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multOut18                        : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL multOutDelay18_reg               : vector_of_signed34(0 TO 1);  -- sfix34 [2]
  SIGNAL multOutReg18                     : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL add_stage1_18                    : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL adder_add_cast_30                : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL adder_add_cast_31                : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL add_stage1_add_9                 : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL add_stage2_9                     : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL tapOutData_5_6                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd19_stage1_1                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_5_1                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd19_stage1_2                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_48           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd19_stage1_add_1            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd19_stage2_1                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_12_6                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd19_stage1_3                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_12_1                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd19_stage1_4                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_49           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd19_stage1_add_2            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd19_stage2_2                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd19_stage2_add_1            : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd19_final_reg               : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd19_balance_reg             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multInDelay19_reg                : vector_of_signed10(0 TO 1);  -- sfix10 [2]
  SIGNAL multInReg19                      : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multOut19                        : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL multOutDelay19_reg               : vector_of_signed34(0 TO 1);  -- sfix34 [2]
  SIGNAL multOutReg19                     : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL add_stage1_19                    : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL tapOutData_6_6                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd20_stage1_1                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_6_1                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd20_stage1_2                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_50           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd20_stage1_add_1            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd20_stage2_1                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_11_6                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd20_stage1_3                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_11_1                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd20_stage1_4                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_51           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd20_stage1_add_2            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd20_stage2_2                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd20_stage2_add_1            : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd20_final_reg               : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd20_balance_reg             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multInDelay20_reg                : vector_of_signed10(0 TO 1);  -- sfix10 [2]
  SIGNAL multInReg20                      : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multOut20                        : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL multOutDelay20_reg               : vector_of_signed34(0 TO 1);  -- sfix34 [2]
  SIGNAL multOutReg20                     : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL add_stage1_20                    : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL adder_add_cast_32                : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL adder_add_cast_33                : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage1_add_10                : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage2_10                    : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL adder_add_cast_34                : signed(36 DOWNTO 0);  -- sfix37_En15
  SIGNAL adder_add_cast_35                : signed(36 DOWNTO 0);  -- sfix37_En15
  SIGNAL add_stage2_add_5                 : signed(36 DOWNTO 0);  -- sfix37_En15
  SIGNAL add_stage3_5                     : signed(36 DOWNTO 0);  -- sfix37_En15
  SIGNAL tapOutData_5_7                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd21_stage1_1                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_5_0                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd21_stage1_2                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_52           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd21_stage1_add_1            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd21_stage2_1                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_12_7                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd21_stage1_3                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_12_0                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd21_stage1_4                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_53           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd21_stage1_add_2            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd21_stage2_2                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd21_stage2_add_1            : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd21_final_reg               : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd21_balance_reg             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multInDelay21_reg                : vector_of_signed10(0 TO 1);  -- sfix10 [2]
  SIGNAL multInReg21                      : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multOut21                        : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL multOutDelay21_reg               : vector_of_signed34(0 TO 1);  -- sfix34 [2]
  SIGNAL multOutReg21                     : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL add_stage1_21                    : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL tapOutData_7_6                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd22_stage1_1                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_7_1                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd22_stage1_2                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_54           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd22_stage1_add_1            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd22_stage2_1                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_10_6                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd22_stage1_3                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_10_1                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd22_stage1_4                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_55           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd22_stage1_add_2            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd22_stage2_2                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd22_stage2_add_1            : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd22_final_reg               : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd22_balance_reg             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multInDelay22_reg                : vector_of_signed10(0 TO 1);  -- sfix10 [2]
  SIGNAL multInReg22                      : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multOut22                        : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL multOutDelay22_reg               : vector_of_signed34(0 TO 1);  -- sfix34 [2]
  SIGNAL multOutReg22                     : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL add_stage1_22                    : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL adder_add_cast_36                : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL adder_add_cast_37                : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage1_add_11                : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage2_11                    : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL tapOutData_8_6                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd23_stage1_1                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_8_1                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd23_stage1_2                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_56           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd23_stage1_add_1            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd23_stage2_1                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_9_6                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd23_stage1_3                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_9_1                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd23_stage1_4                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_57           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd23_stage1_add_2            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd23_stage2_2                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd23_stage2_add_1            : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd23_final_reg               : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd23_balance_reg             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multInDelay23_reg                : vector_of_signed10(0 TO 1);  -- sfix10 [2]
  SIGNAL multInReg23                      : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multOut23                        : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL multOutDelay23_reg               : vector_of_signed34(0 TO 1);  -- sfix34 [2]
  SIGNAL multOutReg23                     : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL add_stage1_23                    : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL tapOutData_6_7                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd24_stage1_1                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_6_0                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd24_stage1_2                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_58           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd24_stage1_add_1            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd24_stage2_1                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_11_7                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd24_stage1_3                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_11_0                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd24_stage1_4                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_59           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd24_stage1_add_2            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd24_stage2_2                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd24_stage2_add_1            : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd24_final_reg               : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd24_balance_reg             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multInDelay24_reg                : vector_of_signed10(0 TO 1);  -- sfix10 [2]
  SIGNAL multInReg24                      : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multOut24                        : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL multOutDelay24_reg               : vector_of_signed34(0 TO 1);  -- sfix34 [2]
  SIGNAL multOutReg24                     : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL add_stage1_24                    : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL adder_add_cast_38                : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL adder_add_cast_39                : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage1_add_12                : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage2_12                    : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL adder_add_cast_40                : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL adder_add_cast_41                : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL add_stage2_add_6                 : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL add_stage3_6                     : signed(35 DOWNTO 0);  -- sfix36_En15
  SIGNAL adder_add_cast_42                : signed(37 DOWNTO 0);  -- sfix38_En15
  SIGNAL adder_add_cast_43                : signed(37 DOWNTO 0);  -- sfix38_En15
  SIGNAL add_stage3_add_3                 : signed(37 DOWNTO 0);  -- sfix38_En15
  SIGNAL add_stage4_3                     : signed(37 DOWNTO 0);  -- sfix38_En15
  SIGNAL tapOutData_7_7                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd25_stage1_1                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_7_0                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd25_stage1_2                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_60           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd25_stage1_add_1            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd25_stage2_1                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_10_7                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd25_stage1_3                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_10_0                  : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd25_stage1_4                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_61           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd25_stage1_add_2            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd25_stage2_2                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd25_stage2_add_1            : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd25_final_reg               : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd25_balance_reg             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multInDelay25_reg                : vector_of_signed10(0 TO 1);  -- sfix10 [2]
  SIGNAL multInReg25                      : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multOut25                        : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL multOutDelay25_reg               : vector_of_signed34(0 TO 1);  -- sfix34 [2]
  SIGNAL multOutReg25                     : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL add_stage1_25                    : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL tapOutData_8_7                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd26_stage1_1                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_8_0                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd26_stage1_2                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_62           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd26_stage1_add_1            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd26_stage2_1                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL tapOutData_9_7                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd26_stage1_3                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL tapOutData_9_0                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL preAdd26_stage1_4                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL subtractor_sub_temp_63           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL preAdd26_stage1_add_2            : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd26_stage2_2                : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL preAdd26_stage2_add_1            : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd26_final_reg               : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL preAdd26_balance_reg             : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multInDelay26_reg                : vector_of_signed10(0 TO 1);  -- sfix10 [2]
  SIGNAL multInReg26                      : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL multOut26                        : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL multOutDelay26_reg               : vector_of_signed34(0 TO 1);  -- sfix34 [2]
  SIGNAL multOutReg26                     : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL add_stage1_26                    : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL adder_add_cast_44                : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL adder_add_cast_45                : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage1_add_13                : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL add_stage4_4_reg_reg             : vector_of_signed35(0 TO 2);  -- sfix35 [3]
  SIGNAL add_stage4_4                     : signed(34 DOWNTO 0);  -- sfix35_En15
  SIGNAL adder_add_cast_46                : signed(38 DOWNTO 0);  -- sfix39_En15
  SIGNAL adder_add_cast_47                : signed(38 DOWNTO 0);  -- sfix39_En15
  SIGNAL add_stage4_add_2                 : signed(38 DOWNTO 0);  -- sfix39_En15
  SIGNAL add_stage5_2                     : signed(38 DOWNTO 0);  -- sfix39_En15
  SIGNAL adder_add_cast_48                : signed(39 DOWNTO 0);  -- sfix40_En15
  SIGNAL adder_add_cast_49                : signed(39 DOWNTO 0);  -- sfix40_En15
  SIGNAL add_stage5_add_1                 : signed(39 DOWNTO 0);  -- sfix40_En15
  SIGNAL add_final_reg                    : signed(39 DOWNTO 0);  -- sfix40_En15
  SIGNAL add_final_reg_conv               : signed(23 DOWNTO 0);  -- sfix24_En15
  SIGNAL dataOut_tmp                      : signed(23 DOWNTO 0);  -- sfix24_En15
  SIGNAL vStartOut_tap_latency_reg        : std_logic_vector(0 TO 3);  -- ufix1 [4]
  SIGNAL vStartIn_reg                     : std_logic;
  SIGNAL vStartIn_reg_vldSig              : std_logic;
  SIGNAL vStartOut_fir_latency_reg        : std_logic_vector(0 TO 14);  -- ufix1 [15]
  SIGNAL vEndOut_tap_latency_reg          : std_logic_vector(0 TO 3);  -- ufix1 [4]
  SIGNAL vEndIn_reg                       : std_logic;
  SIGNAL vEndIn_reg_vldSig                : std_logic;
  SIGNAL vEndOut_fir_latency_reg          : std_logic_vector(0 TO 14);  -- ufix1 [15]
  SIGNAL hStartOut_tap_latency_reg        : std_logic_vector(0 TO 3);  -- ufix1 [4]
  SIGNAL hStartIn_reg                     : std_logic;
  SIGNAL hStartIn_reg_vldSig              : std_logic;
  SIGNAL hStartOut_fir_latency_reg        : std_logic_vector(0 TO 14);  -- ufix1 [15]
  SIGNAL hEndOut_tap_latency_reg          : std_logic_vector(0 TO 3);  -- ufix1 [4]
  SIGNAL hEndIn_reg                       : std_logic;
  SIGNAL hEndIn_reg_vldSig                : std_logic;
  SIGNAL hEndOut_fir_latency_reg          : std_logic_vector(0 TO 14);  -- ufix1 [15]
  SIGNAL validOut_tap_latency_reg         : std_logic_vector(0 TO 3);  -- ufix1 [4]
  SIGNAL validIn_reg                      : std_logic;
  SIGNAL validIn_reg_vldSig               : std_logic;
  SIGNAL validOut_fir_latency_reg         : std_logic_vector(0 TO 14);  -- ufix1 [15]

BEGIN
  dataIn_0 <= unsigned(dataIn(0));

  tapDelay_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        tapDelay_1_reg <= (OTHERS => to_unsigned(16#00#, 8));
      ELSIF enb = '1' AND processData = '1' THEN
        tapDelay_1_reg(6) <= dataIn_0;
        tapDelay_1_reg(0 TO 5) <= tapDelay_1_reg(1 TO 6);
      END IF;
    END IF;
  END PROCESS tapDelay_1_process;

  tapOutData_1(0 TO 6) <= tapDelay_1_reg(0 TO 6);
  tapOutData_1(7) <= dataIn_0;

  tapOutData_1_4 <= tapOutData_1(4);

  preAdd1_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd1_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd1_stage1_1 <= tapOutData_1_4;
      END IF;
    END IF;
  END PROCESS preAdd1_stage1_1_reg_process;


  tapOutData_1_3 <= tapOutData_1(3);

  preAdd1_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd1_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd1_stage1_2 <= tapOutData_1_3;
      END IF;
    END IF;
  END PROCESS preAdd1_stage1_2_reg_process;


  subtractor_sub_temp <= resize(preAdd1_stage1_1, 9) - resize(preAdd1_stage1_2, 9);
  preAdd1_stage1_add_1 <= signed(subtractor_sub_temp);

  preAdd1_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd1_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd1_stage2_1 <= preAdd1_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd1_stage2_1_reg_process;


  dataIn_1 <= unsigned(dataIn(1));

  tapDelay_2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        tapDelay_2_reg <= (OTHERS => to_unsigned(16#00#, 8));
      ELSIF enb = '1' AND processData = '1' THEN
        tapDelay_2_reg(6) <= dataIn_1;
        tapDelay_2_reg(0 TO 5) <= tapDelay_2_reg(1 TO 6);
      END IF;
    END IF;
  END PROCESS tapDelay_2_process;

  tapOutData_2(0 TO 6) <= tapDelay_2_reg(0 TO 6);
  tapOutData_2(7) <= dataIn_1;

  tapOutData_2_4 <= tapOutData_2(4);

  preAdd1_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd1_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd1_stage1_3 <= tapOutData_2_4;
      END IF;
    END IF;
  END PROCESS preAdd1_stage1_3_reg_process;


  tapOutData_2_3 <= tapOutData_2(3);

  preAdd1_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd1_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd1_stage1_4 <= tapOutData_2_3;
      END IF;
    END IF;
  END PROCESS preAdd1_stage1_4_reg_process;


  subtractor_sub_temp_1 <= resize(preAdd1_stage1_3, 9) - resize(preAdd1_stage1_4, 9);
  preAdd1_stage1_add_2 <= signed(subtractor_sub_temp_1);

  preAdd1_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd1_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd1_stage2_2 <= preAdd1_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd1_stage2_2_reg_process;


  preAdd1_stage2_add_1 <= resize(preAdd1_stage2_1, 10) + resize(preAdd1_stage2_2, 10);

  preAdd1_stage3_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd1_stage3_1 <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd1_stage3_1 <= preAdd1_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd1_stage3_1_reg_process;


  dataIn_14 <= unsigned(dataIn(14));

  tapDelay_15_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        tapDelay_15_reg <= (OTHERS => to_unsigned(16#00#, 8));
      ELSIF enb = '1' AND processData = '1' THEN
        tapDelay_15_reg(6) <= dataIn_14;
        tapDelay_15_reg(0 TO 5) <= tapDelay_15_reg(1 TO 6);
      END IF;
    END IF;
  END PROCESS tapDelay_15_process;

  tapOutData_15(0 TO 6) <= tapDelay_15_reg(0 TO 6);
  tapOutData_15(7) <= dataIn_14;

  tapOutData_15_4 <= tapOutData_15(4);

  preAdd1_stage1_5_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd1_stage1_5 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd1_stage1_5 <= tapOutData_15_4;
      END IF;
    END IF;
  END PROCESS preAdd1_stage1_5_reg_process;


  tapOutData_15_3 <= tapOutData_15(3);

  preAdd1_stage1_6_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd1_stage1_6 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd1_stage1_6 <= tapOutData_15_3;
      END IF;
    END IF;
  END PROCESS preAdd1_stage1_6_reg_process;


  subtractor_sub_temp_2 <= resize(preAdd1_stage1_5, 9) - resize(preAdd1_stage1_6, 9);
  preAdd1_stage1_add_3 <= signed(subtractor_sub_temp_2);

  preAdd1_stage2_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd1_stage2_3 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd1_stage2_3 <= preAdd1_stage1_add_3;
      END IF;
    END IF;
  END PROCESS preAdd1_stage2_3_reg_process;


  dataIn_15 <= unsigned(dataIn(15));

  tapDelay_16_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        tapDelay_16_reg <= (OTHERS => to_unsigned(16#00#, 8));
      ELSIF enb = '1' AND processData = '1' THEN
        tapDelay_16_reg(6) <= dataIn_15;
        tapDelay_16_reg(0 TO 5) <= tapDelay_16_reg(1 TO 6);
      END IF;
    END IF;
  END PROCESS tapDelay_16_process;

  tapOutData_16(0 TO 6) <= tapDelay_16_reg(0 TO 6);
  tapOutData_16(7) <= dataIn_15;

  tapOutData_16_4 <= tapOutData_16(4);

  preAdd1_stage1_7_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd1_stage1_7 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd1_stage1_7 <= tapOutData_16_4;
      END IF;
    END IF;
  END PROCESS preAdd1_stage1_7_reg_process;


  tapOutData_16_3 <= tapOutData_16(3);

  preAdd1_stage1_8_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd1_stage1_8 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd1_stage1_8 <= tapOutData_16_3;
      END IF;
    END IF;
  END PROCESS preAdd1_stage1_8_reg_process;


  subtractor_sub_temp_3 <= resize(preAdd1_stage1_7, 9) - resize(preAdd1_stage1_8, 9);
  preAdd1_stage1_add_4 <= signed(subtractor_sub_temp_3);

  preAdd1_stage2_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd1_stage2_4 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd1_stage2_4 <= preAdd1_stage1_add_4;
      END IF;
    END IF;
  END PROCESS preAdd1_stage2_4_reg_process;


  preAdd1_stage2_add_2 <= resize(preAdd1_stage2_3, 10) + resize(preAdd1_stage2_4, 10);

  preAdd1_stage3_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd1_stage3_2 <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd1_stage3_2 <= preAdd1_stage2_add_2;
      END IF;
    END IF;
  END PROCESS preAdd1_stage3_2_reg_process;


  preAdd1_stage3_add_1 <= resize(preAdd1_stage3_1, 11) + resize(preAdd1_stage3_2, 11);

  preAdd1_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd1_final_reg <= to_signed(16#000#, 11);
      ELSIF enb = '1' THEN
        preAdd1_final_reg <= preAdd1_stage3_add_1;
      END IF;
    END IF;
  END PROCESS preAdd1_final_process;


  multInDelay1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay1_reg <= (OTHERS => to_signed(16#000#, 11));
      ELSIF enb = '1' THEN
        multInDelay1_reg(0) <= preAdd1_final_reg;
        multInDelay1_reg(1) <= multInDelay1_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay1_process;

  multInReg1 <= multInDelay1_reg(1);

  multOut1 <= to_signed(16#000003#, 24) * multInReg1;

  multOutDelay1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay1_reg <= (OTHERS => to_signed(0, 35));
      ELSIF enb = '1' THEN
        multOutDelay1_reg(0) <= multOut1;
        multOutDelay1_reg(1) <= multOutDelay1_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay1_process;

  multOutReg1 <= multOutDelay1_reg(1);

  add_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_1 <= to_signed(0, 35);
      ELSIF enb = '1' THEN
        add_stage1_1 <= multOutReg1;
      END IF;
    END IF;
  END PROCESS add_stage1_1_reg_process;


  dataIn_2 <= unsigned(dataIn(2));

  tapDelay_3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        tapDelay_3_reg <= (OTHERS => to_unsigned(16#00#, 8));
      ELSIF enb = '1' AND processData = '1' THEN
        tapDelay_3_reg(6) <= dataIn_2;
        tapDelay_3_reg(0 TO 5) <= tapDelay_3_reg(1 TO 6);
      END IF;
    END IF;
  END PROCESS tapDelay_3_process;

  tapOutData_3(0 TO 6) <= tapDelay_3_reg(0 TO 6);
  tapOutData_3(7) <= dataIn_2;

  tapOutData_3_4 <= tapOutData_3(4);

  preAdd2_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd2_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd2_stage1_1 <= tapOutData_3_4;
      END IF;
    END IF;
  END PROCESS preAdd2_stage1_1_reg_process;


  tapOutData_3_3 <= tapOutData_3(3);

  preAdd2_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd2_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd2_stage1_2 <= tapOutData_3_3;
      END IF;
    END IF;
  END PROCESS preAdd2_stage1_2_reg_process;


  subtractor_sub_temp_4 <= resize(preAdd2_stage1_1, 9) - resize(preAdd2_stage1_2, 9);
  preAdd2_stage1_add_1 <= signed(subtractor_sub_temp_4);

  preAdd2_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd2_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd2_stage2_1 <= preAdd2_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd2_stage2_1_reg_process;


  dataIn_13 <= unsigned(dataIn(13));

  tapDelay_14_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        tapDelay_14_reg <= (OTHERS => to_unsigned(16#00#, 8));
      ELSIF enb = '1' AND processData = '1' THEN
        tapDelay_14_reg(6) <= dataIn_13;
        tapDelay_14_reg(0 TO 5) <= tapDelay_14_reg(1 TO 6);
      END IF;
    END IF;
  END PROCESS tapDelay_14_process;

  tapOutData_14(0 TO 6) <= tapDelay_14_reg(0 TO 6);
  tapOutData_14(7) <= dataIn_13;

  tapOutData_14_4 <= tapOutData_14(4);

  preAdd2_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd2_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd2_stage1_3 <= tapOutData_14_4;
      END IF;
    END IF;
  END PROCESS preAdd2_stage1_3_reg_process;


  tapOutData_14_3 <= tapOutData_14(3);

  preAdd2_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd2_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd2_stage1_4 <= tapOutData_14_3;
      END IF;
    END IF;
  END PROCESS preAdd2_stage1_4_reg_process;


  subtractor_sub_temp_5 <= resize(preAdd2_stage1_3, 9) - resize(preAdd2_stage1_4, 9);
  preAdd2_stage1_add_2 <= signed(subtractor_sub_temp_5);

  preAdd2_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd2_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd2_stage2_2 <= preAdd2_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd2_stage2_2_reg_process;


  preAdd2_stage2_add_1 <= resize(preAdd2_stage2_1, 10) + resize(preAdd2_stage2_2, 10);

  preAdd2_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd2_final_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd2_final_reg <= preAdd2_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd2_final_process;


  preAdd2_balance_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd2_balance_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd2_balance_reg <= preAdd2_final_reg;
      END IF;
    END IF;
  END PROCESS preAdd2_balance_process;


  multInDelay2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay2_reg <= (OTHERS => to_signed(16#000#, 10));
      ELSIF enb = '1' THEN
        multInDelay2_reg(0) <= preAdd2_balance_reg;
        multInDelay2_reg(1) <= multInDelay2_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay2_process;

  multInReg2 <= multInDelay2_reg(1);

  multOut2 <= resize(multInReg2 & '0' & '0', 34);

  multOutDelay2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay2_reg <= (OTHERS => to_signed(0, 34));
      ELSIF enb = '1' THEN
        multOutDelay2_reg(0) <= multOut2;
        multOutDelay2_reg(1) <= multOutDelay2_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay2_process;

  multOutReg2 <= multOutDelay2_reg(1);

  add_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_2 <= to_signed(0, 34);
      ELSIF enb = '1' THEN
        add_stage1_2 <= multOutReg2;
      END IF;
    END IF;
  END PROCESS add_stage1_2_reg_process;


  adder_add_cast <= resize(add_stage1_1, 36);
  adder_add_cast_1 <= resize(add_stage1_2, 36);
  add_stage1_add_1 <= adder_add_cast + adder_add_cast_1;

  add_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage2_1 <= to_signed(0, 36);
      ELSIF enb = '1' THEN
        add_stage2_1 <= add_stage1_add_1;
      END IF;
    END IF;
  END PROCESS add_stage2_1_reg_process;


  dataIn_3 <= unsigned(dataIn(3));

  tapDelay_4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        tapDelay_4_reg <= (OTHERS => to_unsigned(16#00#, 8));
      ELSIF enb = '1' AND processData = '1' THEN
        tapDelay_4_reg(6) <= dataIn_3;
        tapDelay_4_reg(0 TO 5) <= tapDelay_4_reg(1 TO 6);
      END IF;
    END IF;
  END PROCESS tapDelay_4_process;

  tapOutData_4(0 TO 6) <= tapDelay_4_reg(0 TO 6);
  tapOutData_4(7) <= dataIn_3;

  tapOutData_4_4 <= tapOutData_4(4);

  preAdd3_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd3_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd3_stage1_1 <= tapOutData_4_4;
      END IF;
    END IF;
  END PROCESS preAdd3_stage1_1_reg_process;


  tapOutData_4_3 <= tapOutData_4(3);

  preAdd3_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd3_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd3_stage1_2 <= tapOutData_4_3;
      END IF;
    END IF;
  END PROCESS preAdd3_stage1_2_reg_process;


  subtractor_sub_temp_6 <= resize(preAdd3_stage1_1, 9) - resize(preAdd3_stage1_2, 9);
  preAdd3_stage1_add_1 <= signed(subtractor_sub_temp_6);

  preAdd3_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd3_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd3_stage2_1 <= preAdd3_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd3_stage2_1_reg_process;


  dataIn_12 <= unsigned(dataIn(12));

  tapDelay_13_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        tapDelay_13_reg <= (OTHERS => to_unsigned(16#00#, 8));
      ELSIF enb = '1' AND processData = '1' THEN
        tapDelay_13_reg(6) <= dataIn_12;
        tapDelay_13_reg(0 TO 5) <= tapDelay_13_reg(1 TO 6);
      END IF;
    END IF;
  END PROCESS tapDelay_13_process;

  tapOutData_13(0 TO 6) <= tapDelay_13_reg(0 TO 6);
  tapOutData_13(7) <= dataIn_12;

  tapOutData_13_4 <= tapOutData_13(4);

  preAdd3_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd3_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd3_stage1_3 <= tapOutData_13_4;
      END IF;
    END IF;
  END PROCESS preAdd3_stage1_3_reg_process;


  tapOutData_13_3 <= tapOutData_13(3);

  preAdd3_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd3_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd3_stage1_4 <= tapOutData_13_3;
      END IF;
    END IF;
  END PROCESS preAdd3_stage1_4_reg_process;


  subtractor_sub_temp_7 <= resize(preAdd3_stage1_3, 9) - resize(preAdd3_stage1_4, 9);
  preAdd3_stage1_add_2 <= signed(subtractor_sub_temp_7);

  preAdd3_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd3_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd3_stage2_2 <= preAdd3_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd3_stage2_2_reg_process;


  preAdd3_stage2_add_1 <= resize(preAdd3_stage2_1, 10) + resize(preAdd3_stage2_2, 10);

  preAdd3_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd3_final_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd3_final_reg <= preAdd3_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd3_final_process;


  preAdd3_balance_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd3_balance_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd3_balance_reg <= preAdd3_final_reg;
      END IF;
    END IF;
  END PROCESS preAdd3_balance_process;


  multInDelay3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay3_reg <= (OTHERS => to_signed(16#000#, 10));
      ELSIF enb = '1' THEN
        multInDelay3_reg(0) <= preAdd3_balance_reg;
        multInDelay3_reg(1) <= multInDelay3_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay3_process;

  multInReg3 <= multInDelay3_reg(1);

  multOut3 <= to_signed(16#000005#, 24) * multInReg3;

  multOutDelay3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay3_reg <= (OTHERS => to_signed(0, 34));
      ELSIF enb = '1' THEN
        multOutDelay3_reg(0) <= multOut3;
        multOutDelay3_reg(1) <= multOutDelay3_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay3_process;

  multOutReg3 <= multOutDelay3_reg(1);

  add_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_3 <= to_signed(0, 34);
      ELSIF enb = '1' THEN
        add_stage1_3 <= multOutReg3;
      END IF;
    END IF;
  END PROCESS add_stage1_3_reg_process;


  dataIn_4 <= unsigned(dataIn(4));

  tapDelay_5_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        tapDelay_5_reg <= (OTHERS => to_unsigned(16#00#, 8));
      ELSIF enb = '1' AND processData = '1' THEN
        tapDelay_5_reg(6) <= dataIn_4;
        tapDelay_5_reg(0 TO 5) <= tapDelay_5_reg(1 TO 6);
      END IF;
    END IF;
  END PROCESS tapDelay_5_process;

  tapOutData_5(0 TO 6) <= tapDelay_5_reg(0 TO 6);
  tapOutData_5(7) <= dataIn_4;

  tapOutData_5_4 <= tapOutData_5(4);

  preAdd4_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd4_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd4_stage1_1 <= tapOutData_5_4;
      END IF;
    END IF;
  END PROCESS preAdd4_stage1_1_reg_process;


  tapOutData_5_3 <= tapOutData_5(3);

  preAdd4_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd4_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd4_stage1_2 <= tapOutData_5_3;
      END IF;
    END IF;
  END PROCESS preAdd4_stage1_2_reg_process;


  subtractor_sub_temp_8 <= resize(preAdd4_stage1_1, 9) - resize(preAdd4_stage1_2, 9);
  preAdd4_stage1_add_1 <= signed(subtractor_sub_temp_8);

  preAdd4_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd4_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd4_stage2_1 <= preAdd4_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd4_stage2_1_reg_process;


  dataIn_11 <= unsigned(dataIn(11));

  tapDelay_12_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        tapDelay_12_reg <= (OTHERS => to_unsigned(16#00#, 8));
      ELSIF enb = '1' AND processData = '1' THEN
        tapDelay_12_reg(6) <= dataIn_11;
        tapDelay_12_reg(0 TO 5) <= tapDelay_12_reg(1 TO 6);
      END IF;
    END IF;
  END PROCESS tapDelay_12_process;

  tapOutData_12(0 TO 6) <= tapDelay_12_reg(0 TO 6);
  tapOutData_12(7) <= dataIn_11;

  tapOutData_12_4 <= tapOutData_12(4);

  preAdd4_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd4_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd4_stage1_3 <= tapOutData_12_4;
      END IF;
    END IF;
  END PROCESS preAdd4_stage1_3_reg_process;


  tapOutData_12_3 <= tapOutData_12(3);

  preAdd4_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd4_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd4_stage1_4 <= tapOutData_12_3;
      END IF;
    END IF;
  END PROCESS preAdd4_stage1_4_reg_process;


  subtractor_sub_temp_9 <= resize(preAdd4_stage1_3, 9) - resize(preAdd4_stage1_4, 9);
  preAdd4_stage1_add_2 <= signed(subtractor_sub_temp_9);

  preAdd4_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd4_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd4_stage2_2 <= preAdd4_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd4_stage2_2_reg_process;


  preAdd4_stage2_add_1 <= resize(preAdd4_stage2_1, 10) + resize(preAdd4_stage2_2, 10);

  preAdd4_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd4_final_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd4_final_reg <= preAdd4_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd4_final_process;


  preAdd4_balance_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd4_balance_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd4_balance_reg <= preAdd4_final_reg;
      END IF;
    END IF;
  END PROCESS preAdd4_balance_process;


  multInDelay4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay4_reg <= (OTHERS => to_signed(16#000#, 10));
      ELSIF enb = '1' THEN
        multInDelay4_reg(0) <= preAdd4_balance_reg;
        multInDelay4_reg(1) <= multInDelay4_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay4_process;

  multInReg4 <= multInDelay4_reg(1);

  multOut4 <= to_signed(16#000006#, 24) * multInReg4;

  multOutDelay4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay4_reg <= (OTHERS => to_signed(0, 34));
      ELSIF enb = '1' THEN
        multOutDelay4_reg(0) <= multOut4;
        multOutDelay4_reg(1) <= multOutDelay4_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay4_process;

  multOutReg4 <= multOutDelay4_reg(1);

  add_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_4 <= to_signed(0, 34);
      ELSIF enb = '1' THEN
        add_stage1_4 <= multOutReg4;
      END IF;
    END IF;
  END PROCESS add_stage1_4_reg_process;


  adder_add_cast_2 <= resize(add_stage1_3, 35);
  adder_add_cast_3 <= resize(add_stage1_4, 35);
  add_stage1_add_2 <= adder_add_cast_2 + adder_add_cast_3;

  add_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage2_2 <= to_signed(0, 35);
      ELSIF enb = '1' THEN
        add_stage2_2 <= add_stage1_add_2;
      END IF;
    END IF;
  END PROCESS add_stage2_2_reg_process;


  adder_add_cast_4 <= resize(add_stage2_1, 37);
  adder_add_cast_5 <= resize(add_stage2_2, 37);
  add_stage2_add_1 <= adder_add_cast_4 + adder_add_cast_5;

  add_stage3_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage3_1 <= to_signed(0, 37);
      ELSIF enb = '1' THEN
        add_stage3_1 <= add_stage2_add_1;
      END IF;
    END IF;
  END PROCESS add_stage3_1_reg_process;


  dataIn_5 <= unsigned(dataIn(5));

  tapDelay_6_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        tapDelay_6_reg <= (OTHERS => to_unsigned(16#00#, 8));
      ELSIF enb = '1' AND processData = '1' THEN
        tapDelay_6_reg(6) <= dataIn_5;
        tapDelay_6_reg(0 TO 5) <= tapDelay_6_reg(1 TO 6);
      END IF;
    END IF;
  END PROCESS tapDelay_6_process;

  tapOutData_6(0 TO 6) <= tapDelay_6_reg(0 TO 6);
  tapOutData_6(7) <= dataIn_5;

  tapOutData_6_4 <= tapOutData_6(4);

  preAdd5_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd5_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd5_stage1_1 <= tapOutData_6_4;
      END IF;
    END IF;
  END PROCESS preAdd5_stage1_1_reg_process;


  tapOutData_1_2 <= tapOutData_1(2);

  preAdd5_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd5_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd5_stage1_2 <= tapOutData_1_2;
      END IF;
    END IF;
  END PROCESS preAdd5_stage1_2_reg_process;


  subtractor_sub_temp_10 <= resize(preAdd5_stage1_1, 9) - resize(preAdd5_stage1_2, 9);
  preAdd5_stage1_add_1 <= signed(subtractor_sub_temp_10);

  preAdd5_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd5_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd5_stage2_1 <= preAdd5_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd5_stage2_1_reg_process;


  dataIn_10 <= unsigned(dataIn(10));

  tapDelay_11_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        tapDelay_11_reg <= (OTHERS => to_unsigned(16#00#, 8));
      ELSIF enb = '1' AND processData = '1' THEN
        tapDelay_11_reg(6) <= dataIn_10;
        tapDelay_11_reg(0 TO 5) <= tapDelay_11_reg(1 TO 6);
      END IF;
    END IF;
  END PROCESS tapDelay_11_process;

  tapOutData_11(0 TO 6) <= tapDelay_11_reg(0 TO 6);
  tapOutData_11(7) <= dataIn_10;

  tapOutData_11_4 <= tapOutData_11(4);

  preAdd5_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd5_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd5_stage1_3 <= tapOutData_11_4;
      END IF;
    END IF;
  END PROCESS preAdd5_stage1_3_reg_process;


  tapOutData_16_2 <= tapOutData_16(2);

  preAdd5_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd5_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd5_stage1_4 <= tapOutData_16_2;
      END IF;
    END IF;
  END PROCESS preAdd5_stage1_4_reg_process;


  subtractor_sub_temp_11 <= resize(preAdd5_stage1_3, 9) - resize(preAdd5_stage1_4, 9);
  preAdd5_stage1_add_2 <= signed(subtractor_sub_temp_11);

  preAdd5_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd5_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd5_stage2_2 <= preAdd5_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd5_stage2_2_reg_process;


  preAdd5_stage2_add_1 <= resize(preAdd5_stage2_1, 10) + resize(preAdd5_stage2_2, 10);

  preAdd5_stage3_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd5_stage3_1 <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd5_stage3_1 <= preAdd5_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd5_stage3_1_reg_process;


  tapOutData_1_5 <= tapOutData_1(5);

  preAdd5_stage1_5_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd5_stage1_5 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd5_stage1_5 <= tapOutData_1_5;
      END IF;
    END IF;
  END PROCESS preAdd5_stage1_5_reg_process;


  tapOutData_6_3 <= tapOutData_6(3);

  preAdd5_stage1_6_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd5_stage1_6 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd5_stage1_6 <= tapOutData_6_3;
      END IF;
    END IF;
  END PROCESS preAdd5_stage1_6_reg_process;


  subtractor_sub_temp_12 <= resize(preAdd5_stage1_5, 9) - resize(preAdd5_stage1_6, 9);
  preAdd5_stage1_add_3 <= signed(subtractor_sub_temp_12);

  preAdd5_stage2_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd5_stage2_3 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd5_stage2_3 <= preAdd5_stage1_add_3;
      END IF;
    END IF;
  END PROCESS preAdd5_stage2_3_reg_process;


  tapOutData_16_5 <= tapOutData_16(5);

  preAdd5_stage1_7_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd5_stage1_7 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd5_stage1_7 <= tapOutData_16_5;
      END IF;
    END IF;
  END PROCESS preAdd5_stage1_7_reg_process;


  tapOutData_11_3 <= tapOutData_11(3);

  preAdd5_stage1_8_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd5_stage1_8 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd5_stage1_8 <= tapOutData_11_3;
      END IF;
    END IF;
  END PROCESS preAdd5_stage1_8_reg_process;


  subtractor_sub_temp_13 <= resize(preAdd5_stage1_7, 9) - resize(preAdd5_stage1_8, 9);
  preAdd5_stage1_add_4 <= signed(subtractor_sub_temp_13);

  preAdd5_stage2_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd5_stage2_4 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd5_stage2_4 <= preAdd5_stage1_add_4;
      END IF;
    END IF;
  END PROCESS preAdd5_stage2_4_reg_process;


  preAdd5_stage2_add_2 <= resize(preAdd5_stage2_3, 10) + resize(preAdd5_stage2_4, 10);

  preAdd5_stage3_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd5_stage3_2 <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd5_stage3_2 <= preAdd5_stage2_add_2;
      END IF;
    END IF;
  END PROCESS preAdd5_stage3_2_reg_process;


  preAdd5_stage3_add_1 <= resize(preAdd5_stage3_1, 11) + resize(preAdd5_stage3_2, 11);

  preAdd5_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd5_final_reg <= to_signed(16#000#, 11);
      ELSIF enb = '1' THEN
        preAdd5_final_reg <= preAdd5_stage3_add_1;
      END IF;
    END IF;
  END PROCESS preAdd5_final_process;


  multInDelay5_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay5_reg <= (OTHERS => to_signed(16#000#, 11));
      ELSIF enb = '1' THEN
        multInDelay5_reg(0) <= preAdd5_final_reg;
        multInDelay5_reg(1) <= multInDelay5_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay5_process;

  multInReg5 <= multInDelay5_reg(1);

  multOut5 <= to_signed(16#000007#, 24) * multInReg5;

  multOutDelay5_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay5_reg <= (OTHERS => to_signed(0, 35));
      ELSIF enb = '1' THEN
        multOutDelay5_reg(0) <= multOut5;
        multOutDelay5_reg(1) <= multOutDelay5_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay5_process;

  multOutReg5 <= multOutDelay5_reg(1);

  add_stage1_5_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_5 <= to_signed(0, 35);
      ELSIF enb = '1' THEN
        add_stage1_5 <= multOutReg5;
      END IF;
    END IF;
  END PROCESS add_stage1_5_reg_process;


  dataIn_6 <= unsigned(dataIn(6));

  tapDelay_7_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        tapDelay_7_reg <= (OTHERS => to_unsigned(16#00#, 8));
      ELSIF enb = '1' AND processData = '1' THEN
        tapDelay_7_reg(6) <= dataIn_6;
        tapDelay_7_reg(0 TO 5) <= tapDelay_7_reg(1 TO 6);
      END IF;
    END IF;
  END PROCESS tapDelay_7_process;

  tapOutData_7(0 TO 6) <= tapDelay_7_reg(0 TO 6);
  tapOutData_7(7) <= dataIn_6;

  tapOutData_7_4 <= tapOutData_7(4);

  preAdd6_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd6_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd6_stage1_1 <= tapOutData_7_4;
      END IF;
    END IF;
  END PROCESS preAdd6_stage1_1_reg_process;


  tapOutData_7_3 <= tapOutData_7(3);

  preAdd6_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd6_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd6_stage1_2 <= tapOutData_7_3;
      END IF;
    END IF;
  END PROCESS preAdd6_stage1_2_reg_process;


  subtractor_sub_temp_14 <= resize(preAdd6_stage1_1, 9) - resize(preAdd6_stage1_2, 9);
  preAdd6_stage1_add_1 <= signed(subtractor_sub_temp_14);

  preAdd6_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd6_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd6_stage2_1 <= preAdd6_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd6_stage2_1_reg_process;


  dataIn_7 <= unsigned(dataIn(7));

  tapDelay_8_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        tapDelay_8_reg <= (OTHERS => to_unsigned(16#00#, 8));
      ELSIF enb = '1' AND processData = '1' THEN
        tapDelay_8_reg(6) <= dataIn_7;
        tapDelay_8_reg(0 TO 5) <= tapDelay_8_reg(1 TO 6);
      END IF;
    END IF;
  END PROCESS tapDelay_8_process;

  tapOutData_8(0 TO 6) <= tapDelay_8_reg(0 TO 6);
  tapOutData_8(7) <= dataIn_7;

  tapOutData_8_4 <= tapOutData_8(4);

  preAdd6_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd6_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd6_stage1_3 <= tapOutData_8_4;
      END IF;
    END IF;
  END PROCESS preAdd6_stage1_3_reg_process;


  tapOutData_8_3 <= tapOutData_8(3);

  preAdd6_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd6_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd6_stage1_4 <= tapOutData_8_3;
      END IF;
    END IF;
  END PROCESS preAdd6_stage1_4_reg_process;


  subtractor_sub_temp_15 <= resize(preAdd6_stage1_3, 9) - resize(preAdd6_stage1_4, 9);
  preAdd6_stage1_add_2 <= signed(subtractor_sub_temp_15);

  preAdd6_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd6_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd6_stage2_2 <= preAdd6_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd6_stage2_2_reg_process;


  preAdd6_stage2_add_1 <= resize(preAdd6_stage2_1, 10) + resize(preAdd6_stage2_2, 10);

  preAdd6_stage3_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd6_stage3_1 <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd6_stage3_1 <= preAdd6_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd6_stage3_1_reg_process;


  dataIn_8 <= unsigned(dataIn(8));

  tapDelay_9_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        tapDelay_9_reg <= (OTHERS => to_unsigned(16#00#, 8));
      ELSIF enb = '1' AND processData = '1' THEN
        tapDelay_9_reg(6) <= dataIn_8;
        tapDelay_9_reg(0 TO 5) <= tapDelay_9_reg(1 TO 6);
      END IF;
    END IF;
  END PROCESS tapDelay_9_process;

  tapOutData_9(0 TO 6) <= tapDelay_9_reg(0 TO 6);
  tapOutData_9(7) <= dataIn_8;

  tapOutData_9_4 <= tapOutData_9(4);

  preAdd6_stage1_5_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd6_stage1_5 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd6_stage1_5 <= tapOutData_9_4;
      END IF;
    END IF;
  END PROCESS preAdd6_stage1_5_reg_process;


  tapOutData_9_3 <= tapOutData_9(3);

  preAdd6_stage1_6_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd6_stage1_6 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd6_stage1_6 <= tapOutData_9_3;
      END IF;
    END IF;
  END PROCESS preAdd6_stage1_6_reg_process;


  subtractor_sub_temp_16 <= resize(preAdd6_stage1_5, 9) - resize(preAdd6_stage1_6, 9);
  preAdd6_stage1_add_3 <= signed(subtractor_sub_temp_16);

  preAdd6_stage2_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd6_stage2_3 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd6_stage2_3 <= preAdd6_stage1_add_3;
      END IF;
    END IF;
  END PROCESS preAdd6_stage2_3_reg_process;


  dataIn_9 <= unsigned(dataIn(9));

  tapDelay_10_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        tapDelay_10_reg <= (OTHERS => to_unsigned(16#00#, 8));
      ELSIF enb = '1' AND processData = '1' THEN
        tapDelay_10_reg(6) <= dataIn_9;
        tapDelay_10_reg(0 TO 5) <= tapDelay_10_reg(1 TO 6);
      END IF;
    END IF;
  END PROCESS tapDelay_10_process;

  tapOutData_10(0 TO 6) <= tapDelay_10_reg(0 TO 6);
  tapOutData_10(7) <= dataIn_9;

  tapOutData_10_4 <= tapOutData_10(4);

  preAdd6_stage1_7_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd6_stage1_7 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd6_stage1_7 <= tapOutData_10_4;
      END IF;
    END IF;
  END PROCESS preAdd6_stage1_7_reg_process;


  tapOutData_10_3 <= tapOutData_10(3);

  preAdd6_stage1_8_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd6_stage1_8 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd6_stage1_8 <= tapOutData_10_3;
      END IF;
    END IF;
  END PROCESS preAdd6_stage1_8_reg_process;


  subtractor_sub_temp_17 <= resize(preAdd6_stage1_7, 9) - resize(preAdd6_stage1_8, 9);
  preAdd6_stage1_add_4 <= signed(subtractor_sub_temp_17);

  preAdd6_stage2_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd6_stage2_4 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd6_stage2_4 <= preAdd6_stage1_add_4;
      END IF;
    END IF;
  END PROCESS preAdd6_stage2_4_reg_process;


  preAdd6_stage2_add_2 <= resize(preAdd6_stage2_3, 10) + resize(preAdd6_stage2_4, 10);

  preAdd6_stage3_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd6_stage3_2 <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd6_stage3_2 <= preAdd6_stage2_add_2;
      END IF;
    END IF;
  END PROCESS preAdd6_stage3_2_reg_process;


  preAdd6_stage3_add_1 <= resize(preAdd6_stage3_1, 11) + resize(preAdd6_stage3_2, 11);

  preAdd6_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd6_final_reg <= to_signed(16#000#, 11);
      ELSIF enb = '1' THEN
        preAdd6_final_reg <= preAdd6_stage3_add_1;
      END IF;
    END IF;
  END PROCESS preAdd6_final_process;


  multInDelay6_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay6_reg <= (OTHERS => to_signed(16#000#, 11));
      ELSIF enb = '1' THEN
        multInDelay6_reg(0) <= preAdd6_final_reg;
        multInDelay6_reg(1) <= multInDelay6_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay6_process;

  multInReg6 <= multInDelay6_reg(1);

  multOut6 <= resize(multInReg6 & '0' & '0' & '0', 35);

  multOutDelay6_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay6_reg <= (OTHERS => to_signed(0, 35));
      ELSIF enb = '1' THEN
        multOutDelay6_reg(0) <= multOut6;
        multOutDelay6_reg(1) <= multOutDelay6_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay6_process;

  multOutReg6 <= multOutDelay6_reg(1);

  add_stage1_6_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_6 <= to_signed(0, 35);
      ELSIF enb = '1' THEN
        add_stage1_6 <= multOutReg6;
      END IF;
    END IF;
  END PROCESS add_stage1_6_reg_process;


  adder_add_cast_6 <= resize(add_stage1_5, 36);
  adder_add_cast_7 <= resize(add_stage1_6, 36);
  add_stage1_add_3 <= adder_add_cast_6 + adder_add_cast_7;

  add_stage2_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage2_3 <= to_signed(0, 36);
      ELSIF enb = '1' THEN
        add_stage2_3 <= add_stage1_add_3;
      END IF;
    END IF;
  END PROCESS add_stage2_3_reg_process;


  tapOutData_2_5 <= tapOutData_2(5);

  preAdd7_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd7_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd7_stage1_1 <= tapOutData_2_5;
      END IF;
    END IF;
  END PROCESS preAdd7_stage1_1_reg_process;


  tapOutData_2_2 <= tapOutData_2(2);

  preAdd7_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd7_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd7_stage1_2 <= tapOutData_2_2;
      END IF;
    END IF;
  END PROCESS preAdd7_stage1_2_reg_process;


  subtractor_sub_temp_18 <= resize(preAdd7_stage1_1, 9) - resize(preAdd7_stage1_2, 9);
  preAdd7_stage1_add_1 <= signed(subtractor_sub_temp_18);

  preAdd7_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd7_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd7_stage2_1 <= preAdd7_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd7_stage2_1_reg_process;


  tapOutData_15_5 <= tapOutData_15(5);

  preAdd7_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd7_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd7_stage1_3 <= tapOutData_15_5;
      END IF;
    END IF;
  END PROCESS preAdd7_stage1_3_reg_process;


  tapOutData_15_2 <= tapOutData_15(2);

  preAdd7_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd7_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd7_stage1_4 <= tapOutData_15_2;
      END IF;
    END IF;
  END PROCESS preAdd7_stage1_4_reg_process;


  subtractor_sub_temp_19 <= resize(preAdd7_stage1_3, 9) - resize(preAdd7_stage1_4, 9);
  preAdd7_stage1_add_2 <= signed(subtractor_sub_temp_19);

  preAdd7_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd7_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd7_stage2_2 <= preAdd7_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd7_stage2_2_reg_process;


  preAdd7_stage2_add_1 <= resize(preAdd7_stage2_1, 10) + resize(preAdd7_stage2_2, 10);

  preAdd7_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd7_final_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd7_final_reg <= preAdd7_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd7_final_process;


  preAdd7_balance_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd7_balance_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd7_balance_reg <= preAdd7_final_reg;
      END IF;
    END IF;
  END PROCESS preAdd7_balance_process;


  multInDelay7_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay7_reg <= (OTHERS => to_signed(16#000#, 10));
      ELSIF enb = '1' THEN
        multInDelay7_reg(0) <= preAdd7_balance_reg;
        multInDelay7_reg(1) <= multInDelay7_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay7_process;

  multInReg7 <= multInDelay7_reg(1);

  multOut7 <= to_signed(16#00000A#, 24) * multInReg7;

  multOutDelay7_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay7_reg <= (OTHERS => to_signed(0, 34));
      ELSIF enb = '1' THEN
        multOutDelay7_reg(0) <= multOut7;
        multOutDelay7_reg(1) <= multOutDelay7_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay7_process;

  multOutReg7 <= multOutDelay7_reg(1);

  add_stage1_7_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_7 <= to_signed(0, 34);
      ELSIF enb = '1' THEN
        add_stage1_7 <= multOutReg7;
      END IF;
    END IF;
  END PROCESS add_stage1_7_reg_process;


  tapOutData_1_6 <= tapOutData_1(6);

  preAdd8_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd8_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd8_stage1_1 <= tapOutData_1_6;
      END IF;
    END IF;
  END PROCESS preAdd8_stage1_1_reg_process;


  tapOutData_1_1 <= tapOutData_1(1);

  preAdd8_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd8_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd8_stage1_2 <= tapOutData_1_1;
      END IF;
    END IF;
  END PROCESS preAdd8_stage1_2_reg_process;


  subtractor_sub_temp_20 <= resize(preAdd8_stage1_1, 9) - resize(preAdd8_stage1_2, 9);
  preAdd8_stage1_add_1 <= signed(subtractor_sub_temp_20);

  preAdd8_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd8_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd8_stage2_1 <= preAdd8_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd8_stage2_1_reg_process;


  tapOutData_16_6 <= tapOutData_16(6);

  preAdd8_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd8_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd8_stage1_3 <= tapOutData_16_6;
      END IF;
    END IF;
  END PROCESS preAdd8_stage1_3_reg_process;


  tapOutData_16_1 <= tapOutData_16(1);

  preAdd8_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd8_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd8_stage1_4 <= tapOutData_16_1;
      END IF;
    END IF;
  END PROCESS preAdd8_stage1_4_reg_process;


  subtractor_sub_temp_21 <= resize(preAdd8_stage1_3, 9) - resize(preAdd8_stage1_4, 9);
  preAdd8_stage1_add_2 <= signed(subtractor_sub_temp_21);

  preAdd8_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd8_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd8_stage2_2 <= preAdd8_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd8_stage2_2_reg_process;


  preAdd8_stage2_add_1 <= resize(preAdd8_stage2_1, 10) + resize(preAdd8_stage2_2, 10);

  preAdd8_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd8_final_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd8_final_reg <= preAdd8_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd8_final_process;


  preAdd8_balance_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd8_balance_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd8_balance_reg <= preAdd8_final_reg;
      END IF;
    END IF;
  END PROCESS preAdd8_balance_process;


  multInDelay8_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay8_reg <= (OTHERS => to_signed(16#000#, 10));
      ELSIF enb = '1' THEN
        multInDelay8_reg(0) <= preAdd8_balance_reg;
        multInDelay8_reg(1) <= multInDelay8_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay8_process;

  multInReg8 <= multInDelay8_reg(1);

  multOut8 <= to_signed(16#00000B#, 24) * multInReg8;

  multOutDelay8_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay8_reg <= (OTHERS => to_signed(0, 34));
      ELSIF enb = '1' THEN
        multOutDelay8_reg(0) <= multOut8;
        multOutDelay8_reg(1) <= multOutDelay8_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay8_process;

  multOutReg8 <= multOutDelay8_reg(1);

  add_stage1_8_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_8 <= to_signed(0, 34);
      ELSIF enb = '1' THEN
        add_stage1_8 <= multOutReg8;
      END IF;
    END IF;
  END PROCESS add_stage1_8_reg_process;


  adder_add_cast_8 <= resize(add_stage1_7, 35);
  adder_add_cast_9 <= resize(add_stage1_8, 35);
  add_stage1_add_4 <= adder_add_cast_8 + adder_add_cast_9;

  add_stage2_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage2_4 <= to_signed(0, 35);
      ELSIF enb = '1' THEN
        add_stage2_4 <= add_stage1_add_4;
      END IF;
    END IF;
  END PROCESS add_stage2_4_reg_process;


  adder_add_cast_10 <= resize(add_stage2_3, 37);
  adder_add_cast_11 <= resize(add_stage2_4, 37);
  add_stage2_add_2 <= adder_add_cast_10 + adder_add_cast_11;

  add_stage3_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage3_2 <= to_signed(0, 37);
      ELSIF enb = '1' THEN
        add_stage3_2 <= add_stage2_add_2;
      END IF;
    END IF;
  END PROCESS add_stage3_2_reg_process;


  adder_add_cast_12 <= resize(add_stage3_1, 38);
  adder_add_cast_13 <= resize(add_stage3_2, 38);
  add_stage3_add_1 <= adder_add_cast_12 + adder_add_cast_13;

  add_stage4_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage4_1 <= to_signed(0, 38);
      ELSIF enb = '1' THEN
        add_stage4_1 <= add_stage3_add_1;
      END IF;
    END IF;
  END PROCESS add_stage4_1_reg_process;


  tapOutData_3_5 <= tapOutData_3(5);

  preAdd9_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd9_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd9_stage1_1 <= tapOutData_3_5;
      END IF;
    END IF;
  END PROCESS preAdd9_stage1_1_reg_process;


  tapOutData_3_2 <= tapOutData_3(2);

  preAdd9_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd9_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd9_stage1_2 <= tapOutData_3_2;
      END IF;
    END IF;
  END PROCESS preAdd9_stage1_2_reg_process;


  subtractor_sub_temp_22 <= resize(preAdd9_stage1_1, 9) - resize(preAdd9_stage1_2, 9);
  preAdd9_stage1_add_1 <= signed(subtractor_sub_temp_22);

  preAdd9_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd9_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd9_stage2_1 <= preAdd9_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd9_stage2_1_reg_process;


  tapOutData_14_5 <= tapOutData_14(5);

  preAdd9_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd9_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd9_stage1_3 <= tapOutData_14_5;
      END IF;
    END IF;
  END PROCESS preAdd9_stage1_3_reg_process;


  tapOutData_14_2 <= tapOutData_14(2);

  preAdd9_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd9_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd9_stage1_4 <= tapOutData_14_2;
      END IF;
    END IF;
  END PROCESS preAdd9_stage1_4_reg_process;


  subtractor_sub_temp_23 <= resize(preAdd9_stage1_3, 9) - resize(preAdd9_stage1_4, 9);
  preAdd9_stage1_add_2 <= signed(subtractor_sub_temp_23);

  preAdd9_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd9_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd9_stage2_2 <= preAdd9_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd9_stage2_2_reg_process;


  preAdd9_stage2_add_1 <= resize(preAdd9_stage2_1, 10) + resize(preAdd9_stage2_2, 10);

  preAdd9_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd9_final_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd9_final_reg <= preAdd9_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd9_final_process;


  preAdd9_balance_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd9_balance_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd9_balance_reg <= preAdd9_final_reg;
      END IF;
    END IF;
  END PROCESS preAdd9_balance_process;


  multInDelay9_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay9_reg <= (OTHERS => to_signed(16#000#, 10));
      ELSIF enb = '1' THEN
        multInDelay9_reg(0) <= preAdd9_balance_reg;
        multInDelay9_reg(1) <= multInDelay9_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay9_process;

  multInReg9 <= multInDelay9_reg(1);

  multOut9 <= to_signed(16#00000C#, 24) * multInReg9;

  multOutDelay9_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay9_reg <= (OTHERS => to_signed(0, 34));
      ELSIF enb = '1' THEN
        multOutDelay9_reg(0) <= multOut9;
        multOutDelay9_reg(1) <= multOutDelay9_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay9_process;

  multOutReg9 <= multOutDelay9_reg(1);

  add_stage1_9_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_9 <= to_signed(0, 34);
      ELSIF enb = '1' THEN
        add_stage1_9 <= multOutReg9;
      END IF;
    END IF;
  END PROCESS add_stage1_9_reg_process;


  tapOutData_1_7 <= tapOutData_1(7);

  preAdd10_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd10_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd10_stage1_1 <= tapOutData_1_7;
      END IF;
    END IF;
  END PROCESS preAdd10_stage1_1_reg_process;


  tapOutData_1_0 <= tapOutData_1(0);

  preAdd10_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd10_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd10_stage1_2 <= tapOutData_1_0;
      END IF;
    END IF;
  END PROCESS preAdd10_stage1_2_reg_process;


  subtractor_sub_temp_24 <= resize(preAdd10_stage1_1, 9) - resize(preAdd10_stage1_2, 9);
  preAdd10_stage1_add_1 <= signed(subtractor_sub_temp_24);

  preAdd10_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd10_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd10_stage2_1 <= preAdd10_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd10_stage2_1_reg_process;


  tapOutData_16_7 <= tapOutData_16(7);

  preAdd10_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd10_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd10_stage1_3 <= tapOutData_16_7;
      END IF;
    END IF;
  END PROCESS preAdd10_stage1_3_reg_process;


  tapOutData_16_0 <= tapOutData_16(0);

  preAdd10_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd10_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd10_stage1_4 <= tapOutData_16_0;
      END IF;
    END IF;
  END PROCESS preAdd10_stage1_4_reg_process;


  subtractor_sub_temp_25 <= resize(preAdd10_stage1_3, 9) - resize(preAdd10_stage1_4, 9);
  preAdd10_stage1_add_2 <= signed(subtractor_sub_temp_25);

  preAdd10_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd10_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd10_stage2_2 <= preAdd10_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd10_stage2_2_reg_process;


  preAdd10_stage2_add_1 <= resize(preAdd10_stage2_1, 10) + resize(preAdd10_stage2_2, 10);

  preAdd10_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd10_final_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd10_final_reg <= preAdd10_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd10_final_process;


  preAdd10_balance_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd10_balance_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd10_balance_reg <= preAdd10_final_reg;
      END IF;
    END IF;
  END PROCESS preAdd10_balance_process;


  multInDelay10_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay10_reg <= (OTHERS => to_signed(16#000#, 10));
      ELSIF enb = '1' THEN
        multInDelay10_reg(0) <= preAdd10_balance_reg;
        multInDelay10_reg(1) <= multInDelay10_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay10_process;

  multInReg10 <= multInDelay10_reg(1);

  multOut10 <= to_signed(16#00000D#, 24) * multInReg10;

  multOutDelay10_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay10_reg <= (OTHERS => to_signed(0, 34));
      ELSIF enb = '1' THEN
        multOutDelay10_reg(0) <= multOut10;
        multOutDelay10_reg(1) <= multOutDelay10_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay10_process;

  multOutReg10 <= multOutDelay10_reg(1);

  add_stage1_10_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_10 <= to_signed(0, 34);
      ELSIF enb = '1' THEN
        add_stage1_10 <= multOutReg10;
      END IF;
    END IF;
  END PROCESS add_stage1_10_reg_process;


  adder_add_cast_14 <= resize(add_stage1_9, 35);
  adder_add_cast_15 <= resize(add_stage1_10, 35);
  add_stage1_add_5 <= adder_add_cast_14 + adder_add_cast_15;

  add_stage2_5_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage2_5 <= to_signed(0, 35);
      ELSIF enb = '1' THEN
        add_stage2_5 <= add_stage1_add_5;
      END IF;
    END IF;
  END PROCESS add_stage2_5_reg_process;


  tapOutData_4_5 <= tapOutData_4(5);

  preAdd11_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd11_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd11_stage1_1 <= tapOutData_4_5;
      END IF;
    END IF;
  END PROCESS preAdd11_stage1_1_reg_process;


  tapOutData_2_1 <= tapOutData_2(1);

  preAdd11_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd11_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd11_stage1_2 <= tapOutData_2_1;
      END IF;
    END IF;
  END PROCESS preAdd11_stage1_2_reg_process;


  subtractor_sub_temp_26 <= resize(preAdd11_stage1_1, 9) - resize(preAdd11_stage1_2, 9);
  preAdd11_stage1_add_1 <= signed(subtractor_sub_temp_26);

  preAdd11_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd11_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd11_stage2_1 <= preAdd11_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd11_stage2_1_reg_process;


  tapOutData_13_5 <= tapOutData_13(5);

  preAdd11_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd11_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd11_stage1_3 <= tapOutData_13_5;
      END IF;
    END IF;
  END PROCESS preAdd11_stage1_3_reg_process;


  tapOutData_15_1 <= tapOutData_15(1);

  preAdd11_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd11_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd11_stage1_4 <= tapOutData_15_1;
      END IF;
    END IF;
  END PROCESS preAdd11_stage1_4_reg_process;


  subtractor_sub_temp_27 <= resize(preAdd11_stage1_3, 9) - resize(preAdd11_stage1_4, 9);
  preAdd11_stage1_add_2 <= signed(subtractor_sub_temp_27);

  preAdd11_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd11_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd11_stage2_2 <= preAdd11_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd11_stage2_2_reg_process;


  preAdd11_stage2_add_1 <= resize(preAdd11_stage2_1, 10) + resize(preAdd11_stage2_2, 10);

  preAdd11_stage3_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd11_stage3_1 <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd11_stage3_1 <= preAdd11_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd11_stage3_1_reg_process;


  tapOutData_2_6 <= tapOutData_2(6);

  preAdd11_stage1_5_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd11_stage1_5 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd11_stage1_5 <= tapOutData_2_6;
      END IF;
    END IF;
  END PROCESS preAdd11_stage1_5_reg_process;


  tapOutData_4_2 <= tapOutData_4(2);

  preAdd11_stage1_6_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd11_stage1_6 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd11_stage1_6 <= tapOutData_4_2;
      END IF;
    END IF;
  END PROCESS preAdd11_stage1_6_reg_process;


  subtractor_sub_temp_28 <= resize(preAdd11_stage1_5, 9) - resize(preAdd11_stage1_6, 9);
  preAdd11_stage1_add_3 <= signed(subtractor_sub_temp_28);

  preAdd11_stage2_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd11_stage2_3 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd11_stage2_3 <= preAdd11_stage1_add_3;
      END IF;
    END IF;
  END PROCESS preAdd11_stage2_3_reg_process;


  tapOutData_15_6 <= tapOutData_15(6);

  preAdd11_stage1_7_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd11_stage1_7 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd11_stage1_7 <= tapOutData_15_6;
      END IF;
    END IF;
  END PROCESS preAdd11_stage1_7_reg_process;


  tapOutData_13_2 <= tapOutData_13(2);

  preAdd11_stage1_8_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd11_stage1_8 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd11_stage1_8 <= tapOutData_13_2;
      END IF;
    END IF;
  END PROCESS preAdd11_stage1_8_reg_process;


  subtractor_sub_temp_29 <= resize(preAdd11_stage1_7, 9) - resize(preAdd11_stage1_8, 9);
  preAdd11_stage1_add_4 <= signed(subtractor_sub_temp_29);

  preAdd11_stage2_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd11_stage2_4 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd11_stage2_4 <= preAdd11_stage1_add_4;
      END IF;
    END IF;
  END PROCESS preAdd11_stage2_4_reg_process;


  preAdd11_stage2_add_2 <= resize(preAdd11_stage2_3, 10) + resize(preAdd11_stage2_4, 10);

  preAdd11_stage3_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd11_stage3_2 <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd11_stage3_2 <= preAdd11_stage2_add_2;
      END IF;
    END IF;
  END PROCESS preAdd11_stage3_2_reg_process;


  preAdd11_stage3_add_1 <= resize(preAdd11_stage3_1, 11) + resize(preAdd11_stage3_2, 11);

  preAdd11_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd11_final_reg <= to_signed(16#000#, 11);
      ELSIF enb = '1' THEN
        preAdd11_final_reg <= preAdd11_stage3_add_1;
      END IF;
    END IF;
  END PROCESS preAdd11_final_process;


  multInDelay11_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay11_reg <= (OTHERS => to_signed(16#000#, 11));
      ELSIF enb = '1' THEN
        multInDelay11_reg(0) <= preAdd11_final_reg;
        multInDelay11_reg(1) <= multInDelay11_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay11_process;

  multInReg11 <= multInDelay11_reg(1);

  multOut11 <= to_signed(16#00000F#, 24) * multInReg11;

  multOutDelay11_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay11_reg <= (OTHERS => to_signed(0, 35));
      ELSIF enb = '1' THEN
        multOutDelay11_reg(0) <= multOut11;
        multOutDelay11_reg(1) <= multOutDelay11_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay11_process;

  multOutReg11 <= multOutDelay11_reg(1);

  add_stage1_11_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_11 <= to_signed(0, 35);
      ELSIF enb = '1' THEN
        add_stage1_11 <= multOutReg11;
      END IF;
    END IF;
  END PROCESS add_stage1_11_reg_process;


  tapOutData_2_7 <= tapOutData_2(7);

  preAdd12_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd12_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd12_stage1_1 <= tapOutData_2_7;
      END IF;
    END IF;
  END PROCESS preAdd12_stage1_1_reg_process;


  tapOutData_2_0 <= tapOutData_2(0);

  preAdd12_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd12_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd12_stage1_2 <= tapOutData_2_0;
      END IF;
    END IF;
  END PROCESS preAdd12_stage1_2_reg_process;


  subtractor_sub_temp_30 <= resize(preAdd12_stage1_1, 9) - resize(preAdd12_stage1_2, 9);
  preAdd12_stage1_add_1 <= signed(subtractor_sub_temp_30);

  preAdd12_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd12_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd12_stage2_1 <= preAdd12_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd12_stage2_1_reg_process;


  tapOutData_15_7 <= tapOutData_15(7);

  preAdd12_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd12_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd12_stage1_3 <= tapOutData_15_7;
      END IF;
    END IF;
  END PROCESS preAdd12_stage1_3_reg_process;


  tapOutData_15_0 <= tapOutData_15(0);

  preAdd12_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd12_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd12_stage1_4 <= tapOutData_15_0;
      END IF;
    END IF;
  END PROCESS preAdd12_stage1_4_reg_process;


  subtractor_sub_temp_31 <= resize(preAdd12_stage1_3, 9) - resize(preAdd12_stage1_4, 9);
  preAdd12_stage1_add_2 <= signed(subtractor_sub_temp_31);

  preAdd12_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd12_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd12_stage2_2 <= preAdd12_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd12_stage2_2_reg_process;


  preAdd12_stage2_add_1 <= resize(preAdd12_stage2_1, 10) + resize(preAdd12_stage2_2, 10);

  preAdd12_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd12_final_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd12_final_reg <= preAdd12_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd12_final_process;


  preAdd12_balance_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd12_balance_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd12_balance_reg <= preAdd12_final_reg;
      END IF;
    END IF;
  END PROCESS preAdd12_balance_process;


  multInDelay12_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay12_reg <= (OTHERS => to_signed(16#000#, 10));
      ELSIF enb = '1' THEN
        multInDelay12_reg(0) <= preAdd12_balance_reg;
        multInDelay12_reg(1) <= multInDelay12_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay12_process;

  multInReg12 <= multInDelay12_reg(1);

  multOut12 <= to_signed(16#000011#, 24) * multInReg12;

  multOutDelay12_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay12_reg <= (OTHERS => to_signed(0, 34));
      ELSIF enb = '1' THEN
        multOutDelay12_reg(0) <= multOut12;
        multOutDelay12_reg(1) <= multOutDelay12_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay12_process;

  multOutReg12 <= multOutDelay12_reg(1);

  add_stage1_12_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_12 <= to_signed(0, 34);
      ELSIF enb = '1' THEN
        add_stage1_12 <= multOutReg12;
      END IF;
    END IF;
  END PROCESS add_stage1_12_reg_process;


  adder_add_cast_16 <= resize(add_stage1_11, 36);
  adder_add_cast_17 <= resize(add_stage1_12, 36);
  add_stage1_add_6 <= adder_add_cast_16 + adder_add_cast_17;

  add_stage2_6_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage2_6 <= to_signed(0, 36);
      ELSIF enb = '1' THEN
        add_stage2_6 <= add_stage1_add_6;
      END IF;
    END IF;
  END PROCESS add_stage2_6_reg_process;


  adder_add_cast_18 <= resize(add_stage2_5, 37);
  adder_add_cast_19 <= resize(add_stage2_6, 37);
  add_stage2_add_3 <= adder_add_cast_18 + adder_add_cast_19;

  add_stage3_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage3_3 <= to_signed(0, 37);
      ELSIF enb = '1' THEN
        add_stage3_3 <= add_stage2_add_3;
      END IF;
    END IF;
  END PROCESS add_stage3_3_reg_process;


  tapOutData_5_5 <= tapOutData_5(5);

  preAdd13_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd13_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd13_stage1_1 <= tapOutData_5_5;
      END IF;
    END IF;
  END PROCESS preAdd13_stage1_1_reg_process;


  tapOutData_5_2 <= tapOutData_5(2);

  preAdd13_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd13_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd13_stage1_2 <= tapOutData_5_2;
      END IF;
    END IF;
  END PROCESS preAdd13_stage1_2_reg_process;


  subtractor_sub_temp_32 <= resize(preAdd13_stage1_1, 9) - resize(preAdd13_stage1_2, 9);
  preAdd13_stage1_add_1 <= signed(subtractor_sub_temp_32);

  preAdd13_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd13_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd13_stage2_1 <= preAdd13_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd13_stage2_1_reg_process;


  tapOutData_12_5 <= tapOutData_12(5);

  preAdd13_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd13_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd13_stage1_3 <= tapOutData_12_5;
      END IF;
    END IF;
  END PROCESS preAdd13_stage1_3_reg_process;


  tapOutData_12_2 <= tapOutData_12(2);

  preAdd13_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd13_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd13_stage1_4 <= tapOutData_12_2;
      END IF;
    END IF;
  END PROCESS preAdd13_stage1_4_reg_process;


  subtractor_sub_temp_33 <= resize(preAdd13_stage1_3, 9) - resize(preAdd13_stage1_4, 9);
  preAdd13_stage1_add_2 <= signed(subtractor_sub_temp_33);

  preAdd13_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd13_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd13_stage2_2 <= preAdd13_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd13_stage2_2_reg_process;


  preAdd13_stage2_add_1 <= resize(preAdd13_stage2_1, 10) + resize(preAdd13_stage2_2, 10);

  preAdd13_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd13_final_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd13_final_reg <= preAdd13_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd13_final_process;


  preAdd13_balance_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd13_balance_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd13_balance_reg <= preAdd13_final_reg;
      END IF;
    END IF;
  END PROCESS preAdd13_balance_process;


  multInDelay13_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay13_reg <= (OTHERS => to_signed(16#000#, 10));
      ELSIF enb = '1' THEN
        multInDelay13_reg(0) <= preAdd13_balance_reg;
        multInDelay13_reg(1) <= multInDelay13_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay13_process;

  multInReg13 <= multInDelay13_reg(1);

  multOut13 <= to_signed(16#000012#, 24) * multInReg13;

  multOutDelay13_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay13_reg <= (OTHERS => to_signed(0, 34));
      ELSIF enb = '1' THEN
        multOutDelay13_reg(0) <= multOut13;
        multOutDelay13_reg(1) <= multOutDelay13_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay13_process;

  multOutReg13 <= multOutDelay13_reg(1);

  add_stage1_13_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_13 <= to_signed(0, 34);
      ELSIF enb = '1' THEN
        add_stage1_13 <= multOutReg13;
      END IF;
    END IF;
  END PROCESS add_stage1_13_reg_process;


  tapOutData_3_6 <= tapOutData_3(6);

  preAdd14_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd14_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd14_stage1_1 <= tapOutData_3_6;
      END IF;
    END IF;
  END PROCESS preAdd14_stage1_1_reg_process;


  tapOutData_3_1 <= tapOutData_3(1);

  preAdd14_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd14_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd14_stage1_2 <= tapOutData_3_1;
      END IF;
    END IF;
  END PROCESS preAdd14_stage1_2_reg_process;


  subtractor_sub_temp_34 <= resize(preAdd14_stage1_1, 9) - resize(preAdd14_stage1_2, 9);
  preAdd14_stage1_add_1 <= signed(subtractor_sub_temp_34);

  preAdd14_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd14_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd14_stage2_1 <= preAdd14_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd14_stage2_1_reg_process;


  tapOutData_14_6 <= tapOutData_14(6);

  preAdd14_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd14_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd14_stage1_3 <= tapOutData_14_6;
      END IF;
    END IF;
  END PROCESS preAdd14_stage1_3_reg_process;


  tapOutData_14_1 <= tapOutData_14(1);

  preAdd14_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd14_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd14_stage1_4 <= tapOutData_14_1;
      END IF;
    END IF;
  END PROCESS preAdd14_stage1_4_reg_process;


  subtractor_sub_temp_35 <= resize(preAdd14_stage1_3, 9) - resize(preAdd14_stage1_4, 9);
  preAdd14_stage1_add_2 <= signed(subtractor_sub_temp_35);

  preAdd14_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd14_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd14_stage2_2 <= preAdd14_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd14_stage2_2_reg_process;


  preAdd14_stage2_add_1 <= resize(preAdd14_stage2_1, 10) + resize(preAdd14_stage2_2, 10);

  preAdd14_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd14_final_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd14_final_reg <= preAdd14_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd14_final_process;


  preAdd14_balance_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd14_balance_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd14_balance_reg <= preAdd14_final_reg;
      END IF;
    END IF;
  END PROCESS preAdd14_balance_process;


  multInDelay14_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay14_reg <= (OTHERS => to_signed(16#000#, 10));
      ELSIF enb = '1' THEN
        multInDelay14_reg(0) <= preAdd14_balance_reg;
        multInDelay14_reg(1) <= multInDelay14_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay14_process;

  multInReg14 <= multInDelay14_reg(1);

  multOut14 <= to_signed(16#000013#, 24) * multInReg14;

  multOutDelay14_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay14_reg <= (OTHERS => to_signed(0, 34));
      ELSIF enb = '1' THEN
        multOutDelay14_reg(0) <= multOut14;
        multOutDelay14_reg(1) <= multOutDelay14_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay14_process;

  multOutReg14 <= multOutDelay14_reg(1);

  add_stage1_14_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_14 <= to_signed(0, 34);
      ELSIF enb = '1' THEN
        add_stage1_14 <= multOutReg14;
      END IF;
    END IF;
  END PROCESS add_stage1_14_reg_process;


  adder_add_cast_20 <= resize(add_stage1_13, 35);
  adder_add_cast_21 <= resize(add_stage1_14, 35);
  add_stage1_add_7 <= adder_add_cast_20 + adder_add_cast_21;

  add_stage2_7_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage2_7 <= to_signed(0, 35);
      ELSIF enb = '1' THEN
        add_stage2_7 <= add_stage1_add_7;
      END IF;
    END IF;
  END PROCESS add_stage2_7_reg_process;


  tapOutData_6_5 <= tapOutData_6(5);

  preAdd15_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd15_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd15_stage1_1 <= tapOutData_6_5;
      END IF;
    END IF;
  END PROCESS preAdd15_stage1_1_reg_process;


  tapOutData_6_2 <= tapOutData_6(2);

  preAdd15_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd15_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd15_stage1_2 <= tapOutData_6_2;
      END IF;
    END IF;
  END PROCESS preAdd15_stage1_2_reg_process;


  subtractor_sub_temp_36 <= resize(preAdd15_stage1_1, 9) - resize(preAdd15_stage1_2, 9);
  preAdd15_stage1_add_1 <= signed(subtractor_sub_temp_36);

  preAdd15_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd15_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd15_stage2_1 <= preAdd15_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd15_stage2_1_reg_process;


  tapOutData_11_5 <= tapOutData_11(5);

  preAdd15_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd15_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd15_stage1_3 <= tapOutData_11_5;
      END IF;
    END IF;
  END PROCESS preAdd15_stage1_3_reg_process;


  tapOutData_11_2 <= tapOutData_11(2);

  preAdd15_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd15_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd15_stage1_4 <= tapOutData_11_2;
      END IF;
    END IF;
  END PROCESS preAdd15_stage1_4_reg_process;


  subtractor_sub_temp_37 <= resize(preAdd15_stage1_3, 9) - resize(preAdd15_stage1_4, 9);
  preAdd15_stage1_add_2 <= signed(subtractor_sub_temp_37);

  preAdd15_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd15_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd15_stage2_2 <= preAdd15_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd15_stage2_2_reg_process;


  preAdd15_stage2_add_1 <= resize(preAdd15_stage2_1, 10) + resize(preAdd15_stage2_2, 10);

  preAdd15_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd15_final_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd15_final_reg <= preAdd15_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd15_final_process;


  preAdd15_balance_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd15_balance_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd15_balance_reg <= preAdd15_final_reg;
      END IF;
    END IF;
  END PROCESS preAdd15_balance_process;


  multInDelay15_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay15_reg <= (OTHERS => to_signed(16#000#, 10));
      ELSIF enb = '1' THEN
        multInDelay15_reg(0) <= preAdd15_balance_reg;
        multInDelay15_reg(1) <= multInDelay15_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay15_process;

  multInReg15 <= multInDelay15_reg(1);

  multOut15 <= to_signed(16#000014#, 24) * multInReg15;

  multOutDelay15_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay15_reg <= (OTHERS => to_signed(0, 34));
      ELSIF enb = '1' THEN
        multOutDelay15_reg(0) <= multOut15;
        multOutDelay15_reg(1) <= multOutDelay15_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay15_process;

  multOutReg15 <= multOutDelay15_reg(1);

  add_stage1_15_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_15 <= to_signed(0, 34);
      ELSIF enb = '1' THEN
        add_stage1_15 <= multOutReg15;
      END IF;
    END IF;
  END PROCESS add_stage1_15_reg_process;


  tapOutData_7_5 <= tapOutData_7(5);

  preAdd16_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd16_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd16_stage1_1 <= tapOutData_7_5;
      END IF;
    END IF;
  END PROCESS preAdd16_stage1_1_reg_process;


  tapOutData_3_0 <= tapOutData_3(0);

  preAdd16_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd16_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd16_stage1_2 <= tapOutData_3_0;
      END IF;
    END IF;
  END PROCESS preAdd16_stage1_2_reg_process;


  subtractor_sub_temp_38 <= resize(preAdd16_stage1_1, 9) - resize(preAdd16_stage1_2, 9);
  preAdd16_stage1_add_1 <= signed(subtractor_sub_temp_38);

  preAdd16_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd16_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd16_stage2_1 <= preAdd16_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd16_stage2_1_reg_process;


  tapOutData_10_5 <= tapOutData_10(5);

  preAdd16_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd16_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd16_stage1_3 <= tapOutData_10_5;
      END IF;
    END IF;
  END PROCESS preAdd16_stage1_3_reg_process;


  tapOutData_14_0 <= tapOutData_14(0);

  preAdd16_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd16_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd16_stage1_4 <= tapOutData_14_0;
      END IF;
    END IF;
  END PROCESS preAdd16_stage1_4_reg_process;


  subtractor_sub_temp_39 <= resize(preAdd16_stage1_3, 9) - resize(preAdd16_stage1_4, 9);
  preAdd16_stage1_add_2 <= signed(subtractor_sub_temp_39);

  preAdd16_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd16_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd16_stage2_2 <= preAdd16_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd16_stage2_2_reg_process;


  preAdd16_stage2_add_1 <= resize(preAdd16_stage2_1, 10) + resize(preAdd16_stage2_2, 10);

  preAdd16_stage3_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd16_stage3_1 <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd16_stage3_1 <= preAdd16_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd16_stage3_1_reg_process;


  tapOutData_3_7 <= tapOutData_3(7);

  preAdd16_stage1_5_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd16_stage1_5 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd16_stage1_5 <= tapOutData_3_7;
      END IF;
    END IF;
  END PROCESS preAdd16_stage1_5_reg_process;


  tapOutData_7_2 <= tapOutData_7(2);

  preAdd16_stage1_6_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd16_stage1_6 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd16_stage1_6 <= tapOutData_7_2;
      END IF;
    END IF;
  END PROCESS preAdd16_stage1_6_reg_process;


  subtractor_sub_temp_40 <= resize(preAdd16_stage1_5, 9) - resize(preAdd16_stage1_6, 9);
  preAdd16_stage1_add_3 <= signed(subtractor_sub_temp_40);

  preAdd16_stage2_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd16_stage2_3 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd16_stage2_3 <= preAdd16_stage1_add_3;
      END IF;
    END IF;
  END PROCESS preAdd16_stage2_3_reg_process;


  tapOutData_14_7 <= tapOutData_14(7);

  preAdd16_stage1_7_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd16_stage1_7 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd16_stage1_7 <= tapOutData_14_7;
      END IF;
    END IF;
  END PROCESS preAdd16_stage1_7_reg_process;


  tapOutData_10_2 <= tapOutData_10(2);

  preAdd16_stage1_8_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd16_stage1_8 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd16_stage1_8 <= tapOutData_10_2;
      END IF;
    END IF;
  END PROCESS preAdd16_stage1_8_reg_process;


  subtractor_sub_temp_41 <= resize(preAdd16_stage1_7, 9) - resize(preAdd16_stage1_8, 9);
  preAdd16_stage1_add_4 <= signed(subtractor_sub_temp_41);

  preAdd16_stage2_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd16_stage2_4 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd16_stage2_4 <= preAdd16_stage1_add_4;
      END IF;
    END IF;
  END PROCESS preAdd16_stage2_4_reg_process;


  preAdd16_stage2_add_2 <= resize(preAdd16_stage2_3, 10) + resize(preAdd16_stage2_4, 10);

  preAdd16_stage3_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd16_stage3_2 <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd16_stage3_2 <= preAdd16_stage2_add_2;
      END IF;
    END IF;
  END PROCESS preAdd16_stage3_2_reg_process;


  preAdd16_stage3_add_1 <= resize(preAdd16_stage3_1, 11) + resize(preAdd16_stage3_2, 11);

  preAdd16_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd16_final_reg <= to_signed(16#000#, 11);
      ELSIF enb = '1' THEN
        preAdd16_final_reg <= preAdd16_stage3_add_1;
      END IF;
    END IF;
  END PROCESS preAdd16_final_process;


  multInDelay16_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay16_reg <= (OTHERS => to_signed(16#000#, 11));
      ELSIF enb = '1' THEN
        multInDelay16_reg(0) <= preAdd16_final_reg;
        multInDelay16_reg(1) <= multInDelay16_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay16_process;

  multInReg16 <= multInDelay16_reg(1);

  multOut16 <= to_signed(16#000016#, 24) * multInReg16;

  multOutDelay16_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay16_reg <= (OTHERS => to_signed(0, 35));
      ELSIF enb = '1' THEN
        multOutDelay16_reg(0) <= multOut16;
        multOutDelay16_reg(1) <= multOutDelay16_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay16_process;

  multOutReg16 <= multOutDelay16_reg(1);

  add_stage1_16_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_16 <= to_signed(0, 35);
      ELSIF enb = '1' THEN
        add_stage1_16 <= multOutReg16;
      END IF;
    END IF;
  END PROCESS add_stage1_16_reg_process;


  adder_add_cast_22 <= resize(add_stage1_15, 36);
  adder_add_cast_23 <= resize(add_stage1_16, 36);
  add_stage1_add_8 <= adder_add_cast_22 + adder_add_cast_23;

  add_stage2_8_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage2_8 <= to_signed(0, 36);
      ELSIF enb = '1' THEN
        add_stage2_8 <= add_stage1_add_8;
      END IF;
    END IF;
  END PROCESS add_stage2_8_reg_process;


  adder_add_cast_24 <= resize(add_stage2_7, 37);
  adder_add_cast_25 <= resize(add_stage2_8, 37);
  add_stage2_add_4 <= adder_add_cast_24 + adder_add_cast_25;

  add_stage3_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage3_4 <= to_signed(0, 37);
      ELSIF enb = '1' THEN
        add_stage3_4 <= add_stage2_add_4;
      END IF;
    END IF;
  END PROCESS add_stage3_4_reg_process;


  adder_add_cast_26 <= resize(add_stage3_3, 38);
  adder_add_cast_27 <= resize(add_stage3_4, 38);
  add_stage3_add_2 <= adder_add_cast_26 + adder_add_cast_27;

  add_stage4_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage4_2 <= to_signed(0, 38);
      ELSIF enb = '1' THEN
        add_stage4_2 <= add_stage3_add_2;
      END IF;
    END IF;
  END PROCESS add_stage4_2_reg_process;


  adder_add_cast_28 <= resize(add_stage4_1, 39);
  adder_add_cast_29 <= resize(add_stage4_2, 39);
  add_stage4_add_1 <= adder_add_cast_28 + adder_add_cast_29;

  add_stage5_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage5_1 <= to_signed(0, 39);
      ELSIF enb = '1' THEN
        add_stage5_1 <= add_stage4_add_1;
      END IF;
    END IF;
  END PROCESS add_stage5_1_reg_process;


  tapOutData_8_5 <= tapOutData_8(5);

  preAdd17_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd17_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd17_stage1_1 <= tapOutData_8_5;
      END IF;
    END IF;
  END PROCESS preAdd17_stage1_1_reg_process;


  tapOutData_4_1 <= tapOutData_4(1);

  preAdd17_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd17_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd17_stage1_2 <= tapOutData_4_1;
      END IF;
    END IF;
  END PROCESS preAdd17_stage1_2_reg_process;


  subtractor_sub_temp_42 <= resize(preAdd17_stage1_1, 9) - resize(preAdd17_stage1_2, 9);
  preAdd17_stage1_add_1 <= signed(subtractor_sub_temp_42);

  preAdd17_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd17_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd17_stage2_1 <= preAdd17_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd17_stage2_1_reg_process;


  tapOutData_9_5 <= tapOutData_9(5);

  preAdd17_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd17_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd17_stage1_3 <= tapOutData_9_5;
      END IF;
    END IF;
  END PROCESS preAdd17_stage1_3_reg_process;


  tapOutData_13_1 <= tapOutData_13(1);

  preAdd17_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd17_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd17_stage1_4 <= tapOutData_13_1;
      END IF;
    END IF;
  END PROCESS preAdd17_stage1_4_reg_process;


  subtractor_sub_temp_43 <= resize(preAdd17_stage1_3, 9) - resize(preAdd17_stage1_4, 9);
  preAdd17_stage1_add_2 <= signed(subtractor_sub_temp_43);

  preAdd17_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd17_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd17_stage2_2 <= preAdd17_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd17_stage2_2_reg_process;


  preAdd17_stage2_add_1 <= resize(preAdd17_stage2_1, 10) + resize(preAdd17_stage2_2, 10);

  preAdd17_stage3_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd17_stage3_1 <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd17_stage3_1 <= preAdd17_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd17_stage3_1_reg_process;


  tapOutData_4_6 <= tapOutData_4(6);

  preAdd17_stage1_5_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd17_stage1_5 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd17_stage1_5 <= tapOutData_4_6;
      END IF;
    END IF;
  END PROCESS preAdd17_stage1_5_reg_process;


  tapOutData_8_2 <= tapOutData_8(2);

  preAdd17_stage1_6_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd17_stage1_6 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd17_stage1_6 <= tapOutData_8_2;
      END IF;
    END IF;
  END PROCESS preAdd17_stage1_6_reg_process;


  subtractor_sub_temp_44 <= resize(preAdd17_stage1_5, 9) - resize(preAdd17_stage1_6, 9);
  preAdd17_stage1_add_3 <= signed(subtractor_sub_temp_44);

  preAdd17_stage2_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd17_stage2_3 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd17_stage2_3 <= preAdd17_stage1_add_3;
      END IF;
    END IF;
  END PROCESS preAdd17_stage2_3_reg_process;


  tapOutData_13_6 <= tapOutData_13(6);

  preAdd17_stage1_7_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd17_stage1_7 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd17_stage1_7 <= tapOutData_13_6;
      END IF;
    END IF;
  END PROCESS preAdd17_stage1_7_reg_process;


  tapOutData_9_2 <= tapOutData_9(2);

  preAdd17_stage1_8_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd17_stage1_8 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd17_stage1_8 <= tapOutData_9_2;
      END IF;
    END IF;
  END PROCESS preAdd17_stage1_8_reg_process;


  subtractor_sub_temp_45 <= resize(preAdd17_stage1_7, 9) - resize(preAdd17_stage1_8, 9);
  preAdd17_stage1_add_4 <= signed(subtractor_sub_temp_45);

  preAdd17_stage2_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd17_stage2_4 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd17_stage2_4 <= preAdd17_stage1_add_4;
      END IF;
    END IF;
  END PROCESS preAdd17_stage2_4_reg_process;


  preAdd17_stage2_add_2 <= resize(preAdd17_stage2_3, 10) + resize(preAdd17_stage2_4, 10);

  preAdd17_stage3_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd17_stage3_2 <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd17_stage3_2 <= preAdd17_stage2_add_2;
      END IF;
    END IF;
  END PROCESS preAdd17_stage3_2_reg_process;


  preAdd17_stage3_add_1 <= resize(preAdd17_stage3_1, 11) + resize(preAdd17_stage3_2, 11);

  preAdd17_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd17_final_reg <= to_signed(16#000#, 11);
      ELSIF enb = '1' THEN
        preAdd17_final_reg <= preAdd17_stage3_add_1;
      END IF;
    END IF;
  END PROCESS preAdd17_final_process;


  multInDelay17_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay17_reg <= (OTHERS => to_signed(16#000#, 11));
      ELSIF enb = '1' THEN
        multInDelay17_reg(0) <= preAdd17_final_reg;
        multInDelay17_reg(1) <= multInDelay17_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay17_process;

  multInReg17 <= multInDelay17_reg(1);

  multOut17 <= to_signed(16#000017#, 24) * multInReg17;

  multOutDelay17_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay17_reg <= (OTHERS => to_signed(0, 35));
      ELSIF enb = '1' THEN
        multOutDelay17_reg(0) <= multOut17;
        multOutDelay17_reg(1) <= multOutDelay17_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay17_process;

  multOutReg17 <= multOutDelay17_reg(1);

  add_stage1_17_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_17 <= to_signed(0, 35);
      ELSIF enb = '1' THEN
        add_stage1_17 <= multOutReg17;
      END IF;
    END IF;
  END PROCESS add_stage1_17_reg_process;


  tapOutData_4_7 <= tapOutData_4(7);

  preAdd18_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd18_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd18_stage1_1 <= tapOutData_4_7;
      END IF;
    END IF;
  END PROCESS preAdd18_stage1_1_reg_process;


  tapOutData_4_0 <= tapOutData_4(0);

  preAdd18_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd18_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd18_stage1_2 <= tapOutData_4_0;
      END IF;
    END IF;
  END PROCESS preAdd18_stage1_2_reg_process;


  subtractor_sub_temp_46 <= resize(preAdd18_stage1_1, 9) - resize(preAdd18_stage1_2, 9);
  preAdd18_stage1_add_1 <= signed(subtractor_sub_temp_46);

  preAdd18_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd18_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd18_stage2_1 <= preAdd18_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd18_stage2_1_reg_process;


  tapOutData_13_7 <= tapOutData_13(7);

  preAdd18_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd18_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd18_stage1_3 <= tapOutData_13_7;
      END IF;
    END IF;
  END PROCESS preAdd18_stage1_3_reg_process;


  tapOutData_13_0 <= tapOutData_13(0);

  preAdd18_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd18_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd18_stage1_4 <= tapOutData_13_0;
      END IF;
    END IF;
  END PROCESS preAdd18_stage1_4_reg_process;


  subtractor_sub_temp_47 <= resize(preAdd18_stage1_3, 9) - resize(preAdd18_stage1_4, 9);
  preAdd18_stage1_add_2 <= signed(subtractor_sub_temp_47);

  preAdd18_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd18_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd18_stage2_2 <= preAdd18_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd18_stage2_2_reg_process;


  preAdd18_stage2_add_1 <= resize(preAdd18_stage2_1, 10) + resize(preAdd18_stage2_2, 10);

  preAdd18_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd18_final_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd18_final_reg <= preAdd18_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd18_final_process;


  preAdd18_balance_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd18_balance_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd18_balance_reg <= preAdd18_final_reg;
      END IF;
    END IF;
  END PROCESS preAdd18_balance_process;


  multInDelay18_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay18_reg <= (OTHERS => to_signed(16#000#, 10));
      ELSIF enb = '1' THEN
        multInDelay18_reg(0) <= preAdd18_balance_reg;
        multInDelay18_reg(1) <= multInDelay18_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay18_process;

  multInReg18 <= multInDelay18_reg(1);

  multOut18 <= to_signed(16#00001B#, 24) * multInReg18;

  multOutDelay18_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay18_reg <= (OTHERS => to_signed(0, 34));
      ELSIF enb = '1' THEN
        multOutDelay18_reg(0) <= multOut18;
        multOutDelay18_reg(1) <= multOutDelay18_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay18_process;

  multOutReg18 <= multOutDelay18_reg(1);

  add_stage1_18_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_18 <= to_signed(0, 34);
      ELSIF enb = '1' THEN
        add_stage1_18 <= multOutReg18;
      END IF;
    END IF;
  END PROCESS add_stage1_18_reg_process;


  adder_add_cast_30 <= resize(add_stage1_17, 36);
  adder_add_cast_31 <= resize(add_stage1_18, 36);
  add_stage1_add_9 <= adder_add_cast_30 + adder_add_cast_31;

  add_stage2_9_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage2_9 <= to_signed(0, 36);
      ELSIF enb = '1' THEN
        add_stage2_9 <= add_stage1_add_9;
      END IF;
    END IF;
  END PROCESS add_stage2_9_reg_process;


  tapOutData_5_6 <= tapOutData_5(6);

  preAdd19_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd19_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd19_stage1_1 <= tapOutData_5_6;
      END IF;
    END IF;
  END PROCESS preAdd19_stage1_1_reg_process;


  tapOutData_5_1 <= tapOutData_5(1);

  preAdd19_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd19_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd19_stage1_2 <= tapOutData_5_1;
      END IF;
    END IF;
  END PROCESS preAdd19_stage1_2_reg_process;


  subtractor_sub_temp_48 <= resize(preAdd19_stage1_1, 9) - resize(preAdd19_stage1_2, 9);
  preAdd19_stage1_add_1 <= signed(subtractor_sub_temp_48);

  preAdd19_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd19_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd19_stage2_1 <= preAdd19_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd19_stage2_1_reg_process;


  tapOutData_12_6 <= tapOutData_12(6);

  preAdd19_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd19_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd19_stage1_3 <= tapOutData_12_6;
      END IF;
    END IF;
  END PROCESS preAdd19_stage1_3_reg_process;


  tapOutData_12_1 <= tapOutData_12(1);

  preAdd19_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd19_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd19_stage1_4 <= tapOutData_12_1;
      END IF;
    END IF;
  END PROCESS preAdd19_stage1_4_reg_process;


  subtractor_sub_temp_49 <= resize(preAdd19_stage1_3, 9) - resize(preAdd19_stage1_4, 9);
  preAdd19_stage1_add_2 <= signed(subtractor_sub_temp_49);

  preAdd19_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd19_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd19_stage2_2 <= preAdd19_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd19_stage2_2_reg_process;


  preAdd19_stage2_add_1 <= resize(preAdd19_stage2_1, 10) + resize(preAdd19_stage2_2, 10);

  preAdd19_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd19_final_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd19_final_reg <= preAdd19_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd19_final_process;


  preAdd19_balance_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd19_balance_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd19_balance_reg <= preAdd19_final_reg;
      END IF;
    END IF;
  END PROCESS preAdd19_balance_process;


  multInDelay19_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay19_reg <= (OTHERS => to_signed(16#000#, 10));
      ELSIF enb = '1' THEN
        multInDelay19_reg(0) <= preAdd19_balance_reg;
        multInDelay19_reg(1) <= multInDelay19_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay19_process;

  multInReg19 <= multInDelay19_reg(1);

  multOut19 <= to_signed(16#00001C#, 24) * multInReg19;

  multOutDelay19_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay19_reg <= (OTHERS => to_signed(0, 34));
      ELSIF enb = '1' THEN
        multOutDelay19_reg(0) <= multOut19;
        multOutDelay19_reg(1) <= multOutDelay19_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay19_process;

  multOutReg19 <= multOutDelay19_reg(1);

  add_stage1_19_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_19 <= to_signed(0, 34);
      ELSIF enb = '1' THEN
        add_stage1_19 <= multOutReg19;
      END IF;
    END IF;
  END PROCESS add_stage1_19_reg_process;


  tapOutData_6_6 <= tapOutData_6(6);

  preAdd20_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd20_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd20_stage1_1 <= tapOutData_6_6;
      END IF;
    END IF;
  END PROCESS preAdd20_stage1_1_reg_process;


  tapOutData_6_1 <= tapOutData_6(1);

  preAdd20_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd20_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd20_stage1_2 <= tapOutData_6_1;
      END IF;
    END IF;
  END PROCESS preAdd20_stage1_2_reg_process;


  subtractor_sub_temp_50 <= resize(preAdd20_stage1_1, 9) - resize(preAdd20_stage1_2, 9);
  preAdd20_stage1_add_1 <= signed(subtractor_sub_temp_50);

  preAdd20_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd20_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd20_stage2_1 <= preAdd20_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd20_stage2_1_reg_process;


  tapOutData_11_6 <= tapOutData_11(6);

  preAdd20_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd20_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd20_stage1_3 <= tapOutData_11_6;
      END IF;
    END IF;
  END PROCESS preAdd20_stage1_3_reg_process;


  tapOutData_11_1 <= tapOutData_11(1);

  preAdd20_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd20_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd20_stage1_4 <= tapOutData_11_1;
      END IF;
    END IF;
  END PROCESS preAdd20_stage1_4_reg_process;


  subtractor_sub_temp_51 <= resize(preAdd20_stage1_3, 9) - resize(preAdd20_stage1_4, 9);
  preAdd20_stage1_add_2 <= signed(subtractor_sub_temp_51);

  preAdd20_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd20_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd20_stage2_2 <= preAdd20_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd20_stage2_2_reg_process;


  preAdd20_stage2_add_1 <= resize(preAdd20_stage2_1, 10) + resize(preAdd20_stage2_2, 10);

  preAdd20_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd20_final_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd20_final_reg <= preAdd20_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd20_final_process;


  preAdd20_balance_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd20_balance_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd20_balance_reg <= preAdd20_final_reg;
      END IF;
    END IF;
  END PROCESS preAdd20_balance_process;


  multInDelay20_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay20_reg <= (OTHERS => to_signed(16#000#, 10));
      ELSIF enb = '1' THEN
        multInDelay20_reg(0) <= preAdd20_balance_reg;
        multInDelay20_reg(1) <= multInDelay20_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay20_process;

  multInReg20 <= multInDelay20_reg(1);

  multOut20 <= to_signed(16#00001F#, 24) * multInReg20;

  multOutDelay20_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay20_reg <= (OTHERS => to_signed(0, 34));
      ELSIF enb = '1' THEN
        multOutDelay20_reg(0) <= multOut20;
        multOutDelay20_reg(1) <= multOutDelay20_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay20_process;

  multOutReg20 <= multOutDelay20_reg(1);

  add_stage1_20_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_20 <= to_signed(0, 34);
      ELSIF enb = '1' THEN
        add_stage1_20 <= multOutReg20;
      END IF;
    END IF;
  END PROCESS add_stage1_20_reg_process;


  adder_add_cast_32 <= resize(add_stage1_19, 35);
  adder_add_cast_33 <= resize(add_stage1_20, 35);
  add_stage1_add_10 <= adder_add_cast_32 + adder_add_cast_33;

  add_stage2_10_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage2_10 <= to_signed(0, 35);
      ELSIF enb = '1' THEN
        add_stage2_10 <= add_stage1_add_10;
      END IF;
    END IF;
  END PROCESS add_stage2_10_reg_process;


  adder_add_cast_34 <= resize(add_stage2_9, 37);
  adder_add_cast_35 <= resize(add_stage2_10, 37);
  add_stage2_add_5 <= adder_add_cast_34 + adder_add_cast_35;

  add_stage3_5_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage3_5 <= to_signed(0, 37);
      ELSIF enb = '1' THEN
        add_stage3_5 <= add_stage2_add_5;
      END IF;
    END IF;
  END PROCESS add_stage3_5_reg_process;


  tapOutData_5_7 <= tapOutData_5(7);

  preAdd21_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd21_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd21_stage1_1 <= tapOutData_5_7;
      END IF;
    END IF;
  END PROCESS preAdd21_stage1_1_reg_process;


  tapOutData_5_0 <= tapOutData_5(0);

  preAdd21_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd21_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd21_stage1_2 <= tapOutData_5_0;
      END IF;
    END IF;
  END PROCESS preAdd21_stage1_2_reg_process;


  subtractor_sub_temp_52 <= resize(preAdd21_stage1_1, 9) - resize(preAdd21_stage1_2, 9);
  preAdd21_stage1_add_1 <= signed(subtractor_sub_temp_52);

  preAdd21_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd21_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd21_stage2_1 <= preAdd21_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd21_stage2_1_reg_process;


  tapOutData_12_7 <= tapOutData_12(7);

  preAdd21_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd21_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd21_stage1_3 <= tapOutData_12_7;
      END IF;
    END IF;
  END PROCESS preAdd21_stage1_3_reg_process;


  tapOutData_12_0 <= tapOutData_12(0);

  preAdd21_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd21_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd21_stage1_4 <= tapOutData_12_0;
      END IF;
    END IF;
  END PROCESS preAdd21_stage1_4_reg_process;


  subtractor_sub_temp_53 <= resize(preAdd21_stage1_3, 9) - resize(preAdd21_stage1_4, 9);
  preAdd21_stage1_add_2 <= signed(subtractor_sub_temp_53);

  preAdd21_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd21_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd21_stage2_2 <= preAdd21_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd21_stage2_2_reg_process;


  preAdd21_stage2_add_1 <= resize(preAdd21_stage2_1, 10) + resize(preAdd21_stage2_2, 10);

  preAdd21_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd21_final_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd21_final_reg <= preAdd21_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd21_final_process;


  preAdd21_balance_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd21_balance_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd21_balance_reg <= preAdd21_final_reg;
      END IF;
    END IF;
  END PROCESS preAdd21_balance_process;


  multInDelay21_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay21_reg <= (OTHERS => to_signed(16#000#, 10));
      ELSIF enb = '1' THEN
        multInDelay21_reg(0) <= preAdd21_balance_reg;
        multInDelay21_reg(1) <= multInDelay21_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay21_process;

  multInReg21 <= multInDelay21_reg(1);

  multOut21 <= resize(multInReg21 & '0' & '0' & '0' & '0' & '0', 34);

  multOutDelay21_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay21_reg <= (OTHERS => to_signed(0, 34));
      ELSIF enb = '1' THEN
        multOutDelay21_reg(0) <= multOut21;
        multOutDelay21_reg(1) <= multOutDelay21_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay21_process;

  multOutReg21 <= multOutDelay21_reg(1);

  add_stage1_21_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_21 <= to_signed(0, 34);
      ELSIF enb = '1' THEN
        add_stage1_21 <= multOutReg21;
      END IF;
    END IF;
  END PROCESS add_stage1_21_reg_process;


  tapOutData_7_6 <= tapOutData_7(6);

  preAdd22_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd22_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd22_stage1_1 <= tapOutData_7_6;
      END IF;
    END IF;
  END PROCESS preAdd22_stage1_1_reg_process;


  tapOutData_7_1 <= tapOutData_7(1);

  preAdd22_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd22_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd22_stage1_2 <= tapOutData_7_1;
      END IF;
    END IF;
  END PROCESS preAdd22_stage1_2_reg_process;


  subtractor_sub_temp_54 <= resize(preAdd22_stage1_1, 9) - resize(preAdd22_stage1_2, 9);
  preAdd22_stage1_add_1 <= signed(subtractor_sub_temp_54);

  preAdd22_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd22_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd22_stage2_1 <= preAdd22_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd22_stage2_1_reg_process;


  tapOutData_10_6 <= tapOutData_10(6);

  preAdd22_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd22_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd22_stage1_3 <= tapOutData_10_6;
      END IF;
    END IF;
  END PROCESS preAdd22_stage1_3_reg_process;


  tapOutData_10_1 <= tapOutData_10(1);

  preAdd22_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd22_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd22_stage1_4 <= tapOutData_10_1;
      END IF;
    END IF;
  END PROCESS preAdd22_stage1_4_reg_process;


  subtractor_sub_temp_55 <= resize(preAdd22_stage1_3, 9) - resize(preAdd22_stage1_4, 9);
  preAdd22_stage1_add_2 <= signed(subtractor_sub_temp_55);

  preAdd22_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd22_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd22_stage2_2 <= preAdd22_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd22_stage2_2_reg_process;


  preAdd22_stage2_add_1 <= resize(preAdd22_stage2_1, 10) + resize(preAdd22_stage2_2, 10);

  preAdd22_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd22_final_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd22_final_reg <= preAdd22_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd22_final_process;


  preAdd22_balance_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd22_balance_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd22_balance_reg <= preAdd22_final_reg;
      END IF;
    END IF;
  END PROCESS preAdd22_balance_process;


  multInDelay22_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay22_reg <= (OTHERS => to_signed(16#000#, 10));
      ELSIF enb = '1' THEN
        multInDelay22_reg(0) <= preAdd22_balance_reg;
        multInDelay22_reg(1) <= multInDelay22_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay22_process;

  multInReg22 <= multInDelay22_reg(1);

  multOut22 <= to_signed(16#000022#, 24) * multInReg22;

  multOutDelay22_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay22_reg <= (OTHERS => to_signed(0, 34));
      ELSIF enb = '1' THEN
        multOutDelay22_reg(0) <= multOut22;
        multOutDelay22_reg(1) <= multOutDelay22_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay22_process;

  multOutReg22 <= multOutDelay22_reg(1);

  add_stage1_22_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_22 <= to_signed(0, 34);
      ELSIF enb = '1' THEN
        add_stage1_22 <= multOutReg22;
      END IF;
    END IF;
  END PROCESS add_stage1_22_reg_process;


  adder_add_cast_36 <= resize(add_stage1_21, 35);
  adder_add_cast_37 <= resize(add_stage1_22, 35);
  add_stage1_add_11 <= adder_add_cast_36 + adder_add_cast_37;

  add_stage2_11_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage2_11 <= to_signed(0, 35);
      ELSIF enb = '1' THEN
        add_stage2_11 <= add_stage1_add_11;
      END IF;
    END IF;
  END PROCESS add_stage2_11_reg_process;


  tapOutData_8_6 <= tapOutData_8(6);

  preAdd23_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd23_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd23_stage1_1 <= tapOutData_8_6;
      END IF;
    END IF;
  END PROCESS preAdd23_stage1_1_reg_process;


  tapOutData_8_1 <= tapOutData_8(1);

  preAdd23_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd23_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd23_stage1_2 <= tapOutData_8_1;
      END IF;
    END IF;
  END PROCESS preAdd23_stage1_2_reg_process;


  subtractor_sub_temp_56 <= resize(preAdd23_stage1_1, 9) - resize(preAdd23_stage1_2, 9);
  preAdd23_stage1_add_1 <= signed(subtractor_sub_temp_56);

  preAdd23_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd23_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd23_stage2_1 <= preAdd23_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd23_stage2_1_reg_process;


  tapOutData_9_6 <= tapOutData_9(6);

  preAdd23_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd23_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd23_stage1_3 <= tapOutData_9_6;
      END IF;
    END IF;
  END PROCESS preAdd23_stage1_3_reg_process;


  tapOutData_9_1 <= tapOutData_9(1);

  preAdd23_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd23_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd23_stage1_4 <= tapOutData_9_1;
      END IF;
    END IF;
  END PROCESS preAdd23_stage1_4_reg_process;


  subtractor_sub_temp_57 <= resize(preAdd23_stage1_3, 9) - resize(preAdd23_stage1_4, 9);
  preAdd23_stage1_add_2 <= signed(subtractor_sub_temp_57);

  preAdd23_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd23_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd23_stage2_2 <= preAdd23_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd23_stage2_2_reg_process;


  preAdd23_stage2_add_1 <= resize(preAdd23_stage2_1, 10) + resize(preAdd23_stage2_2, 10);

  preAdd23_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd23_final_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd23_final_reg <= preAdd23_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd23_final_process;


  preAdd23_balance_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd23_balance_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd23_balance_reg <= preAdd23_final_reg;
      END IF;
    END IF;
  END PROCESS preAdd23_balance_process;


  multInDelay23_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay23_reg <= (OTHERS => to_signed(16#000#, 10));
      ELSIF enb = '1' THEN
        multInDelay23_reg(0) <= preAdd23_balance_reg;
        multInDelay23_reg(1) <= multInDelay23_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay23_process;

  multInReg23 <= multInDelay23_reg(1);

  multOut23 <= to_signed(16#000023#, 24) * multInReg23;

  multOutDelay23_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay23_reg <= (OTHERS => to_signed(0, 34));
      ELSIF enb = '1' THEN
        multOutDelay23_reg(0) <= multOut23;
        multOutDelay23_reg(1) <= multOutDelay23_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay23_process;

  multOutReg23 <= multOutDelay23_reg(1);

  add_stage1_23_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_23 <= to_signed(0, 34);
      ELSIF enb = '1' THEN
        add_stage1_23 <= multOutReg23;
      END IF;
    END IF;
  END PROCESS add_stage1_23_reg_process;


  tapOutData_6_7 <= tapOutData_6(7);

  preAdd24_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd24_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd24_stage1_1 <= tapOutData_6_7;
      END IF;
    END IF;
  END PROCESS preAdd24_stage1_1_reg_process;


  tapOutData_6_0 <= tapOutData_6(0);

  preAdd24_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd24_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd24_stage1_2 <= tapOutData_6_0;
      END IF;
    END IF;
  END PROCESS preAdd24_stage1_2_reg_process;


  subtractor_sub_temp_58 <= resize(preAdd24_stage1_1, 9) - resize(preAdd24_stage1_2, 9);
  preAdd24_stage1_add_1 <= signed(subtractor_sub_temp_58);

  preAdd24_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd24_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd24_stage2_1 <= preAdd24_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd24_stage2_1_reg_process;


  tapOutData_11_7 <= tapOutData_11(7);

  preAdd24_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd24_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd24_stage1_3 <= tapOutData_11_7;
      END IF;
    END IF;
  END PROCESS preAdd24_stage1_3_reg_process;


  tapOutData_11_0 <= tapOutData_11(0);

  preAdd24_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd24_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd24_stage1_4 <= tapOutData_11_0;
      END IF;
    END IF;
  END PROCESS preAdd24_stage1_4_reg_process;


  subtractor_sub_temp_59 <= resize(preAdd24_stage1_3, 9) - resize(preAdd24_stage1_4, 9);
  preAdd24_stage1_add_2 <= signed(subtractor_sub_temp_59);

  preAdd24_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd24_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd24_stage2_2 <= preAdd24_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd24_stage2_2_reg_process;


  preAdd24_stage2_add_1 <= resize(preAdd24_stage2_1, 10) + resize(preAdd24_stage2_2, 10);

  preAdd24_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd24_final_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd24_final_reg <= preAdd24_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd24_final_process;


  preAdd24_balance_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd24_balance_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd24_balance_reg <= preAdd24_final_reg;
      END IF;
    END IF;
  END PROCESS preAdd24_balance_process;


  multInDelay24_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay24_reg <= (OTHERS => to_signed(16#000#, 10));
      ELSIF enb = '1' THEN
        multInDelay24_reg(0) <= preAdd24_balance_reg;
        multInDelay24_reg(1) <= multInDelay24_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay24_process;

  multInReg24 <= multInDelay24_reg(1);

  multOut24 <= to_signed(16#000024#, 24) * multInReg24;

  multOutDelay24_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay24_reg <= (OTHERS => to_signed(0, 34));
      ELSIF enb = '1' THEN
        multOutDelay24_reg(0) <= multOut24;
        multOutDelay24_reg(1) <= multOutDelay24_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay24_process;

  multOutReg24 <= multOutDelay24_reg(1);

  add_stage1_24_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_24 <= to_signed(0, 34);
      ELSIF enb = '1' THEN
        add_stage1_24 <= multOutReg24;
      END IF;
    END IF;
  END PROCESS add_stage1_24_reg_process;


  adder_add_cast_38 <= resize(add_stage1_23, 35);
  adder_add_cast_39 <= resize(add_stage1_24, 35);
  add_stage1_add_12 <= adder_add_cast_38 + adder_add_cast_39;

  add_stage2_12_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage2_12 <= to_signed(0, 35);
      ELSIF enb = '1' THEN
        add_stage2_12 <= add_stage1_add_12;
      END IF;
    END IF;
  END PROCESS add_stage2_12_reg_process;


  adder_add_cast_40 <= resize(add_stage2_11, 36);
  adder_add_cast_41 <= resize(add_stage2_12, 36);
  add_stage2_add_6 <= adder_add_cast_40 + adder_add_cast_41;

  add_stage3_6_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage3_6 <= to_signed(0, 36);
      ELSIF enb = '1' THEN
        add_stage3_6 <= add_stage2_add_6;
      END IF;
    END IF;
  END PROCESS add_stage3_6_reg_process;


  adder_add_cast_42 <= resize(add_stage3_5, 38);
  adder_add_cast_43 <= resize(add_stage3_6, 38);
  add_stage3_add_3 <= adder_add_cast_42 + adder_add_cast_43;

  add_stage4_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage4_3 <= to_signed(0, 38);
      ELSIF enb = '1' THEN
        add_stage4_3 <= add_stage3_add_3;
      END IF;
    END IF;
  END PROCESS add_stage4_3_reg_process;


  tapOutData_7_7 <= tapOutData_7(7);

  preAdd25_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd25_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd25_stage1_1 <= tapOutData_7_7;
      END IF;
    END IF;
  END PROCESS preAdd25_stage1_1_reg_process;


  tapOutData_7_0 <= tapOutData_7(0);

  preAdd25_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd25_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd25_stage1_2 <= tapOutData_7_0;
      END IF;
    END IF;
  END PROCESS preAdd25_stage1_2_reg_process;


  subtractor_sub_temp_60 <= resize(preAdd25_stage1_1, 9) - resize(preAdd25_stage1_2, 9);
  preAdd25_stage1_add_1 <= signed(subtractor_sub_temp_60);

  preAdd25_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd25_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd25_stage2_1 <= preAdd25_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd25_stage2_1_reg_process;


  tapOutData_10_7 <= tapOutData_10(7);

  preAdd25_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd25_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd25_stage1_3 <= tapOutData_10_7;
      END IF;
    END IF;
  END PROCESS preAdd25_stage1_3_reg_process;


  tapOutData_10_0 <= tapOutData_10(0);

  preAdd25_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd25_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd25_stage1_4 <= tapOutData_10_0;
      END IF;
    END IF;
  END PROCESS preAdd25_stage1_4_reg_process;


  subtractor_sub_temp_61 <= resize(preAdd25_stage1_3, 9) - resize(preAdd25_stage1_4, 9);
  preAdd25_stage1_add_2 <= signed(subtractor_sub_temp_61);

  preAdd25_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd25_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd25_stage2_2 <= preAdd25_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd25_stage2_2_reg_process;


  preAdd25_stage2_add_1 <= resize(preAdd25_stage2_1, 10) + resize(preAdd25_stage2_2, 10);

  preAdd25_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd25_final_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd25_final_reg <= preAdd25_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd25_final_process;


  preAdd25_balance_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd25_balance_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd25_balance_reg <= preAdd25_final_reg;
      END IF;
    END IF;
  END PROCESS preAdd25_balance_process;


  multInDelay25_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay25_reg <= (OTHERS => to_signed(16#000#, 10));
      ELSIF enb = '1' THEN
        multInDelay25_reg(0) <= preAdd25_balance_reg;
        multInDelay25_reg(1) <= multInDelay25_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay25_process;

  multInReg25 <= multInDelay25_reg(1);

  multOut25 <= to_signed(16#000027#, 24) * multInReg25;

  multOutDelay25_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay25_reg <= (OTHERS => to_signed(0, 34));
      ELSIF enb = '1' THEN
        multOutDelay25_reg(0) <= multOut25;
        multOutDelay25_reg(1) <= multOutDelay25_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay25_process;

  multOutReg25 <= multOutDelay25_reg(1);

  add_stage1_25_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_25 <= to_signed(0, 34);
      ELSIF enb = '1' THEN
        add_stage1_25 <= multOutReg25;
      END IF;
    END IF;
  END PROCESS add_stage1_25_reg_process;


  tapOutData_8_7 <= tapOutData_8(7);

  preAdd26_stage1_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd26_stage1_1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd26_stage1_1 <= tapOutData_8_7;
      END IF;
    END IF;
  END PROCESS preAdd26_stage1_1_reg_process;


  tapOutData_8_0 <= tapOutData_8(0);

  preAdd26_stage1_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd26_stage1_2 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd26_stage1_2 <= tapOutData_8_0;
      END IF;
    END IF;
  END PROCESS preAdd26_stage1_2_reg_process;


  subtractor_sub_temp_62 <= resize(preAdd26_stage1_1, 9) - resize(preAdd26_stage1_2, 9);
  preAdd26_stage1_add_1 <= signed(subtractor_sub_temp_62);

  preAdd26_stage2_1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd26_stage2_1 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd26_stage2_1 <= preAdd26_stage1_add_1;
      END IF;
    END IF;
  END PROCESS preAdd26_stage2_1_reg_process;


  tapOutData_9_7 <= tapOutData_9(7);

  preAdd26_stage1_3_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd26_stage1_3 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd26_stage1_3 <= tapOutData_9_7;
      END IF;
    END IF;
  END PROCESS preAdd26_stage1_3_reg_process;


  tapOutData_9_0 <= tapOutData_9(0);

  preAdd26_stage1_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd26_stage1_4 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        preAdd26_stage1_4 <= tapOutData_9_0;
      END IF;
    END IF;
  END PROCESS preAdd26_stage1_4_reg_process;


  subtractor_sub_temp_63 <= resize(preAdd26_stage1_3, 9) - resize(preAdd26_stage1_4, 9);
  preAdd26_stage1_add_2 <= signed(subtractor_sub_temp_63);

  preAdd26_stage2_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd26_stage2_2 <= to_signed(16#000#, 9);
      ELSIF enb = '1' THEN
        preAdd26_stage2_2 <= preAdd26_stage1_add_2;
      END IF;
    END IF;
  END PROCESS preAdd26_stage2_2_reg_process;


  preAdd26_stage2_add_1 <= resize(preAdd26_stage2_1, 10) + resize(preAdd26_stage2_2, 10);

  preAdd26_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd26_final_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd26_final_reg <= preAdd26_stage2_add_1;
      END IF;
    END IF;
  END PROCESS preAdd26_final_process;


  preAdd26_balance_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        preAdd26_balance_reg <= to_signed(16#000#, 10);
      ELSIF enb = '1' THEN
        preAdd26_balance_reg <= preAdd26_final_reg;
      END IF;
    END IF;
  END PROCESS preAdd26_balance_process;


  multInDelay26_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multInDelay26_reg <= (OTHERS => to_signed(16#000#, 10));
      ELSIF enb = '1' THEN
        multInDelay26_reg(0) <= preAdd26_balance_reg;
        multInDelay26_reg(1) <= multInDelay26_reg(0);
      END IF;
    END IF;
  END PROCESS multInDelay26_process;

  multInReg26 <= multInDelay26_reg(1);

  multOut26 <= to_signed(16#000028#, 24) * multInReg26;

  multOutDelay26_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        multOutDelay26_reg <= (OTHERS => to_signed(0, 34));
      ELSIF enb = '1' THEN
        multOutDelay26_reg(0) <= multOut26;
        multOutDelay26_reg(1) <= multOutDelay26_reg(0);
      END IF;
    END IF;
  END PROCESS multOutDelay26_process;

  multOutReg26 <= multOutDelay26_reg(1);

  add_stage1_26_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage1_26 <= to_signed(0, 34);
      ELSIF enb = '1' THEN
        add_stage1_26 <= multOutReg26;
      END IF;
    END IF;
  END PROCESS add_stage1_26_reg_process;


  adder_add_cast_44 <= resize(add_stage1_25, 35);
  adder_add_cast_45 <= resize(add_stage1_26, 35);
  add_stage1_add_13 <= adder_add_cast_44 + adder_add_cast_45;

  add_stage4_4_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage4_4_reg_reg <= (OTHERS => to_signed(0, 35));
      ELSIF enb = '1' THEN
        add_stage4_4_reg_reg(0) <= add_stage1_add_13;
        add_stage4_4_reg_reg(1 TO 2) <= add_stage4_4_reg_reg(0 TO 1);
      END IF;
    END IF;
  END PROCESS add_stage4_4_reg_process;

  add_stage4_4 <= add_stage4_4_reg_reg(2);

  adder_add_cast_46 <= resize(add_stage4_3, 39);
  adder_add_cast_47 <= resize(add_stage4_4, 39);
  add_stage4_add_2 <= adder_add_cast_46 + adder_add_cast_47;

  add_stage5_2_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_stage5_2 <= to_signed(0, 39);
      ELSIF enb = '1' THEN
        add_stage5_2 <= add_stage4_add_2;
      END IF;
    END IF;
  END PROCESS add_stage5_2_reg_process;


  adder_add_cast_48 <= resize(add_stage5_1, 40);
  adder_add_cast_49 <= resize(add_stage5_2, 40);
  add_stage5_add_1 <= adder_add_cast_48 + adder_add_cast_49;

  add_final_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        add_final_reg <= to_signed(0, 40);
      ELSIF enb = '1' THEN
        add_final_reg <= add_stage5_add_1;
      END IF;
    END IF;
  END PROCESS add_final_process;


  
  add_final_reg_conv <= X"7FFFFF" WHEN (add_final_reg(39) = '0') AND (add_final_reg(38 DOWNTO 23) /= X"0000") ELSE
      X"800000" WHEN (add_final_reg(39) = '1') AND (add_final_reg(38 DOWNTO 23) /= X"FFFF") ELSE
      add_final_reg(23 DOWNTO 0);

  dataOut_1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        dataOut_tmp <= to_signed(16#000000#, 24);
      ELSIF enb = '1' THEN
        dataOut_tmp <= add_final_reg_conv;
      END IF;
    END IF;
  END PROCESS dataOut_1_process;


  dataOut <= std_logic_vector(dataOut_tmp);

  -- Delay Pixel
  vStartOut_tap_latency_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        vStartOut_tap_latency_reg <= (OTHERS => '0');
      ELSIF enb = '1' AND processData = '1' THEN
        vStartOut_tap_latency_reg(0) <= vStartIn;
        vStartOut_tap_latency_reg(1 TO 3) <= vStartOut_tap_latency_reg(0 TO 2);
      END IF;
    END IF;
  END PROCESS vStartOut_tap_latency_process;

  vStartIn_reg <= vStartOut_tap_latency_reg(3);

  vStartIn_reg_vldSig <= vStartIn_reg AND processData;

  -- Delay Pixel
  vStartOut_fir_latency_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        vStartOut_fir_latency_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        vStartOut_fir_latency_reg(0) <= vStartIn_reg_vldSig;
        vStartOut_fir_latency_reg(1 TO 14) <= vStartOut_fir_latency_reg(0 TO 13);
      END IF;
    END IF;
  END PROCESS vStartOut_fir_latency_process;

  vStartOut <= vStartOut_fir_latency_reg(14);

  -- Delay Horizontal Start
  vEndOut_tap_latency_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        vEndOut_tap_latency_reg <= (OTHERS => '0');
      ELSIF enb = '1' AND processData = '1' THEN
        vEndOut_tap_latency_reg(0) <= vEndIn;
        vEndOut_tap_latency_reg(1 TO 3) <= vEndOut_tap_latency_reg(0 TO 2);
      END IF;
    END IF;
  END PROCESS vEndOut_tap_latency_process;

  vEndIn_reg <= vEndOut_tap_latency_reg(3);

  vEndIn_reg_vldSig <= vEndIn_reg AND processData;

  -- Delay Horizontal Start
  vEndOut_fir_latency_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        vEndOut_fir_latency_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        vEndOut_fir_latency_reg(0) <= vEndIn_reg_vldSig;
        vEndOut_fir_latency_reg(1 TO 14) <= vEndOut_fir_latency_reg(0 TO 13);
      END IF;
    END IF;
  END PROCESS vEndOut_fir_latency_process;

  vEndOut <= vEndOut_fir_latency_reg(14);

  -- Delay Horizontal End
  hStartOut_tap_latency_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        hStartOut_tap_latency_reg <= (OTHERS => '0');
      ELSIF enb = '1' AND processData = '1' THEN
        hStartOut_tap_latency_reg(0) <= hStartIn;
        hStartOut_tap_latency_reg(1 TO 3) <= hStartOut_tap_latency_reg(0 TO 2);
      END IF;
    END IF;
  END PROCESS hStartOut_tap_latency_process;

  hStartIn_reg <= hStartOut_tap_latency_reg(3);

  hStartIn_reg_vldSig <= hStartIn_reg AND processData;

  -- Delay Horizontal End
  hStartOut_fir_latency_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        hStartOut_fir_latency_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        hStartOut_fir_latency_reg(0) <= hStartIn_reg_vldSig;
        hStartOut_fir_latency_reg(1 TO 14) <= hStartOut_fir_latency_reg(0 TO 13);
      END IF;
    END IF;
  END PROCESS hStartOut_fir_latency_process;

  hStartOut <= hStartOut_fir_latency_reg(14);

  -- Delay Vertical Start
  hEndOut_tap_latency_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        hEndOut_tap_latency_reg <= (OTHERS => '0');
      ELSIF enb = '1' AND processData = '1' THEN
        hEndOut_tap_latency_reg(0) <= hEndIn;
        hEndOut_tap_latency_reg(1 TO 3) <= hEndOut_tap_latency_reg(0 TO 2);
      END IF;
    END IF;
  END PROCESS hEndOut_tap_latency_process;

  hEndIn_reg <= hEndOut_tap_latency_reg(3);

  hEndIn_reg_vldSig <= hEndIn_reg AND processData;

  -- Delay Vertical Start
  hEndOut_fir_latency_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        hEndOut_fir_latency_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        hEndOut_fir_latency_reg(0) <= hEndIn_reg_vldSig;
        hEndOut_fir_latency_reg(1 TO 14) <= hEndOut_fir_latency_reg(0 TO 13);
      END IF;
    END IF;
  END PROCESS hEndOut_fir_latency_process;

  hEndOut <= hEndOut_fir_latency_reg(14);

  -- Delay Vertical End
  validOut_tap_latency_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        validOut_tap_latency_reg <= (OTHERS => '0');
      ELSIF enb = '1' AND processData = '1' THEN
        validOut_tap_latency_reg(0) <= validIn;
        validOut_tap_latency_reg(1 TO 3) <= validOut_tap_latency_reg(0 TO 2);
      END IF;
    END IF;
  END PROCESS validOut_tap_latency_process;

  validIn_reg <= validOut_tap_latency_reg(3);

  validIn_reg_vldSig <= validIn_reg AND processData;

  -- Delay Vertical End
  validOut_fir_latency_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        validOut_fir_latency_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        validOut_fir_latency_reg(0) <= validIn_reg_vldSig;
        validOut_fir_latency_reg(1 TO 14) <= validOut_fir_latency_reg(0 TO 13);
      END IF;
    END IF;
  END PROCESS validOut_fir_latency_process;

  validOut <= validOut_fir_latency_reg(14);

END rtl;

