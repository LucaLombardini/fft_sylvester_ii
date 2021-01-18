LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;
USE work.cupack.all;

ENTITY pla_command IS
	PORT(	STATE	: std_logic_vector(cc_lsb_addr-1 DOWNTO 0);
		CW	: std_logic_vector(command_len-1 DOWNTO 0));
END ENTITY;



ARCHITECTURE behav OF pla_command IS
BEGIN

cmd_gen: PROCESS(STATE)
BEGIN
	CASE STATE IS
		WHEN S_IDLE | D_IDLE => DATA <= CW_0;
		WHEN S_LD_AR => DATA <= CW_1;
		WHEN S_LD_AI | D_LD_AI => DATA <= CW_2;
		WHEN S_LD_BR | D_LD_BR => DATA <= CW_3;
		WHEN S_M1 | D_M1 => DATA <= CW_4;
		WHEN S_M3 | D_M3 => DATA <= CW_5;
		WHEN S_M2 | D_M2 => DATA <= CW_6;
		WHEN S_M4 | D_M4 => DATA <= CW_7;
		WHEN S_M5 => DATA <= CW_8;
		WHEN S_M6 => DATA <= CW_9;
		WHEN S_S5 => DATA <= CW_10;
		WHEN S_S6 => DATA <= CW_11;
		WHEN S_RND_BR => DATA <= CW_12;
		WHEN S_RND_BI => DATA <= CW_13;
		WHEN S_SND_BI => DATA <= CW_14;
		WHEN C_M5 => DATA <= CW_15;
		WHEN C_M6 => DATA <= CW_16;
		WHEN C_S5 => DATA <= CW_17;
		WHEN C_S6 => DATA <= CW_18;
		WHEN C_RND_BR => DATA <= CW_19;
		WHEN C_RND_BI => DATA <= CW_20;
		WHEN C_SND_BI => DATA <= CW_21;
		WHEN OTHERS => CW <= CW0;
	END CASE;
END PROCESS;

END ARCHITECTURE;
