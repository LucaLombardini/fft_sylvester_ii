LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.cupack.all;
USE work.definespack.all;

ENTITY pipe_machine IS
	PORT(	CLK	: IN std_logic;
		RST_n	: IN std_logic;
		START	: IN std_logic;
		DONE	: IN std_logic;
		W_IN	: IN signed(io_width*n_coef-1 DOWNTO 0);
		W_OUT	: OUT signed(io_width*n_coef-1 DOWNTO 0));
END ENTITY;

ARCHITECTURE behav OF pipe_machine IS

	COMPONENT reg IS
		GENERIC(bitwidth: positive	:= 8);
		PORT(	CLK	: IN std_logic;
		    	RST_n	: IN std_logic;
			LD	: IN std_logic;
			D_IN	: IN signed(bitwidth-1 DOWNTO 0);
			D_OUT	: OUT signed(bitwidth-1 DOWNTO 0));
	END COMPONENT;

	TYPE state_enum IS (IDLE, LD_R, LD_I, ADV_1, ADV_2, WAIT_EVENT, KLD_R,KLD_R);
	SIGNAL present_state, next_state : state_enum;
	SIGNAL pipe0_ld, pipe1_ld, pipe2_ld, pipe3_ld : std_logic;
	SIGNAL pipe0_out, pipe1_out, pipe2_out : signed(io_width*n_coef-1 DOWNTO 0);

BEGIN

	state_update: PROCESS(CLK, RST_n)
	BEGIN
		IF RST_n = '0' THEN
			present_state <= IDLE;
		ELSIF CLK'EVENT AND CLK = '0' THEN
			present_state <= next_state;
		END IF;
	END PROCESS;

	sequencer: PROCESS(present_state, START, DONE)
	BEGIN
		CASE present_state IS
			WHEN IDLE	=>	IF START = '1' THEN
							next_state <= LD_R;
						ELSE
							next_state <= IDLE;
						END IF;
			WHEN LD_R	=>	next_state <= LD_I;
			WHEN LD_I	=>	next_state <= ADV_1;
			WHEN ADV_1	=>	next_state <= ADV_2;
			WHEN ADV_2	=>	next_state <= WAIT_EVENT;
			WHEN WAIT_EVENT	=>	IF DONE = '1' THEN
							next_state <= ADV_1;
						ELSIF START = '1'THEN
							next_state <= KLD_R;
						ELSE
							next_state <=WAIT_EVENT;
						END IF;
			WHEN KLD_R	=>	next_state <= KLD_I;
			WHEN KLD_I	=>	next_state <= WAIT_EVENT;
			WHEN OTHERS	=>	next_state <= IDLE;
		END CASE;
	END PROCESS;

	command_generator: PROCESS(present_state)
	BEGIN
		CASE present_state IS
			WHEN IDLE	=>	pipe0_ld <= '0';
						pipe1_ld <= '0';
						pipe2_ld <= '0';
						pipe3_ld <= '0';

			WHEN LD_R	=>	pipe0_ld <= '1';
						pipe1_ld <= '0';
						pipe2_ld <= '0';
						pipe3_ld <= '0';

			WHEN LD_I	=>	pipe0_ld <= '1';
						pipe1_ld <= '1';
						pipe2_ld <= '0';
						pipe3_ld <= '0';

			WHEN ADV_1	=>	pipe0_ld <= '1';
						pipe1_ld <= '1';
						pipe2_ld <= '1';
						pipe3_ld <= '1';

			WHEN ADV_2	=>	pipe0_ld <= '1';
						pipe1_ld <= '1';
						pipe2_ld <= '1';
						pipe3_ld <= '1';
						
			WHEN WAIT_EVENT	=>	pipe0_ld <= '0';
						pipe1_ld <= '0';
						pipe2_ld <= '0';
						pipe3_ld <= '0';

			WHEN KLD_R	=>	pipe0_ld <= '1';
						pipe1_ld <= '0';
						pipe2_ld <= '0';
						pipe3_ld <= '0';

			WHEN KLD_I	=>	pipe0_ld <= '1';
						pipe1_ld <= '1';
						pipe2_ld <= '0';
						pipe3_ld <= '0';
		END CASE;
	END PROCESS;

	regpipe0: reg GENERIC MAP(io_width*n_coef) PORT MAP(CLK, RST_n,
				 			pipe0_ld,
							W_IN,
							pipe0_out);
	regpipe1: reg GENERIC MAP(io_width*n_coef) PORT MAP(CLK, RST_n,
				 			pipe1_ld,
							pipe0_out,
							pipe1_out);
	regpipe2: reg GENERIC MAP(io_width*n_coef) PORT MAP(CLK, RST_n,
				 			pipe2_ld,
							pipe1_out,
							pipe2_out);
	regpipe3: reg GENERIC MAP(io_width*n_coef) PORT MAP(CLK, RST_n,
				 			pipe3_ld,
							pipe2_out,
							W_OUT);

END ARCHITECTURE;
