library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sync_gen is
generic(DISPLAY_WIDTH      : integer;
		PULSE_WIDTH        : integer;
		FRONT_PORCH_WIDTH  : integer;
		BACK_PORCH_WIDTH   : integer);
port(clk, reset : in std_logic;
	 sync       : out std_logic);
end sync_gen;

architecture rtl of sync_gen is
	type state is (STATE_LOW_PULSE, STATE_FRONT_PORCH, STATE_DISPLAY, STATE_BACK_PORCH);
	signal n_sync_state : state;
	signal s_sync_state : state;
	signal s_sync       : std_logic;
	signal s_counter    : integer range 0 to DISPLAY_WIDTH;
begin
	state_transfer : process(clk)
	begin
		if rising_edge(clk) then
			s_sync_state <= n_sync_state;
		end if;
	end process;

	sync_state_machine :
	process(clk, reset, s_sync)
	begin
		if reset = '1' then
			s_counter    <= 0;
			s_sync       <= '0';
			n_sync_state <= STATE_FRONT_PORCH;
		elsif rising_edge(clk) then
			case s_sync_state is
				when STATE_LOW_PULSE   =>
					s_sync <= '0';
					if s_counter = (PULSE_WIDTH - 1) then
						s_counter <= 0;
						n_sync_state <= STATE_BACK_PORCH;
					else
						s_counter <= s_counter + 1;
					end if;
				when STATE_BACK_PORCH  =>
					s_sync <= '1';
					if s_counter = (BACK_PORCH_WIDTH - 1) then
						s_counter <= 0;
						n_sync_state <= STATE_DISPLAY;
					else
						s_counter <= s_counter + 1;
					end if;
				when STATE_DISPLAY     =>
					s_sync  <= '1';
					if s_counter = (DISPLAY_WIDTH - 1) then
						s_counter <= 0;
						n_sync_state <= STATE_FRONT_PORCH;
					else
						s_counter <= s_counter + 1;
					end if;
				when STATE_FRONT_PORCH =>
					s_sync <= '1';
					if s_counter = (FRONT_PORCH_WIDTH - 1) then
						s_counter <= 0;
						n_sync_state <= STATE_LOW_PULSE;
					else
						s_counter <= s_counter + 1;
					end if;
			end case;
		end if;
	sync <= s_sync;
	end process; end rtl;
