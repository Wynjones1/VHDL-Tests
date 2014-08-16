library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga is
port(red   : out std_logic_vector(2 downto 0);
	 green : out std_logic_vector(2 downto 0);
	 blue  : out std_logic_vector(1 downto 0);
	 HS    : out std_logic;
	 VS    : out std_logic;
	 reset : in  std_logic;
	 clk   : in  std_logic);
end vga;

architecture rtl of vga is
	component sync_gen is
	generic(DISPLAY_WIDTH      : integer;
			PULSE_WIDTH        : integer;
			FRONT_PORCH_WIDTH  : integer;
			BACK_PORCH_WIDTH   : integer);
	port(clk, reset : in std_logic;
		 sync       : out std_logic);
	end component;

	signal s_HS  : std_logic;
	signal s_VS  : std_logic;
	signal s_half_clock : std_logic;

	signal colour : std_logic_vector(7 downto 0);
begin

	divide_clock:
	process(clk, reset)
	begin
		if reset = '1' then
			s_half_clock <= '0';
		elsif rising_edge(clk) then
			if s_half_clock = '1' then
				s_half_clock <= '0';
			else
				s_half_clock <= '1';
			end if;
		end if;
	end process;

	h_sync : sync_gen generic map(DISPLAY_WIDTH => 640, PULSE_WIDTH => 96,
								  FRONT_PORCH_WIDTH => 16, BACK_PORCH_WIDTH => 48)
					  port map(clk => s_half_clock, sync => s_HS, reset => reset);

	v_sync : sync_gen generic map(DISPLAY_WIDTH => 384000, PULSE_WIDTH => 1600,
								  FRONT_PORCH_WIDTH => 8000, BACK_PORCH_WIDTH => 23200)
					  port map(clk => s_half_clock, sync => s_VS, reset => reset);

	process(s_half_clock, reset)
	begin
		if reset = '1' then
			colour <= "00000000";
		elsif rising_edge(s_half_clock) then
			colour <= not colour;
		end if;
	end process;

	HS <= not s_HS;
	VS <= not s_VS;

	green <= colour(7 downto 5);
	red   <= colour(4 downto 2);
	blue  <= colour(1 downto 0);
end rtl;
