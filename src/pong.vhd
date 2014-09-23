library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pong is
	port(clk   : in std_logic;
		 reset : in std_logic;
		 pix_x : in integer;
		 pix_y : in integer;
		 col   : out std_logic);
end pong;

architecture rtl of pong is
	constant WIDTH          : integer := 640;
	constant HEIGHT         : integer := 480;
	constant PADDLE_WIDTH   : integer := 25;
	constant PADDLE_HEIGHT  : integer := 100;
	constant BALL_WIDTH     : integer := 20;
	constant PADDLE_OFFSET  : integer := 70;
	constant BALL_HEIGHT    : integer := BALL_WIDTH;
	signal   s_pos_rpaddle  : integer range 0 to WIDTH  - PADDLE_WIDTH - 1;
	signal   s_pos_lpaddle  : integer range 0 to WIDTH  - PADDLE_WIDTH - 1;
	signal   s_ball_pos_x   : integer range 0 to WIDTH  - BALL_WIDTH   - 1 := WIDTH / 2;
	signal   s_ball_pos_y   : integer range 0 to HEIGHT - BALL_HEIGHT  - 1 := HEIGHT / 2;
	signal   s_draw_ball    : std_logic;
	signal   s_draw_lpaddle : std_logic;
	signal   s_draw_rpaddle : std_logic;
begin

	run:
	process(clk, reset, s_ball_pos_x, s_ball_pos_y)
		variable s_dir_x : integer range -1 to 1 := 1;
		variable s_dir_y : integer range -1 to 1 := 1;
	begin
		if reset = '1' then
			s_ball_pos_x <= WIDTH / 2;
			s_ball_pos_y <= HEIGHT / 2;
			s_dir_x := -1;
			s_dir_y := 0;
		elsif rising_edge(clk) then
			--Check if we are hitting the edge.
			if s_ball_pos_x = WIDTH - BALL_WIDTH - 1 then
				s_dir_x := -1;
			elsif s_ball_pos_x = 0 or s_dir_x = 0 then
				s_dir_x := 1;
			end if;

			if s_ball_pos_y = HEIGHT - BALL_HEIGHT - 1 then
				s_dir_y := -1;
			elsif s_ball_pos_y = 0 or s_dir_y = 0 then
				s_dir_y := 1;
			end if;

			--Check if we are hitting the left paddle
			-- from the right
			if s_pos_lpaddle <= s_ball_pos_y and s_ball_pos_y < s_pos_lpaddle + PADDLE_HEIGHT + BALL_HEIGHT then
				if s_ball_pos_x = PADDLE_OFFSET + PADDLE_WIDTH then
					s_dir_x := 1;
			-- from the left
				elsif s_ball_pos_x = PADDLE_OFFSET - BALL_WIDTH then
					s_dir_x := - 1;
				end if;
			end if;

			if PADDLE_OFFSET <= s_ball_pos_x and s_ball_pos_x < PADDLE_OFFSET + PADDLE_WIDTH + BALL_WIDTH then
				--from the top
				if s_ball_pos_y = s_pos_lpaddle - BALL_WIDTH then
					s_dir_y := -1;
				--from the bottom
				elsif s_ball_pos_y = s_pos_lpaddle + PADDLE_HEIGHT then
					s_dir_y := 1;
				end if;
			end if;

			--Check if we are hitting the right paddle
			if s_pos_rpaddle <= s_ball_pos_y and s_ball_pos_y < s_pos_rpaddle + PADDLE_HEIGHT - BALL_HEIGHT then
				-- from the right
				if s_ball_pos_x = WIDTH - PADDLE_OFFSET then
					s_dir_x := 1;
				-- from the left
				elsif s_ball_pos_x = WIDTH - PADDLE_OFFSET - PADDLE_WIDTH - BALL_WIDTH then
					s_dir_x := - 1;
				end if;
			end if;

			 if WIDTH - PADDLE_OFFSET - PADDLE_WIDTH <= s_ball_pos_x and
			 	s_ball_pos_x < WIDTH - PADDLE_OFFSET - PADDLE_WIDTH - BALL_WIDTH then
			 	--from the top
			 	if s_ball_pos_y = s_pos_rpaddle - BALL_WIDTH then
			 		s_dir_y := -1;
			 	--from the bottom
			 	elsif s_ball_pos_y = s_pos_rpaddle + PADDLE_HEIGHT then
			 		s_dir_y := 1;
			 	end if;
			 end if;

			s_ball_pos_x <= s_ball_pos_x + s_dir_x;
			s_ball_pos_y <= s_ball_pos_y + s_dir_y;
		end if;
	end process run;

	draw_ball:
	process(pix_x, pix_y, s_ball_pos_x, s_ball_pos_y)
	begin
		s_draw_ball <= '0';
		if s_ball_pos_x <= pix_x and pix_x < (s_ball_pos_x + BALL_WIDTH)  and
		   s_ball_pos_y <= pix_y and pix_y < (s_ball_pos_y + BALL_HEIGHT) then

			s_draw_ball <= '1';

		end if;
	end process draw_ball;

	draw_lpaddle:
	process(pix_x, pix_y, s_pos_lpaddle)
	begin
		s_draw_lpaddle <= '0';
		if PADDLE_OFFSET <= pix_x and pix_x < PADDLE_OFFSET + PADDLE_WIDTH and
		   s_pos_lpaddle <= pix_y and pix_y < s_pos_lpaddle  + PADDLE_HEIGHT then

		   s_draw_lpaddle <= '1';

		end if;
	end process draw_lpaddle;

	draw_rpaddle:
	process(pix_x, pix_y, s_pos_rpaddle)
	begin
		s_draw_rpaddle <= '0';
		if (WIDTH - PADDLE_WIDTH - PADDLE_OFFSET )<= pix_x and
			pix_x < (WIDTH - PADDLE_WIDTH - PADDLE_OFFSET) + PADDLE_WIDTH and
		   s_pos_rpaddle <= pix_y and pix_y < s_pos_rpaddle  + PADDLE_HEIGHT then

		   s_draw_rpaddle <= '1';

		end if;
	end process draw_rpaddle;

	s_pos_lpaddle <= 150;
	s_pos_rpaddle <= 150;

	col <= '1' when s_draw_ball = '1'  or s_draw_lpaddle = '1'  or s_draw_rpaddle = '1' else '0';
end rtl;
