library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg4 is
port(ld, clk : in std_logic;
	 d       : in std_logic_vector(3 downto 0);
	 r       : out std_logic_vector(3 downto 0));
end reg4;

architecture rtl of reg4 is
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if ld = '1' then
				r <= d;
			end if;
		end if;
	end process;
end rtl;
