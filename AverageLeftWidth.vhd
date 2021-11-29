LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY AverageLeftWidth IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        data                              :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12
        Enable                            :   IN    std_logic;
        average                           :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En18
        );
END AverageLeftWidth;


ARCHITECTURE rtl OF AverageLeftWidth IS

  -- Signals
  SIGNAL data_signed                      : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay11_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL reduced_reg                      : std_logic_vector(0 TO 6);  -- ufix1 [7]
  SIGNAL Enable_1                         : std_logic;
  SIGNAL Delay_out1                       : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay16_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Add_out1                         : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay31_out1                     : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay1_out1                      : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay17_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay2_out1                      : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay18_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Add1_out1                        : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay32_out1                     : signed(15 DOWNTO 0);  -- int16
  SIGNAL Add8_out1                        : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay39_out1                     : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay3_out1                      : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay19_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay4_out1                      : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay20_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Add2_out1                        : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay33_out1                     : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay5_out1                      : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay21_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay6_out1                      : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay22_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Add3_out1                        : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay34_out1                     : signed(15 DOWNTO 0);  -- int16
  SIGNAL Add9_out1                        : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay40_out1                     : signed(15 DOWNTO 0);  -- int16
  SIGNAL Add12_out1                       : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay43_out1                     : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay7_out1                      : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay23_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay8_out1                      : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay24_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Add4_out1                        : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay35_out1                     : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay15_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay25_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay9_out1                      : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay26_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Add5_out1                        : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay36_out1                     : signed(15 DOWNTO 0);  -- int16
  SIGNAL Add10_out1                       : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay41_out1                     : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay10_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay27_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay14_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay28_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Add6_out1                        : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay37_out1                     : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay13_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay29_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay12_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Delay30_out1                     : signed(11 DOWNTO 0);  -- sfix12
  SIGNAL Add7_out1                        : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay38_out1                     : signed(15 DOWNTO 0);  -- int16
  SIGNAL Add11_out1                       : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay42_out1                     : signed(15 DOWNTO 0);  -- int16
  SIGNAL Add13_out1                       : signed(15 DOWNTO 0);  -- int16
  SIGNAL Delay44_out1                     : signed(15 DOWNTO 0);  -- int16
  SIGNAL Add14_out1                       : signed(15 DOWNTO 0);  -- int16
  SIGNAL Gain_out1                        : signed(31 DOWNTO 0);  -- sfix32_En18

