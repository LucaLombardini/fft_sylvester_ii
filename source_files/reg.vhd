LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEE.numeric_std.all;
USE worl.definespack.all;

ENTITY reg IS
	GENERIC(bitwidth: positive	:= 8);
	PORT(	CLK	: IN std_logic;
	    	RST_n	: IN std_logic;
		LD	: IN std_logic;
		D_IN	: IN signed(bitwidth-1 DOWNTO 0);
		D_OUT	: OUT signed(bitwidth-1 DOWNTO 0));
END ENTITY;


ARCHITECTURE behav OF reg IS
BEGIN
	reg_define: PROCESS(RST_n, CLK)
	BEGIN
		IF RST_n = '0' THEN
			D_OUT = to_signed(0, bitwidth);
		ELSIF CLK'EVENT AND CLK = '1' THEN
			IF LD = '1'THEN
				D_OUT <= D_IN;
			END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE;
