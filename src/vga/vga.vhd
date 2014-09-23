library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga is
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
end vga;

architecture rtl of vga is
	component counter is
		generic( count_to : integer := 1);
		port( clk   : in  std_logic;
			  reset : in  std_logic;
			  pulse : out std_logic;
			  count : out integer);
	end component;

	constant HS_COUNT_MAX : integer := 800;
	constant VS_COUNT_MAX : integer := 521;
	signal   hs_count     : integer range 0 to HS_COUNT_MAX - 1 := 0;
	signal   vs_count     : integer range 0 to VS_COUNT_MAX - 1 := 0;
	signal   s_hs_display : std_logic;
	signal   s_vs_display : std_logic;
	signal   s_display    : std_logic;
	signal   s_pulse      : std_logic;
begin

	hs_counter :
		counter
		generic map(count_to => HS_COUNT_MAX)
		port    map(clk   => clk,
					reset => reset,
					count => hs_count,
					pulse => s_pulse);

	vs_counter :
		counter
		generic map(count_to => VS_COUNT_MAX)
		port    map(clk   => s_pulse,
					reset => reset,
					count => vs_count);

	hs_set:
		process(hs_count)
		begin
			pix_x <= 0;
			if hs_count < 640 then
				hs <= '1';
				s_hs_display <= '1';
				pix_x <= hs_count;
			elsif hs_count < 640 + 16 then
				hs <= '1';
				s_hs_display <= '0';
			elsif hs_count < 640 + 16 + 96 then
				hs <= '0';
				s_hs_display <= '0';
			elsif hs_count < 640 + 16 + 96 + 48 then
				hs <= '1';
				s_hs_display <= '0';
			end if;
		end process hs_set;

	vs_set:
		process(vs_count)
		begin
			pix_y <= 0;
			if vs_count < 480 then
				vs <= '1';
				s_vs_display <= '1';
				pix_y <= vs_count;
			elsif vs_count < 480 + 10 then
				vs <= '1';
				s_vs_display <= '0';
			elsif vs_count < 480 + 10 + 2 then
				vs <= '0';
				s_vs_display <= '0';
			elsif vs_count < 480 + 10 + 2 + 29 then
				vs <= '1';
				s_vs_display <= '0';
			end if;
		end process vs_set;

	process(s_vs_display, s_hs_display)
	begin
		s_display <= '0';
		if s_vs_display = '1' then
			if s_hs_display = '1' then
				s_display <= '1';
			end if;
		end if;
	end process;

	red_out   <= red_in   when s_display = '1' else (others => '0');
	green_out <= green_in when s_display = '1' else (others => '0');
	blue_out  <= blue_in  when s_display = '1' else (others => '0');
end rtl;
