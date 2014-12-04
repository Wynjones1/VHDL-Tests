library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library IEEE;
use std.textio.all;

entity top is
	port( clk   : in  std_logic;
		  vs    : out std_logic;
		  hs    : out std_logic;
		  red   : out std_logic_vector(2 downto 0);
		  green : out std_logic_vector(2 downto 0);
		  blue  : out std_logic_vector(1 downto 0));
end entity;


architecture rtl of top is
	component vga is
		port( clk   : in  std_logic;
			  hs    : out std_logic;
			  vs    : out std_logic;
			  pix_x : out integer range 0 to 799;
			  pix_y : out integer range 0 to 520;
			  en    : out std_logic);
	end component;

	constant CLK_SPEED  : integer := 50000000;
	constant XMAX       : integer := 5;
	constant YMAX       : integer := 5;
	constant XRES       : integer := 160;
	constant YRES       : integer := 144;
	signal s_half_clk   : std_logic;
	signal s_display_en : std_logic;
	signal pix_x        : integer;
	signal pix_y        : integer;

	type framebuffer_t is array(0 to YRES - 1) of std_logic_vector(XRES - 1 downto 0);

	impure function init_fb(filename : in string) return framebuffer_t is
		file     romfile   : text is in filename;
		variable file_line : line;
		variable fb        : framebuffer_t;
		variable temp      : bit_vector(XRES - 1 downto 0);
	begin
		for i in framebuffer_t'range loop
			readline (romfile, file_line);
			read (file_line, temp);
			fb(i) := to_stdlogicvector(temp);
		end loop;

		return fb;
	end function;

	function inrange(
			min   : in integer;
			val   : in integer;
			max   : in integer)
			return boolean is
	begin
		return (min <= val) and (val < (min + max));
	end function;

	signal fb      : framebuffer_t := init_fb("fb.rom");
begin
	gen_pixel_clk:
	process(clk)
	begin
		if rising_edge(clk) then
			if s_half_clk = '1' then
				s_half_clk <= '0';
			else
				s_half_clk <= '1';
			end if;
		end if;
	end process;

	vga0: vga
	port map ( s_half_clk, hs, vs, pix_x, pix_y, s_display_en);

	colour_process:
	process(s_half_clk, s_display_en,  pix_x, pix_y, fb)
		variable x       : std_logic_vector(2 downto 0);
		variable y       : std_logic_vector(2 downto 0);
		constant start   : integer := 4;
		constant cross   : integer := 7;
		variable p       : std_logic;
	begin
		if rising_edge(s_half_clk) then
			if s_display_en = '1'and inrange(240, pix_x, XRES) and inrange(168, pix_y, YRES) then
				p := fb(pix_y - 168)(pix_x - 240);
				red     <= (others => p);
				green   <= (others => p);
				blue    <= (others => p);
			else
				red   <= "000";
				green <= "000";
				blue  <= "00";
			end if;
		end if;
	end process;
end architecture;
