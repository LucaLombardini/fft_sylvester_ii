-- Author:       Luca Lombardini
-- Academic_y:   2020/2021
-- Purpose:      (Master Degree) Digital Integrated Systems' Final Project
-- Contacts:     s277972@studenti.polito.it
--               lombamari2@gmail.com
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.cupack.all;

ENTITY cu_butterfly IS
	PORT(	CLK	: IN std_logic;
		RST_n	: IN std_logic;
		STATUS	: IN std_logic;
		CTRL_WRD: OUT std_logic_vector(command_len-1 DOWNTO 0));
END ENTITY;


ARCHITECTURE struct OF cu_butterfly IS

	COMPONENT rom_even IS
		PORT(	ADDR	: IN std_logic_vector(base_addr-1 DOWNTO 0);
			DATA	: OUT std_logic_vector(uir_width-1 DOWNTO 0));
	END COMPONENT;

	COMPONENT rom_odd IS
		PORT(	ADDR	: IN std_logic_vector(base_addr-1 DOWNTO 0);
			DATA	: OUT std_logic_vector(uir_width-1 DOWNTO 0));
	END COMPONENT;

	COMPONENT late_status_pla IS
		PORT(	STATUS	: IN std_logic;
			LSB	: IN std_logic;
			CC	: IN std_logic;
			LSB_out	: OUT std_logic;
			CC_val	: OUT std_logic);
	END COMPONENT;

	COMPONENT reg IS
		GENERIC(bitwidth: positive := 8);
		PORT(	CLK	: IN std_logic;
			RST_n	: IN std_logic;
			LD	: IN std_logic;
			D_IN	: IN signed(bitwidth-1 DOWNTO 0);
			D_OUT	: OUT signed(bitwidth-1 DOWNTO 0));
	END COMPONENT;


	COMPONENT reg_n IS
		GENERIC(bitwidth: positive := 8);
		PORT(	CLK	: IN std_logic;
			RST_n	: IN std_logic;
			LD	: IN std_logic;
			D_IN	: IN std_logic_vector(bitwidth-1 DOWNTO 0);
			D_OUT	: OUT std_logic_vector(bitwidth-1 DOWNTO 0));
	END COMPONENT;

	COMPONENT mux2to1 IS
		GENERIC(bitwidth: positive := 8);
		PORT(	A	: IN signed(bitwidth-1 DOWNTO 0);
			B	: IN signed(bitwidth-1 DOWNTO 0);
			SEL	: IN std_logic;
			Y	: OUT signed(bitwidth-1 DOWNTO 0));
	END COMPONENT;

	SIGNAL next_address	: signed(base_addr DOWNTO 0); --not conn. yet
	SIGNAL roms_address	: signed(base_addr DOWNTO 0);
	SIGNAL even_out		: std_logic_vector(uir_width-1 DOWNTO 0);
	SIGNAL odd_out		: std_logic_vector(uir_width-1 DOWNTO 0);
	SIGNAL micro_addr_lsb	: std_logic;
	SIGNAL late_sel_bit	: std_logic;
	SIGNAL u_next_reg_in	: signed(cc_lsb_addr-1 DOWNTO 0);
	SIGNAL u_command_reg_in : signed(command_len-1 DOWNTO 0);
	SIGNAL u_instr_in	: std_logic_vector(uir_width-1 DOWNTO 0);
	SIGNAL u_instr_out	: std_logic_vector(uir_width-1 DOWNTO 0);
	SIGNAL future_lsb	: std_logic;
	SIGNAL cc_validation	: std_logic;

BEGIN
--############################################################################
--#	uAR: contains the actual machine's instruction address
	micro_addr_reg: reg GENERIC MAP(base_addr+1)
				PORT MAP(CLK,RST_n,
					'1',
					next_address,
					roms_address);
--############################################################################
--#	uROM for the even addresses
	mirco_rom_even: rom_even PORT MAP(std_logic_vector(roms_address(base_addr DOWNTO 1)),
					even_out);
--############################################################################
--#	uROM for the odd addresses
	micro_rom_odd:  rom_odd PORT MAP(std_logic_vector(roms_address(base_addr DOWNTO 1)),
					odd_out);
--############################################################################
--#	Mux used to select the next address, driven by the late status
	mux_next_addr:  mux2to1 GENERIC MAP(cc_lsb_addr) 
				PORT MAP(signed(even_out(uir_width-1 DOWNTO command_len)),
					signed(odd_out(uir_width-1 DOWNTO command_len)),
					late_sel_bit,
					u_next_reg_in);
--############################################################################
--#	Mux used to select the actual command word, driven byt the uAR LSB
	mux_ctrl_wrd :  mux2to1 GENERIC MAP(command_len) 
				PORT MAP(signed(even_out(command_len-1 DOWNTO 0)),
					signed(odd_out(command_len-1 DOWNTO 0)),
					late_sel_bit,
					u_command_reg_in);
--############################################################################
--#	uIR input composition of selected Next_address and actual command word
	u_instr_in <= std_logic_vector(u_next_reg_in) & std_logic_vector(u_command_reg_in);
--############################################################################
--#	uIR containing the next address, CC validation and actual command word
	u_instruction: reg_n GENERIC MAP(uir_width) 
				PORT MAP(CLK, RST_n,
					'1',
					u_instr_in,
					u_instr_out);
--############################################################################
--#	Buffered control word sent to the output
	CTRL_WRD <= u_instr_out(command_len-1 DOWNTO 0);
--############################################################################
--#	Next address roundtrip completion to uAR input, w/out CC and LSB
	next_address <= signed(u_instr_out(uir_width-2 DOWNTO command_len+1) & future_lsb );
--############################################################################
--#	Late status PLA used to combine LSB and STATUS when CC enabled
	late_status:	late_status_pla PORT MAP(STATUS,
					u_instr_out(command_len),
					u_instr_out(uir_width-1),
					future_lsb,
					cc_validation);
--############################################################################
--#	uAR buffered LSB pickup
	micro_addr_lsb <= roms_address(0);
--############################################################################
--#	Selection signal generation for the Next Address mux (implicit mux)
	late_sel_bit <= future_lsb WHEN cc_validation = '1' ELSE micro_addr_lsb;
	-- inplace single bit multiplexer, or else too much conversion needed
END ARCHITECTURE;
