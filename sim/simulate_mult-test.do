vsim -t ns -novopt work.tb_multiplier
wave add *
run -all
quit -f
