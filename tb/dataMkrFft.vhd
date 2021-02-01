LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_textio.all;
USE work.definespack.all;
USE work.cupack.all;

LIBRARY STD;
USE STD.textio.all;

ENTITY dataMkrFft IS
	PORT(	CLK	: IN std_logic;
		RST_n	: IN std_logic;
		STARTR	: IN std_logic;
		DATA_IN	: OUT signed(io_width*n_samples-1 DOWNTO 0);
		COEF	: OUT signed(io_width*n_coef-1 DOWNTO 0);
		END_SIM	: OUT std_logic);
END ENTITY;


ARCHITECTURE behav OF dataMkrFft IS

	TYPE DATA_ARRAY IS ARRAY(0 TO 1) OF signed(io_width*n_samples-1 DOWNTO 0);
	TYPE COEF_ARRAY IS ARRAY(0 TO 1) OF signed(io_width*n_coef-1 DOWNTO 0);
	SIGNAL data_buf : DATA_ARRAY;
	SIGNAL coef_buf : COEF_ARRAY;
	SIGNAL isEndFile : std_logic;

BEGIN

	DATA_IN <= data_buf(0);
	COEF	<= coef_buf(0);

	read_data: PROCESS(RST_n, CLK)
		FILE fp : text OPEN read_mode IS "fft_in_vectors.hex";
		VARIABLE file_line : line;
		VARIABLE value : std_logic_vector(io_width*n_samples-1 DOWNTO 0);
		VARIABLE cntr : integer;
		VARIABLE many_data : integer := 2;
	BEGIN
		IF RST_n = '0' THEN
			isEndFile <= '0';
		ELSIF CLK'EVENT AND CLK = '0' THEN
			IF STARTR = '1' THEN
				cntr := 0;
				WHILE cntr < many_data AND NOT(endfile(fp)) LOOP
					readline(fp, file_line);
					hread(file_line, value);
					CASE cntr IS
						WHEN 0 => data_buf(0) <= signed(value);
						WHEN OTHERS => data_buf(1) <= signed(value);
					END CASE;
					cntr := cntr + 1;
				END LOOP;
				IF NOT(endfile(fp)) THEN
					isEndFile <= '0';
				ELSE
					isEndFile <= '1';
				END IF;
			ELSE
				data_buf(0) <= data_buf(1);
			END IF;
		END IF;
	END PROCESS;

	read_coeff: PROCESS(RST_n, CLK)
		FILE fp2 : text OPEN read_mode IS "fft_in_coef.hex";
		VARIABLE file_line2 : line;
		VARIABLE value2 : std_logic_vector(io_width*n_coef-1 DOWNTO 0);
		VARIABLE cntr2 : integer;
		VARIABLE many_data2 : integer := 2;
		VARIABLE real_buf, imag_buf : std_logic_vector(io_width*n_coef-1 DOWNTO 0);
	BEGIN
		IF RST_n = '0' THEN
			NULL;
		ELSIF CLK'EVENT AND CLK = '0' THEN
			IF STARTR = '1' THEN
				cntr2 := 0;
				WHILE cntr2 < many_data2 AND NOT(endfile(fp2)) LOOP
					
					readline(fp2, file_line2);
					hread(file_line2, value2);
					CASE cntr2 IS
						WHEN 0 => coef_buf(0) <= signed(value2);
							real_buf := value2;
						WHEN OTHERS => coef_buf(1) <= signed(value2);
							imag_buf := value2;
					END CASE;
					cntr2 := cntr2 + 1;
				END LOOP;
				IF endfile(fp2) THEN
					coef_buf(0) <= signed(real_buf);
					coef_buf(1) <= signed(imag_buf);
				END IF;
			ELSE
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
