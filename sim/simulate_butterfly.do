vsim -t ns -novopt work.tb_butterfly
add wave *
add wave sim:/tb_butterfly/dut_butterfly/datapath/*
add wave sim:/tb_butterfly/dut_butterfly/datapath/multiplier_op/D_M_n
add wave sim:/tb_butterfly/dut_butterfly/datapath/mux1_bus2_sum1/*
add wave sim:/tb_butterfly/dut_butterfly/datapath/mux2_prod_mux1/*
add wave sim:/tb_butterfly/dut_butterfly/datapath/mux3_sum1_prod/*
add wave sim:/tb_butterfly/dut_butterfly/datapath/adder1/S_A_n
add wave sim:/tb_butterfly/dut_butterfly/datapath/mux4_bus2_sum2/*
add wave sim:/tb_butterfly/dut_butterfly/datapath/adder2/S_A_n
add wave sim:/tb_butterfly/dut_butterfly/datapath/mux5_round/*
run 750 ns
