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

	TYPE state_enum IS (IDLE, LD_WR1, LD_WI1, ADV_WR1, ADV_WI1, ATTENTION, LD_WR2, LD_WI2, WAIT_DONE_C, PIPE_ADV1, PIPE_ADV2, SNDWI1, PREWR2, WAIT_DONE_S, SNDWIX);
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
		VARIABLE switcher : std_logic_vector(1 DOWNTO 0);
	BEGIN
		switcher(1) := DONE;
		switcher(0) := START;
		CASE present_state IS
			WHEN IDLE	=>	IF START = '1' THEN
							next_state <= LD_WR1;
						ELSE
							next_state <= IDLE;
						END IF;
			WHEN LD_WR1	=>	next_state <= LD_WI1;
			WHEN LD_WI1	=>	next_state <= ADV_WR1;
			WHEN ADV_WR1	=>	next_state <= ADV_WI1;
			WHEN ADV_WI1	=>	next_state <= ATTENTION;
			WHEN ATTENTION	=>	IF START = '1' THEN
							next_state <= LD_WR2;
						ELSE
							next_state<=WAIT_DONE_S;
						END IF;
			WHEN LD_WR2	=>	next_state <= LD_WI2;
			WHEN LD_WI2	=>	next_state <= WAIT_DONE_C;
			WHEN WAIT_DONE_C=>	CASE switcher IS
							WHEN "00" => next_state <= WAIT_DONE_C;
							WHEN "01" => next_state <= WAIT_DONE_C;
							WHEN "10" => next_state <= SNDWI1;
							WHEN OTHERS => next_state <= PIPE_ADV1;
						END CASE;
			WHEN SNDWI1	=>	next_state <= PREWR2;
			WHEN PREWR2	=>	next_state <= WAIT_DONE_S;
			WHEN PIPE_ADV1	=>	next_state <= PIPE_ADV2;
			WHEN PIPE_ADV2	=>	next_state <= WAIT_DONE_C;
			WHEN WAIT_DONE_S=>	IF DONE = '1' THEN
							next_state <= SNDWIX;
						ELSE
							next_state <= WAIT_DONE_S;
						END IF;
			WHEN SNDWIX	=>	next_state <= IDLE;
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

			WHEN LD_WR1	=>	pipe0_ld <= '1';
						pipe1_ld <= '0';
						pipe2_ld <= '0';
						pipe3_ld <= '0';

			WHEN LD_WI1	=>	pipe0_ld <= '1';
						pipe1_ld <= '1';
						pipe2_ld <= '0';
						pipe3_ld <= '0';

			WHEN ADV_WR1	=>	pipe0_ld <= '0';
						pipe1_ld <= '1';
						pipe2_ld <= '1';
						pipe3_ld <= '0';

			WHEN ADV_WI1	=>	pipe0_ld <= '0';
						pipe1_ld <= '0';
						pipe2_ld <= '1';
						pipe3_ld <= '1';
						
			WHEN ATTENTION	=>	pipe0_ld <= '0';
						pipe1_ld <= '0';
						pipe2_ld <= '0';
						pipe3_ld <= '0';

			WHEN LD_WR2	=>	pipe0_ld <= '1';
						pipe1_ld <= '0';
						pipe2_ld <= '0';
						pipe3_ld <= '0';

			WHEN LD_WI2	=>	pipe0_ld <= '1';
						pipe1_ld <= '1';
						pipe2_ld <= '0';
						pipe3_ld <= '0';

			WHEN WAIT_DONE_C=>	pipe0_ld <= '0';
						pipe1_ld <= '0';
						pipe2_ld <= '0';
						pipe3_ld <= '0';
			
			WHEN SNDWI1	=>	pipe0_ld <= '1';
						pipe1_ld <= '1';
						pipe2_ld <= '1';
						pipe3_ld <= '1';
	
			WHEN PREWR2	=>	pipe0_ld <= '1';
						pipe1_ld <= '1';
						pipe2_ld <= '1';
						pipe3_ld <= '1';

			WHEN PIPE_ADV1	=>	pipe0_ld <= '1';
						pipe1_ld <= '1';
						pipe2_ld <= '1';
						pipe3_ld <= '1';

			WHEN PIPE_ADV2	=>	pipe0_ld <= '1';
						pipe1_ld <= '1';
						pipe2_ld <= '1';
						pipe3_ld <= '1';
	
	
			WHEN WAIT_DONE_S=>	pipe0_ld <= '0';
						pipe1_ld <= '0';
						pipe2_ld <= '0';
						pipe3_ld <= '0';

			WHEN SNDWIX	=>	pipe0_ld <= '0';
						pipe1_ld <= '0';
						pipe2_ld <= '0';
						pipe3_ld <= '1';
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
