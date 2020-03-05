----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 11/20/2018 12:19:52 PM
-- Design Name:
-- Module Name: au2mc - rtl
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity au2mc is
    Port ( ain : in STD_LOGIC_VECTOR (11 downto 0);
           d_bin : out STD_LOGIC;
           clk_48k : in STD_LOGIC;
           clr : in STD_LOGIC;
           processed: out integer);
end au2mc;

architecture rtl of au2mc is
    constant threshold_value : integer := 1024;
    type audio is array (0 to 7) of integer;
    signal sum_of_window : integer;
    signal audio_before: audio :=(others => 0);
    signal output: std_logic;
    signal buffer_for_audio :std_logic_vector (11 downto 0) := (others => '0');
    signal counter : integer := 0;

begin
     buffering : process(clk_48k, buffer_for_audio,clr)
        begin
            if clr ='1' then
                audio_before <= (others => 0);
            end if;
            processed  <= audio_before(counter);
            audio_before(counter) <= to_integer(abs(signed(buffer_for_audio)));

        end process;
    input_entry: process(clk_48k,clr)
    begin
         if clr='1' then
            buffer_for_audio <= (others => '0');
            output <= '0';
        end if;
        sum_of_window <= audio_before(7) + audio_before(6) + audio_before(5) + audio_before(4) + audio_before(3) + audio_before(2) + audio_before(1) + audio_before(0);

    if ((sum_of_window / 8) > threshold_value) then
        output <= '1';
    else
        output <= '0';
    end if;
    if rising_edge(clk_48k) then

        if (ain(11) = '1' ) then
           buffer_for_audio <= '0' & ain(10 downto 0);
        else
            buffer_for_audio <= '1' & ain(10 downto 0);
        end if;
        counter <= (1+counter) mod 8;
     end if;
     end process;
     d_bin <= output;
   end rtl;
