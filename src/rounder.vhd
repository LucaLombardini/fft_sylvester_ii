-- Author:       Luca Lombardini
-- Academic_y:   2020/2021
-- Purpose:      (Master Degree) Digital Integrated Systems' Final Project
-- Contacts:     s277972@studenti.polito.it
--               lombamari2@gmail.com
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;

ENTITY rounder IS
	PORT(	ROUND_IN	: IN signed(round_i_width-1 DOWNTO 0);
		ROUND_OUT	: OUT signed(round_o_width-1 DOWNTO 0));
END ENTITY;


ARCHITECTURE behav OF rounder IS
	SIGNAL upperHalf	: signed(round_o_width-1 DOWNTO 0);
	SIGNAL trailPart	: std_logic_vector(round_o_width-2 DOWNTO 0);
	SIGNAL round		: signed(round_o_width-1 DOWNTO 0);
	SIGNAL notZero, isCenter, isOdd: std_logic;
	CONSTANT zero_vect	: std_logic_vector(round_o_width-2 DOWNTO 0) := std_logic_vector(to_unsigned(0, round_o_width-1));
BEGIN
	trailPart<= std_logic_vector(ROUND_IN(round_o_width-2 DOWNTO 0));
	isCenter <= ROUND_IN(round_o_width-1);
	isOdd	 <= ROUND_IN(round_o_width);
	notZero	 <= '0' WHEN trailPart = zero_vect ELSE '1';
	
	round(round_o_width-1 DOWNTO 1)	<= (OTHERS => '0');
	round(0) <= (isCenter AND (isOdd OR notZero));
	upperHalf <= ROUND_IN(round_i_width-1 DOWNTO round_i_width - round_o_width);
	ROUND_OUT <= upperHalf + round AFTER (3*clk_period)/4;
END ARCHITECTURE;
