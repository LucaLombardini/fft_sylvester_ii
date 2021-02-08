-- Author:       Luca Lombardini
-- Academic_y:   2020/2021
-- Purpose:      (Master Degree) Digital Integrated Systems' Final Project
-- Contacts:     s277972@studenti.polito.it
--               lombamari2@gmail.com
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;
USE work.cupack.all;

ENTITY fft_unit IS
	PORT(	CLK	: IN std_logic;
		RST_n	: IN std_logic;
		START	: IN std_logic;
		DATA_IN	: IN signed(io_width*n_samples-1 DOWNTO 0);
		COEF_IN	: IN signed(io_width*n_coef-1 DOWNTO 0);
		DATA_OUT: OUT signed(io_width*n_samples-1 DOWNTO 0);
		DONE	: OUT std_logic);
END ENTITY;

ARCHITECTURE struct OF fft_unit IS
	
	COMPONENT pipe_machine IS
		PORT(	CLK	: IN std_logic;
			RST_n	: IN std_logic;
			START	: IN std_logic;
			DONE	: IN std_logic;
			W_IN	: IN signed(io_width*n_coef-1 DOWNTO 0);
			W_OUT	: OUT signed(io_width*n_coef-1 DOWNTO 0));
	END COMPONENT;

	COMPONENT butterfly IS
		PORT(	CLK	: IN std_logic;
			RST_n	: IN std_logic;
			START	: IN std_logic;
			PORT_A	: IN signed(io_width-1 DOWNTO 0);
			PORT_B	: IN signed(io_width-1 DOWNTO 0);
			COEFF_IN: IN signed(io_width-1 DOWNTO 0);
			DONE	: OUT std_logic;
			OUT_A	: OUT signed(io_width-1 DOWNTO 0);
			OUT_B	: OUT signed(io_width-1 DOWNTO 0));
	END COMPONENT;
