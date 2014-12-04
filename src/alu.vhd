library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_misc.all;
use work.types.all;

entity alu is
	port( op          : in  alu_op_t;
		  i0          : in  reg_t;
		  i1          : in  reg_t;
		  q           : out reg_t;
		  flags_in    : in  reg_t;
		  flags_out   : out reg_t);
end entity;

-- report "res " & integer'image(res);

architecture rtl of alu is
begin
	process(op, i0, i1, flags_in)
		constant RES_WIDTH : integer := i0'length + 1;
		variable res_slv   : std_logic_vector(RES_WIDTH - 1 downto 0);
		variable res       : integer range 0 to (2 ** RES_WIDTH) - 1;
		variable i0_int    : integer range 0 to (2 ** i0'length) - 1;
		variable i1_int    : integer range 0 to (2 ** i1'length) - 1;
		variable carry_int : integer range 0 to 1;
	begin
		i0_int    := to_integer(unsigned(i0));
		i1_int    := to_integer(unsigned(i1));
		carry_int := to_integer(unsigned(flags_in(CARRY_BIT downto CARRY_BIT)));
		flags_out <= flags_in;
		case op is
			when alu_op_add  =>
				res     := i0_int + i1_int;
				res_slv := std_logic_vector(to_unsigned(res, 9));
				q <= res_slv(7 downto 0);
				flags_out(CARRY_BIT) <= res_slv(8);
				flags_out(ZERO_BIT)  <= nor_reduce(res_slv(7 downto 0));

			when alu_op_adc =>
				res     := i0_int + i1_int + carry_int;
				res_slv := std_logic_vector(to_unsigned(res, 9));
				q <= res_slv(7 downto 0);
				flags_out(CARRY_BIT) <= res_slv(8);
				flags_out(ZERO_BIT)  <= nor_reduce(res_slv(7 downto 0));

			when alu_op_and  =>
				res_slv(7 downto 0)       := i0 and i1;
				flags_out(ZERO_BIT)       <= nor_reduce(res_slv(7 downto 0));
				flags_out(SUBTRACT_BIT)   <= '0';
				flags_out(CARRY_BIT)      <= '0';
				flags_out(HALF_CARRY_BIT) <= '1';

			when alu_op_bit  =>
			when alu_op_cp   =>
			when alu_op_cpl  =>
			when alu_op_daa  =>
			when alu_op_or   =>
				res_slv(7 downto 0)       := i0 or i1;
				flags_out(ZERO_BIT)       <= nor_reduce(res_slv(7 downto 0));
				flags_out(SUBTRACT_BIT)   <= '0';
				flags_out(CARRY_BIT)      <= '0';
				flags_out(HALF_CARRY_BIT) <= '1';
			when alu_op_rl   =>
			when alu_op_rla  =>
			when alu_op_rr   =>
			when alu_op_rra  =>
			when alu_op_rrc  =>
			when alu_op_sla  =>
			when alu_op_sra  =>
			when alu_op_srl  =>
			when alu_op_sub  =>
			when alu_op_swap =>
			when alu_op_xor  =>
				res_slv(7 downto 0)       := i0 xor i1;
				flags_out(ZERO_BIT)       <= nor_reduce(res_slv(7 downto 0));
				flags_out(SUBTRACT_BIT)   <= '0';
				flags_out(CARRY_BIT)      <= '0';
				flags_out(HALF_CARRY_BIT) <= '1';
		end case;
	end process;
end rtl;
