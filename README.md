# Real Time Embedded System

### Main objective
A real time system has to accept important temporal constraints. A real time embedded system must be able to react to events with a limited time.
In this repo, the measures of response time to interruptions are studied and tested in laboratories, such as for example the influence of dynamic memories, of cache memories, of option of compilation. 
- Measurements of response time to the interruptions, tasks commutations, primitives of synchronizations are carried out on an embedded system based on a Altera System-on-Chip (SoC) FPGA, the [DE1-SoC board](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=836).
- Multiprocessors, accelerators, custom instructions, specialized hardware are designed to improve the performance of a specific application. 
- Specialized programmable interfaces are implemented in VHDL and C.
- Reports are written to illustrate our results.

### Members
- [Haoxin SUN](https://github.com/HaoxinSEU)
- [Xufeng GAO](https://github.com/XufengGAO)

### Main works in this repo
- Lab 2: Specific operations by pure C program, custom instructions, and a hardware DMA accelerator; Profiling by software and hardware tools.
- Lab 3: Multiprocessor system design; usage of hardware Mailbox and Mutex IP cores; hardware counter without locks design.
- Mini project: Use a hardware accelerator to do MNIST handwritten digit classification.
