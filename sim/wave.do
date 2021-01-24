onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_butterfly/clk_dist
add wave -noupdate -format Logic /tb_butterfly/rst_n_dist
add wave -noupdate -format Logic /tb_butterfly/start_dist
add wave -noupdate -format Logic /tb_butterfly/end_sim_dist
add wave -noupdate -format Logic /tb_butterfly/mode_dist
add wave -noupdate -format Logic /tb_butterfly/done_dist
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/d_in
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/c_in
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/d_out
add wave -noupdate -format Literal /tb_butterfly/dut_butterfly/datapath/ctrl_word
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/data_out
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/databus2
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/bus2_allign
add wave -noupdate -format Literal /tb_butterfly/dut_butterfly/datapath/rfd_addr_wr
add wave -noupdate -format Literal /tb_butterfly/dut_butterfly/datapath/rfd_addr_rd
add wave -noupdate -divider MULT
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/databus1
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/coeffbus
add wave -noupdate -format Logic /tb_butterfly/dut_butterfly/datapath/multiplier_op/d_m_n
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/mult_out
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/mult_line
add wave -noupdate -divider MUX1
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/mux1_bus2_sum1/a
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/mux1_bus2_sum1/b
add wave -noupdate -format Logic /tb_butterfly/dut_butterfly/datapath/mux1_bus2_sum1/sel
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/mux1_bus2_sum1/y
add wave -noupdate -divider MUX2
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/mux2_prod_mux1/a
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/mux2_prod_mux1/b
add wave -noupdate -format Logic /tb_butterfly/dut_butterfly/datapath/mux2_prod_mux1/sel
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/mux2_prod_mux1/y
add wave -noupdate -divider MUX3
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/mux3_sum1_prod/a
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/mux3_sum1_prod/b
add wave -noupdate -format Logic -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/mux3_sum1_prod/sel
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/mux3_sum1_prod/y
add wave -noupdate -divider ADDER1
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/add1_porta
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/add1_portb
add wave -noupdate -format Logic /tb_butterfly/dut_butterfly/datapath/adder1/s_a_n
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/add1_line
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/add1_out
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/chosen_src
add wave -noupdate -divider MUX4
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/mux4_bus2_sum2/a
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/mux4_bus2_sum2/b
add wave -noupdate -format Logic /tb_butterfly/dut_butterfly/datapath/mux4_bus2_sum2/sel
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/mux4_bus2_sum2/y
add wave -noupdate -divider ADDER2
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/mult_line
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/add2_portb
add wave -noupdate -format Logic /tb_butterfly/dut_butterfly/datapath/adder2/s_a_n
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/add2_out
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/add2_line
add wave -noupdate -divider ROUNDER
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/rndr_in
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/rndr_out
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/mux5_round/a
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/mux5_round/b
add wave -noupdate -format Logic /tb_butterfly/dut_butterfly/datapath/mux5_round/sel
add wave -noupdate -format Literal -radix hexadecimal /tb_butterfly/dut_butterfly/datapath/mux5_round/y
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {165 ns} 0}
configure wave -namecolwidth 578
configure wave -valuecolwidth 234
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {0 ns} {191 ns}
