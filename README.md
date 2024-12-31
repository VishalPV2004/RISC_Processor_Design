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

5. **BRAM Integration**:
   - The processor uses **Block RAM (BRAM)**, instantiated as an IP core in Vivado.
   - BRAM serves as the instruction memory (`inst_mem`), storing program instructions loaded from `data.mem`.
   - BRAM improves performance by offering low-latency access to instructions during execution.

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

---

## Toolchain

### Vivado Design Suite
- The project was developed and synthesized using the **Vivado Design Suite** by Xilinx.
- **BRAM IP** was instantiated to implement high-performance program memory.

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
