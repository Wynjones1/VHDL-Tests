library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_div is
generic(n : integer);
port(clk_in  : in  std_logic;
	 clk_out : out std_logic);
end clock_div;

architecture rtl of clock_div is
constant CLOCK_SPEED : integer := 50000000;
signal count         : integer range 0 to CLOCK_SPEED / (n * 2);
signal s_clk_tmp     : std_logic;
begin
	process(clk_in, s_clk_tmp)
	begin
		s_clk_tmp <= s_clk_tmp;
		if rising_edge(clk_in) then
			if count = CLOCK_SPEED / (n * 2) then
				count <= 0;
				s_clk_tmp <= not s_clk_tmp;
			else
				count <= count + 1;
			end if;
		end if;
	end process;
	clk_out <= s_clk_tmp;
end rtl;
