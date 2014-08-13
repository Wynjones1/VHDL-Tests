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

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity comp is
port( A  : in std_logic_vector(2 downto 0);
	  B  : in std_logic_vector(2 downto 0);
	  Q  : out std_logic);
end comp;

architecture arch0 of comp is
	component big_xnor is
	port( A, B : in  std_logic;
		  F    : out std_logic);
	end component;

	component big_and is
	port( A, B, C : in  std_logic;
		  F       : out std_logic);
	end component;

	signal p1_out, p2_out, p3_out : std_logic;
begin
	x1: big_xnor port map (A => A(2), B => B(2), F => p1_out);
	x2: big_xnor port map (A => A(1), B => B(1), F => p2_out);
	x3: big_xnor port map (A => A(0), B => B(0), F => p3_out);
	a1: big_and  port map (A => p1_out, B => p2_out, C => p3_out, F => Q);
end arch0;
