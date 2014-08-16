library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity simple is
port( a, b , c_in: in std_logic;
	  o,c_out    : out std_logic);
end simple;

architecture rtl of simple is
	signal s_input  : std_logic_vector(2 downto 0);
	signal s_output : std_logic_vector(1 downto 0);
begin
	s_input <= a & b & c_in;
	with s_input select
		s_output <= "00" when "000",
					"01" when "100",
					"01" when "010",
					"10" when "110",
					"01" when "001",
					"10" when "101",
					"10" when "011",
					"11" when "111",
					"00" when others;
	o       <= s_output(0);
	c_out   <= s_output(1);
end rtl;
