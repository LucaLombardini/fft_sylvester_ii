-- Author:       Luca Lombardini
-- Academic_y:   2020/2021
-- Purpose:      (Master Degree) Digital Integrated Systems' Final Project
-- Contacts:     s277972@studenti.polito.it
--               lombamari2@gmail.com
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.cupack.all;
USE work.definespack.all;

ENTITY pipe_machine IS
	PORT(	CLK	: IN std_logic;
		RST_n	: IN std_logic;
		START	: IN std_logic;
		DONE	: IN std_logic;
		W_IN	: IN signed(io_width*n_coef-1 DOWNTO 0);
		W_OUT	: OUT signed(io_width*n_coef-1 DOWNTO 0));
END ENTITY;

ARCHITECTURE behav OF pipe_machine IS

	COMPONENT reg IS
		GENERIC(bitwidth: positive	:= 8);
		PORT(	CLK	: IN std_logic;
		    	RST_n	: IN std_logic;
			LD	: IN std_logic;
			D_IN	: IN signed(bitwidth-1 DOWNTO 0);
			D_OUT	: OUT signed(bitwidth-1 DOWNTO 0));
	END COMPONENT;

	TYPE PIPE_ARRAY IS ARRAY(0 TO 11) OF signed(io_width*n_coef-1 DOWNTO 0); --12 in-between sigs
	SIGNAL pipe : PIPE_ARRAY;

BEGIN

pipeline: FOR i IN 0 TO 10 GENERATE --11 regs, too much problems encountered with behavioral FSM
	pipeReg_i: reg GENERIC MAP(io_width*n_coef) PORT MAP(CLK, RST_n, '1', pipe(i), pipe(i+1));
END GENERATE;

pipe(0) <= W_IN;
W_OUT <= pipe(11);

END ARCHITECTURE;