--#############################################################################
--#	Signal Zone
	SIGNAL lv0_in0 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_in8 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_out0 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_out8 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_gr0_done0 : std_logic;
	SIGNAL lv0_in1 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_in9 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_out1 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_out9 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_gr0_done1 : std_logic;
	SIGNAL lv0_in2 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_in10 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_out2 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_out10 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_gr0_done2 : std_logic;
	SIGNAL lv0_in3 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_in11 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_out3 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_out11 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_gr0_done3 : std_logic;
	SIGNAL lv0_in4 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_in12 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_out4 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_out12 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_gr0_done4 : std_logic;
	SIGNAL lv0_in5 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_in13 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_out5 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_out13 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_gr0_done5 : std_logic;
	SIGNAL lv0_in6 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_in14 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_out6 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_out14 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_gr0_done6 : std_logic;
	SIGNAL lv0_in7 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_in15 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_out7 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_out15 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv0_gr0_done7 : std_logic;
	SIGNAL lev0_w0 : signed(io_width-1 DOWNTO 0);
	SIGNAL doneAggr0 : std_logic;
	SIGNAL w_pipe0 : signed(io_width*n_coef-1 DOWNTO 0);
	SIGNAL lv1_out0 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv1_out4 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv1_gr0_done0 : std_logic;
	SIGNAL lv1_out1 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv1_out5 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv1_gr0_done1 : std_logic;
	SIGNAL lv1_out2 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv1_out6 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv1_gr0_done2 : std_logic;
	SIGNAL lv1_out3 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv1_out7 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv1_gr0_done3 : std_logic;
	SIGNAL lev1_w0 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv1_out8 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv1_out12 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv1_gr1_done0 : std_logic;
	SIGNAL lv1_out9 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv1_out13 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv1_gr1_done1 : std_logic;
	SIGNAL lv1_out10 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv1_out14 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv1_gr1_done2 : std_logic;
	SIGNAL lv1_out11 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv1_out15 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv1_gr1_done3 : std_logic;
	SIGNAL lev1_w4 : signed(io_width-1 DOWNTO 0);
	SIGNAL doneAggr1 : std_logic;
	SIGNAL w_pipe1 : signed(io_width*n_coef-1 DOWNTO 0);
	SIGNAL lv2_out0 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv2_out2 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv2_gr0_done0 : std_logic;
	SIGNAL lv2_out1 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv2_out3 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv2_gr0_done1 : std_logic;
	SIGNAL lev2_w0 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv2_out4 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv2_out6 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv2_gr1_done0 : std_logic;
	SIGNAL lv2_out5 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv2_out7 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv2_gr1_done1 : std_logic;
	SIGNAL lev2_w4 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv2_out8 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv2_out10 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv2_gr2_done0 : std_logic;
	SIGNAL lv2_out9 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv2_out11 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv2_gr2_done1 : std_logic;
	SIGNAL lev2_w2 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv2_out12 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv2_out14 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv2_gr3_done0 : std_logic;
	SIGNAL lv2_out13 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv2_out15 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv2_gr3_done1 : std_logic;
	SIGNAL lev2_w6 : signed(io_width-1 DOWNTO 0);
	SIGNAL doneAggr2 : std_logic;
	SIGNAL w_pipe2 : signed(io_width*n_coef-1 DOWNTO 0);
	SIGNAL lv3_out0 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_out1 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_gr0_done0 : std_logic;
	SIGNAL lev3_w0 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_out2 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_out3 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_gr1_done0 : std_logic;
	SIGNAL lev3_w4 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_out4 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_out5 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_gr2_done0 : std_logic;
	SIGNAL lev3_w2 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_out6 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_out7 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_gr3_done0 : std_logic;
	SIGNAL lev3_w6 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_out8 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_out9 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_gr4_done0 : std_logic;
	SIGNAL lev3_w1 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_out10 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_out11 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_gr5_done0 : std_logic;
	SIGNAL lev3_w5 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_out12 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_out13 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_gr6_done0 : std_logic;
	SIGNAL lev3_w3 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_out14 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_out15 : signed(io_width-1 DOWNTO 0);
	SIGNAL lv3_gr7_done0 : std_logic;
	SIGNAL lev3_w7 : signed(io_width-1 DOWNTO 0);
