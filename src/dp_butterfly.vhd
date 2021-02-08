-- Author:       Luca Lombardini
-- Academic_y:   2020/2021
-- Purpose:      (Master Degree) Digital Integrated Systems' Final Project
-- Contacts:     s277972@studenti.polito.it
--               lombamari2@gmail.com
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;
USE work.cupack.all;

ENTITY dp_butterfly IS
	PORT(	CLK		: IN std_logic;
		RST_n		: IN std_logic;
		PORT_A		: IN signed(io_width-1 DOWNTO 0);
		PORT_B		: IN signed(io_width-1 DOWNTO 0);
		COEFF_IN	: IN signed(io_width-1 DOWNTO 0);
		CTRL_WORD	: IN std_logic_vector(command_len-1 DOWNTO 0);
		OUT_A		: OUT signed(io_width-1 DOWNTO 0);
		OUT_B		: OUT signed(io_width-1 DOWNTO 0));
END ENTITY;


ARCHITECTURE struct OF dp_butterfly IS

COMPONENT register_file IS
	GENERIC(addr_width	: positive	:= 4;
		data_width	: positive	:= 8;
		wr_ports	: positive	:= 1;
		rd_ports	: positive	:= 1);
	PORT(	CLK		: IN std_logic;
		WR		: IN std_logic_vector(wr_ports-1 DOWNTO 0);
		WR_ADDR	: IN unsigned(wr_ports*addr_width-1 DOWNTO 0);
		WR_DATA	: IN signed(wr_ports*data_width-1 DOWNTO 0);
		RD_ADDR	: IN unsigned(rd_ports*addr_width-1 DOWNTO 0);
		RD_DATA	: OUT signed(rd_ports*data_width-1 DOWNTO 0));
END COMPONENT;

COMPONENT multiplier IS
	PORT(	CLK	: IN std_logic;
		A	: IN signed(m_in_width-1 DOWNTO 0);
		B	: IN signed(m_in_width-1 DOWNTO 0);
		D_M_n	: IN std_logic;
		PROD	: OUT signed(prod_width-1 DOWNTO 0));
END COMPONENT;

COMPONENT adder IS
	PORT(	CLK	: IN std_logic;
		A	: IN signed(add_width-1 DOWNTO 0);
	    	B	: IN signed(add_width-1 DOWNTO 0);
		S_A_n	: IN std_logic;
		SUM	: OUT signed(add_width-1 DOWNTO 0));
END COMPONENT;

COMPONENT rounder IS
	PORT(	ROUND_IN	: IN signed(round_i_width-1 DOWNTO 0);
		ROUND_OUT	: OUT signed(round_o_width-1 DOWNTO 0));
END COMPONENT;

COMPONENT reg IS
	GENERIC(bitwidth: positive	:= 8);
	PORT(	CLK	: IN std_logic;
	    	RST_n	: IN std_logic;
		LD	: IN std_logic;
		D_IN	: IN signed(bitwidth-1 DOWNTO 0);
		D_OUT	: OUT signed(bitwidth-1 DOWNTO 0));
END COMPONENT;

COMPONENT mux2to1 IS
	GENERIC(bitwidth: positive	:= 8);
	PORT(	A	: IN signed(bitwidth-1 DOWNTO 0);
		B	: IN signed(bitwidth-1 DOWNTO 0);
		SEL	: IN std_logic;
		Y	: OUT signed(bitwidth-1 DOWNTO 0));
END COMPONENT;

--#############################################################################
--# Buses
SIGNAL databus1	: signed(io_width-1 DOWNTO 0); 
SIGNAL databus2	: signed(io_width-1 DOWNTO 0);
SIGNAL coeffbus	: signed(io_width-1 DOWNTO 0);
--#############################################################################
--# Local connections
SIGNAL mult_line: signed(prod_width-1 DOWNTO 0); 
SIGNAL add1_line: signed(add_width-1 DOWNTO 0);
SIGNAL add2_line: signed(add_width-1 DOWNTO 0);
--#############################################################################
--# Temporary signals for port connection
SIGNAL rfd_addr_wr : unsigned(rfd_wr_ports*rfd_addr_width-1 DOWNTO 0);
SIGNAL rfd_addr_rd : unsigned(rfd_rd_ports*rfd_addr_width-1 DOWNTO 0);
SIGNAL rfd_wr_bits : std_logic_vector(rfd_wr_ports-1 DOWNTO 0);
SIGNAL aggr_in     : signed(rfd_wr_ports*io_width-1 DOWNTO 0);
SIGNAL bus_concat  : signed(rfd_rd_ports*io_width-1 DOWNTO 0);
SIGNAL mult_out	   : signed(prod_width-1 DOWNTO 0);
SIGNAL bus2_allign : signed(add_width-1 DOWNTO 0);
SIGNAL chosen_src  : signed(add_width-1 DOWNTO 0);
SIGNAL add1_portA  : signed(add_width-1 DOWNTO 0);
SIGNAL add1_portB  : signed(add_width-1 DOWNTO 0);
SIGNAL add1_out    : signed(add_width-1 DOWNTO 0);
SIGNAL add2_portB  : signed(add_width-1 DOWNTO 0);
SIGNAL add2_out    : signed(add_width-1 DOWNTO 0);
SIGNAL rndr_in     : signed(add_width-1 DOWNTO 0);
SIGNAL rndr_out    : signed(io_width-1 DOWNTO 0);
SIGNAL reord_out   : signed(io_width-1 DOWNTO 0);

