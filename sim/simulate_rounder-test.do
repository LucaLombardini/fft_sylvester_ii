vsim -t ns -novopt work.tb_rounder
wave add *
run -all
quit -f
