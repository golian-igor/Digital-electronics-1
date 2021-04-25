------------------------------------------------------------------------
--
-- Traffic light controller using FSM.
-- Nexys A7-50T, Vivado v2020.1.1, EDA Playground
--
-- Copyright (c) 2020-Present Tomas Fryza
-- Dept. of Radio Electronics, Brno University of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
-- This code is inspired by:
-- [1] LBEbooks, Lesson 92 - Example 62: Traffic Light Controller
--     https://www.youtube.com/watch?v=6_Rotnw1hFM
-- [2] David Williams, Implementing a Finite State Machine in VHDL
--     https://www.allaboutcircuits.com/technical-articles/implementing-a-finite-state-machine-in-vhdl/
-- [3] VHDLwhiz, One-process vs two-process vs three-process state machine
--     https://vhdlwhiz.com/n-process-state-machine/
--
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- Entity declaration for traffic light controller
------------------------------------------------------------------------
entity traffic is
    port(
        clk     : in  std_logic;
        reset   : in  std_logic;
        -- Traffic lights (RGB LEDs) for two directions
        south_o : out std_logic_vector(3 - 1 downto 0);
        west_o  : out std_logic_vector(3 - 1 downto 0)
    );
end entity traffic;

------------------------------------------------------------------------
-- Architecture declaration for traffic light controller
------------------------------------------------------------------------
architecture Behavioral of tlc is

    -- Define the states
    type t_state is (STOP,
                     WEST_GO,
                     WEST_WAIT,
                     SOUTH_GO,
                     SOUTH_WAIT
                     );
    -- Define the signal that uses different states
    signal s_state  : t_state;
    -- Internal clock enable
    signal s_en     : std_logic;
    -- Local delay counter
    signal   s_cnt  : unsigned(5 - 1 downto 0);

    -- Specific values for local counter
    constant c_DELAY_3SEC : unsigned(5 - 1 downto 0) := b"1_0000";
    constant c_DELAY_05SEC: unsigned(5 - 1 downto 0) := b"0_1000";
    constant c_ZERO       : unsigned(5 - 1 downto 0) := b"0_0000";

    -- Output values
    constant c_RED        : std_logic_vector(3 - 1 downto 0) := b"100";
    constant c_YELLOW     : std_logic_vector(3 - 1 downto 0) := b"110";
    constant c_GREEN      : std_logic_vector(3 - 1 downto 0) := b"010";

begin

    --------------------------------------------------------------------
    -- Instance (copy) of clock_enable entity generates an enable pulse
    -- every 250 ms (4 Hz). Remember that the frequency of the clock 
    -- signal is 100 MHz.
    
    -- JUST FOR SHORTER/FASTER SIMULATION
    s_en <= '1';
