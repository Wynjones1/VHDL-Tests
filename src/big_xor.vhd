library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity big_xnor is
port( A, B : in  std_logic;
	  F    : out std_logic);
end big_xnor;

architecture arch0 of big_xnor is
begin
	F <= (A and (not B)) or ((not A) and B);
end architecture;
