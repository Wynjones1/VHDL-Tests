library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga_counter is
	generic( disp : integer;
			 fp   : integer;
			 pw   : integer;
			 bp   : integer);
	port( clk  : in std_logic;
		  sync : out std_logic;
		  pix  : out integer;
		  en   : out std_logic);
end entity;

architecture rtl of vga_counter is
	signal count_s : integer range 0 to (disp + fp + pw + bp - 1);
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if count_s < disp - 1 then
				sync    <= '1';
				en      <= '1';
				count_s <= count_s + 1;
			elsif count_s < disp + fp - 1 then
				sync    <= '1';
				en      <= '0';
				count_s <= count_s + 1;
			elsif count_s < disp + fp + pw - 1 then
				sync    <= '0';
				en      <= '0';
				count_s <= count_s + 1;
			elsif count_s < disp + fp + pw + bp - 1 then
				sync    <= '1';
				en      <= '0';
				count_s <= count_s + 1;
			else
				sync    <= '1';
				en      <= '1';
				count_s <= 0;
			end if;
		end if;
	end process;

	pix <= count_s;
end rtl;

