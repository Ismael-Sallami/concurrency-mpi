# SCD · Concurrency & Distributed Systems (C++ / MPI)

Concurrent and distributed programming built from primitives — **~8,500 lines of C++**
across the four lab assignments of *Sistemas Concurrentes y Distribuidos* (Concurrency &
Distributed Systems), Computer Engineering, University of Granada.

## What's inside

| Assignment | Topic | Key implementations |
|---|---|---|
| **Práctica 1** | Semaphores | Producer–consumer with **FIFO and LIFO** buffers, multi-producer/multi-consumer, cigarette-smokers |
| **Práctica 2** | Monitors (SU / Hoare) | Readers–writers, cigarette-smokers, bounded multiple producer–consumer |
| **Práctica 3** | Message passing (**MPI**) | **Dining philosophers** with deadlock analysis + waiter/arbitrator fix, distributed producer–consumer |
| **Práctica 4** | Real-time systems | **Cyclic executive schedulers** with period / WCET timing analysis, clock synchronization |
| **Extra** | MPI | Distributed Sieve of Eratosthenes |

## Concepts demonstrated

- Synchronization primitives: semaphores, SU/Hoare monitors, condition variables.
- **Deadlock**: detection, analysis and resolution (arbitrator pattern in dining philosophers).
- **Distributed message passing with MPI** (point-to-point and process topologies).
- **Real-time scheduling**: cyclic executives, period/WCET budgeting, timing measurement.
- Classic problems: producer–consumer (FIFO/LIFO), readers–writers, cigarette-smokers.

## Build

Threaded programs (C++11):
```bash
g++ -std=c++11 -pthread src/Practica2/escritores-lectores.cpp -o rw && ./rw
```
MPI programs:
```bash
mpicxx src/Practica3/scd-p3-fuentes/filosofos.cpp -o filo && mpirun -np 6 ./filo
```

## Metrics

- **8,497 lines** of author-written C++ across 37 source files.
- 4 lab assignments + 1 extra MPI activity.

---
Author: **Ismael Sallami Moreno** · University of Granada.