BEGIN
--#############################################################################
--#	1st Layer
	lv0_gr0_but0 : butterfly PORT MAP (CLK, RST_n, START, lv0_in0, lv0_in8, lev0_w0, lv0_gr0_done0, lv0_out0, lv0_out8);
	lv0_gr0_but1 : butterfly PORT MAP (CLK, RST_n, START, lv0_in1, lv0_in9, lev0_w0, lv0_gr0_done1, lv0_out1, lv0_out9);
	lv0_gr0_but2 : butterfly PORT MAP (CLK, RST_n, START, lv0_in2, lv0_in10, lev0_w0, lv0_gr0_done2, lv0_out2, lv0_out10);
	lv0_gr0_but3 : butterfly PORT MAP (CLK, RST_n, START, lv0_in3, lv0_in11, lev0_w0, lv0_gr0_done3, lv0_out3, lv0_out11);
	lv0_gr0_but4 : butterfly PORT MAP (CLK, RST_n, START, lv0_in4, lv0_in12, lev0_w0, lv0_gr0_done4, lv0_out4, lv0_out12);
	lv0_gr0_but5 : butterfly PORT MAP (CLK, RST_n, START, lv0_in5, lv0_in13, lev0_w0, lv0_gr0_done5, lv0_out5, lv0_out13);
	lv0_gr0_but6 : butterfly PORT MAP (CLK, RST_n, START, lv0_in6, lv0_in14, lev0_w0, lv0_gr0_done6, lv0_out6, lv0_out14);
	lv0_gr0_but7 : butterfly PORT MAP (CLK, RST_n, START, lv0_in7, lv0_in15, lev0_w0, lv0_gr0_done7, lv0_out7, lv0_out15);
	pipe0 : pipe_machine PORT MAP(CLK, RST_n, START, doneAggr0, COEF_IN, w_pipe0);
	lv0_in0 <= DATA_IN(io_width*16-1 DOWNTO io_width*15);
	lv0_in8 <= DATA_IN(io_width*8-1 DOWNTO io_width*7);
	lv0_in1 <= DATA_IN(io_width*15-1 DOWNTO io_width*14);
	lv0_in9 <= DATA_IN(io_width*7-1 DOWNTO io_width*6);
	lv0_in2 <= DATA_IN(io_width*14-1 DOWNTO io_width*13);
	lv0_in10 <= DATA_IN(io_width*6-1 DOWNTO io_width*5);
	lv0_in3 <= DATA_IN(io_width*13-1 DOWNTO io_width*12);
	lv0_in11 <= DATA_IN(io_width*5-1 DOWNTO io_width*4);
	lv0_in4 <= DATA_IN(io_width*12-1 DOWNTO io_width*11);
	lv0_in12 <= DATA_IN(io_width*4-1 DOWNTO io_width*3);
	lv0_in5 <= DATA_IN(io_width*11-1 DOWNTO io_width*10);
	lv0_in13 <= DATA_IN(io_width*3-1 DOWNTO io_width*2);
	lv0_in6 <= DATA_IN(io_width*10-1 DOWNTO io_width*9);
	lv0_in14 <= DATA_IN(io_width*2-1 DOWNTO io_width*1);
	lv0_in7 <= DATA_IN(io_width*9-1 DOWNTO io_width*8);
	lv0_in15 <= DATA_IN(io_width*1-1 DOWNTO io_width*0);
	lev0_w0 <= COEF_IN(io_width*8-1 DOWNTO io_width*7);
	doneAggr0 <= lv0_gr0_done0 AND lv0_gr0_done1 AND lv0_gr0_done2 AND lv0_gr0_done3 AND lv0_gr0_done4 AND lv0_gr0_done5 AND lv0_gr0_done6 AND lv0_gr0_done7;
--#############################################################################
--#	2nd Layer
	lv1_gr0_but0 : butterfly PORT MAP (CLK, RST_n, doneAggr0, lv0_out0, lv0_out4, lev1_w0, lv1_gr0_done0, lv1_out0, lv1_out4);
	lv1_gr0_but1 : butterfly PORT MAP (CLK, RST_n, doneAggr0, lv0_out1, lv0_out5, lev1_w0, lv1_gr0_done1, lv1_out1, lv1_out5);
	lv1_gr0_but2 : butterfly PORT MAP (CLK, RST_n, doneAggr0, lv0_out2, lv0_out6, lev1_w0, lv1_gr0_done2, lv1_out2, lv1_out6);
	lv1_gr0_but3 : butterfly PORT MAP (CLK, RST_n, doneAggr0, lv0_out3, lv0_out7, lev1_w0, lv1_gr0_done3, lv1_out3, lv1_out7);
	lv1_gr1_but0 : butterfly PORT MAP (CLK, RST_n, doneAggr0, lv0_out8, lv0_out12, lev1_w4, lv1_gr1_done0, lv1_out8, lv1_out12);
	lv1_gr1_but1 : butterfly PORT MAP (CLK, RST_n, doneAggr0, lv0_out9, lv0_out13, lev1_w4, lv1_gr1_done1, lv1_out9, lv1_out13);
	lv1_gr1_but2 : butterfly PORT MAP (CLK, RST_n, doneAggr0, lv0_out10, lv0_out14, lev1_w4, lv1_gr1_done2, lv1_out10, lv1_out14);
	lv1_gr1_but3 : butterfly PORT MAP (CLK, RST_n, doneAggr0, lv0_out11, lv0_out15, lev1_w4, lv1_gr1_done3, lv1_out11, lv1_out15);
	pipe1 : pipe_machine PORT MAP(CLK, RST_n, doneAggr0, doneAggr1, w_pipe0, w_pipe1);
	lev1_w0 <= w_pipe0(io_width*8-1 DOWNTO io_width*7);
	lev1_w4 <= w_pipe0(io_width*4-1 DOWNTO io_width*3);
	doneAggr1 <= lv1_gr0_done0 AND lv1_gr0_done1 AND lv1_gr0_done2 AND lv1_gr0_done3 AND lv1_gr1_done0 AND lv1_gr1_done1 AND lv1_gr1_done2 AND lv1_gr1_done3;
