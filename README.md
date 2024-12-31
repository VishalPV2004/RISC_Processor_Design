# Custom Processor Implementation in Verilog

This repository contains the Verilog implementation of a custom processor, featuring a wide range of arithmetic, logical, and control operations. The processor is designed to work with 32-bit instruction registers, 16-bit general-purpose registers (GPRs), and supports both immediate and register-based addressing modes.

## Features

### Instruction Set Architecture (ISA)
The processor supports the following operations:

#### Arithmetic Operations
- **MOV**: Move immediate or register value to a destination register.
- **ADD**: Perform addition (register-register or immediate).
- **SUB**: Perform subtraction (register-register or immediate).
- **MUL**: Perform multiplication (register-register or immediate).

#### Logical Operations
- **ROR**: Bitwise OR (register-register or immediate).
- **RAND**: Bitwise AND (register-register or immediate).
- **RXOR**: Bitwise XOR (register-register or immediate).
- **RXNOR**: Bitwise XNOR (register-register or immediate).
- **RNAND**: Bitwise NAND (register-register or immediate).
- **RNOR**: Bitwise NOR (register-register or immediate).
- **RNOT**: Bitwise NOT (register or immediate).

#### Control Operations
- **MOVSGPR**: Move the contents of the special-purpose register (SGPR) to a destination register.
#### Load/Store Operations 
- **STOREDIN**: Store input data (`din`) into memory. 
- **STOREG**: Store the contents of a register into memory. 
- **SENDDOUT**: Send data from memory to the output (`dout`). 
- **SENDREG**: Load data from memory into a register. 
#### Jump/Branch Operations 
-   **JUMP**: Perform an unconditional jump to a target address. 
- **JCARRY**: Jump if the carry flag is set. 
- **JNOCARRY**: Jump if the carry flag is clear. 
- **JSIGN**: Jump if the sign flag is set. 
- **JNOSIGN**: Jump if the sign flag is clear. 
- **JZERO**: Jump if the zero flag is set. 
- **JNOZERO**: Jump if the zero flag is clear. 
- **JOVERFLOW**: Jump if the overflow flag is set. 
- **JNOOVERFLOW**: Jump if the overflow flag is clear. 
#### Halt Operation - **HALT**: Stop the processor execution.

### Special Features
1. **Immediate Mode**: Allows operations to use constants directly.
2. **Condition Flags**: Supports computation of:
   - Sign bit
   - Zero bit
   - Overflow
   - Carry
3. **Pipeline Mechanism**: Simulates a simple pipeline with clock synchronization.
4. **Program Memory Integration**: Instructions are loaded from an external memory file (`data.mem`).

---

## File Structure

![Screenshot from 2024-12-31 20-36-34](https://github.com/user-attachments/assets/1203530c-f78d-4ce4-9e3a-c905c5a01ca3)

### Main Components
1. **Instruction Register (IR)**:
   - Holds the current instruction being executed.
   - Divided into fields: `oper_type`, `rdst`, `rsrc1`, `imm_mode`, and `isrc`.

2. **General-Purpose Registers (GPRs)**:
   - 32 registers, each 16 bits wide.
   - Used for general arithmetic and logical operations.

3. **Special Purpose Register (SGPR)**:
   - Stores the most significant bits of multiplication results.

4. **Condition Flags**:
   - `Sign`: Indicates whether the result is negative.
   - `Zero`: Indicates whether the result is zero.
   - `Overflow`: Indicates signed overflow.
   - `Carry`: Indicates unsigned overflow.
   ![sch1](https://github.com/user-attachments/assets/7df37fdb-aad6-4f74-9a0b-629f01ffcb9c)
---



![sch2](https://github.com/user-attachments/assets/2bf3b264-c55e-407d-9b04-2a24d82ad684)

5. **BRAM Integration**:
   - The processor uses **Block RAM (BRAM)**, instantiated as an IP core in Vivado.
   - BRAM serves as the instruction memory (`inst_mem`), storing program instructions loaded from `data.mem`.
   - BRAM improves performance by offering low-latency access to instructions during execution.
   **BRAM Simulation** : 
   ![memSim](https://github.com/user-attachments/assets/97c22477-4d7b-4daf-8190-1052bad97a13)

---



![bram](https://github.com/user-attachments/assets/97cabd1a-b76e-4efb-9ec2-bfb86fc8cf12)

---


![bram2](https://github.com/user-attachments/assets/fa588cb4-af78-4455-a96a-ad90bcbefaa8)

---

## How It Works

1. **Instruction Fetch**:
   - Instructions are fetched sequentially from the BRAM.

2. **Decoding**:
   - Instructions are decoded into operation type, destination register, source registers, and mode of operation (immediate or register).

3. **Execution**:
   - Arithmetic and logical operations are performed based on the decoded instruction.

4. **Condition Flags**:
   - After each operation, flags (sign, zero, overflow, carry) are computed and updated.

5. **Result Storage**:
   - Results are stored in GPRs or SGPR, depending on the operation.
   - ![simplifed](https://github.com/user-attachments/assets/dfc92cb4-3373-4570-babe-ad520e89e4cd)


---

## Toolchain

### Vivado Design Suite
- The project was developed and synthesized using the **Vivado Design Suite** by Xilinx.
- **BRAM IP** was instantiated to implement high-performance program memory.
**Memory with Instruction register :**
![ir+mem](https://github.com/user-attachments/assets/f5362686-ac2d-47b3-8319-27dc8cf5f911)

**ALU with Instruction register :**
![LogicalArithmetic](https://github.com/user-attachments/assets/c618bf1f-0a93-449f-97a9-63a6a560f3dc)
- **TestBench** used to initiate the registers and carry out other operations
--   **Initialization of all GPRs to 2 :** 
![init](https://github.com/user-attachments/assets/21364d29-beeb-4020-b0de-7fb8a6ca3666)

---

## Simple Assembly Program: Multiplication via Repeated Addition

This program demonstrates multiplication of two numbers (`5` and `6`) using repeated addition.

```assembly
mov r0, #5       // Load immediate value 5 into r0
mov r1, #6       // Load immediate value 6 into r1
mov r2, #0       // Initialize r2 with 0
mov r3, #6       // Load immediate value 6 into r3

ADD r2, r2, r0   // Add r0 to r2 and store result in r2
sub r3, r3, #1   // Subtract 1 from r3
jnz r3           // Jump to the loop if r3 is not zero

mov r5, r2       // Move the final result from r2 to r5
hlt              // Halt the program
```

**OUTPUT : (overall simplified)**
![simplifed](https://github.com/user-attachments/assets/70ed46f4-ebe0-4121-b643-301e6fbedb6e)

---


**Flags and Registers (After simulation)**

![flags_ram](https://github.com/user-attachments/assets/a43e8678-5141-4348-9e23-2250c9b478ff)

- According to the program, all the data have been put onto respective destination registers

---

  
**Program Memory (Last Instruction)**

![rom](https://github.com/user-attachments/assets/89af3dcd-b95c-4a4b-bd72-82a733901460)


