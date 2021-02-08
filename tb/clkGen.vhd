-- Author:       Luca Lombardini
-- Academic_y:   2020/2021
-- Purpose:      (Master Degree) Digital Integrated Systems' Final Project
-- Contacts:     s277972@studenti.polito.it
--               lombamari2@gmail.com
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;

ENTITY clkGen IS
	PORT(	END_SIM	: IN std_logic;
		CLK		: OUT std_logic;
		RST_n		: OUT std_logic);
END ENTITY;



ARCHITECTURE behav OF clkGen IS
	SIGNAL clk_inf	: std_logic;
BEGIN
	endless_clk: PROCESS
	BEGIN
		IF clk_inf = 'U' THEN
			clk_inf <= '0';
		ELSE
			clk_inf <= NOT(clk_inf);
		END IF;
		WAIT FOR clk_period / 2;
	END PROCESS;
	
	CLK <= clk_inf AND NOT(END_SIM);
	
	initial_reset: PROCESS
	BEGIN
		RST_n <= '0';
		WAIT FOR rst_release;
		RST_n <= '1';
		WAIT;
	END PROCESS;
END ARCHITECTURE;