BEGIN
--#############################################################################
--#	Register File for the input Data
	data_reg_file	: register_file GENERIC MAP(rfd_addr_width,
					rfd_data_width,
					rfd_wr_ports,
					rfd_rd_ports) 
					PORT MAP(CLK,
					rfd_wr_bits,
					rfd_addr_wr,
					aggr_in,
					rfd_addr_rd,
					bus_concat);
	aggr_in(2*io_width-1 DOWNTO io_width) <= PORT_B;
	aggr_in(io_width-1 DOWNTO 0) <= PORT_A;
	databus1 <= bus_concat(io_width-1 DOWNTO 0);
	databus2 <= bus_concat(2*io_width-1 DOWNTO io_width);
	rfd_wr_bits <= CTRL_WORD(RFD_WR2) & CTRL_WORD(RFD_WR1);
	rfd_addr_wr <= CTRL_WORD(RFD_WR2_ADDR1) & CTRL_WORD(RFD_WR2_ADDR0) & CTRL_WORD(RFD_WR1_ADDR1) & CTRL_WORD(RFD_WR1_ADDR0);
	rfd_addr_rd <= CTRL_WORD(RFD_RD2_ADDR1) & CTRL_WORD(RFD_RD2_ADDR0) & CTRL_WORD(RFD_RD1_ADDR1) & CTRL_WORD(RFD_RD1_ADDR0);
--#############################################################################
--#	Register File for the coefficients
	coef_reg_file	: register_file GENERIC MAP(rfc_addr_width,
					rfc_data_width,
					rfc_wr_ports,
					rfc_rd_ports) 
					PORT MAP(CLK,
					CTRL_WORD(RFC_WR DOWNTO RFC_WR),
					unsigned(CTRL_WORD(RFC_WR_ADDR DOWNTO RFC_WR_ADDR)),
					COEFF_IN,
					unsigned(CTRL_WORD(RFC_RD_ADDR DOWNTO RFC_RD_ADDR)),
					coeffbus);
--#############################################################################
--#	Multiplier
	multiplier_op	: multiplier 	PORT MAP(CLK,
					databus1,
					coeffbus,
					CTRL_WORD(MULT_DOUBLE),
					mult_out);
--#############################################################################
--#	Multiplier Result Buffer
	reg_mult	: reg 		GENERIC MAP(prod_width) 
					PORT MAP(CLK,
					RST_n,
					CTRL_WORD(R_MULT_LD),
					mult_out,
					mult_line);
--#############################################################################
--#	Adder1 input multiplexers
	mux1_bus2_sum1	: mux2to1 	GENERIC MAP(add_width) 
					PORT MAP(add1_line,
					bus2_allign,
					CTRL_WORD(MUX1_SEL),
					chosen_src);
	mux2_prod_mux1	: mux2to1 	GENERIC MAP(add_width) 
					PORT MAP(chosen_src,
					mult_line,
					CTRL_WORD(MUX2_SEL),
					add1_portA);
	mux3_sum1_prod	: mux2to1 	GENERIC MAP(add_width) 
					PORT MAP(mult_line,
					add1_line,
					CTRL_WORD(MUX3_SEL),
					add1_portB);
	-- duplicate sign and extend to 40 bits adding 19 trailing zeros
	bus2_allign <= signed(databus2(io_width-1) & std_logic_vector(databus2) & std_logic_vector(to_unsigned(0, io_width-1)));
--#############################################################################
--#	Adder1
	adder1		: adder 	PORT MAP(CLK,
					add1_portA,
					add1_portB,
					CTRL_WORD(ADD1_SUB_ADD),
					add1_out);
--#############################################################################
--#	Adder1 Result Buffer
	reg_add1	: reg 		GENERIC MAP(add_width) 
					PORT MAP(CLK,
					RST_n,
					CTRL_WORD(R_ADD1_LD),
					add1_out,
					add1_line);
--#############################################################################
--#	Adder2 input multiplexer
	mux4_bus2_sum2	: mux2to1 	GENERIC MAP(add_width) 
					PORT MAP(add2_line,
					bus2_allign,
					CTRL_WORD(MUX4_SEL),
					add2_portB);
--#############################################################################
--#	Adder2
	adder2		: adder 	PORT MAP(CLK,
					mult_line,
					add2_portB,
					CTRL_WORD(ADD2_SUB_ADD),
					add2_out);
--#############################################################################
--#	Adder2 Result Buffer
	reg_add2	: reg 		GENERIC MAP(add_width) 
					PORT MAP(CLK,
					RST_n,
					CTRL_WORD(R_ADD2_LD),
					add2_out,
					add2_line);
--#############################################################################
--#	Rounder input multiplexer
	mux5_round	: mux2to1 	GENERIC MAP(add_width) 
					PORT MAP(add1_line,
					add2_line,
					CTRL_WORD(MUX5_SEL),
					rndr_in);
--#############################################################################
--#	Rounder
	round_unit	: rounder 	PORT MAP(rndr_in,
					rndr_out);
--#############################################################################
--#	Reordering
	reorder_reg	: reg		GENERIC MAP(io_width)
					PORT MAP(CLK,
					RST_n,
					CTRL_WORD(REORD_LD),
					rndr_out,
					reord_out);
--#############################################################################
--#	Output Buffers
	output_A_buffer	: reg 		GENERIC MAP(io_width) 
					PORT MAP(CLK,
					RST_n,
					CTRL_WORD(OUT_A_BUF_LD),
					reord_out,
					OUT_A);

	output_B_buffer	: reg 		GENERIC MAP(io_width) 
					PORT MAP(CLK,
					RST_n,
					CTRL_WORD(OUT_B_BUF_LD),
					rndr_out,
					OUT_B);
END ARCHITECTURE;
