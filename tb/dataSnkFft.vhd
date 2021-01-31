LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_textio.all;
USE work.definespack.all;
USE work.cupack.all;

LIBRARY STD;
USE STD.textio.all;

ENTITY dataSnkFft IS
	PORT(	CLK	: IN std_logic;
	    	RST_n	: IN std_logic;
	    	DATA_RDY: IN std_logic;
		DATA	: IN signed(io_width*n_samples-1 DOWNTO 0));
END ENTITY;


ARCHITECTURE behav OF dataSnkFft IS
BEGIN
	wrt_process: PROCESS(RST_n, CLK)
		FILE fp : text OPEN write_mode IS "fft_out_vectors.hex";
		VARIABLE line_out	: line;
		VARIABLE cycle	: integer := 0;
		VARIABLE value : std_logic_vector(io_width*n_samples-1 DOWNTO 0);
		VARIABLE data_amount	: integer := 2;
	BEGIN
		IF RST_n = '0' THEN
			cycle := 0;
		ELSIF CLK'EVENT AND CLK = '0' THEN
			IF DATA_RDY = '1' THEN
				value := std_logic_vector(DATA); 
				hwrite(line_out, value); -- write r
				writeline(fp, line_out);
				cycle := 1;
			ELSIF cycle > 0 AND cycle < data_amount THEN
				value := std_logic_vector(DATA);
				hwrite(line_out, value); --write i
				writeline(fp, line_out);
				cycle := cycle + 1;
			END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE;
