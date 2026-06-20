# Simple AXI-Style Slave Memory Architecture

## Project Objective

This project implements a simplified AXI-style slave memory to understand basic SoC bus communication and verification concepts.

The design is intended as a beginner-to-industry bridge for learning:

- AXI channel behavior
- VALID/READY handshaking
- Write and read transactions
- Backpressure handling
- Protocol stability checking
- Directed verification methodology

## Design Scope

This design supports:

- Single-clock operation
- Active-low reset
- 32-bit address bus
- 32-bit data bus
- Single-beat write transfers
- Single-beat read transfers
- Write response generation
- Read response generation
- Configurable READY delay controls
- 16-word internal memory

This version does not yet support:

- AXI burst transfers
- AXI IDs
- Outstanding transactions
- Byte strobes
- Out-of-order responses
- Full UVM environment

## Top-Level Block Diagram

                 Testbench / AXI Master Model
                              |
                              |
        ------------------------------------------------
        |                                              |
        |        Simple AXI-Style Slave Memory         |
        |                                              |
        |  AW Channel: Write address handshake         |
        |  W  Channel: Write data handshake            |
        |  B  Channel: Write response handshake        |
        |  AR Channel: Read address handshake          |
        |  R  Channel: Read data handshake             |
        |                                              |
        |  Internal Memory: 16 x 32-bit words          |
        ------------------------------------------------

###    AXI-Style Channels    ###

## Write Address Channel ##
# Signals:
AWADDR
AWVALID
AWREADY
# Purpose:
The write address channel transfers the target write address from the master to the slave.


## Write Data Channel ##
# Signals:
WDATA
WVALID
WREADY
# Purpose:
The write data channel transfers write data from the master to the slave.


## Write Response Channel ##
# Signals:
BRESP
BVALID
BREADY
# Purpose:
The write response channel allows the slave to report write completion status.
# Current response:
2'b00: OKAY


## Read Address Channel ##
# Signals:
ARADDR
ARVALID
ARREADY
# Purpose:
The read address channel transfers the requested read address from the master to the slave.


## Read Data Channel ##
# Signals:
RDATA
RRESP
RVALID
RREADY
# Purpose:
The read data channel returns read data and read response from the slave to the master.
# Current response:
2'b00: OKAY


##  Internal Memory  ##

# The slave contains:
reg [31:0] mem [0:15];
# Address mapping uses word indexing:
write_index = awaddr_reg[5:2];
read_index  = ARADDR[5:2];
# Example mapping:
0x00 -> mem[0]
0x04 -> mem[1]
0x08 -> mem[2]
0x0C -> mem[3]
0x10 -> mem[4]


## Write Operation ##
The write address and write data channels are handled independently.
Slave accepts AWADDR when AWVALID && AWREADY.
Slave accepts WDATA when WVALID && WREADY.
After both address and data are received, the slave writes data into memory.
Slave asserts BVALID with BRESP = OKAY.
Write response completes when BVALID && BREADY.

# Read Operation ##
Slave accepts ARADDR when ARVALID && ARREADY.
Slave reads the internal memory.
Slave drives RDATA, RRESP, and asserts RVALID.
Read completes when RVALID && RREADY.

## READY Delay Controls ##
# The design includes training-oriented delay controls:
AWREADY_DELAY_EN
WREADY_DELAY_EN
ARREADY_DELAY_EN
These inputs allow the testbench to force delayed READY behavior and verify payload stability during stalled transfers.

## Design Assumptions ##
All logic runs on ACLK.
Reset is active-low using ARESETn.
Only aligned word accesses are tested.
Responses are always OKAY.
No burst behavior is implemented yet.
No byte-level write strobes are implemented yet.

## Industry Relevance ##
This project models the basic behavior found in AXI-based SoC peripherals and memory-mapped register blocks.
The same concepts are used in:
SoC verification
IP verification
Bus protocol verification
FPGA memory-mapped peripheral design
CPU/GPU subsystem verification
NoC endpoint verification