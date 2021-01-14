LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;

ENTITY dp_butterfly IS
	PORT(	CLK		: IN std_logic;
		RST_n		: IN std_logic;
		DATA_IN	: IN signed(io_width-1 DOWNTO 0);
		COEFF_IN	: IN signed(io_width-1 DOWNTO 0);
		CTRL_WORD	: IN std_logic_vector(cw_width-1 DOWNTO 0);
		DATA_OUT	: OUT signed(io_width-1 DOWNTO 0));
END ENTITY;


ARCHITECTURE struct OF dp_butterfly IS

COMPONENT register_file IS
	GENERIC(addr_width	: positive	:= 4;
		data_width	: positive	:= 8;
		wr_ports	: positive	:= 1;
		rd_ports	: positive	:= 1);
	PORT(	CLK		: IN std_logic;
		WR		: IN std_logic;
		WR_ADDR	: IN unsigned(wr_ports*addr_width-1 DOWNTO 0);
		WR_DATA	: IN signed(wr_ports*data_width-1 DOWNTO 0);
		RD_ADDR	: IN unsigned(rd_ports*addr_width-1 DOWNTO 0);
		RD_DATA	: OUT signed(rd_ports*data_width));
END COMPONENT;

COMPONENT multiplier IS
	PORT(	CLK	: IN std_logic;
		A	: IN signed(m_in_width-1 DOWNTO 0);
		B	: IN signed(m_in_width-1 DOWNTO 0);
		M_D_n	: IN std_logic;
		PROD	: OUT signed(prod_width-1 DOWNTO 0));
END COMPONENT;

COMPONENT adder IS
	PORT(	CLK	: IN std_logic;
		A	: IN signed(add_width-1 DOWNTO 0);
	    	B	: IN signed(add_width-1 DOWNTO 0);
		A_S_n	: IN std_logic;
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

BEGIN
END ARCHITECTURE;
