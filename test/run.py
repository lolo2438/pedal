from vunit import VUnit

vu = VUnit.from_argv(compile_builtins=False)
vu.add_vhdl_builtins()
vu.add_osvvm()

riscv_lib = vu.add_library("riscv")
riscv_lib.add_source_files("../riscv/*.vhd")


pedal = vu.add_library("pedal")
# Pkgs
pedal.add_source_files("../pkg/*.vhd")
# DSP
pedal.add_source_files("../dsp/*.vhd")

# TB sources
pedal.add_source_files("*.vhd")

vu.main()
