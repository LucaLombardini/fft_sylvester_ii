LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;

ENTITY tb_reg_file IS
END ENTITY;

ARCHITECTURE tb OF tb_reg_file IS

	COMPONENT register_file IS
		GENERIC(addr_width	: positive	:= 4;
			data_width	: positive	:= 8;
			wr_ports	: positive	:= 1;
			rd_ports	: positive	:= 1);
		PORT(	CLK		: IN std_logic;
			WR		: IN std_logic;
			WR_ADDR	: IN unsigned(wr_ports*addr_width-1 DOWNTO 0);
			WR_DATA	: IN signed(wr_ports*data_width-1 DOWNTO 0);
			RD_ADDR	: IN unsigned(rd_ports*addr_width-1 DOWNTO 0);
			RD_DATA	: OUT signed(rd_ports*data_width));
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
	SIGNAL wr_sig		: std_logic(rf_wr_test-1 DOWNTO 0);
	SIGNAL data_in		: signed(rf_wr_test*rf_data_test-1 DOWNTO 0);
	SIGNAL data_out	: signed(rf_rd_test*rf_data_test-1 DOWNTO 0);
	SIGNAL addr_in		: unsigned(rf_wr_test*rf_addr_test-1 DOWNTO 0);
	SIGNAL addr_out	: unsigned(rf_rd_test*rf_addr_test-1 DOWNTO 0);
		
BEGIN

	simulation_ender: PROCESS
	BEGIN
		WAIT UNTIL end_simulation = '1';
		ASSERT FALSE
			REPORT "SIMULATION SUCCESSFULLY ENDED!"
			SEVERITY FAILURE;
	END PROCESS;

	write_address_gen: PROCESS(rst_distrib_n, clk_distrib)
		VARIABLE tmp	: unsigned(rf_addr_test-1 DOWNTO 0);
	BEGIN
		IF rst_distrib_n = '0' THEN
			FOR i IN 0 TO rf_wr_test-1 LOOP
				addr_in((i+1)*rf_addr_test-1 DOWNTO i*rf_addr_test) <= to_signed(i,rf_addr_test);
			END LOOP;
			wr_sig <= (OTHERS => '1');
		ELSIF clk_distrib'EVENT AND clk_distrib = '1' THEN
			FOR i IN 0 TO rf_wr_test-1 LOOP
				IF i = 0 THEN
					tmp := addr_in(rf_addr_test-1 DOWNTO 0);
					addr_in(rf_addr_test-1 DOWNTO 0) <= addr_in(rf_wr_test*rf_addr_test-1 DOWNTO (rf_wr_test-1)*rf_addr_test);
				ELSIF i = rf_wr_test-1 THEN
					addr_in((i+1)*rf_addr_test-1 DOWNTO i*rf_addr_test) <= addr_in(i*rf_addr_test-1 DOWNTO (i-1)*rf_addr_test);
				ELSE
					addr_in(rf_wr_test*rf_addr_test-1 DOWNTO (rf_wr_test-1)*rf_addr_test) <= tmp;
				END IF;
			END LOOP;
		END IF;
	END PROCESS;

	clk_gn	: clkGen PORT MAP(end_simulation, clk_distrib, rst_distrib_n);
	d_mkr	: dataMaker GENERIC MAP(input_filename => "reg_file_in.hex") PORT MAP(clk_distrib, rst_distrib_n, data_in, end_simulation);
	dut	: register_file GENERIC MAP(addr_width => rf_addr_test; data_width => rf_data_test; wr_ports = rf_wr_test; rd_ports => rf_rd_test) PORT MAP(clk_distrib, wr_sig, addr_in, data_in, addr_out, data_out);
	d_snk	: dataSink GENERIC MAP(output_filename => "reg_file_out.hex") PORT MAP(clk_distrib, rst_distrib_n, '1', data_out);
END ARCHITECTURE;
