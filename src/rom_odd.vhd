LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;
USE work.cupack.all;

ENTITY rom_odd IS
	PORT(	ADDR	: IN std_logic_vector(base_addr-1 DOWNTO 0);
		DATA	: OUT std_logic_vector(uir_width-1 DOWNTO 0));
END ENTITY;



ARCHITECTURE behav OF rom_odd IS
BEGIN

rom_data_access: PROCESS(ADDR)
BEGIN
	CASE ADDR IS
		WHEN X_IDLE => DATA <= '0' & S_LD_AR & '1' & CW_IDLE;
		WHEN X_LD_AR => DATA <= '0' & S_LD_AI & '1' & CW_SLD_AR;
		WHEN X_LD_AI => DATA <= '0' & S_LD_BR & '1' & CW_SLD_AI;
		WHEN X_LD_BR => DATA <= '0' & S_M1 & '1' & CW_SLD_BR;
		WHEN X_M1 => DATA <= '0' & S_M3 & '1' & CW_SM1;
		WHEN X_M3 => DATA <= '0' & S_M2 & '1' & CW_SM3;
		WHEN X_M2 => DATA <= '0' & S_M4 & '1' & CW_SM2;
		WHEN X_M4 => DATA <= '1' & C_M5 & '1' & CW_SM4;
		WHEN X_M5 => DATA <= '0' & C_M6 & '1' & CW_CM5;
		WHEN X_M6 => DATA <= '0' & C_S5 & '1' & CW_CM6;
		WHEN X_S5 => DATA <= '0' & C_S6 & '1' & CW_CS5;
		WHEN X_S6 => DATA <= '0' & C_RND_BR & '1' & CW_CS6;
		WHEN X_RND_BR => DATA <= '0' & C_RND_BI & '1' & CW_CRND_BR;
		WHEN X_RND_BI => DATA <= '0' & C_SND_BI & '1' & CW_CRND_BI;
		WHEN XS_SND_BI => DATA <= '0' & IDLE & '1' & CW_SSND_BI;
		WHEN XC_SND_BI => DATA <= '1' & C_M5 & '1' & CW_CSND_BI;
		WHEN OTHERS => DATA <= '1' & IDLE & '0' & CW_IDLE;
	END CASE;
END PROCESS;

END ARCHITECTURE;
