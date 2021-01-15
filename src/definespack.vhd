LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

PACKAGE definespack IS
--#############################################################################
--#	Top level interface defines
	CONSTANT io_width	: positive	:= 20;
--#############################################################################
--#	Coefficient's Register file defines
	CONSTANT rfc_data_width: positive	:= io_width;
	CONSTANT rfc_addr_width: positive	:= 1;
	CONSTANT rfc_wr_ports	: positive	:= 1;
	CONSTANT rfc_rd_ports	: positive	:= 1;
--#############################################################################
--#	Data's Register file defines
	CONSTANT rfd_data_width: positive	:= io_width;
	CONSTANT rfd_addr_width: positive	:= 2;
	CONSTANT rfd_wr_ports	: positive	:= 1;
	CONSTANT rfd_rd_ports	: positive	:= 2;
--#############################################################################
--#	Multiplier defines
	CONSTANT m_in_width	: positive	:= io_width;
	CONSTANT prod_width	: positive	:= m_in_width * 2;
--#############################################################################
--#	Adder_subtractor defines
	CONSTANT add_width	: positive	:= io_width;
--#############################################################################
--#	Rounder defines
	CONSTANT round_i_width	: positive	:= add_width;
	CONSTANT round_o_width	: positive	:= io_width;
--#############################################################################
--#	Control Unit defines
	CONSTANT cw_width	: positive	:= 10;
--#############################################################################
--#	Testbenches defines
	CONSTANT clk_period	: time		:= 10 ns;
	CONSTANT rst_release	: time		:= 15 ns;
	CONSTANT maker_width	: positive	:= io_width;
	CONSTANT filename1	: string	:= "../tb/notorious_sigs.hex";
	CONSTANT input_file	: string	:= filename1;
	CONSTANT dut_cycle_lat	: positive	:= 14;
	CONSTANT output_file	: string	:= "results.hex";
	CONSTANT sink_width	: positive	:= io_width;
	CONSTANT serial_data	: integer	:= 4;
	CONSTANT adder_const	: signed	:= to_signed(1,add_width);
END definespack;
