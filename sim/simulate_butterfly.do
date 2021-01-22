vsim -t ns -novopt work.tb_butterfly
add wave *
add wave sim:/tb_butterfly/dut_butterfly/datapath/*
run 400 ns