--    clk_en0 : entity work.clock_enable
--        generic map(
--            g_MAX =>        -- g_MAX = 250 ms / (1/100 MHz)
--        )
--        port map(
--            clk   => clk,
--            reset => reset,
--            ce_o  => s_en
--        );

    --------------------------------------------------------------------
    -- p_traffic_fsm:
    -- The sequential process with synchronous reset and clock_enable 
    -- entirely controls the s_state signal by CASE statement.
    --------------------------------------------------------------------
    p_smart_traffic_fsm : process(clk)
    begin
    if rising_edge(clk) then
        if (reset = '1') then       
            s_state <= STOP ;       
            s_cnt   <= c_ZERO;
                  
            elsif (s_en = '1') then
            
                if ( south_sensor = '0' and west_sensor = '0') then
                 case s_state is
                     when STOP =>
                          s_state <= SOUTH_GO;
                     when SOUTH_GO =>
                          s_state <= SOUTH_GO;
                     when SOUTH_WAIT =>
                       
                     if( s_cnt < c_DELAY_05SEC) then
                          s_cnt <= s_cnt + 1/2;
                     else
                          s_state <= WEST_GO;
                          s_cnt <= c_ZERO;  
                     end if;
                     when WEST_GO =>
                          s_state <= WEST_GO; 
                     when WEST_WAIT =>
                      
                     if( s_cnt < c_DELAY_05SEC) then
                          s_cnt <= s_cnt + 1/2;
                     else
                          s_state <= SOUTH_GO;
                          s_cnt <= c_ZERO;  
                     end if;     
                     end case;
                          
                elsif ( south_sensor = '1' and west_sensor = '0') then
                  case s_state is
                    when STOP =>
                        s_state <= SOUTH_GO;
                  
                    when SOUTH_GO =>          
                          s_state <= SOUTH_GO;
                          
                     when SOUTH_WAIT =>
                       
                     if( s_cnt < c_DELAY_05SEC) then
                          s_cnt <= s_cnt + 1/2;
                     else
                          s_state <= STOP;
                          s_cnt <= c_ZERO;  
                     end if;
                     when WEST_GO =>
                       
                     if( s_cnt < c_DELAY_3SEC) then
                          s_cnt <= s_cnt + 1;
                     else
                          s_state <= WEST_WAIT;
                          s_cnt <= c_ZERO;  
                     end if;
                     when WEST_WAIT =>
                       
                     if( s_cnt < c_DELAY_05SEC) then
                          s_cnt <= s_cnt + 1/2;
                     else
                          s_state <= SOUTH_GO;
                          s_cnt <= c_ZERO;  
                     end if;     
                     end case;
                     
                elsif ( south_sensor = '0' and west_sensor = '1') then
                 case s_state is
                    when STOP =>
                        s_state <= WEST_GO;
                  
                    when WEST_GO =>          
                          s_state <= WEST_GO;
                          
                     when SOUTH_WAIT =>
                       
                     if( s_cnt < c_DELAY_05SEC) then
                          s_cnt <= s_cnt + 1/2;
                     else
                          s_state <= WEST_GO;
                          s_cnt <= c_ZERO;  
                     end if;
                     when SOUTH_GO =>
                       
                     if( s_cnt < c_DELAY_3SEC) then
                          s_cnt <= s_cnt + 1;
                     else
                          s_state <= SOUTH_WAIT;
                          s_cnt <= c_ZERO;  
                     end if;
                     when WEST_WAIT =>
                       
                     if( s_cnt < c_DELAY_05SEC) then
                          s_cnt <= s_cnt + 1/2;
                     else
                          s_state <= STOP;
                          s_cnt <= c_ZERO;  
                     end if;     
                     end case;
                     
                elsif ( south_sensor = '1' and west_sensor = '1') then
                 case s_state is 
                    when STOP =>                     
                     if( s_cnt < c_DELAY_2SEC) then
                          s_cnt <= s_cnt + 1;
                     else
                          s_state <= WEST_GO;
                          s_cnt <= c_ZERO;  
                     end if;   
                     when WEST_GO => 
                      
                     if( s_cnt < c_DELAY_3SEC) then
                          s_cnt <= s_cnt + 1;
                     else
                          s_state <= WEST_WAIT;
                          s_cnt <= c_ZERO;  
                     end if;
                     when WEST_WAIT => 
                       
                     if( s_cnt < c_DELAY_05SEC) then
                          s_cnt <= s_cnt + 1/2;
                     else
                          s_state <= SOUTH_GO;
                          s_cnt <= c_ZERO;  
                     end if;   
                     when SOUTH_GO => 
                       
                     if( s_cnt < c_DELAY_3SEC) then
                          s_cnt <= s_cnt + 1;
                     else
                          s_state <= SOUTH_WAIT;
                          s_cnt <= c_ZERO;  
                     end if; 
                     when SOUTH_WAIT => 
                       
                     if( s_cnt < c_DELAY_05SEC) then
                          s_cnt <= s_cnt + 1/2;
                     else
                          s_state <= STOP;
                          s_cnt <= c_ZERO;  
                     end if;  
                     end case;      
            end if;
        end if; 
    end if; 
    end process p_smart_traffic_fsm;
    
end architecture Behavioral;
