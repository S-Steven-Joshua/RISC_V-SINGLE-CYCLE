# UART 32-bit Serializer and Deserializer

## Overview

This project implements a simple UART-based data transmission system capable of transferring 32-bit data over a standard 8-bit UART interface.

The design consists of two major blocks:

1. **Serializer (Transmitter Side)**
   - Accepts a 32-bit parallel input.
   - Splits the 32-bit word into four 8-bit bytes.
   - Sequentially transmits each byte through the UART transmitter.

2. **Deserializer (Receiver Side)**
   - Receives four 8-bit UART packets.
   - Reconstructs the original 32-bit data word.
   - Generates a valid signal once all four bytes are received.

---

## Features

- 32-bit parallel data transmission over UART
- Automatic serialization into 8-bit packets
- Automatic reconstruction of original 32-bit data
- UART transmitter and receiver modules
- Byte counter for packet tracking
- Data valid indication after complete reception
- Fully synthesizable RTL design
- FPGA and ASIC compatible

---
## Output for the Serializer  
<img width="1920" height="1021" alt="Image" src="https://github.com/user-attachments/assets/652020eb-ac72-422d-872b-807a8825092e" />

---
## Output for the UART
<img width="1920" height="1017" alt="Image" src="https://github.com/user-attachments/assets/36a770e7-3cd1-467e-b5fe-dfcbad741171" />

---
## Overall Output 
<img width="1920" height="1019" alt="Image" src="https://github.com/user-attachments/assets/180ce083-292b-4d5b-8600-1f94bd580d29" />

---
## Linting Output 
<img width="1920" height="1019" alt="Image" src="https://github.com/user-attachments/assets/08b8d728-1540-4563-b444-a1d0622e8b33" />

---
## Verification

The design was verified using a SystemVerilog testbench that performs end-to-end validation of the serializer, UART transmitter, UART receiver, and deserializer.

### Verification Objectives

- Verify correct serialization of 32-bit input data into four 8-bit UART packets.
- Verify correct UART transmission and reception.
- Verify byte ordering throughout the transmission process.
- Verify reconstruction of the original 32-bit data at the receiver.
- Verify proper operation of control signals such as `master_busy` and `master_write`.

---
## Applications

- FPGA-to-FPGA Communication
- SoC Peripheral Interfaces
- Embedded System Communication
- Debug and Monitoring Interfaces
- Processor-to-UART Bridges
- Low-Pin-Count Data Transfer Systems
- Serial Communication Between Digital Systems

---

## Future Improvements

- Configurable Baud Rate Generator
- UART Parity Support
- FIFO Buffers for TX and RX
- Error Detection and Handling
- Interrupt-Based Communication
- Variable-Length Packet Support
- AXI/APB Interface Integration
- Flow Control Support (RTS/CTS)

---

## Author

**Steven Joshua**

Electronics and VLSI Student
