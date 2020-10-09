
derive_pll_clocks -create_base_clocks


derive_clock_uncertainty


set_time_format -unit ns -decimal_places 3

create_clock -name {clock_50_i}  -period 20.000  [get_ports {clock_50_i}]

create_clock -name {SPI_SCK}  -period 27.777  [get_ports {SPI_SCK}]




#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock_fall -clock [get_clocks {clock_50_i}]  1.000 [get_ports {clock_50_i}]
set_input_delay -add_delay  -clock_fall -clock [get_clocks {SPI_SCK}]  1.000 [get_ports {SPI_DI}]
set_input_delay -add_delay  -clock_fall -clock [get_clocks {SPI_SCK}]  1.000 [get_ports {SPI_SCK}]
set_input_delay -add_delay  -clock_fall -clock [get_clocks {SPI_SCK}]  1.000 [get_ports {SPI_SS2}]



#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay   -clock [get_clocks {SPI_SCK}] 1.000 [get_ports {SPI_DO}]



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {SPI_SCK}] -group [get_clocks {pll|altpll_component|auto_generated|pll1|clk[*]}]


#**************************************************************
# Set False Path
#**************************************************************

# Put constraints on input ports
set_false_path -from [get_ports {btn_*}] -to *

# Put constraints on output ports
set_false_path -from * -to [get_ports {LED*}]
set_false_path -from * -to [get_ports {VGA_*}]
set_false_path -from * -to [get_ports {AUDIO_L}]
set_false_path -from * -to [get_ports {AUDIO_R}]

