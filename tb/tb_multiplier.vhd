LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;

ENTITY tb_multiplier IS
END ENTITY;

ARCHITECTURE tb OF tb_multiplier IS

	COMPONENT multiplier IS
		PORT(	CLK	: IN std_logic;
			A	: IN signed(m_in_width-1 DOWNTO 0);
			B	: IN signed(m_in_width-1 DOWNTO 0);
			M_D_n	: IN std_logic;
			PROD	: OUT signed(prod_width-1 DOWNTO 0));
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
	SIGNAL mult_in		: signed(m_in_width-1 DOWNTO 0);
	SIGNAL mult_out	: signed(prod_width-1 DOWNTO 0);
	SIGNAL doub_out	: signed(prod_width-1 DOWNTO 0);
	
BEGIN

	simulation_ender: PROCESS
	BEGIN
		WAIT UNTIL end_simulation = '1';
		ASSERT FALSE
			REPORT "SIMULATION SUCCESSFULLY ENDED!"
			SEVERITY FAILURE;
	END PROCESS;
	
	clk_gn	: clkGen PORT MAP(end_simulation, clk_distrib, rst_distrib_n);
	d_mkr	: dataMaker PORT MAP(clk_distrib, rst_distrib_n, mult_in, end_simulation);
	dut_1	: multiplier PORT MAP(clk_distrib, mult_in, mult_const, '1', mult_out);
	dut_2	: multiplier PORT MAP(clk_distrib, mult_in, mult_const, '0', doub_out);
	mu_snk	: dataSink GENERIC MAP(output_filename => "mult_out.hex") PORT MAP(clk_distrib, rst_distrib_n, '1', mult_out);
	do_snk	: dataSink GENERIC MAP(output_filename => "doub_out.hex") PORT MAP(clk_distrib, rst_distrib_n, '1', doub_out);
END ARCHITECTURE;
