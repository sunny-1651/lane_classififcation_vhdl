LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY dataWriteFSM IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        vEndIn                            :   IN    std_logic;
        validIn                           :   IN    std_logic;
        RowCounterIn                      :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16
        vStartIn                          :   IN    std_logic;
        push                              :   OUT   std_logic;
        LockedInFrame                     :   OUT   std_logic;
        FSMState                          :   OUT   std_logic_vector(1 DOWNTO 0)  -- ufix2
        );
END dataWriteFSM;


ARCHITECTURE rtl OF dataWriteFSM IS

  -- Signals
  SIGNAL RowCounterIn_unsigned            : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL BirdsEyeViewFSM_BufferFSMState   : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL BirdsEyeViewFSM_LockedInFrame    : std_logic;
  SIGNAL BirdsEyeViewFSM_BufferFSMState_next : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL BirdsEyeViewFSM_LockedInFrame_next : std_logic;
  SIGNAL pop                              : std_logic;
  SIGNAL FSMState_tmp                     : unsigned(1 DOWNTO 0);  -- ufix2

BEGIN
  RowCounterIn_unsigned <= unsigned(RowCounterIn);

  -- Birds-Eye View FSM - Determine whether to idle, buffer or write data
  BirdsEyeViewFSM_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        BirdsEyeViewFSM_BufferFSMState <= to_unsigned(16#0#, 2);
        BirdsEyeViewFSM_LockedInFrame <= '0';
      ELSIF enb = '1' THEN
        BirdsEyeViewFSM_BufferFSMState <= BirdsEyeViewFSM_BufferFSMState_next;
        BirdsEyeViewFSM_LockedInFrame <= BirdsEyeViewFSM_LockedInFrame_next;
      END IF;
    END IF;
  END PROCESS BirdsEyeViewFSM_process;

  BirdsEyeViewFSM_output : PROCESS (BirdsEyeViewFSM_BufferFSMState, BirdsEyeViewFSM_LockedInFrame,
       RowCounterIn_unsigned, vEndIn, vStartIn, validIn)
    VARIABLE BufferFSMState_temp : unsigned(1 DOWNTO 0);
    VARIABLE LockedInFrame_temp : std_logic;
  BEGIN
    BufferFSMState_temp := BirdsEyeViewFSM_BufferFSMState;
    LockedInFrame_temp := BirdsEyeViewFSM_LockedInFrame;
    CASE BirdsEyeViewFSM_BufferFSMState IS
      WHEN "00" =>
        IF vStartIn /= '0' THEN 
          LockedInFrame_temp := '0';
        END IF;
        IF RowCounterIn_unsigned = to_unsigned(16#00C6#, 16) THEN 
          BufferFSMState_temp := to_unsigned(16#1#, 2);
          pop <= '0';
          push <=  NOT LockedInFrame_temp;
        ELSE 
          BufferFSMState_temp := to_unsigned(16#0#, 2);
          push <= '0';
          pop <= '0';
        END IF;
      WHEN "01" =>
        pop <= '0';
        push <= validIn AND ( NOT BirdsEyeViewFSM_LockedInFrame);
        IF RowCounterIn_unsigned = to_unsigned(16#0101#, 16) THEN 
          BufferFSMState_temp := to_unsigned(16#2#, 2);
          LockedInFrame_temp := '1';
        ELSE 
          BufferFSMState_temp := to_unsigned(16#1#, 2);
        END IF;
      WHEN "10" =>
        pop <= '1';
        push <= '0';
        IF vEndIn /= '0' THEN 
          BufferFSMState_temp := to_unsigned(16#0#, 2);
        ELSE 
          BufferFSMState_temp := to_unsigned(16#2#, 2);
        END IF;
      WHEN OTHERS => 
        push <= '0';
        pop <= '0';
    END CASE;
    LockedInFrame <= LockedInFrame_temp;
    FSMState_tmp <= BufferFSMState_temp;
    BirdsEyeViewFSM_BufferFSMState_next <= BufferFSMState_temp;
    BirdsEyeViewFSM_LockedInFrame_next <= LockedInFrame_temp;
  END PROCESS BirdsEyeViewFSM_output;


  FSMState <= std_logic_vector(FSMState_tmp);

END rtl;

