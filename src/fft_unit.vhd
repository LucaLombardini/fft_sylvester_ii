LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;i
USE work.definespack.all;
USE work.cupack.all;

ENTITY fft_unit IS
	PORT(	CLK	: IN std_logic;
		RST_n	: IN std_logic;
		START	: IN std_logic;
		DATA_IN	: IN signed(io_width*data_ports*butt_per_level-1 DOWNTO 0);
		COEF_IN	: IN signed(io_width*coef_ports*new_coeffs-1 DOWNTO 0);
		DATA_OUT: OUT signed(io_width*out_ports*butt_per_level-1 DOWNTO 0);
		DONE	: OUT std_logic);
END ENTITY;

ARCHITECTURE struct OF fft_unit IS

	COMPONENT mux2to1 IS
		GENERIC(bitwidth: positive := 8);
		PORT(	A	: IN signed(bitwidth-1 DOWNTO 0);
			B	: IN signed(bitwidth-1 DOWNTO 0);
			SEL	: IN std_logic;
			Y	: OUT signed(bitwidth-1 DOWNTO 0));
	END COMPONENT;

	COMPONENT butterfly IS
		PORT(	CLK	: IN std_logic;
			RST_n	: IN std_logic;
			START	: IN std_logic;
			DATA_IN	: IN signed(io_width-1 DOWNTO 0);
			COEFF_IN: IN signed(io_width-1 DOWNTO 0);
			DONE	: OUT std_logic;
			DATA_OUT: OUT signed(io_width-1 DOWNTO 0));
	END COMPONENT;
--#############################################################################
--#	Signal Zone
	TYPE coef_array IS ARRAY (0 TO 7) OF signed(io_width-1 DOWNTO 0);
	SIGNAL w_coeffs : coef_array;
BEGIN
--#############################################################################
--#	First Layer
	lev0_gr0_but0 : butterfly PORT MAP(CLK,	RST_n, START,
						DATA_IN(););

END ARCHITECTURE
