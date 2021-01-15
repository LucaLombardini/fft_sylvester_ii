LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_textio.all;
USE work.definespack.all;

LIBRARY STD;
USE STD.textio.all;

ENTITY dataSink IS
	GENERIC(output_filename : string := "default_output.hex");
	PORT(	CLK	: IN std_logic;
		RST_n	: IN std_logic;
		DATA_RDY: IN std_logic;
		DATA	: IN signed(sink_width-1 DOWNTO 0));
END ENTITY;



ARCHITECTURE behav OF dataSink IS
BEGIN
	write_process: PROCESS(CLK, RST_n)
		FILE fp : text OPEN write_mode IS output_filename;
		VARIABLE line_out	: line;
		VARIABLE data_count	: integer := 0;
		VARIABLE value		: std_logic_vector(sink_width-1 DOWNTO 0);
	BEGIN
		IF CLK'EVENT AND CLK = '1' THEN
			IF DATA_RDY = '1' OR data_count < (serial_data+1) THEN
				data_count := data_count + 1;
				value := std_logic_vector(DATA);
				hwrite(line_out, value);
				writeline(fp, line_out);
			ELSE
				data_count := 0;
			END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE;
