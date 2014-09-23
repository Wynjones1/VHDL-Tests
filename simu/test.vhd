library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity test is
end test;

architecture rtl of test is	
	component top is
		port( clk : in std_logic;
			  red : out std_logic_vector(2 downto 0);
			  green : out std_logic_vector(2 downto 0);
			  blue  : out std_logic_vector(1 downto 0);
			  vs    : out std_logic;
			  hs    : out std_logic);
	end component;

	signal red     : std_logic_vector(2 downto 0);
	signal green   : std_logic_vector(2 downto 0);
	signal blue    : std_logic_vector(1 downto 0);
	signal HS      : std_logic;
	signal VS      : std_logic;
	signal clk     : std_logic;
	signal s_reset : std_logic;
begin
	top0 : top port map(clk => clk,
						red => red,
						blue => blue,
						green => green,
						HS => HS,
						VS => VS);

	process
	begin
		s_reset <= '1';
		wait for 20 ns;
		s_reset <= '0';
		wait;
	end process;

	process
	begin
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
	end process;
end rtl;
