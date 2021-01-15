vsim -t ns -novopt work.tb_reg_file
wave add *
run -all
quit -f
