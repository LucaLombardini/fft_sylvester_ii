LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;
USE work.cupack.all;

ENTITY rom_odd IS
	PORT(	ADDR	: std_logic_vector(base_addr-1 DOWNTO 0);
		DATA	: std_logic_vector(cc_lsb_addr-1 DOWNTO 0));
END ENTITY;



ARCHITECTURE behav OF rom_odd IS
BEGIN

rom_data_access: PROCESS(ADDR)
BEGIN
	CASE ADDR IS
		WHEN X_IDLE => DATA <= S_LD_AR;
		WHEN X_LD_AR => DATA <= S_LD_AI;
		WHEN X_LD_AI => DATA <= S_LD_BR;
		WHEN X_LD_BR => DATA <= S_M1;
		WHEN X_M1 => DATA <= S_M3;
		WHEN X_M3 => DATA <= S_M2;
		WHEN X_M2 => DATA <= S_M4;
		WHEN X_M4 => DATA <= C_M5;
		WHEN X_M5 => DATA <= C_M6;
		WHEN X_M6 => DATA <= C_S5;
		WHEN X_S5 => DATA <= C_S6;
		WHEN X_S6 => DATA <= C_RND_BR;
		WHEN X_RND_BR => DATA <= C_RND_BI;
		WHEN X_RND_BI => DATA <= C_SND_BI;
		WHEN XS_SND_BI => DATA <= D_IDLE;
		WHEN XC_SND_BI => DATA <= C_M5;
		WHEN OTHERS => DATA <= D_IDLE;
	END CASE;
END PROCESS;

END ARCHITECTURE;
