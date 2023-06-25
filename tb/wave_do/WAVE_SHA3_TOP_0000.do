add wave -position insertpoint  sim:/tb_sha3_top_0000/CLK
add wave -position insertpoint  sim:/tb_sha3_top_0000/RST_N
add wave -position insertpoint  sim:/tb_sha3_top_0000/SHA3_TOP_START
add wave -position insertpoint  sim:/tb_sha3_top_0000/SHA3_TOP_MODE
add wave -position insertpoint  sim:/tb_sha3_top_0000/SHA3_TOP_OP
add wave -position insertpoint -color Turquoise sim:/tb_sha3_top_0000/st
add wave -divider STATE
add wave -position insertpoint -color Magenta sim:/tb_sha3_top_0000/i_SHA3/y
add wave -divider INPUT_BUFFER
add wave -position insertpoint -color Orchid  -radix  hex sim:/tb_sha3_top_0000/SHA3_TOP_INPUT
add wave -divider INPUT_BUFFER
add wave -position insertpoint -color SkyBlue sim:/tb_sha3_top_0000/i_SHA3/i_ACQUISITION_BLOCK/y
add wave -position insertpoint -color SkyBlue sim:/tb_sha3_top_0000/i_SHA3/i_ACQUISITION_BLOCK/AB_ready
add wave -position insertpoint -color SkyBlue sim:/tb_sha3_top_0000/i_SHA3/i_ACQUISITION_BLOCK/AB_done
add wave -position insertpoint -color SkyBlue -radix unsigned sim:/tb_sha3_top_0000/i_SHA3/i_ACQUISITION_BLOCK/count_A_out
add wave -position insertpoint -color SkyBlue -radix hex sim:/tb_sha3_top_0000/i_SHA3/i_ACQUISITION_BLOCK/AB_OUT
add wave -divider STREAM_CONTROL
add wave -position insertpoint -color SkyBlue -radix  hex sim:/tb_sha3_top_0000/i_SHA3/i_STREAM_CONTROL/SC_stream_in
add wave -position insertpoint -color DarkOrchid sim:/tb_sha3_top_0000/i_SHA3/i_STREAM_CONTROL/y
add wave -position insertpoint  -color LimeGreen sim:/tb_sha3_top_0000/i_SHA3/SC_DONE
add wave -position insertpoint -color DarkOrchid sim:/tb_sha3_top_0000/i_SHA3/i_STREAM_CONTROL/SC_AB_READY
add wave -position insertpoint -color DarkOrchid sim:/tb_sha3_top_0000/i_SHA3/i_STREAM_CONTROL/SC_SHA3_READY
add wave -position insertpoint -color DarkOrchid sim:/tb_sha3_top_0000/i_SHA3/one_stream_op
add wave -divider LAST_STREAM
add wave -position insertpoint -color LimeGreen sim:/tb_sha3_top_0000/i_SHA3/i_STREAM_CONTROL/count5_rst_n
add wave -position insertpoint -color LimeGreen sim:/tb_sha3_top_0000/i_SHA3/i_STREAM_CONTROL/count5_en
add wave -position insertpoint -color LimeGreen -radix unsigned sim:/tb_sha3_top_0000/i_SHA3/i_STREAM_CONTROL/r_cycles
add wave -position insertpoint -radix unsigned sim:/tb_sha3_top_0000/i_SHA3/i_STREAM_CONTROL/i_last_block/COMPARATOR_EQ_IN1
add wave -position insertpoint sim:/tb_sha3_top_0000/i_SHA3/i_STREAM_CONTROL/SC_last_block
add wave -divider REG1_REG2_REG3
add wave -position insertpoint sim:/tb_sha3_top_0000/i_SHA3/i_STREAM_CONTROL/SEL_MUX_stream
add wave -position insertpoint -color SkyBlue -radix  hex sim:/tb_sha3_top_0000/i_SHA3/i_STREAM_CONTROL/SC_stream_out
add wave -divider PADDING
add wave -position insertpoint -color Orange -radix  hex sim:/tb_sha3_top_0000/i_SHA3/i_PADDING/PADD_MESS_IN
add wave -position insertpoint -color Orange sim:/tb_sha3_top_0000/i_SHA3/i_PADDING/PADD_LAST_BLOCK
add wave -position insertpoint -color Orange -radix  hex sim:/tb_sha3_top_0000/i_SHA3/i_PADDING/PADD_MESS_OUT
add wave -position insertpoint sim:/tb_sha3_top_0000/i_SHA3/sel_mux_padding
add wave -divider SHA3_CORE
add wave -position insertpoint -color Magenta sim:/tb_sha3_top_0000/i_SHA3/i_SHA3_CORE/y
add wave -position insertpoint -color Orange -radix  hex sim:/tb_sha3_top_0000/i_SHA3/i_SHA3_CORE/SHA3_MESSAGE
add wave -position insertpoint -color Magenta sim:/tb_sha3_top_0000/i_SHA3/i_SHA3_CORE/SHA3_ROUND
add wave -position insertpoint -color Gold sim:/tb_sha3_top_0000/i_SHA3/i_SHA3_CORE/SHA3_START
add wave -divider FEEDBACK
add wave -position insertpoint  -radix hex -color Khaki sim:/tb_sha3_top_0000/i_SHA3/i_SHA3_CORE/Feedback_State_delayed
add wave -position insertpoint  -radix hex -color Khaki sim:/tb_sha3_top_0000/i_SHA3/i_SHA3_CORE/VSX_State_S
add wave -position insertpoint  -radix hex -color Khaki sim:/tb_sha3_top_0000/i_SHA3/i_SHA3_CORE/VSX_mod/VSX_OUT_STATE
add wave -position insertpoint  -radix hex -color Khaki sim:/tb_sha3_top_0000/i_SHA3/i_SHA3_CORE/VSX_mod/XORED_State_S
add wave -divider MUX01
add wave -position insertpoint -radix hex -color Khaki  sim:/tb_sha3_top_0000/i_SHA3/i_SHA3_CORE/mux01/x
add wave -position insertpoint -radix hex -color Khaki  sim:/tb_sha3_top_0000/i_SHA3/i_SHA3_CORE/mux01/y
add wave -position insertpoint -radix hex -color Khaki  sim:/tb_sha3_top_0000/i_SHA3/i_SHA3_CORE/mux01/output
add wave -position insertpoint  sim:/tb_sha3_top_0000/i_SHA3/i_SHA3_CORE/mux02_control
add wave -divider KECCAK
add wave -position insertpoint -radix  unsigned  sim:/tb_sha3_top_0000/i_SHA3/i_SHA3_CORE/Keccak/Keccak_nr_round
add wave -position insertpoint -color Magenta sim:/tb_sha3_top_0000/i_SHA3/i_SHA3_CORE/permutation_computed
add wave -position insertpoint -color Magenta sim:/tb_sha3_top_0000/i_SHA3/i_SHA3_CORE/SHA3_READY
add wave -position insertpoint -color Magenta sim:/tb_sha3_top_0000/i_SHA3/i_SHA3_CORE/SHA3_DONE
add wave -divider OUTPUT
add wave -position insertpoint -color CornflowerBlue  -radix  hex sim:/tb_sha3_top_0000/SHA3_DONE
add wave -position insertpoint -color CornflowerBlue  -radix  hex sim:/tb_sha3_top_0000/SHA3_OUT

run
