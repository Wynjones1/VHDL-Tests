library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ssd is
port (val     : in std_logic_vector(3 downto 0);
	  decimal : in std_logic;
	  enable  : in std_logic;
	  dout    : out std_logic_vector(7 downto 0));
end ssd;

architecture rtl of ssd is
	signal temp  : std_logic_vector(6 downto 0);
begin
	process(val, decimal, enable)
	begin
		temp <= (others => '0');
		if enable = '1' then
			case val is
				when "0000" => temp <= "0000001" ;
				when "0001" => temp <= "1001111" ;
				when "0010" => temp <= "0010010" ;
				when "0011" => temp <= "0000110" ;
				when "0100" => temp <= "1001100" ;
				when "0101" => temp <= "0100100" ;
				when "0110" => temp <= "0100000" ;
				when "0111" => temp <= "0001111" ;
				when "1000" => temp <= "0000000" ;
				when "1001" => temp <= "0000100" ;
				when "1010" => temp <= "0001000" ;
				when "1011" => temp <= "1100000" ;
				when "1100" => temp <= "0110001" ;
				when "1101" => temp <= "1000010" ;
				when "1110" => temp <= "0110000" ;
				when "1111" => temp <= "0111000" ;
				when others => temp <= "1111111" ;
			end case;
		end if;
	end process;


	dout <= temp & (not decimal and enable);
end rtl;
