-- Author:       Luca Lombardini
-- Academic_y:   2020/2021
-- Purpose:      (Master Degree) Digital Integrated Systems' Final Project
-- Contacts:     s277972@studenti.polito.it
--               lombamari2@gmail.com
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;

ENTITY startTimer IS
	PORT(	CONT_SING_n	: IN std_logic;
		STROBE		: OUT std_logic);
END ENTITY;


ARCHITECTURE behav OF startTimer IS
	SIGNAL strobe_dist : std_logic;
BEGIN
	STROBE <= strobe_dist;
	
	strobe_gen: PROCESS
	BEGIN
		IF strobe_dist = 'U' THEN
			strobe_dist <= '0';
			WAIT FOR 28 ns;
		ELSE
			strobe_dist <= '1';
			WAIT FOR 10 ns;
			strobe_dist <= '0';
			IF CONT_SING_n = '0' THEN
				WAIT FOR 130 ns;
			ELSE
				WAIT FOR 50 ns;
			END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE;
