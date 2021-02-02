vsim -t ns -novopt work.tb_fft
add wave *
add wave sim:/tb_fft/dut_fft/*
add wave sim:/tb_fft/dut_fft/lv1_gr0_but0/*
add wave sim:/tb_fft/dut_fft/pipe0/*
run 1 us
