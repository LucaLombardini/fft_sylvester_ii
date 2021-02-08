-- Author:       Luca Lombardini
-- Academic_y:   2020/2021
-- Purpose:      (Master Degree) Digital Integrated Systems' Final Project
-- Contacts:     s277972@studenti.polito.it
--               lombamari2@gmail.com
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_textio.all;
USE work.definespack.all;
USE work.cupack.all;

LIBRARY STD;
USE STD.textio.all;

ENTITY dataSnkButt IS
	PORT(	CLK	: IN std_logic;
	    	RST_n	: IN std_logic;
	    	DATA_RDY: IN std_logic;
		DATA_A	: IN signed(io_width-1 DOWNTO 0);
		DATA_B	: IN signed(io_width-1 DOWNTO 0));
END ENTITY;


ARCHITECTURE behav OF dataSnkButt IS
BEGIN
	wrt_process: PROCESS(RST_n, CLK)
		FILE fp : text OPEN write_mode IS "butterfly_out.hex";
		VARIABLE line_out	: line;
		VARIABLE cycle	: integer := 0;
		VARIABLE value_a, value_b : std_logic_vector(io_width-1 DOWNTO 0);
		VARIABLE data_amount	: integer := 2;
	BEGIN
		IF RST_n = '0' THEN
			cycle := 0;
		ELSIF CLK'EVENT AND CLK = '0' THEN
			IF DATA_RDY = '1' THEN
				value_a := std_logic_vector(DATA_A); -- read ar
				value_b := std_logic_vector(DATA_B); -- read br
				hwrite(line_out, value_a); -- write ar
				writeline(fp, line_out);
				cycle := 1;
			ELSIF cycle > 0 AND cycle < data_amount THEN
				value_a := std_logic_vector(DATA_A); -- read ai
				hwrite(line_out, value_a); --write ai
				writeline(fp, line_out);
				hwrite(line_out, value_b); --write br
				writeline(fp, line_out);
				value_b := std_logic_vector(DATA_B); -- read bi
				hwrite(line_out, value_b); -- write  bi
				writeline(fp, line_out);
				cycle := cycle + 1;
			END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE;
