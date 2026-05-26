# RISC-V Single Cycle Processor

## Introduction
This project presents the design and implementation of a **32-bit RISC-V Single Cycle Processor** using **Verilog HDL**. The processor is based on the **RISC-V RV32I instruction set architecture (ISA)** and executes each instruction in a single clock cycle.

The goal of this project is to understand the internal working of a processor by building the complete datapath and control logic from scratch. The design includes essential processor components such as the **Program Counter (PC), Instruction Memory, Register File, ALU, Control Unit, Immediate Generator, Data Memory, and multiplexers** required for instruction execution.

The processor supports fundamental instruction categories including:

- **R-Type Instructions** – arithmetic and logical operations  
- **I-Type Instructions** – immediate arithmetic and load operations  
- **S-Type Instructions** – store operations  
- **B-Type Instructions** – branch instructions  
- **J-Type Instructions** – jump instructions  

This project demonstrates how instructions move through the datapath, how control signals are generated, and how memory and register operations are performed within a single clock cycle architecture.

The design was implemented and verified through simulation using **SystemVerilog testbenches**.

---

## Features
- 32-bit RISC-V Single Cycle Architecture  
- RV32I Instruction Set Support  
- Modular Verilog Design  
- ALU with Arithmetic and Logical Operations  
- Register File with Read/Write Support  
- Branch and Jump Instruction Handling  
- Separate Instruction and Data Memory  
- Fully Synthesizable RTL Design  
- Simulation and Verification Support  

---

## Project Objective
The primary objective of this project is to gain hands-on experience in:

- Processor Architecture Design  
- RTL Design using Verilog  
- Datapath and Control Unit Implementation  
- Computer Architecture Concepts  
- Digital Design Verification and Simulation  

---

## Architecture Overview
The processor follows a **single cycle execution model**, where every instruction completes all stages — fetch, decode, execute, memory access, and write-back — within one clock cycle.

### Major Components
- Program Counter (PC)
- Instruction Memory
- Control Unit
- Register File
- Immediate Generator
- ALU
- Data Memory
- Branch & Jump Logic
- Multiplexers
---
# Reference Architecture

The processor architecture used in this project is inspired from the book:

## *Digital Design and Computer Architecture – RISC-V Edition*  
**Authors:** Sarah L. Harris and David Money Harris

<p align="center">
  <img width="600" alt="Book Cover" src="https://github.com/user-attachments/assets/d576a2c4-a9db-4cd2-bf16-e65ce8f044ee" />
</p>

---

## Instruction Set

<p align="center">
  <img width="1186" height="655" alt="RISC-V Processor Diagram" src="https://github.com/user-attachments/assets/bf0fe34b-dfd7-49a2-878b-bbcbfd707a8f" />
</p>

---

# Instruction Set Explanation

## R-Type Instructions
R-Type instructions are used for **register-to-register arithmetic and logical operations**.

### Format
```text
opcode | rd | funct3 | rs1 | rs2 | funct7
```

### Register Usage
- **rd**  → Destination register (stores result)
- **rs1** → First source register
- **rs2** → Second source register

### Working
Both source registers contain data values used for arithmetic or logical operations inside the ALU.

### Examples
```assembly
ADD x1, x2, x3
SUB x4, x5, x6
AND x7, x8, x9
OR  x10, x11, x12
```

### Example Explanation
```assembly
ADD x1, x2, x3
```

```text
x1 = x2 + x3
```

- x2 and x3 contain arithmetic data
- ALU performs addition
- Result is stored in x1

---

## I-Type Instructions
I-Type instructions are used for **immediate arithmetic operations and load instructions**.

### Format
```text
opcode | rd | funct3 | rs1 | immediate
```

### Register Usage
- **rd**  → Destination register
- **rs1** → Source register / Base address register
- **Immediate** → Constant value or offset

### Working
For arithmetic instructions, rs1 contains data and immediate acts as a constant value.  
For load instructions, rs1 contains the base memory address.

### Examples
```assembly
ADDI x1, x2, 10
LW   x3, 0(x4)
```

### Example Explanation

#### Arithmetic Example
```assembly
ADDI x1, x2, 10
```

```text
x1 = x2 + 10
```

- x2 contains arithmetic data
- Immediate value is 10
- Result stored in x1

#### Load Example
```assembly
LW x3, 0(x4)
```

```text
x3 = Memory[x4 + 0]
```

- x4 contains base address
- Immediate acts as offset
- Data from memory stored into x3

---

## S-Type Instructions
S-Type instructions are used for **store operations**.

### Format
```text
opcode | immediate | funct3 | rs1 | rs2
```

### Register Usage
- **rs1** → Base address register
- **rs2** → Register containing data to store

### Working
The processor calculates the memory address using rs1 and immediate offset, then stores data from rs2 into memory.

### Example
```assembly
SW x5, 0(x6)
```

### Example Explanation
```text
Memory[x6 + 0] = x5
```

- x6 contains base address
- x5 contains data to store
- Data written into memory

---

## B-Type Instructions
B-Type instructions are used for **branch operations**.

### Format
```text
opcode | immediate | funct3 | rs1 | rs2
```

### Register Usage
- **rs1** → First register for comparison
- **rs2** → Second register for comparison

### Working
The processor compares rs1 and rs2 values.  
If the condition becomes true, the PC jumps to the target address.

### Examples
```assembly
BEQ x1, x2, label
BNE x3, x4, label
```

### Example Explanation
```assembly
BEQ x1, x2, label
```

```text
If x1 == x2 → Branch to label
```

- x1 and x2 contain comparison data
- Immediate value gives branch offset
- PC changes if condition is true

---

## J-Type Instructions
J-Type instructions are used for **jump operations**.

### Format
```text
opcode | rd | immediate
```

### Register Usage
- **rd** → Stores return address

### Working
The processor jumps to a new instruction address and stores the next PC value inside rd.

### Example
```assembly
JAL x1, label
```

### Example Explanation
```text
x1 = PC + 4
PC  = Target Address
```

- rd stores return address
- Immediate gives jump target offset
- PC jumps to new address
---

# Supported Instructions

| Instruction Type | Supported Instructions |
|------------------|------------------------|
| R-Type           | ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU |
| I-Type           | ADDI, ANDI, ORI, XORI, SLLI, SRLI, SRAI, SLTI, SLTIU |
| Load Instructions| LW |
| Store Instructions | SW |
| Branch Instructions | BEQ |
| Jump Instructions | JAL, JALR |

---

# Conclusion

This project demonstrates the complete implementation of a **32-bit RISC-V Single Cycle Processor** using System Verilog HDL. Through this design, fundamental concepts of computer architecture such as instruction execution, datapath design, control signal generation, ALU operations, memory access, branching, and jumping were successfully implemented and verified.

---
# Author
## Steven Joshua
Electronics and VLSI Enthusiast
