# Simulation Results: Simple AXI-Style Slave Memory

## Simulation Tool

# The design was compiled and simulated using:
Icarus Verilog 12.0

# Waveforms were generated in VCD format and viewed using:
GTKWave

##  Files Simulated  ##
# RTL:
rtl/simple_axi_slave.v
# Testbench:
tb/simple_axi_slave_tb.v


# Compile Command
iverilog -o sim\simple_axi_slave_tb.vvp rtl\simple_axi_slave.v tb\simple_axi_slave_tb.v
# Run Command
vvp sim\simple_axi_slave_tb.vvp
# Waveform Command
gtkwave waves\simple_axi_slave_tb.vcd


## Normal Regression Output
WRITE: addr=00000000 data=11111111 response=00
READ : addr=00000000 data=11111111 response=00
CHECK PASS: addr=00000000 expected=11111111 actual=11111111

WRITE: addr=00000004 data=22222222 response=00
READ : addr=00000004 data=22222222 response=00
CHECK PASS: addr=00000004 expected=22222222 actual=22222222

WRITE: addr=00000008 data=33333333 response=00
READ : addr=00000008 data=33333333 response=00
CHECK PASS: addr=00000008 expected=33333333 actual=33333333

WRITE: addr=0000000c data=44444444 response=00
READ : addr=0000000c data=44444444 response=00
CHECK PASS: addr=0000000c expected=44444444 actual=44444444

WRITE WITH BREADY DELAY: addr=00000010 data=aaaa5555 delay=3 response=00
RREADY DELAY CHECK PASS: addr=00000010 expected=aaaa5555 actual=aaaa5555 delay=4

WRITE: addr=00000014 data=cafebabe response=00
READ : addr=00000014 data=cafebabe response=00
CHECK PASS: addr=00000014 expected=cafebabe actual=cafebabe

TEST SUMMARY
PASS COUNT = 6
FAIL COUNT = 0
PROTOCOL ERROR COUNT = 0
OVERALL RESULT: TEST PASSED


# Negative Test Output
The intentional protocol bug test was enabled separately to validate the protocol checker.
# Injected violation:
AWADDR changed while AWVALID=1 and AWREADY=0
# Detected output:
PROTOCOL ERROR: AWADDR changed while AWVALID=1 and AWREADY=0
PROTOCOL ERROR COUNT = 1
OVERALL RESULT: TEST FAILED
This failure is expected during negative testing.

###             Verified Features              ###
# Feature	                                Status
RTL syntax compilation	                    PASS
Single write transaction	                PASS
Single read transaction	                    PASS
Multiple write/read tests	                PASS
Read-after-write data checking	            PASS
Write response generation	                PASS
Read response generation	                PASS
Delayed BREADY handling     	            PASS
Delayed RREADY handling	                    PASS
Delayed AWREADY handling	                PASS
Delayed WREADY handling	                    PASS
Delayed ARREADY handling	                PASS
Payload stability checker	                PASS
Intentional protocol violation detection	PASS


## Waveform Observations
# Important waveform behaviors observed:
AWVALID && AWREADY marks write address acceptance.
WVALID && WREADY marks write data acceptance.
BVALID remains asserted until BREADY.
ARVALID && ARREADY marks read address acceptance.
RVALID remains asserted until RREADY.
RDATA remains stable while RVALID=1 and RREADY=0.
During READY delay tests, address/data signals remain stable while waiting for handshake.

## Current Signoff Criteria
# The current milestone is considered passed when:
PASS COUNT = 6
FAIL COUNT = 0
PROTOCOL ERROR COUNT = 0
OVERALL RESULT: TEST PASSED