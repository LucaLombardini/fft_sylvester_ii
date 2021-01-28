LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;
USE work.cupack.all;

ENTITY rom_even IS
	PORT(	ADDR	: IN std_logic_vector(base_addr-1 DOWNTO 0);
		DATA	: OUT std_logic_vector(uir_width-1 DOWNTO 0));
END ENTITY;



ARCHITECTURE behav OF rom_even IS
BEGIN

rom_data_access: PROCESS(ADDR)
BEGIN
	CASE ADDR IS
		WHEN IDLE_LD_AR => DATA <= '1' & IDLE & '0' & CW_IDLE;
		WHEN S_M1 => DATA <= '0' & S_M3 & '0' & CW_SM1;
		WHEN S_M3 => DATA <= '0' & S_M2 & '0' & CW_SM3;
		WHEN S_M2 => DATA <= '0' & S_M4 & '0' & CW_SM2;
		WHEN S_M4 => DATA <= '1' & S_M5 & '0' & CW_SM4;
		WHEN S_M5 => DATA <= '0' & S_M6 & '0' & CW_SM5;
		WHEN X_M6 => DATA <= '0' & S_S5 & '0' & CW_SM6;
		WHEN X_S5 => DATA <= '0' & S_S6 & '0' & CW_SS5;
		WHEN X_S6 => DATA <= '0' & S_RND_BR & '0' & CW_SS6;
		WHEN X_RND_BR => DATA <= '0' & S_SND_R & '0' & CW_SRND_BR;
		WHEN X_SND_R => DATA <= '0' & S_SND_I & '0' & CW_SSND_R;
		WHEN S_SND_BI => DATA <= '0' & IDLE & '0' & CW_SSND_I;
		WHEN C_SND_BI => DATA <= '1' & S_M6 & '0' & CW_CSND_I;
		WHEN OTHERS => DATA <= '1' & IDLE & '0' & CW_IDLE;
	END CASE;
END PROCESS;

END ARCHITECTURE;
