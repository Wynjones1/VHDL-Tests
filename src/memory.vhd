library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory is
	port( clk      : in  std_logic;
		  address  : in  std_logic_vector;
		  we       : in  std_logic;
		  data_in  : in  std_logic_vector;
		  data_out : out std_logic_vector);
end entity;

architecture rtl of memory is
	constant MEM_WIDTH    : integer := address'length;
	constant MEM_MAX_ADDR : integer := 2 ** MEM_WIDTH - 1;

	type ram_t is array(0 to MEM_MAX_ADDR) of std_logic_vector(data_in'length - 1 downto 0);

	signal ram          : ram_t;
	signal read_address : std_logic_vector(address'length - 1 downto 0);
begin
	process(clk, address, we, data_in)
	begin
		if rising_edge(clk) then
			if we = '1' then
				ram(to_integer(unsigned(address))) <= data_in;
			end if;
			read_address <= address;
		end if;
	end process;

	data_out <= ram(to_integer(unsigned(read_address)));
end rtl;
