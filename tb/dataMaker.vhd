LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_textio.all;
USE work.definespack.all;

LIBRARY STD;
USE STD.textio.all;

ENTITY dataMaker IS
	PORT(	CLK	: IN std_logic;
		RST_n	: IN std_logic;
		DATA	: OUT signed(maker_width-1 DOWNTO 0);
		END_SIM : OUT std_logic);
END ENTITY;



ARCHITECTURE behav OF dataMaker IS
	SIGNAL isEndFile	: std_logic;
BEGIN
	file_reader: PROCESS(CLK)
		FILE fp : text OPEN read_mode IS input_file;
		VARIABLE file_line	: line;
		VARIABLE value 	: std_logic_vector(maker_width-1 DOWNTO 0);
	BEGIN
		IF RST_n = '0' THEN
			DATA <= to_signed(0,maker_width);
			isEndFile <= '0';
		ELSIF CLK'EVENT AND CLK = '1' THEN
			IF NOT(endfile(fp)) THEN
				readline(fp, file_line);
				hread(file_line, value);
				DATA <= signed(value);
				isEndFile <= '0';
			ELSE
				isEndFile <= '1';
			END IF;
		END IF;
	END PROCESS;
	
	simulation_ender: PROCESS
	BEGIN
		IF isEndFile = '1' THEN
			WAIT FOR (dut_cycle_lat+1)*clk_period;
			END_SIM <= '1';
		ELSE
			END_SIM <= '0';
		END IF;
	END PROCESS;
END ARCHITECTURE;
