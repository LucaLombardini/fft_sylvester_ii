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
	SIGNAL trailPart	: signed(round_o_width-2 DOWNTO 0);
	SIGNAL round		: signed(round_o_width-1 DOWNTO 0);
	SIGNAL notZero, isCenter, isOdd: std_logic;
BEGIN
	trailPart<= std_logic_vector(ROUND_IN(round_o_width-2 DOWNTO 0));
	isCenter <= std_logic_vector(ROUND_IN(round_o_width-1))(0);
	isOdd	 <= std_logic_vector(ROUND_IN(round_o_width))(0);
	notZero	 <= '0' WHEN trailPart = (OTHERS => '0') ELSE '1';
	
	round(round_o_width-1 DOWNTO 1)	<= (OTHERS => '0');
	round(0) <= (isCenter AND (isOdd OR notZero));
	upperHalf <= ROUND_IN(round_i_width-1 DOWNTO round_i_width - round_o_width);
	ROUND_OUT <= upperHalf + round;
END ARCHITECTURE;
