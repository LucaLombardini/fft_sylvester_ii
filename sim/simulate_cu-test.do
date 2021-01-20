vsim -t ns -novopt work.tb_cu
add wave *
run 2000 ns
quit -f
