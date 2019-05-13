## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

 ##Clock signal
##Bank = 34, Pin name = ,                    Sch name = CLK100MHZ
        set_property PACKAGE_PIN W5 [get_ports clock]
        set_property IOSTANDARD LVCMOS33 [get_ports clock]
        create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clock]

# Switches
set_property PACKAGE_PIN W19 [get_ports step1]
set_property IOSTANDARD LVCMOS33 [get_ports step1]

set_property PACKAGE_PIN U17 [get_ports go1]
set_property IOSTANDARD LVCMOS33 [get_ports go1]

set_property PACKAGE_PIN T17 [get_ports instr1]
set_property IOSTANDARD LVCMOS33 [get_ports instr1]

set_property PACKAGE_PIN U18 [get_ports reset1]
set_property IOSTANDARD LVCMOS33 [get_ports reset1]

set_property PACKAGE_PIN V17 [get_ports {slide_sw[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {slide_sw[0]}]

set_property PACKAGE_PIN V16 [get_ports {slide_sw[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {slide_sw[1]}]

set_property PACKAGE_PIN W16 [get_ports {slide_sw[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {slide_sw[2]}]

set_property PACKAGE_PIN W17 [get_ports {slide_sw2[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {slide_sw2[0]}]

set_property PACKAGE_PIN W15 [get_ports {slide_sw2[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {slide_sw2[1]}]

set_property PACKAGE_PIN V15 [get_ports {slide_sw2[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {slide_sw2[2]}]

set_property PACKAGE_PIN W14 [get_ports {slide_sw2[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {slide_sw2[3]}]

set_property PACKAGE_PIN W13 [get_ports {slide_sw2[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {slide_sw2[4]}]

set_property PACKAGE_PIN V2 [get_ports {slide_sw2[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {slide_sw2[5]}]

set_property PACKAGE_PIN T3 [get_ports {slide_sw2[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {slide_sw2[6]}]

set_property PACKAGE_PIN T2 [get_ports {slide_sw2[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {slide_sw2[7]}]

set_property PACKAGE_PIN R3 [get_ports {slide_sw2[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {slide_sw2[8]}]

set_property PACKAGE_PIN W2 [get_ports {slide_sw2[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {slide_sw2[9]}]

set_property PACKAGE_PIN U1 [get_ports {slide_sw2[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {slide_sw2[10]}]

set_property PACKAGE_PIN T1 [get_ports {slide_sw2[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {slide_sw2[11]}]

# LEDs
set_property PACKAGE_PIN L1 [get_ports {light[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[0]}]

set_property PACKAGE_PIN P1 [get_ports {light[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[1]}]

set_property PACKAGE_PIN N3 [get_ports {light[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[2]}]

set_property PACKAGE_PIN P3 [get_ports {light[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[3]}]

set_property PACKAGE_PIN U3 [get_ports {light[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[4]}]

set_property PACKAGE_PIN W3 [get_ports {light[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[5]}]

set_property PACKAGE_PIN V3 [get_ports {light[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[6]}]

set_property PACKAGE_PIN V13 [get_ports {light[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[7]}]

set_property PACKAGE_PIN V14 [get_ports {light[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[8]}]

set_property PACKAGE_PIN U14 [get_ports {light[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[9]}]

set_property PACKAGE_PIN U15 [get_ports {light[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[10]}]

set_property PACKAGE_PIN W18 [get_ports {light[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[11]}]

set_property PACKAGE_PIN V19 [get_ports {light[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[12]}]

set_property PACKAGE_PIN U19 [get_ports {light[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[13]}]

set_property PACKAGE_PIN E19 [get_ports {light[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[14]}]

set_property PACKAGE_PIN U16 [get_ports {light[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[15]}]

#set_property PACKAGE
# Others (BITSTREAM, CONFIG)
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]

set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets reset_IBUF]
set_property SEVERITY {Warning} [get_drc_checks LUTLP-1] 