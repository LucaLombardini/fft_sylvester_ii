LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;

ENTITY tb_rounder IS
END ENTITY;

ARCHITECTURE tb OF tb_rounder IS

	COMPONENT rounder IS
		PORT(	ROUND_IN	: IN signed(round_i_width-1 DOWNTO 0);
			ROUND_OUT	: OUT signed(round_o_width-1 DOWNTO 0));
	END COMPONENT;

	COMPONENT dataMaker IS
		GENERIC(input_filename : string := "default_input.hex");
		PORT(	CLK	: IN std_logic;
			RST_n	: IN std_logic;
			DATA	: OUT signed(maker_width-1 DOWNTO 0);
			END_SIM : OUT std_logic);
	END COMPONENT;
	
	COMPONENT dataSink IS
		GENERIC(output_filename : string := "default_output.hex");
		PORT(	CLK	: IN std_logic;
			RST_n	: IN std_logic;
			DATA_RDY: IN std_logic;
			DATA	: IN signed(sink_width-1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT clkGen IS
		PORT(	END_SIM	: IN std_logic;
			CLK		: OUT std_logic;
			RST_n		: OUT std_logic);
	END COMPONENT;
	
	SIGNAL end_simulation	: std_logic;
	SIGNAL clk_distrib	: std_logic;
	SIGNAL rst_distrib_n	: std_logic;
	SIGNAL rnd_in		: signed(round_i_width-1 DOWNTO 0);
	SIGNAL rnd_out		: signed(round_o_width-1 DOWNTO 0);
	
BEGIN

	simulation_ender: PROCESS
	BEGIN
		WAIT UNTIL end_simulation = '1';
		ASSERT FALSE
			REPORT "SIMULATION SUCCESSFULLY ENDED!"
			SEVERITY FAILURE;
	END PROCESS;
	
	clk_gn	: clkGen PORT MAP(end_simulation, clk_distrib, rst_distrib_n);
	d_mkr	: dataMaker GENERIC MAP(input_filename => "rnd_in.hex") PORT MAP(clk_distrib, rst_distrib_n, rnd_in, end_simulation);
	dut	: rounder PORT MAP(rnd_in, nd_out);
	d_snk	: dataSink GENERIC MAP(output_filename => "rnd_out.hex") PORT MAP(clk_distrib, rst_distrib_n, '1', rnd_out);
	
END ARCHITECTURE;