--#############################################################################
--#	3rd Layer
	lv2_gr0_but0 : butterfly PORT MAP (CLK, RST_n, doneAggr1, lv1_out0, lv1_out2, lev2_w0, lv2_gr0_done0, lv2_out0, lv2_out2);
	lv2_gr0_but1 : butterfly PORT MAP (CLK, RST_n, doneAggr1, lv1_out1, lv1_out3, lev2_w0, lv2_gr0_done1, lv2_out1, lv2_out3);
	lv2_gr1_but0 : butterfly PORT MAP (CLK, RST_n, doneAggr1, lv1_out4, lv1_out6, lev2_w4, lv2_gr1_done0, lv2_out4, lv2_out6);
	lv2_gr1_but1 : butterfly PORT MAP (CLK, RST_n, doneAggr1, lv1_out5, lv1_out7, lev2_w4, lv2_gr1_done1, lv2_out5, lv2_out7);
	lv2_gr2_but0 : butterfly PORT MAP (CLK, RST_n, doneAggr1, lv1_out8, lv1_out10, lev2_w2, lv2_gr2_done0, lv2_out8, lv2_out10);
	lv2_gr2_but1 : butterfly PORT MAP (CLK, RST_n, doneAggr1, lv1_out9, lv1_out11, lev2_w2, lv2_gr2_done1, lv2_out9, lv2_out11);
	lv2_gr3_but0 : butterfly PORT MAP (CLK, RST_n, doneAggr1, lv1_out12, lv1_out14, lev2_w6, lv2_gr3_done0, lv2_out12, lv2_out14);
	lv2_gr3_but1 : butterfly PORT MAP (CLK, RST_n, doneAggr1, lv1_out13, lv1_out15, lev2_w6, lv2_gr3_done1, lv2_out13, lv2_out15);
	pipe2 : pipe_machine PORT MAP(CLK, RST_n, doneAggr1, doneAggr2, w_pipe1, w_pipe2);
	lev2_w0 <= w_pipe1(io_width*8-1 DOWNTO io_width*7);
	lev2_w4 <= w_pipe1(io_width*4-1 DOWNTO io_width*3);
	lev2_w2 <= w_pipe1(io_width*6-1 DOWNTO io_width*5);
	lev2_w6 <= w_pipe1(io_width*2-1 DOWNTO io_width*1);
	doneAggr2 <= lv2_gr0_done0 AND lv2_gr0_done1 AND lv2_gr1_done0 AND lv2_gr1_done1 AND lv2_gr2_done0 AND lv2_gr2_done1 AND lv2_gr3_done0 AND lv2_gr3_done1;
