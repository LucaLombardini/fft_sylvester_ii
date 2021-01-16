LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;

ENTITY register_file IS
	GENERIC(addr_width	: positive	:= 4;
		data_width	: positive	:= 8;
		wr_ports	: positive	:= 1;
		rd_ports	: positive	:= 1);
	PORT(	CLK		: IN std_logic;
		WR		: IN std_logic_vector(wr_ports-1 DOWNTO 0);
		WR_ADDR	: IN unsigned(wr_ports*addr_width-1 DOWNTO 0);
		WR_DATA	: IN signed(wr_ports*data_width-1 DOWNTO 0);
		RD_ADDR	: IN unsigned(rd_ports*addr_width-1 DOWNTO 0);
		RD_DATA	: OUT signed(rd_ports*data_width-1 DOWNTO 0));
END ENTITY;



ARCHITECTURE behav OF register_file IS
	SUBTYPE reg_locs IS NATURAL RANGE 0 TO 2**(addr_width);
	TYPE reg_array IS ARRAY(reg_locs) OF signed(data_width-1 DOWNTO 0);
	SIGNAL register_block	: reg_array;
BEGIN
	read_define: PROCESS(RD_ADDR, register_block)
	BEGIN
		FOR i IN 0 TO rd_ports-1 LOOP
			RD_DATA((i+1)*data_width-1 DOWNTO i*data_width) <= register_block(to_integer(RD_ADDR((i+1)*addr_width-1 DOWNTO i*addr_width)));
		END LOOP;
	END PROCESS;

	write_define:PROCESS(CLK)
	BEGIN
		IF CLK'EVENT AND CLK = '1' THEN
			--IF WR = '1' THEN
			FOR j IN 0 TO wr_ports-1 LOOP
				IF WR(j) = '1' THEN
					register_block(to_integer(WR_ADDR((j+1)*addr_width-1 DOWNTO j*addr_width))) <= WR_DATA((j+1)*data_width-1 DOWNTO j*data_width);
				END IF;
			END LOOP;
			--END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE;
