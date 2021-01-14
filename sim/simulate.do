vsim -t ns -novopt work.tb_RISCV_CPU_abs
wave add *
run 182 ns
quit -f