--#############################################################################
--#	4th Layer
	lv3_gr0_but0 : butterfly PORT MAP (CLK, RST_n, doneAggr2, lv2_out0, lv2_out1, lev3_w0, lv3_gr0_done0, lv3_out0, lv3_out1);
	lv3_gr1_but0 : butterfly PORT MAP (CLK, RST_n, doneAggr2, lv2_out2, lv2_out3, lev3_w4, lv3_gr1_done0, lv3_out2, lv3_out3);
	lv3_gr2_but0 : butterfly PORT MAP (CLK, RST_n, doneAggr2, lv2_out4, lv2_out5, lev3_w2, lv3_gr2_done0, lv3_out4, lv3_out5);
	lv3_gr3_but0 : butterfly PORT MAP (CLK, RST_n, doneAggr2, lv2_out6, lv2_out7, lev3_w6, lv3_gr3_done0, lv3_out6, lv3_out7);
	lv3_gr4_but0 : butterfly PORT MAP (CLK, RST_n, doneAggr2, lv2_out8, lv2_out9, lev3_w1, lv3_gr4_done0, lv3_out8, lv3_out9);
	lv3_gr5_but0 : butterfly PORT MAP (CLK, RST_n, doneAggr2, lv2_out10, lv2_out11, lev3_w5, lv3_gr5_done0, lv3_out10, lv3_out11);
	lv3_gr6_but0 : butterfly PORT MAP (CLK, RST_n, doneAggr2, lv2_out12, lv2_out13, lev3_w3, lv3_gr6_done0, lv3_out12, lv3_out13);
	lv3_gr7_but0 : butterfly PORT MAP (CLK, RST_n, doneAggr2, lv2_out14, lv2_out15, lev3_w7, lv3_gr7_done0, lv3_out14, lv3_out15);
	lev3_w0 <= w_pipe2(io_width*8-1 DOWNTO io_width*7);
	lev3_w4 <= w_pipe2(io_width*4-1 DOWNTO io_width*3);
	lev3_w2 <= w_pipe2(io_width*6-1 DOWNTO io_width*5);
	lev3_w6 <= w_pipe2(io_width*2-1 DOWNTO io_width*1);
	lev3_w1 <= w_pipe2(io_width*7-1 DOWNTO io_width*6);
	lev3_w5 <= w_pipe2(io_width*3-1 DOWNTO io_width*2);
	lev3_w3 <= w_pipe2(io_width*5-1 DOWNTO io_width*4);
	lev3_w7 <= w_pipe2(io_width*1-1 DOWNTO io_width*0);
	DONE <= lv3_gr0_done0 AND lv3_gr1_done0 AND lv3_gr2_done0 AND lv3_gr3_done0 AND lv3_gr4_done0 AND lv3_gr5_done0 AND lv3_gr6_done0 AND lv3_gr7_done0;
--#############################################################################
--#	Output reorder
	DATA_OUT(io_width*16-1 DOWNTO io_width*15) <= lv3_out0;
	DATA_OUT(io_width*15-1 DOWNTO io_width*14) <= lv3_out8;
	DATA_OUT(io_width*14-1 DOWNTO io_width*13) <= lv3_out4;
	DATA_OUT(io_width*13-1 DOWNTO io_width*12) <= lv3_out12;
	DATA_OUT(io_width*12-1 DOWNTO io_width*11) <= lv3_out2;
	DATA_OUT(io_width*11-1 DOWNTO io_width*10) <= lv3_out10;
	DATA_OUT(io_width*10-1 DOWNTO io_width*9) <= lv3_out6;
	DATA_OUT(io_width*9-1 DOWNTO io_width*8) <= lv3_out14;
	DATA_OUT(io_width*8-1 DOWNTO io_width*7) <= lv3_out1;
	DATA_OUT(io_width*7-1 DOWNTO io_width*6) <= lv3_out9;
	DATA_OUT(io_width*6-1 DOWNTO io_width*5) <= lv3_out5;
	DATA_OUT(io_width*5-1 DOWNTO io_width*4) <= lv3_out13;
	DATA_OUT(io_width*4-1 DOWNTO io_width*3) <= lv3_out3;
	DATA_OUT(io_width*3-1 DOWNTO io_width*2) <= lv3_out11;
	DATA_OUT(io_width*2-1 DOWNTO io_width*1) <= lv3_out7;
	DATA_OUT(io_width*1-1 DOWNTO io_width*0) <= lv3_out15;
END ARCHITECTURE;
