# AXI4-Lite VIP in SystemVerilog

## Overview

This project implements a lightweight AXI4-Lite Verification IP (VIP) in SystemVerilog for verifying AXI4-Lite compliant slave devices.

The verification environment includes:

* Transaction Generator
* Driver
* Monitor
* Scoreboard
* Functional Coverage
* Assertions
* Protocol Checker
* Mailbox-based communication

The environment verifies read and write transactions and checks protocol correctness, data integrity, and functional coverage.

---

## Verification Architecture

Generator
    |
    v
Driver -----> DUT (AXI4-Lite Slave)
    |
    v
Monitor
   / \
  /   \
Scoreboard  Coverage
      |
      v
Protocol Checker + Assertions

---

## Features

* Randomized AXI4-Lite read/write transactions
* Functional coverage collection
* Scoreboard-based data checking
* AXI protocol assertions
* Protocol checker implementation
* Mailbox-based component communication
* Self-checking testbench

## Verification Components

### Generator
Creates randomized AXI4-Lite read and write transactions.

### Driver
Converts transactions into pin-level AXI bus activity.

### Monitor
Captures DUT activity and reconstructs transactions.

### Scoreboard
Checks DUT responses and validates correctness.

### Functional Coverage
Tracks exercised addresses, transaction types, and responses.

### Protocol Checker
Verifies AXI4-Lite protocol compliance.

### Assertions
SystemVerilog assertions for protocol verification.

---

## DUT

AXI4-Lite Slave

Supported addresses:

| Address |
| ------- |
| 0x00    |
| 0x04    |
| 0x08    |
| 0x0C    |

---

## Simulation Results

### Scoreboard Report

* Total Transactions: 33
* Write Transactions: 7
* Read Transactions: 26
* Error Count: 0

Result:

PASS

### Functional Coverage

Coverage Achieved: 87.50%

---

## Directory Structure

rtl/

* DUT source files

sv_tb/

* Generator
* Driver
* Monitor
* Scoreboard
* Coverage
* Assertions
* Protocol Checker
* Testbench files

docs/

* Verification plan
* Architecture notes
* Simulation results

---

## Tools

* AMD Vivado Simulator 2024.2
* SystemVerilog

---

## Author

Ajay Kumar K
