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
			PORT_A	: IN signed(io_width-1 DOWNTO 0);
			PORT_B	: IN signed(io_width-1 DOWNTO 0);
			COEFF_IN: IN signed(io_width-1 DOWNTO 0);
			DONE	: OUT std_logic;
			OUT_A	: OUT signed(io_width-1 DOWNTO 0);
			OUT_B	: OUT signed(io_width-1 DOWNTO 0));
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
			DATA_A	: OUT signed(io_width-1 DOWNTO 0);
			DATA_B	: OUT signed(io_width-1 DOWNTO 0);
			COEF	: OUT signed(io_width-1 DOWNTO 0);
			END_SIM	: OUT std_logic);
	END COMPONENT;
	
	COMPONENT dataSnkButt IS
		PORT(	CLK	: IN std_logic;
		    	RST_n	: IN std_logic;
		    	DATA_RDY: IN std_logic;
			DATA_A	: IN signed(io_width-1 DOWNTO 0);
			DATA_B	: IN signed(io_width-1 DOWNTO 0));
	END COMPONENT;

	SIGNAL clk_dist, rst_n_dist, start_dist, end_sim_dist, mode_dist, done_dist	: std_logic;
	SIGNAL d_in_a, d_in_b, c_in, d_out_a, d_out_b : signed(io_width-1 DOWNTO 0);

BEGIN
	--mode_dist <= '1';

	mode_changer: PROCESS
		VARIABLE exec_cntr : integer := 0;
	BEGIN
		IF mode_dist = 'U' THEN
			mode_dist <= '0';
			WAIT FOR 3*clk_period + rst_release;
		ELSE
			WAIT FOR clk_period;
			exec_cntr := exec_cntr + 1;
			IF exec_cntr < 4 THEN -- alternate 3 single with 3 continuos
				mode_dist <= '0';
				WAIT FOR 12 * clk_period;
			ELSIF exec_cntr > 3 AND exec_cntr < 7 THEN 
				mode_dist <= '1';
				WAIT FOR 5 * clk_period;
			ELSE
				exec_cntr := 0;
			END IF;
		END IF;
	END PROCESS;

	clk_gen	: clkGen PORT MAP(end_sim_dist, clk_dist, rst_n_dist);
	
	timed_start	: startTimer PORT MAP(mode_dist, start_dist);
	
	data_in_mkr	: dataMkrButt PORT MAP(clk_dist, rst_n_dist, start_dist, d_in_a, d_in_b, c_in, end_sim_dist);

	dut_butterfly	: butterfly PORT MAP(clk_dist, rst_n_dist, start_dist, d_in_a, d_in_b, c_in, done_dist, d_out_a, d_out_b);
	
	data_out_sink	: dataSnkButt PORT MAP(clk_dist, rst_n_dist, done_dist, d_out_a, d_out_b);

END ARCHITECTURE;
