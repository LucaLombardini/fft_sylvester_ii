LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;

PACKAGE cupack IS
	CONSTANT base_addr	: integer	:= 4;
	CONSTANT lsb_addr	: integer	:= 5;
	CONSTANT cc_lsb_addr	: integer	:= 6;
	CONSTANT command_len	: integer	:= 27;
	CONSTANT uir_width	: integer	:= 33;
	CONSTANT IDLE_LD_R	: std_logic_vector(base_addr-1 DOWNTO 0) := "0000";
	CONSTANT S_M1	: std_logic_vector(base_addr-1 DOWNTO 0) := "0001";
	CONSTANT S_M3	: std_logic_vector(base_addr-1 DOWNTO 0) := "0010";
	CONSTANT S_M2	: std_logic_vector(base_addr-1 DOWNTO 0) := "0011";
	CONSTANT S_M4	: std_logic_vector(base_addr-1 DOWNTO 0) := "0100";
	CONSTANT S_M5	: std_logic_vector(base_addr-1 DOWNTO 0) := "0101";
	CONSTANT X_M6	: std_logic_vector(base_addr-1 DOWNTO 0) := "0110";
	CONSTANT X_S5	: std_logic_vector(base_addr-1 DOWNTO 0) := "0111";
	CONSTANT X_S6	: std_logic_vector(base_addr-1 DOWNTO 0) := "1000";
	CONSTANT X_RND_BR	: std_logic_vector(base_addr-1 DOWNTO 0) := "1001";
	CONSTANT X_SND_R	: std_logic_vector(base_addr-1 DOWNTO 0) := "1010";
	CONSTANT S_SND_I	: std_logic_vector(base_addr-1 DOWNTO 0) := "1011";
	CONSTANT C_SND_I	: std_logic_vector(base_addr-1 DOWNTO 0) := "1100";
	CONSTANT IDLE	: std_logic_vector(base_addr-1 DOWNTO 0) := "0000";
	CONSTANT S_M6	: std_logic_vector(base_addr-1 DOWNTO 0) := "0110";
	CONSTANT S_S5	: std_logic_vector(base_addr-1 DOWNTO 0) := "0111";
	CONSTANT S_S6	: std_logic_vector(base_addr-1 DOWNTO 0) := "1000";
	CONSTANT S_RND_BR	: std_logic_vector(base_addr-1 DOWNTO 0) := "1001";
	CONSTANT S_RND_BI	: std_logic_vector(base_addr-1 DOWNTO 0) := "1100";
	CONSTANT C_M6	: std_logic_vector(base_addr-1 DOWNTO 0) := "0110";
	CONSTANT C_S5	: std_logic_vector(base_addr-1 DOWNTO 0) := "0111";
	CONSTANT C_S6	: std_logic_vector(base_addr-1 DOWNTO 0) := "1000";
	CONSTANT C_RND_BR	: std_logic_vector(base_addr-1 DOWNTO 0) := "1001";
	CONSTANT C_RND_BI	: std_logic_vector(base_addr-1 DOWNTO 0) := "1100";
	CONSTANT CW_IDLE	: std_logic_vector(command_len-1 DOWNTO 0) := "000000000000000000000000000";
	CONSTANT CW_SLD_R	: std_logic_vector(command_len-1 DOWNTO 0) := "010000110000000000000000000";
	CONSTANT CW_SM1	: std_logic_vector(command_len-1 DOWNTO 0) := "110101110100000000000000000";
	CONSTANT CW_SM3	: std_logic_vector(command_len-1 DOWNTO 0) := "001000000100010000000000000";
	CONSTANT CW_SM2	: std_logic_vector(command_len-1 DOWNTO 0) := "001000001100011000000000000";
	CONSTANT CW_SM4	: std_logic_vector(command_len-1 DOWNTO 0) := "000000001110010000110000000";
	CONSTANT CW_SM5	: std_logic_vector(command_len-1 DOWNTO 0) := "000000000000110001000100000";
	CONSTANT CW_SM6	: std_logic_vector(command_len-1 DOWNTO 0) := "000000001000110000100000000";
	CONSTANT CW_SS5	: std_logic_vector(command_len-1 DOWNTO 0) := "000000000000010111000100000";
	CONSTANT CW_SS6	: std_logic_vector(command_len-1 DOWNTO 0) := "000000000000000000101011000";
	CONSTANT CW_SRND_BR	: std_logic_vector(command_len-1 DOWNTO 0) := "000000000000000000000101100";
	CONSTANT CW_SSND_R	: std_logic_vector(command_len-1 DOWNTO 0) := "000000000000000000000010011";
	CONSTANT CW_SSND_I	: std_logic_vector(command_len-1 DOWNTO 0) := "000000000000000000000000110";
	CONSTANT CW_CM6	: std_logic_vector(command_len-1 DOWNTO 0) := "010000111000110000100000000";
	CONSTANT CW_CS5	: std_logic_vector(command_len-1 DOWNTO 0) := "110101110100010111000100000";
	CONSTANT CW_CS6	: std_logic_vector(command_len-1 DOWNTO 0) := "001000000100010000101011000";
	CONSTANT CW_CRND_BR	: std_logic_vector(command_len-1 DOWNTO 0) := "001000001100011000000101100";
	CONSTANT CW_CSND_R	: std_logic_vector(command_len-1 DOWNTO 0) := "000000001110010000110010011";
	CONSTANT CW_CSND_I	: std_logic_vector(command_len-1 DOWNTO 0) := "000000000000110001000100110";
	CONSTANT RFC_WR_ADDR	: integer	:= 26;
	CONSTANT RFC_WR	: integer	:= 25;
	CONSTANT RFC_RD_ADDR	: integer	:= 24;
	CONSTANT RFD_WR1_ADDR0	: integer	:= 23;
	CONSTANT RFD_WR1_ADDR1	: integer	:= 22;
	CONSTANT RFD_WR2_ADDR0	: integer	:= 21;
	CONSTANT RFD_WR2_ADDR1	: integer	:= 20;
	CONSTANT RFD_WR	: integer	:= 19;
	CONSTANT RFD_RD1_ADDR0	: integer	:= 18;
	CONSTANT RFD_RD1_ADDR1	: integer	:= 17;
	CONSTANT RFD_RD2_ADDR0	: integer	:= 16;
	CONSTANT RFD_RD2_ADDR1	: integer	:= 15;
	CONSTANT MULT_DOUBLE	: integer	:= 14;
	CONSTANT R_MULT_LD	: integer	:= 13;
	CONSTANT MUX1_SEL	: integer	:= 12;
	CONSTANT MUX2_SEL	: integer	:= 11;
	CONSTANT MUX3_SEL	: integer	:= 10;
	CONSTANT ADD1_SUB_ADD	: integer	:= 9;
	CONSTANT R_ADD1_LD	: integer	:= 8;
	CONSTANT MUX4_SEL	: integer	:= 7;
	CONSTANT ADD2_SUB_ADD	: integer	:= 6;
	CONSTANT R_ADD2_LD	: integer	:= 5;
	CONSTANT MUX5_SEL	: integer	:= 4;
	CONSTANT REORD_LD	: integer	:= 3;
	CONSTANT OUT_A_BUF_LD	: integer	:= 2;
	CONSTANT OUT_B_BUF_LD	: integer	:= 1;
	CONSTANT DONE_BIT	: integer	:= 0;
END cupack;