library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity big_and is
port( A, B, C : in  std_logic;
	  F       : out std_logic);
end big_and;

architecture arch0 of big_and is
begin
	F <= A and B and C;
end architecture;
