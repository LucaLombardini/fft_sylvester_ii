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

ENTITY dataMkrButt IS
	PORT(	CLK	: IN std_logic;
	    	RST_n	: IN std_logic;
	    	STARTR	: IN std_logic;
		DATA_A	: OUT signed(io_width-1 DOWNTO 0);
		DATA_B	: OUT signed(io_width-1 DOWNTO 0);
		COEF	: OUT signed(io_width-1 DOWNTO 0);
		END_SIM	: OUT std_logic);
END ENTITY;


ARCHITECTURE behav OF dataMkrButt IS
	TYPE DATA_ARRAY IS ARRAY(0 TO 1) OF signed(io_width-1 DOWNTO 0);
	TYPE COEF_ARRAY IS ARRAY(0 TO 1) OF signed(io_width-1 DOWNTO 0);
	SIGNAL data_a_buf : DATA_ARRAY;
	SIGNAL data_b_buf : DATA_ARRAY;
	SIGNAL coef_buf : COEF_ARRAY;
	SIGNAL isEndFile : std_logic;
BEGIN
	DATA_A <= data_a_buf(0);
	DATA_B <= data_b_buf(0);
	COEF <= coef_buf(0);

	read_process: PROCESS(RST_n, CLK) -- read 6 values in block when descending clk
		FILE fp : text OPEN read_mode IS "butterfly_in.hex";
		VARIABLE file_line	: line;
		VARIABLE value 	: std_logic_vector(io_width-1 DOWNTO 0);
		VARIABLE many_data	: integer := 6;
		VARIABLE cntr		: integer;
		VARIABLE cycle		: integer;
		VARIABLE many_cycles	: integer := 2;
	BEGIN
		IF RST_n = '0' THEN
			isEndFile <= '0'; --CAUSE INITIAL UNASSIGNED VALUE
		ELSIF CLK'EVENT AND CLK = '0' THEN --READ 6 VALUES FROM FILE
			IF STARTR = '1' THEN -- READ NEW DATA ONLY WHEN NEEDED: LIKE A CLEAR FOR THE PIPES
				cntr := 0;
				cycle := 0;
				WHILE cntr < many_data AND NOT(endfile(fp)) LOOP
					readline(fp, file_line);
					hread(file_line, value);
					CASE cntr IS
						WHEN 0 =>	data_a_buf(0) <= signed(value); --AR
						WHEN 1 =>	data_a_buf(1) <= signed(value); --AI
						WHEN 2 =>	data_b_buf(0) <= signed(value); --BR
						WHEN 3 =>	data_b_buf(1) <= signed(value); --BI
						WHEN 4 =>	coef_buf(0) <= signed(value); --WR
						WHEN OTHERS =>	coef_buf(1) <= signed(value); --WI
					END CASE;
					cntr := cntr + 1;
				END LOOP;
				IF NOT(endfile(fp)) THEN
					isEndFile <= '0';
				ELSE
					isEndFile <= '1';
				END IF;
			ELSE -- PIPE ADVANCE
				data_a_buf(0) <= data_a_buf(1);
				data_b_buf(0) <= data_b_buf(1);
				coef_buf(0) <= coef_buf(1);
			END IF;
		END IF;
	END PROCESS;

	simulation_ender: PROCESS(RST_n, CLK)
		VARIABLE cnt	: integer ;
	BEGIN
		IF RST_n = '0' THEN
			cnt := 0;
			END_SIM <= '0';
		ELSIF CLK'EVENT AND CLK = '1' THEN
			IF isEndFile = '1' THEN
				IF cnt = dut_cycle_lat THEN
					END_SIM <= '1';
				ELSE
					cnt := cnt + 1;
					END_SIM <= '0';
				END IF;
			ELSE
				END_SIM <= '0';
			END IF;
		END IF;
	END PROCESS;

END ARCHITECTURE;
