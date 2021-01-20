LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_textio.all;
USE work.definespack.all;
USE work.cupack.all;

LIBRARY STD;
USE STD.textio.all;

ENTITY tb_cu IS
END ENTITY;

ARCHITECTURE tb OF tb_cu IS

	COMPONENT cu_butterfly IS
		PORT(	CLK	: IN std_logic;
			RST_n	: IN std_logic;
			STATUS	: IN std_logic;
			CTRL_WRD: OUT std_logic_vector(command_len-1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT clkGen IS
		PORT(	END_SIM	: IN std_logic;
			CLK		: OUT std_logic;
			RST_n		: OUT std_logic);
	END COMPONENT;
	
	SIGNAL clk_dist, rst_n_dist	: std_logic;
	SIGNAL cw_to_print		: std_logic_vector(command_len-1 DOWNTO 0);
	SIGNAL start			: std_logic;

BEGIN
	
	start_manip: PROCESS
		VARIABLE exec_cntr : integer := 0;
	BEGIN
		IF start = 'U' THEN
			start <= '0';
			WAIT FOR 3*clk_period + rst_release;
		ELSE
			start <= '1';
			WAIT FOR clk_period;
			start <= '0';
			exec_cntr := exec_cntr + 1;
			IF exec_cntr < 4 THEN	-- ALTERNATE 3 SINGLE WITH 3 CONTINUOUS
				WAIT FOR 15 * clk_period;
			ELSIF exec_cntr > 3 AND exec_cntr < 7 THEN
				WAIT FOR 7 * clk_period;
			ELSE
				exec_cntr := 0;
			END IF;
		END IF;
	END PROCESS;

	cu_dut: cu_butterfly PORT MAP(clk_dist, rst_n_dist, start, cw_to_print);

	clk_gen: clkGen PORT MAP('0', clk_dist, rst_n_dist);

	write_process: PROCESS(clk_dist, rst_n_dist)
		FILE fp : text OPEN write_mode IS "ctrl_wrd_out.bin";
		VARIABLE line_out	: line;
		VARIABLE data_count	: integer := 0;
	BEGIN
		IF rst_n_dist = '0' THEN
			NULL;
		ELSIF clk_dist'EVENT AND clk_dist = '1' THEN
			--value := std_logic_vector(cw_to_print);
			write(line_out, cw_to_print);
			writeline(fp, line_out);
		END IF;
	END PROCESS;

END ARCHITECTURE;
