LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;

ENTITY startTimer IS
	PORT(	CLK		: IN std_logic;
		RST_n		: IN std_logic;
		CONT_SING_n	: IN std_logic;
		STROBE		: OUT std_logic);
END ENTITY;


ARCHITECTURE behav OF startTimer IS
	SIGNAL clk_inf	: std_logic;
	SIGNAL clr	: std_logic;
BEGIN
	
	strobe_gen: PROCESS(RST_n, CLK)
		VARIABLE cntr : integer;
		CONSTANT tc_single : integer := 14;
		CONSTANT tc_contin : integer := 6; -- 7 states periodicity
	BEGIN
		IF RST_n = '0' THEN
			cntr := 0;
		ELSIF CLK'EVENT AND CLK = '0' THEN -- late status use
			IF CONT_SING_n = '0' THEN
				IF cntr = tc_single THEN
					cntr := 0;
					STROBE <= '1';
				ELSE
					cntr := cntr + 1;
					STROBE <= '0';
				END IF;
			ELSE
				IF cntr = tc_contin THEN
					cntr := 0;
					STROBE <= '1';
				ELSE
					cntr := cntr + 1;
					STROBE <= '0';
				END IF;
			END IF;
		END IF;
	END PROCESS;

END ARCHITECTURE;
