-- Author:       Luca Lombardini
-- Academic_y:   2020/2021
-- Purpose:      (Master Degree) Digital Integrated Systems' Final Project
-- Contacts:     s277972@studenti.polito.it
--               lombamari2@gmail.com
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;

ENTITY tb_adder IS
END ENTITY;

ARCHITECTURE tb OF tb_adder IS

	COMPONENT adder IS
		PORT(	CLK	: IN std_logic;
			A	: IN signed(add_width-1 DOWNTO 0);
		    	B	: IN signed(add_width-1 DOWNTO 0);
			A_S_n	: IN std_logic;
			SUM	: OUT signed(add_width-1 DOWNTO 0));
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
	SIGNAL adder_in	: signed(add_width-1 DOWNTO 0);
	SIGNAL adder_out	: signed(add_width-1 DOWNTO 0);
	SIGNAL sub_out		: signed(add_width-1 DOWNTO 0);
	
BEGIN

	simulation_ender: PROCESS
	BEGIN
		WAIT UNTIL end_simulation = '1';
		ASSERT FALSE
			REPORT "SIMULATION SUCCESSFULLY ENDED!"
			SEVERITY FAILURE;
	END PROCESS;
	
	clk_gn	: clkGen PORT MAP(end_simulation, clk_distrib, rst_distrib_n);
	d_mkr	: dataMaker PORT MAP(clk_distrib, rst_distrib_n, adder_in, end_simulation);
	dut_1	: adder PORT MAP(clk_distrib, adder_in, adder_const, '1', adder_out);
	dut_2	: adder PORT MAP(clk_distrib, adder_in, adder_const, '0', sub_out);
	ad_snk	: dataSink GENERIC MAP(output_filename => "add_out.hex") PORT MAP(clk_distrib, rst_distrib_n, '1', adder_out);
	sb_snk	: dataSink GENERIC MAP(output_filename => "sub_out.hex") PORT MAP(clk_distrib, rst_distrib_n, '1', sub_out);
END ARCHITECTURE;
