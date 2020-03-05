--ELEC3342 Testbench for Morse code decorder

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Testbench is
end Testbench;

architecture behavioral of Testbench is
   component mcencoder
Port (
           din : in std_logic_VECTOR (7 downto 0);
           den : out std_logic;
           sout : out std_logic;
           clr : in std_logic;
           clk : in std_logic;
           check: out std_logic);
    end component;

 -- Input signals for mcdecorder   ;
    signal den, sout, check : std_logic;
    signal clr, clk : std_logic;
-- Clock signal;    
-- Output signals    ;
    signal din :  std_logic_vector(7 downto 0);

-- Clock period constat value-
    constant clkPeriod : time := 50 us;
--  Time of a signal high - 2*clkperiod
    constant signal_last :time :=400 us;
-- Time gap between two signals 
    constant signal_gap :time := 500us; 
    
       
    begin 
 -- Include component and define the port map
    encoder: mcencoder port map (din,den,sout,clr,clk,check);

-- Generate clk signal    
    clkPro : process 
                 begin
                     clk <= '0';
                     wait for clkPeriod/2;
                     clk <= '1';
                     wait for clkPeriod/2;
    end process;   

 --clr = 0 
    clr<='0';
      
    process
    begin
    
        -- A
        din<="01000001";
        wait for clkPeriod*10;
        
        -- space
        din<="00100000";
        wait for clkPeriod*10;
        
        -- b
        din<="01000010";
        wait for clkPeriod;
        
         -- pepriod
        din<="00101110";
        wait for clkPeriod ;
           
    end process;
    
    
    FINISH : process
    begin
        wait for clkPeriod*300;
        std.env.finish;
    end process;
end behavioral;








