library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sseg is
port( clk    : in std_logic;
	  digit  : in integer range 0 to 15;
	  enable : in std_logic;
	  anode  : out std_logic;
	  cout   : out std_logic_vector(6 downto 0));
end sseg;

architecture rtl of sseg is
begin
	process(clk, digit)
	begin
		if rising_edge(clk) then
			case  digit is
				when 0      => cout <= "1000000";
				when 1      => cout <= "1111001";
				when 2      => cout <= "0100100";
				when 3      => cout <= "0110000";
				when 4      => cout <= "0011001";
				when 5      => cout <= "0010010";
				when 6      => cout <= "0000010";
				when 7      => cout <= "1111000";
				when 8      => cout <= "0000000";
				when 9      => cout <= "0010000";
				when 10     => cout <= "0001000";
				when 11     => cout <= "0000011";
				when 12     => cout <= "1000110";
				when 13     => cout <= "0100001";
				when 14     => cout <= "0000110";
				when 15     => cout <= "0001110";
				when others => cout <= "1111111";
			end case;
		anode <= not enable;
		end if;
	end process;
end rtl;
