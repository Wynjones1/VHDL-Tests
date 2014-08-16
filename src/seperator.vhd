library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity seperator is
port( val : in integer range 0 to 9999;
	  d0  : out integer range 0 to 0;
	  d1  : out integer range 0 to 0;
	  d2  : out integer range 0 to 0;
	  d3  : out integer range 0 to 0);
end;

architecture rtl of seperator is
begin
	d0 <=  val         mod 10;
	d1 <= (val / 10)   mod 10;
	d2 <= (val / 100)  mod 10;
	d2 <= (val / 1000) mod 10;
end rtl;
