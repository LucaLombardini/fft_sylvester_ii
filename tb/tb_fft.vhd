LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_textio.all;
USE work.definespack.all;
USE work.cupack.all;

LIBRARY STD;
USE STD.textio.all;

ENTITY tb_fft IS
END ENTITY;

ARCHITECTURE tb OF tb_fft IS

	COMPONENT fft_unit IS
		PORT(	CLK	: IN std_logic;
			RST_n	: IN std_logic;
			START	: IN std_logic;
			DATA_IN	: IN signed(io_width*n_samples-1 DOWNTO 0);
			COEF_IN	: IN signed(io_width*n_coef-1 DOWNTO 0);
			DATA_OUT: OUT signed(io_width*n_samples-1 DOWNTO 0);
			DONE	: OUT std_logic);
	END COMPONENT;

	COMPONENT clkGen IS
		PORT(	END_SIM	: IN std_logic;
			CLK	: OUT std_logic;
			RST_n	: OUT std_logic);
	END COMPONENT;

	COMPONENT startTimer IS
		PORT(CONT_SING_n: IN std_logic;
		    	STROBE	: OUT std_logic);
	END COMPONENT;

	COMPONENT dataMkrFft IS
		PORT(	CLK	: IN std_logic;
			RST_n	: IN std_logic;
			STARTR	: IN std_logic;
			DATA_IN	: OUT signed(io_width*n_samples-1 DOWNTO 0);
			COEF	: OUT signed(io_width*n_coef-1 DOWNTO 0);
			END_SIM	: OUT std_logic);
	END COMPONENT;

	COMPONENT dataSnkFft IS
		PORT(	CLK	: IN std_logic;
			RST_n	: IN std_logic;
			DATA_RDY: IN std_logic;
			DATA	: IN signed(io_width*n_samples-1 DOWNTO 0));
	END COMPONENT;

	SIGNAL clk_dist, rst_n_dist, start_dist, end_sim_dist, mode_dist, done_dist : std_logic;
	SIGNAL d_in, d_out : signed(io_width*n_samples-1 DOWNTO 0);
	SIGNAL coef_in : signed(io_width*n_coef-1 DOWNTO 0);

BEGIN

	simulation_ender: PROCESS
        BEGIN
                WAIT UNTIL end_sim_dist = '1';
		WAIT FOR 4*dut_cycle_lat*clk_period;
                ASSERT FALSE
                        REPORT "SIMULATION SUCCESSFULLY ENDED!"
                        SEVERITY FAILURE;
        END PROCESS;

	mode_changer: PROCESS
		VARIABLE exec_cntr : integer := 0;
	BEGIN
		IF mode_dist = 'U' THEN
			mode_dist <= '0';
			WAIT FOR 3*clk_period + rst_release;
		ELSE
			WAIT FOR clk_period;
			exec_cntr := exec_cntr + 1;
			IF exec_cntr < 4 THEN
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

	clk_gen : clkGen PORT MAP('0', clk_dist, rst_n_dist);

	timed_start : startTimer PORT MAP(mode_dist, start_dist);

	data_in_mkr : dataMkrFft PORT MAP(clk_dist, rst_n_dist, start_dist, d_in, coef_in, end_sim_dist);

	dut_fft: fft_unit PORT MAP(clk_dist, rst_n_dist, start_dist, d_in, coef_in, d_out, done_dist);

	data_out_sink : dataSnkFft PORT MAP(clk_dist, rst_n_dist, done_dist, d_out);

END ARCHITECTURE;
