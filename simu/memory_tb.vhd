library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity memory_tb is
end memory_tb ;

architecture rtl of memory_tb is	
	signal clk      : std_logic := '0';
	signal reset    : std_logic := '1';
	signal address  : std_logic_vector(15 downto 0);
	signal we       : std_logic := '0';
	signal data_in  : std_logic_vector(7 downto 0) := (others => '0');
	signal data_out : std_logic_vector(7 downto 0) := (others => '0');

	component memory is
	port( clk      : in  std_logic;
		  address  : in  std_logic_vector;
		  we       : in  std_logic;
		  data_in  : in  std_logic_vector;
		  data_out : out std_logic_vector);
	end component;
begin
	mem0 : memory port map (clk, address, we, data_in, data_out);

	-- Generate reset signal
	process begin
		reset <= '1';
		wait for 30 ns;
		reset <= '0';
		wait;
	end process;

	-- Generate the clock signal
	process
	begin
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
	end process;

	process(clk)
		variable next_address : std_logic_vector(15 downto 0);
		variable state : integer := 0;
	begin
		if reset = '1' then
			we      <= '0';
			data_in <= (others => '0');
			address <= (others => '0');
			state   := 0;
		elsif rising_edge(clk) then
			if state = 0 then
				next_address := std_logic_vector(unsigned(address) + 1);
				we           <= '1';
				data_in      <= next_address(7 downto 0);
				address      <= next_address;
				if unsigned(next_address) = 0 then
					state := 1;
				end if;
			else
				next_address := std_logic_vector(unsigned(address) + 1);
				we           <= '0';
				address      <= next_address;
				if unsigned(next_address) = 0 then
					state := 0;
				end if;
			end if;
		end if;
	end process;

end rtl;