BEGIN
  data_signed <= signed(data);

  Delay11_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay11_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay11_out1 <= data_signed;
      END IF;
    END IF;
  END PROCESS Delay11_process;


  reduced_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        reduced_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        reduced_reg(0) <= Enable;
        reduced_reg(1 TO 6) <= reduced_reg(0 TO 5);
      END IF;
    END IF;
  END PROCESS reduced_process;

  Enable_1 <= reduced_reg(6);

  Delay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' AND Enable_1 = '1' THEN
        Delay_out1 <= data_signed;
      END IF;
    END IF;
  END PROCESS Delay_process;


  Delay16_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay16_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay16_out1 <= Delay_out1;
      END IF;
    END IF;
  END PROCESS Delay16_process;


  Add_out1 <= resize(resize(Delay11_out1, 13) + resize(Delay16_out1, 13), 16);

  Delay31_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay31_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay31_out1 <= Add_out1;
      END IF;
    END IF;
  END PROCESS Delay31_process;


  Delay1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay1_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' AND Enable_1 = '1' THEN
        Delay1_out1 <= Delay_out1;
      END IF;
    END IF;
  END PROCESS Delay1_process;


  Delay17_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay17_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay17_out1 <= Delay1_out1;
      END IF;
    END IF;
  END PROCESS Delay17_process;


  Delay2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay2_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' AND Enable_1 = '1' THEN
        Delay2_out1 <= Delay1_out1;
      END IF;
    END IF;
  END PROCESS Delay2_process;


  Delay18_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay18_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay18_out1 <= Delay2_out1;
      END IF;
    END IF;
  END PROCESS Delay18_process;


  Add1_out1 <= resize(resize(Delay17_out1, 13) + resize(Delay18_out1, 13), 16);

  Delay32_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay32_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay32_out1 <= Add1_out1;
      END IF;
    END IF;
  END PROCESS Delay32_process;


  Add8_out1 <= Delay31_out1 + Delay32_out1;

  Delay39_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay39_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay39_out1 <= Add8_out1;
      END IF;
    END IF;
  END PROCESS Delay39_process;


  Delay3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay3_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' AND Enable_1 = '1' THEN
        Delay3_out1 <= Delay2_out1;
      END IF;
    END IF;
  END PROCESS Delay3_process;


  Delay19_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay19_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay19_out1 <= Delay3_out1;
      END IF;
    END IF;
  END PROCESS Delay19_process;


  Delay4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay4_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' AND Enable_1 = '1' THEN
        Delay4_out1 <= Delay3_out1;
      END IF;
    END IF;
  END PROCESS Delay4_process;


  Delay20_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay20_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay20_out1 <= Delay4_out1;
      END IF;
    END IF;
  END PROCESS Delay20_process;


  Add2_out1 <= resize(resize(Delay19_out1, 13) + resize(Delay20_out1, 13), 16);

  Delay33_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay33_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay33_out1 <= Add2_out1;
      END IF;
    END IF;
  END PROCESS Delay33_process;


  Delay5_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay5_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' AND Enable_1 = '1' THEN
        Delay5_out1 <= Delay4_out1;
      END IF;
    END IF;
  END PROCESS Delay5_process;


  Delay21_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay21_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay21_out1 <= Delay5_out1;
      END IF;
    END IF;
  END PROCESS Delay21_process;


  Delay6_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay6_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' AND Enable_1 = '1' THEN
        Delay6_out1 <= Delay5_out1;
      END IF;
    END IF;
  END PROCESS Delay6_process;


  Delay22_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay22_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay22_out1 <= Delay6_out1;
      END IF;
    END IF;
  END PROCESS Delay22_process;


  Add3_out1 <= resize(resize(Delay21_out1, 13) + resize(Delay22_out1, 13), 16);

  Delay34_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay34_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay34_out1 <= Add3_out1;
      END IF;
    END IF;
  END PROCESS Delay34_process;


  Add9_out1 <= Delay33_out1 + Delay34_out1;

  Delay40_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay40_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay40_out1 <= Add9_out1;
      END IF;
    END IF;
  END PROCESS Delay40_process;


  Add12_out1 <= Delay39_out1 + Delay40_out1;

  Delay43_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay43_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay43_out1 <= Add12_out1;
      END IF;
    END IF;
  END PROCESS Delay43_process;


  Delay7_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay7_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' AND Enable_1 = '1' THEN
        Delay7_out1 <= Delay6_out1;
      END IF;
    END IF;
  END PROCESS Delay7_process;


  Delay23_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay23_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay23_out1 <= Delay7_out1;
      END IF;
    END IF;
  END PROCESS Delay23_process;


  Delay8_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay8_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' AND Enable_1 = '1' THEN
        Delay8_out1 <= Delay7_out1;
      END IF;
    END IF;
  END PROCESS Delay8_process;


  Delay24_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay24_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay24_out1 <= Delay8_out1;
      END IF;
    END IF;
  END PROCESS Delay24_process;


  Add4_out1 <= resize(resize(Delay23_out1, 13) + resize(Delay24_out1, 13), 16);

  Delay35_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay35_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay35_out1 <= Add4_out1;
      END IF;
    END IF;
  END PROCESS Delay35_process;


  Delay15_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay15_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' AND Enable_1 = '1' THEN
        Delay15_out1 <= Delay8_out1;
      END IF;
    END IF;
  END PROCESS Delay15_process;


  Delay25_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay25_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay25_out1 <= Delay15_out1;
      END IF;
    END IF;
  END PROCESS Delay25_process;


  Delay9_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay9_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' AND Enable_1 = '1' THEN
        Delay9_out1 <= Delay15_out1;
      END IF;
    END IF;
  END PROCESS Delay9_process;


  Delay26_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay26_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay26_out1 <= Delay9_out1;
      END IF;
    END IF;
  END PROCESS Delay26_process;


  Add5_out1 <= resize(resize(Delay25_out1, 13) + resize(Delay26_out1, 13), 16);

  Delay36_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay36_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay36_out1 <= Add5_out1;
      END IF;
    END IF;
  END PROCESS Delay36_process;


  Add10_out1 <= Delay35_out1 + Delay36_out1;

  Delay41_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay41_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay41_out1 <= Add10_out1;
      END IF;
    END IF;
  END PROCESS Delay41_process;


  Delay10_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay10_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' AND Enable_1 = '1' THEN
        Delay10_out1 <= Delay9_out1;
      END IF;
    END IF;
  END PROCESS Delay10_process;


  Delay27_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay27_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay27_out1 <= Delay10_out1;
      END IF;
    END IF;
  END PROCESS Delay27_process;


  Delay14_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay14_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' AND Enable_1 = '1' THEN
        Delay14_out1 <= Delay10_out1;
      END IF;
    END IF;
  END PROCESS Delay14_process;


  Delay28_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay28_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay28_out1 <= Delay14_out1;
      END IF;
    END IF;
  END PROCESS Delay28_process;


  Add6_out1 <= resize(resize(Delay27_out1, 13) + resize(Delay28_out1, 13), 16);

  Delay37_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay37_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay37_out1 <= Add6_out1;
      END IF;
    END IF;
  END PROCESS Delay37_process;


  Delay13_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay13_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' AND Enable_1 = '1' THEN
        Delay13_out1 <= Delay14_out1;
      END IF;
    END IF;
  END PROCESS Delay13_process;


  Delay29_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay29_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay29_out1 <= Delay13_out1;
      END IF;
    END IF;
  END PROCESS Delay29_process;


  Delay12_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay12_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' AND Enable_1 = '1' THEN
        Delay12_out1 <= Delay13_out1;
      END IF;
    END IF;
  END PROCESS Delay12_process;


  Delay30_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay30_out1 <= to_signed(16#000#, 12);
      ELSIF enb = '1' THEN
        Delay30_out1 <= Delay12_out1;
      END IF;
    END IF;
  END PROCESS Delay30_process;


  Add7_out1 <= resize(resize(Delay29_out1, 13) + resize(Delay30_out1, 13), 16);

  Delay38_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay38_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay38_out1 <= Add7_out1;
      END IF;
    END IF;
  END PROCESS Delay38_process;


  Add11_out1 <= Delay37_out1 + Delay38_out1;

  Delay42_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay42_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay42_out1 <= Add11_out1;
      END IF;
    END IF;
  END PROCESS Delay42_process;


  Add13_out1 <= Delay41_out1 + Delay42_out1;

  Delay44_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay44_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay44_out1 <= Add13_out1;
      END IF;
    END IF;
  END PROCESS Delay44_process;


  Add14_out1 <= Delay43_out1 + Delay44_out1;

  Gain_out1 <= resize(Add14_out1 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 32);

  average <= std_logic_vector(Gain_out1);

END rtl;

