----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.11.2019 14:40:57
-- Design Name: 
-- Module Name: symdet - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity symdet is
    Port ( d_bin : in STD_LOGIC;
           dot : out STD_LOGIC;
           dash : out STD_LOGIC;
           lg : out STD_LOGIC;
           wg : out STD_LOGIC;
           valid : out STD_LOGIC;
           clr : in STD_LOGIC;
           clk : in STD_LOGIC
           );
           
end symdet;

architecture Behavioral of symdet is

    type symbols is (dotDet, dashDet, lgDet, wgDet, nullDet);
    signal detect : symbols :=nullDet;
    signal count : unsigned(31 downto 0)    := (others => '0');
    signal reset_c : std_logic := '0';
    signal last_in : std_logic                := '0';
begin
    
    count : process (clk)
    begin
        if rising_edge(clk) then
            if clr = '1' or reset_c = '1' then
                count <= x"00000000";
            else
                count <= count + 1;
            end if;            
   end if;
   end process;
    
    
   detection : process (clk)
   begin
        if rising_edge(clk) then
            if clr = '1' then 
                detect <= nullDet;
            else
                reset_c <= '0';
                if (last_in='1' and d_bin='0') then     --symbol change, previous was 1
                    case to_integer(count) is
                        when  0 to  6000     => detect <= dotDet;    
                        when  6001 to 15600 => detect <= dashDet;
                        when others          => detect <= nullDet;
                    end case; 
                    reset_c <= '1';    
                elsif (last_in='0' and d_bin='1') then
                    case to_integer(count) is
                        when  0 to 15600    => detect <= lgDet;
                        when 15601 to 50000 => detect <= wgDet;
                        when others         => detect <= nullDet;
                     end case;
                     reset_c <= '1';                                    
                end if; 
            end if;
            last_in <= d_bin;
        end if;  
    end process;  
    
    output : process(clk)
    begin
        if rising_edge(clk) then
            if clr = '1' then
--              detect <= nullDet;
            else
                dot     <= '0';
                dash    <= '0';
                lg      <= '0';
                wg      <= '0';
                valid <= '0';
                    case detect is
                        when dotDet      => dot  <= '1';
                        when dashDet     => dash <= '1';
                        when lgDet       => lg   <= '1';
                        when wgDet       => wg   <= '1';
                        when nullDet     => null;
                    end case;
                    valid <='1';
                end if;
            end if;
    end process;
end Behavioral;