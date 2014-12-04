library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga is
	port( clk   : in  std_logic;
		  hs    : out std_logic;
		  vs    : out std_logic;
		  pix_x : out integer range 0 to 799;
		  pix_y : out integer range 0 to 520;
		  en    : out std_logic);
end entity;

architecture rtl of vga is
	component vga_counter is
		generic( disp : integer;
				 fp   : integer;
				 pw   : integer;
				 bp   : integer);
		port( clk  : in std_logic;
			  sync : out std_logic;
			  pix  : out integer;
			  en   : out std_logic);
	end component;

	signal h_disp_s  : std_logic;
	signal v_disp_s  : std_logic;
	signal vs_s      : std_logic;
	signal hs_s      : std_logic;
begin
	horiz: vga_counter
		generic map (640, 16, 96, 48)
		port map (clk, hs_s, pix_x, h_disp_s);

	vert: vga_counter
		generic map (480, 10, 2, 29)
		port map (hs_s, vs_s, pix_y, v_disp_s);

	hs <= hs_s;
	vs <= vs_s;
	en <= v_disp_s and h_disp_s;
end;
