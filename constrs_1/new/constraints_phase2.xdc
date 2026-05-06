set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

## CLOCK
set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports {CLK}]
create_clock -name sys_clk_pin -period 361.7 -waveform {0 180.850} [get_ports {CLK}]

## Clock uncertainty 
set_clock_uncertainty 2.0 [get_clocks sys_clk_pin]

## RESET
set_property -dict { PACKAGE_PIN A8 IOSTANDARD LVCMOS33 } [get_ports {nrst}]
set_false_path -from [get_ports {nrst}] ##for the timing warning

## INPUT DELAYS
# set_input_delay 2.0 -max -clock sys_clk_pin [get_ports {pixel_in[*]}]
# set_input_delay 0.0 -min -clock sys_clk_pin [get_ports {pixel_in[*]}]


## OUTPUT DELAYS
## Output delay = 25% of clock period
## 0.25 x 361.700 ns = 90.425 ns

## row output delay
# set_output_delay 90.425 -max -clock sys_clk_pin [get_ports {row[*]}]
# set_output_delay 0.0    -min -clock sys_clk_pin [get_ports {row[*]}]

## col output delay
# set_output_delay 90.425 -max -clock sys_clk_pin [get_ports {col[*]}]
# set_output_delay 0.0    -min -clock sys_clk_pin [get_ports {col[*]}]

## coeff output delay
# set_output_delay 90.425 -max -clock sys_clk_pin [get_ports {coeff[*]}]
# set_output_delay 0.0    -min -clock sys_clk_pin [get_ports {coeff[*]}]

## pixel_out output delay
# set_output_delay 90.425 -max -clock sys_clk_pin [get_ports {pixel_out[*]}]
# set_output_delay 0.0    -min -clock sys_clk_pin [get_ports {pixel_out[*]}]

## pixel_valid output delay
set_output_delay 90.425 -max -clock sys_clk_pin [get_ports {pixel_valid}]
set_output_delay 0.0    -min -clock sys_clk_pin [get_ports {pixel_valid}]

## done output delay
set_output_delay 90.425 -max -clock sys_clk_pin [get_ports {done}]
set_output_delay 0.0    -min -clock sys_clk_pin [get_ports {done}]

## hold output delay
# set_output_delay 90.425 -max -clock sys_clk_pin [get_ports {hold}]
# set_output_delay 0.0    -min -clock sys_clk_pin [get_ports {hold}]

## req output delay
set_output_delay 90.425 -max -clock sys_clk_pin [get_ports {req}]
set_output_delay 0.0    -min -clock sys_clk_pin [get_ports {req}]