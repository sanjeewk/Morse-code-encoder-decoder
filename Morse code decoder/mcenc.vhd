library IEEE;
use IEEE.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity mcencoder is
    Port (
           din : in std_logic_VECTOR (7 downto 0);
           den : out std_logic;
           sout : out std_logic;
           clr : in std_logic;
           clk : in std_logic;
           check: out std_logic);
end mcencoder;

architecture Behavioral of mcencoder is
type arr is array (0 to 10) of STD_LOGIC_VECTOR (7 downto 0);
signal memory : arr;
signal fake : integer := 0;
signal w_ind : integer := 0;
signal r_ind: integer:= 0;
signal write : std_logic := '1';
signal read : std_logic := '0';
signal letter: integer := 0;
signal length: integer := 0;

begin

  
 inp:   process (din)
 begin
   if(write = '1') then
       check <= '1';
       memory(w_ind)<=din;
       w_ind <= w_ind + 1;
       if(din = "00101110") then
        write <= '0';
        read <= '1';
 
       end if;
   end if;    
   end process;
   
  load_out: process (clk)
   begin
--   and r_ind< w_ind
   if(read = '1' and r_ind< w_ind ) then
--      check <= '0';  
      case(memory(r_ind)) is
        when "01000001" =>
            length = 6;
            read = 0;
            letter <= '0';
        when "01000010" =>  
             letter <= 2;
--            sout <= '0';
        when "00101110" =>
--            read <= '0';    
        when others =>
--        sout <= '1';
--            dot <= '0';
--            dash <= '0'; 
--            wg <= '1';
               
      end case;
   r_ind <= r_ind + 1;   
   end if;   
   
   end process;
   output : process(clk) 
   begin
        if(letter >0 and read = 0) then
            case(letter) is 
            when 1 =>
                if(length > 0)
                    case (length) is
                    when 6=>
                        sout <= '1';
                    when 5=>
                        sout <= '0';
                    when 4=>
                        sout <= '1';
                    when 3=>
                        sout <= '1';
                    when 2=>
                        sout <= '1';   
                    when 1=>
                        sout <= '0';  
                      when others=>
                        sout <= '1'; 
                end case;
                read = 1;  
                length = length -1;         
                end if
            when 2 =>    
        end if
   end process;
end Behavioral;
