library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
port(
	  clk   : in  std_logic;
	  reset : in  std_logic;
	  red   : out std_logic_vector(2 downto 0);
	  green : out std_logic_vector(2 downto 0);
	  blue  : out std_logic_vector(1 downto 0);
	  HS    : out std_logic;
	  VS    : out std_logic);
end top;

architecture rtl of top is
	component vga is
	port(red   : out std_logic_vector(2 downto 0);
		 green : out std_logic_vector(2 downto 0);
		 blue  : out std_logic_vector(1 downto 0);
		 HS    : out std_logic;
		 VS    : out std_logic;
		 reset : in  std_logic;
		 clk   : in  std_logic);
	end component;

	signal vga_clock : std_logic;
begin
	vga_clock <= clk;
	vga_instance : vga port map(red   => red,
								green => green,
								blue  => blue,
								HS    => HS,
								VS    => VS,
								reset => reset,
								clk   => vga_clock);
end rtl;
