vsim -t ns -novopt work.tb_adder
wave add *
run -all
quit -f
