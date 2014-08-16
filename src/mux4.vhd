library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux4 is
port( d0, d1 : in std_logic_vector(3 downto 0);
	  sel    : in std_logic;
	  dout   : out std_logic_vector(3 downto 0));
end mux4;


architecture rtl of mux4 is
begin
	process(sel,d0, d1)
	begin
		if sel = '1' then
			dout <= d1;
		else
			dout <= d0;
		end if;
	end process;
end rtl;
