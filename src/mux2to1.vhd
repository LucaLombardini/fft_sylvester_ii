LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY mux2to1 IS
	GENERIC(bitwidth: positive	:= 8);
	PORT(	A	: IN signed(bitwidth-1 DOWNTO 0);
		B	: IN signed(bitwidth-1 DOWNTO 0);
		SEL	: IN std_logic;
		Y	: OUT signed(bitwidth-1 DOWNTO 0));
END ENTITY;



ARCHITECTURE behav OF mux2to1 IS
BEGIN
	Y <= A WHEN SEL = '0' ELSE B;
END ARCHITECTURE;
