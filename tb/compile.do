#create work library
vlib work

#compile vhdl file taking into account hierarchy
vcom ../src/keccak_globals.vhd
vcom ../src/keccak_round_constants_gen.vhd
vcom ../src/keccak_round.vhd
vcom ../src/Keccak_REG.vhd
vcom ../src/Keccak_core.vhd
vcom ../src/Keccak_2to1mux.vhd
vcom ../src/Keccak_4to1mux.vhd
vcom ../src/bN_2to1mux.vhd
vcom ../src/PAD_SHA3_256.vhd
vcom ../src/PAD_SHA3_512.vhd
vcom ../src/PAD_SHAKE_128.vhd
vcom ../src/PAD_SHAKE_256.vhd
vcom ../src/PADDING.vhd
vcom ../src/TRUNC.vhd
vcom ../src/VSX_MODULE.vhd
vcom ../src/SHA3.vhd

vcom ../tb/tb_SHA3_256.vhd


#launch simulation
vsim -gui work.tb_SHA3_256

#open run time file
source ./wave_do/WAVE_SHA3_256

#quit modelsim
quit -f
