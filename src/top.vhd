library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
	port( clk   : in std_logic;
		  reset : in std_logic;
		  -- VGA
		  red   : out std_logic_vector(2 downto 0);
		  green : out std_logic_vector(2 downto 0);
		  blue  : out std_logic_vector(1 downto 0);
		  vs    : out std_logic;
		  hs    : out std_logic;
		  --SSeg
		  cout  : out std_logic_vector(6 downto 0);
		  dp    : out std_logic;
		  an    : out std_logic_vector(3 downto 0));
end top;

architecture rtl of top is
	component vga is
		port( clk       : in  std_logic;
			  reset     : in  std_logic;
			  red_in    : in  std_logic_vector(2 downto 0);
			  green_in  : in  std_logic_vector(2 downto 0);
			  blue_in   : in  std_logic_vector(1 downto 0);
			  red_out   : out std_logic_vector(2 downto 0);
			  green_out : out std_logic_vector(2 downto 0);
			  blue_out  : out std_logic_vector(1 downto 0);
			  pix_x     : out integer;
			  pix_y     : out integer;
			  vs        : out std_logic;
			  hs        : out std_logic);
	end component;

	component pong is
		port(clk   : in std_logic;
			 reset : in std_logic;
			 pix_x : in integer;
			 pix_y : in integer;
			 col   : out std_logic);
	end component;

	component ssd4 is
	port(clk   : in std_logic;
		 reset : in std_logic;
		 hex   : in std_logic;
		 val   : in integer range 0 to 65535;
		 an    : out std_logic_vector(3 downto 0);
		 cout : out std_logic_vector(6 downto 0));
	end component;

	constant WIDTH  : integer := 640;
	constant HEIGHT : integer := 480;

	signal s_pulse    : std_logic;
	signal s_half_clk : std_logic := '0';
	signal s_pix_x    : integer range 0 to WIDTH  - 1;
	signal s_pix_y    : integer range 0 to HEIGHT - 1;
	signal s_colour   : std_logic;
	signal red_in     : std_logic_vector(2 downto 0);
	signal green_in   : std_logic_vector(2 downto 0);
	signal blue_in    : std_logic_vector(1 downto 0);
	signal s_vs       : std_logic;
	signal s_game_clk : std_logic;

	signal s_counter : integer := 0;
begin
	ssd: ssd4
	port map(clk    => clk,
			 reset  => reset,
			 val    => s_counter,
			 hex    => '1',
			 an     => an,
			 cout   => cout);

	dp <= '1';

	gen_counter:
	process(clk, s_counter)
	variable v_counter : integer range 0 to 25000000 := 0;
	begin
		if rising_edge(clk) then
			if v_counter = 25000000 - 1 then
				v_counter := 0;
				if s_counter = 9999 then
					s_counter <= 0;
				else 
					s_counter <= s_counter + 1;
				end if;
			else
				v_counter := v_counter + 1;
			end if;
		end if;
	end process; 

	half_clk_gen:
	process(clk, reset)
	begin
		if reset = '1' then
			s_half_clk <= '0';
		elsif rising_edge(clk) then
			if s_half_clk = '1' then
				s_half_clk <= '0';
			else
				s_half_clk <= '1';
			end if;
		end if;
	end process half_clk_gen;

	game_clk_gen:
	process(clk, reset)
		variable count : integer;
	begin
		if reset = '1' then
			s_game_clk <= '0';
			count      :=  0;
		elsif rising_edge(clk) then
			count := count + 1;
			if count > (25000000 / 240) - 1 then
				count := 0;
				if s_game_clk = '1' then
					s_game_clk <= '0';
				else
					s_game_clk <= '1';
				end if;
			end if;
		end if;
	end process game_clk_gen;

	vga_controller :
		vga
		port map(clk       => s_half_clk,
				 reset     => reset,
				 red_in    => red_in,
				 green_in  => green_in,
				 blue_in   => blue_in,
				 red_out   => red,
				 green_out => green,
				 blue_out  => blue,
				 vs        => s_vs,
				 hs        => hs,
				 pix_x     => s_pix_x,
				 pix_y     => s_pix_y);

	pong_gen:
	pong port map(clk   => s_game_clk,
				  reset => reset,
				  pix_x => s_pix_x,
				  pix_y => s_pix_y,
				  col   => s_colour);

	colour_gen:
	process(s_colour, s_pix_x, s_pix_y)
	begin
		if s_pix_x = 0 or s_pix_x = WIDTH -1 or
		   s_pix_y = 0 or s_pix_y = HEIGHT - 1 then
			red_in   <= "000";
			green_in <= "111";
			blue_in  <= "00";
		else
			if s_colour = '1' then
				red_in   <= "111";
				green_in <= "111";
				blue_in  <= "11";
			else
				red_in   <= "000";
				green_in <= "000";
				blue_in  <= "00";
			end if;
		end if;
	end process colour_gen;

	vs <= s_vs;
end rtl;
