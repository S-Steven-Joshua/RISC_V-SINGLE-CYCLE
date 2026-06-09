# APB Master–Slave Interface (SystemVerilog)

A simple implementation of an **AMBA APB (Advanced Peripheral Bus)** Master and Slave using **SystemVerilog**. This project demonstrates the APB transaction protocol, including the Setup and Access phases, using a finite state machine (FSM) in the master and a simple peripheral slave.

---

## Overview

The design consists of:

- **APB Master**
  - Generates APB transactions
  - Controls `PSEL`, `PENABLE`, `PWRITE`
  - Implements APB protocol using an FSM

- **APB Slave**
  - Receives APB transactions
  - Responds with `PREADY`
  - Captures write data

- **Top Module**
  - Connects the APB Master and APB Slave
  - Demonstrates complete APB communication

---
## APB Protocol
