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
		WHEN IDLE_LD_R => DATA <= '0' & S_M1 & '1' & CW_SLD_R;
		WHEN S_M1 => DATA <= '0' & S_M3 & '1' & CW_SM1;
		WHEN S_M3 => DATA <= '0' & S_M2 & '1' & CW_SM3;
		WHEN S_M2 => DATA <= '0' & S_M4 & '1' & CW_SM2;
		WHEN S_M4 => DATA <= '1' & C_M5 & '1' & CW_SM4;
		WHEN S_M5 => DATA <= '0' & C_M6 & '1' & CW_SM5;
		WHEN X_M6 => DATA <= '0' & C_S5 & '1' & CW_CM6;
		WHEN X_S5 => DATA <= '0' & C_S6 & '1' & CW_CS5;
		WHEN X_S6 => DATA <= '0' & C_RND_BR & '1' & CW_CS6;
		WHEN X_RND_BR => DATA <= '0' & C_SND_R & '1' & CW_CRND_BR;
		WHEN X_SND_R => DATA <= '0' & C_SND_I & '1' & CW_CSND_R;
		WHEN S_SND_I => DATA <= '0' & IDLE & '1' & CW_SSND_I;
		WHEN C_SND_I => DATA <= '1' & C_M6 & '1' & CW_CSND_I;
		WHEN OTHERS => DATA <= '1' & IDLE & '0' & CW_IDLE;
	END CASE;
END PROCESS;

END ARCHITECTURE;
