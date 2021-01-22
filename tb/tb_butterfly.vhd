LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_textio.all;
USE work.definespack.all;
USE work.cupack.all;

LIBRARY STD;
USE STD.textio.all;

ENTITY tb_butterfly IS
END ENTITY;

ARCHITECTURE tb OF tb_butterfly IS

	COMPONENT butterfly IS
		PORT(	CLK	: IN std_logic;
			RST_n	: IN std_logic;
			START	: IN std_logic;
			DATA_IN	: IN signed(io_width-1 DOWNTO 0);
			COEFF_IN: IN signed(io_width-1 DOWNTO 0);
			DONE	: OUT std_logic;
			DATA_OUT: OUT signed(io_width-1 DOWNTO 0));
	END COMPONENT;

	COMPONENT clkGen IS
		PORT(	END_SIM	: IN std_logic;
			CLK		: OUT std_logic;
			RST_n		: OUT std_logic);
	END COMPONENT;

	COMPONENT startTimer IS
		PORT(	CONT_SING_n	: IN std_logic;
			STROBE		: OUT std_logic);
	END COMPONENT;
	
	COMPONENT dataMkrButt IS
		PORT(	CLK	: IN std_logic;
		    	RST_n	: IN std_logic;
		    	STARTR	: IN std_logic;
			DATA	: OUT signed(io_width-1 DOWNTO 0);
			COEF	: OUT signed(io_width-1 DOWNTO 0);
			END_SIM	: OUT std_logic);
	END COMPONENT;
	
	COMPONENT dataSnkButt IS
		PORT(	CLK	: IN std_logic;
		    	RST_n	: IN std_logic;
		    	DATA_RDY: IN std_logic;
			DATA	: IN signed(io_width-1 DOWNTO 0));
	END COMPONENT;

	SIGNAL clk_dist, rst_n_dist, start_dist, end_sim_dist, mode_dist, done_dist	: std_logic;
	SIGNAL d_in, c_in, d_out : signed(io_width-1 DOWNTO 0);

BEGIN
	mode_dist <= '0';

	clk_gen	: clkGen PORT MAP(end_sim_dist, clk_dist, rst_n_dist);
	
	timed_start	: startTimer PORT MAP(mode_dist, start_dist);
	
	data_in_mkr	: dataMkrButt PORT MAP(clk_dist, rst_n_dist, start_dist, d_in, c_in, end_sim_dist);

	dut_butterfly	: butterfly PORT MAP(clk_dist, rst_n_dist, start_dist, d_in, c_in, done_dist, d_out);
	
	data_out_sink	: dataSnkButt PORT MAP(clk_dist, rst_n_dist, done_dist, d_out);

END ARCHITECTURE;
