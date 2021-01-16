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
	CONSTANT prod_width	: positive	:= m_in_width*2;
--#############################################################################
--#	Adder_subtractor defines
	CONSTANT add_width	: positive	:= prod_width;
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
	
	CONSTANT filename1	: string	:= "../tb/notorious_sigs.hex";
	CONSTANT input_file	: string	:= filename1;
	CONSTANT dut_cycle_lat	: positive	:= 1;
	CONSTANT output_file	: string	:= "results.hex";
	CONSTANT serial_data	: integer	:= 4;
	CONSTANT adder_const	: signed	:= to_signed(1,add_width);
	CONSTANT mult_const	: signed	:= to_signed(16,m_in_width);
	CONSTANT rf_data_test	: positive	:= 4;
	CONSTANT rf_addr_test	: positive	:= 2;
	CONSTANT rf_wr_test	: positive	:= 4;
	CONSTANT rf_rd_test	: positive	:= 2;
	CONSTANT maker_width	: positive	:= rf_data_test*rf_wr_test;
	CONSTANT sink_width	: positive	:= rf_data_test*rf_rd_test;
END definespack;
