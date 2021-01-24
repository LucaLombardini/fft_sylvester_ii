LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;

ENTITY adder IS
	PORT(	CLK	: IN std_logic;
		A	: IN signed(add_width-1 DOWNTO 0);
	    	B	: IN signed(add_width-1 DOWNTO 0);
		S_A_n	: IN std_logic;
		SUM	: OUT signed(add_width-1 DOWNTO 0));
END ENTITY;


ARCHITECTURE behav OF adder IS
BEGIN
	adder_define: PROCESS(CLK)
	BEGIN
		IF CLK'EVENT AND CLK = '1' THEN
			IF S_A_n = '0' THEN
				SUM <= A + B;
			ELSE
				SUM <= A - B;
			END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE;
