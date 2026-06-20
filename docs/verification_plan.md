# Verification Plan: Simple AXI-Style Slave Memory

## Verification Objective

The objective is to verify the functional correctness and basic protocol behavior of a simplified AXI-style slave memory.

The verification plan focuses on:

- Correct write operation
- Correct read operation
- Correct write response generation
- Correct read response generation
- VALID/READY handshake behavior
- Master-side response backpressure
- Slave-side READY delay behavior
- Payload stability during stalled transfers
- Negative testing of protocol checker behavior

## Design Under Test
DUT:
simple_axi_slave

# Main RTL file:
rtl/simple_axi_slave.v
# Testbench file:
tb/simple_axi_slave_tb.v

## Verification Environment
The current verification environment is a directed Verilog testbench.
Main components:
Clock generator
Reset generator
AXI write task
AXI read task
Write-and-check task
Backpressure test tasks
Protocol stability checker
Pass/fail counter
Protocol error counter
VCD waveform dump


### Testbench Tasks ###

## axi_write ##
# Purpose:
Performs a single write transaction.
# Checks:
Write address handshake
Write data handshake
Write response completion

## axi_read ##
# Purpose:
Performs a single read transaction.
# Checks:
Read address handshake
Read data response completion

## write_and_check ##
# Purpose:
Writes data to an address, reads back from the same address, and compares actual data against expected data.
# Checks:
Memory storage correctness
Read-after-write behavior

## write_with_bready_delay ##
# Purpose:
Verifies that the slave holds BVALID until the master asserts BREADY.
# Checks:
Write response backpressure behavior

## read_with_rready_delay ##
# Purpose:
Verifies that the slave holds RVALID and RDATA until the master asserts RREADY.
# Checks:
Read data backpressure behavior
Read data stability under delayed RREADY

## inject_awaddr_stability_bug ##
# Purpose:
Intentionally violates the AXI stability rule by changing AWADDR while AWVALID=1 and AWREADY=0.
# Checks:
Protocol checker can detect address instability
This task is disabled during normal regression.


###                    Directed Test Scenarios                   ###

## Test ID	 Scenario	                                            Expected Result
    T01 	 Write/read address 0x00 with data 0x11111111	        Read data matches
    T02 	 Write/read address 0x04 with data 0x22222222	        Read data matches
    T03 	 Write/read address 0x08 with data 0x33333333	        Read data matches
    T04	     Write/read address 0x0C with data 0x44444444	        Read data matches
    T05	     Write with delayed BREADY                              Write response completes correctly
    T06 	 Read with delayed RREADY	                            Read data remains correct
    T07	     Write/read with delayed AWREADY, WREADY, and ARREADY	Transfer completes correctly
    T08	     Intentional AWADDR stability violation	                Protocol error detected


## Protocol Checks ##
# The testbench checks the following stability rules:
AWADDR must remain stable while AWVALID=1 and AWREADY=0.
WDATA must remain stable while WVALID=1 and WREADY=0.
ARADDR must remain stable while ARVALID=1 and ARREADY=0.
RDATA must remain stable while RVALID=1 and RREADY=0.
The checker uses previous-cycle stall tracking to avoid false failures when a new valid transaction begins.

## Pass/Fail Criteria ##
# Normal regression passes when:
fail_count == 0
protocol_error_count == 0
# Normal regression fails when:
fail_count > 0
# or:
protocol_error_count > 0
# Negative protocol test is expected to produce:
protocol_error_count > 0



### Simulation Command ###
# Compile:
iverilog -o sim\simple_axi_slave_tb.vvp rtl\simple_axi_slave.v tb\simple_axi_slave_tb.v
# Run:
vvp sim\simple_axi_slave_tb.vvp
# Open waveform:
gtkwave waves\simple_axi_slave_tb.vcd



## Current Verification Status ##
# Completed:
Directed write/read verification
Multiple address/data tests
Master-side response backpressure tests
Slave-side READY delay tests
Protocol stability checker
Negative checker validation

# Future improvements:
SystemVerilog interface
Transaction class
Randomized stimulus
Scoreboard model
Functional coverage
SVA assertions
UVM environment
AXI burst support
WSTRB support
Error response support