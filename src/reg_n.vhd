-- Author:       Luca Lombardini
-- Academic_y:   2020/2021
-- Purpose:      (Master Degree) Digital Integrated Systems' Final Project
-- Contacts:     s277972@studenti.polito.it
--               lombamari2@gmail.com
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;

ENTITY reg_n IS
	GENERIC(bitwidth: positive	:= 8);
	PORT(	CLK	: IN std_logic;
	    	RST_n	: IN std_logic;
		LD	: IN std_logic;
		D_IN	: IN std_logic_vector(bitwidth-1 DOWNTO 0);
		D_OUT	: OUT std_logic_vector(bitwidth-1 DOWNTO 0));
END ENTITY;


ARCHITECTURE behav OF reg_n IS
BEGIN
	reg_define: PROCESS(RST_n, CLK)
	BEGIN
		IF RST_n = '0' THEN
			D_OUT <= (OTHERS => '0');
		ELSIF CLK'EVENT AND CLK = '0' THEN
			IF LD = '1'THEN
				D_OUT <= D_IN;
			END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE;
