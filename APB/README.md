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
<img width="690" height="455" alt="Image" src="https://github.com/user-attachments/assets/06b75205-d3f4-493e-a421-541ab8027300" />

- **NOTE:HERE BACK TO BACK TRANSACTION IS AVOIDED. WE CAN CHANGE IT IF WE WANT IT**
---
## Output 
<img width="1920" height="1020" alt="Image" src="https://github.com/user-attachments/assets/6dddd39f-f542-4050-a003-4d2201b280ff" />

<img width="1920" height="1015" alt="Image" src="https://github.com/user-attachments/assets/5bfa124a-3862-46d7-bd79-0b1dba217ed6" />

---
### State Description

| State | Description |
|---------|------------|
| IDLE | Waits for a transaction request |
| SETUP | Drives APB control signals |
| ACCESS | Waits for slave response (`PREADY`) |

---

## Signals

### APB Master Signals

| Signal | Direction | Description |
|----------|-----------|-------------|
| PCLK | Input | APB clock |
| PRESETn | Input | Active-low reset |
| PADDR | Input | Address bus |
| PWDATA | Input | Write data bus |
| PWRITE | Input | Write control |
| PSEL | Output | Peripheral select |
| PENABLE | Output | Access phase indicator |
| PREADY | Input | Slave ready signal |

---
