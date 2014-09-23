library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
	generic( count_to : integer := 1);
	port( clk   : in  std_logic;
		  reset : in  std_logic;
		  pulse : out std_logic;
		  count : out integer);
end counter;

architecture rtl of counter is
	signal s_count : integer range 0 to count_to -1 := 0;
begin
	count_up : process(clk, reset)
	begin
		if reset = '1' then
			s_count <= 0;
			pulse   <= '0';
		else
			if rising_edge(clk) then
				if s_count >= count_to - 1 then
					s_count <= 0;
					pulse <= '1';
				else
					s_count <= s_count + 1;
					pulse <= '0';
				end if;
			end if;
		end if;
	end process count_up;

	count <= s_count;
end rtl;
