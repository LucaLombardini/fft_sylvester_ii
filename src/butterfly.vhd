LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;
USE work.cupack.all;

ENTITY butterfly IS
	PORT(	CLK	: IN std_logic;
		RST_n	: IN std_logic;
		START	: IN std_logic;
		PORT_A	: IN signed(io_width-1 DOWNTO 0);
		PORT_B	: IN signed(io_width-1 DOWNTO 0);
		COEFF_IN: IN signed(io_width-1 DOWNTO 0);
		DONE	: OUT std_logic;
		OUT_A	: OUT signed(io_width-1 DOWNTO 0);
		OUT_B	: OUT signed(io_width-1 DOWNTO 0));
END ENTITY;


ARCHITECTURE struct OF butterfly IS

	COMPONENT dp_butterfly IS
		PORT(	CLK	 : IN std_logic;
			RST_n	 : IN std_logic;
			PORT_A	 : IN signed(io_width-1 DOWNTO 0);
			PORT_B	 : IN signed(io_width-1 DOWNTO 0);
			COEFF_IN : IN signed(io_width-1 DOWNTO 0);
			CTRL_WORD: IN std_logic_vector(command_len-1 DOWNTO 0);
			OUT_A : OUT signed(io_width-1 DOWNTO 0);
			OUT_B : OUT signed(io_width-1 DOWNTO 0));
	END COMPONENT;

	COMPONENT cu_butterfly IS
		PORT(	CLK	: IN std_logic;
			RST_n	: IN std_logic;
			STATUS	: IN std_logic;
			CTRL_WRD: OUT std_logic_vector(command_len-1 DOWNTO 0));
	END COMPONENT;

--#############################################################################
--#	Signal used to interface Control Unit with Data Path
	SIGNAL cw_to_datapath	: std_logic_vector(command_len-1 DOWNTO 0);

BEGIN
--#############################################################################
--#	Datapath section of butterfly unit
	datapath	: dp_butterfly 	PORT MAP(CLK,
					RST_n,
					PORT_A,
					PORT_B,
					COEFF_IN,
					cw_to_datapath,
					OUT_A,
					OUT_B);
--#############################################################################
--#	Control Unit Section of butterfly unit
	control_unit	: cu_butterfly 	PORT MAP(CLK,
					RST_n,
					START,
					cw_to_datapath);
--#############################################################################
--#	Done bit connection
	DONE <= cw_to_datapath(DONE_BIT);
END ARCHITECTURE;
