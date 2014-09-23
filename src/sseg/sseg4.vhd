library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sseg4 is
port(clk   : in std_logic;
	 reset : in std_logic;
	 hex   : in std_logic;
	 val   : in integer range 0 to 65535;
	 an    : out std_logic_vector(3 downto 0);
	 cout  : out std_logic_vector(6 downto 0));
end sseg4;

architecture rtl of sseg4 is
	component sseg is
	port( digit  : in integer range 0 to 15;
		  clk    : in std_logic;
		  enable : in std_logic;
		  anode  : out std_logic;
		  cout   : out std_logic_vector(6 downto 0));
	end component;

	signal digit_clk : std_logic;
	signal s_enable  : std_logic_vector(3 downto 0) := "0001";
	signal cout0     : std_logic_vector(6 downto 0);
	signal cout1     : std_logic_vector(6 downto 0);
	signal cout2     : std_logic_vector(6 downto 0);
	signal cout3     : std_logic_vector(6 downto 0);
	signal d0        : integer;
	signal d1        : integer;
	signal d2        : integer;
	signal d3        : integer;
begin
	sseg0: sseg
	port map(digit  => d0,
			 clk    => clk,
			 enable => s_enable(0),
			 anode  => an(0),
			 cout   => cout0);

	sseg1: sseg
	port map(digit  => d1,
			 clk    => clk,
			 enable => s_enable(1),
			 anode  => an(1),
			 cout   => cout1);

	sseg2: sseg
	port map(digit  => d2,
			 clk    => clk,
			 enable => s_enable(2),
			 anode  => an(2),
			 cout   => cout2);

	sseg3: sseg
	port map(digit  => d3,
			 clk    => clk,
			 enable => s_enable(3),
			 anode  => an(3),
			 cout   => cout3);

	gen_clk:
	process(clk)
		constant CLK_SPEED : integer := 25000000;
		constant RATE      : integer := 240;
		constant COUNT_MAX : integer := CLK_SPEED / RATE;
		variable count     : integer range 0 to COUNT_MAX - 1;
	begin
		if rising_edge(clk) then
			if count >= COUNT_MAX - 1 then
				count := 0;
				if digit_clk = '1' then
					digit_clk <= '0';
				else
					digit_clk <= '1';
				end if;
			else
				count := count + 1;
			end if;
		end if;
	end process;

	select_segment:
	process(digit_clk, reset, s_enable, cout0, cout1, cout2, cout3)
	begin
		if reset = '1' then
			s_enable <= "0001";
			cout     <= cout0;
		elsif rising_edge(digit_clk) then
			case s_enable is
				when "0001" =>
					s_enable <= "0010";
					cout <= cout1;
				when "0010" =>
					s_enable <= "0100";
					cout <= cout2;
				when "0100" =>
					s_enable <= "1000";
					cout <= cout3;
				when others =>
					s_enable <= "0001";
					cout <= cout0;
			end case;
		end if;
	end process;

	set_digits:
	process(val, hex)
	begin
		if hex = '1' then
			if val > 9999 then
				d0 <= 9;
				d1 <= 9;
				d2 <= 9;
				d3 <= 9;
			else
				d0 <= val / 1    mod 16;
				d1 <= val / 16   mod 16;
				d2 <= val / 256  mod 16;
				d3 <= val / 4096 mod 16;
			end if;
		else
			d0 <= val / 1    mod 10;
			d1 <= val / 10   mod 10;
			d2 <= val / 100  mod 10;
			d3 <= val / 1000 mod 10;
		end if;
	end process;
end rtl;
