LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;

ENTITY multiplier IS
	PORT(	CLK	: IN std_logic;
		A	: IN signed(m_in_width-1 DOWNTO 0);
		B	: IN signed(m_in_width-1 DOWNTO 0);
		D_M_n	: IN std_logic;
		PROD	: OUT signed(prod_width-1 DOWNTO 0));
END ENTITY;


ARCHITECTURE behav OF multiplier IS	
BEGIN
	mult_define: PROCESS(CLK)
		VARIABLE tmp	: std_logic_vector(prod_width-1 DOWNTO 0);
	BEGIN
		IF CLK'EVENT AND CLK = '1' THEN
			IF D_M_n = '0' THEN
				PROD <= A * B;
			ELSE
				--tmp(m_in_width DOWNTO 0) := std_logic_vector(A) & '0';
				--tmp(prod_width-1 DOWNTO m_in_width+1) := (OTHERS => A(m_in_width-1));
				tmp(prod_width-1 DOWNTO m_in_width) := std_logic_vector(A);
				tmp(m_in_width-1 DOWNTO 0) := (OTHERS => '0');
				PROD <= signed(tmp);
			END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE;
