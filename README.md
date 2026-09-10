# concurrency-mpi

![C++](https://img.shields.io/badge/C%2B%2B-11-00599C)
![OpenMPI](https://img.shields.io/badge/OpenMPI-4.1-cf4a2b)
[![build](https://img.shields.io/github/actions/workflow/status/Ismael-Sallami/concurrency-mpi/ci.yml?branch=main&logo=github&label=build)](https://github.com/Ismael-Sallami/concurrency-mpi/actions/workflows/ci.yml)
![license](https://img.shields.io/badge/license-MIT-4c1)

Thirty-one programs that solve the classic synchronisation problems three times over: with
semaphores, with monitors and with message passing.

## Context

Coursework for **Concurrent and Distributed Systems**, year 3 of the double degree in
Computer Science and Business Administration, University of Granada (2024-25). Solo work.

The `scd` support library (`scd.h`, `scd.cpp`) is provided by the subject and is kept
because the programs do not compile without it.

## The problem

The same problems come back at every level of abstraction, and that repetition is the point
of the subject: producer-consumer, readers-writers, cigarette smokers and dining
philosophers, solved first with the lowest primitive available and then with higher ones.

Each solution has to guarantee three things, and none of them can be checked by looking at
one run: mutual exclusion where the resource demands it, no deadlock, and no starvation.

## The solution

| Practice | Tool | Programs |
| --- | --- | --- |
| 1 | Semaphores | Producer-consumer with **FIFO and LIFO** buffers, the multiple-producer multiple-consumer version, cigarette smokers |
| 2 | **SU monitors** | Readers-writers, smokers, bounded multiple producer-consumer |
| 3 | **MPI** | Dining philosophers, the version that deadlocks, and the fix with a waiter; distributed producer-consumer with an intermediate buffer process |
| 4 | Real time | Cyclic executives with period and WCET analysis, clock and duration handling |
| Extra | MPI | Distributed Sieve of Eratosthenes |

Details worth naming:

- **The deadlock is committed on purpose.** `philosophers-deadlock.cpp` is the version where
  every philosopher takes the same fork first, and it hangs. `philosophers-waiter.cpp` adds
  the arbitrator that limits how many sit at once, which is the standard fix. Keeping both
  is what makes the problem visible.
- **FIFO and LIFO are separate programs**, not a flag. The order of the buffer changes which
  index the producer and the consumer touch, so the two solutions are different code, and
  the outputs in `docs/results/` show the difference.
- **The cyclic executives are timed, not guessed.** `timing.cpp` and `clocks.cpp` work with
  durations and instants so the schedule can be checked against the period and the
  worst-case execution time, instead of assuming the tasks fit.
- **The exams are here too.** `docs/exams/` holds seven problems solved under exam
  conditions: supermarket checkouts, philosophers with a waiter in two different styles,
  producer-consumer with odd and even consumers, and two turn-based games over MPI.

## Layout

```
src/practice-1-semaphores/    producer-consumer, its multiple version and the smokers
src/practice-2-monitors/      the same problems with SU monitors, plus readers-writers
src/practice-3-mpi/           philosophers and distributed producer-consumer
src/practice-4-realtime/      cyclic executives, clocks and timing
src/extra-mpi-sieve/          distributed Sieve of Eratosthenes
docs/exams/                   seven exam problems
docs/results/                 captured output of the runs
tools/build-all.sh            builds everything in one command
```

## Requirements

- A C++ compiler with C++11 (g++ 11 or later).
- OpenMPI (`openmpi-bin`, `libopenmpi-dev`) for the MPI programs.

## Build and run

```bash
bash tools/build-all.sh                      # every program, binaries land in build/
./build/prodcons-fifo                        # threaded programs run straight away
mpirun -np 11 ./build/philosophers-waiter    # philosophers, forks and the waiter
mpirun -np 21 ./build/sieve                  # the sieve, one process per range
```

The MPI programs fix the number of processes they need in a constant at the top of the file:
`num_procesos` in the philosophers, `num_prod` and `num_cons` in the producer-consumer.
Passing a different `-np` makes them abort on purpose.

## Results

Sample runs are captured in `docs/results/`. The programs print in Spanish, so the files are
worth opening rather than quoted here.

The producer-consumer traces the buffer indices on every operation, and that is where the
two versions part company: the FIFO run reports a read cursor 80 times and the LIFO run
never does, because popping from the end you pushed to does not need one. Both captures
carry the same banner, though, since `prodcons-fifo.cpp:153` prints the LIFO one. The
banner is copy-pasted; the traced indices are not.

The sieve reports which process found each prime, so the split of the ranges is visible:
process 19 accounts for 61, 67, 71 and on up.

## What I learned

- A concurrent program that runs correctly once proves nothing. The interesting bugs only
  appear under a particular interleaving, which is why the deadlocking version of the
  philosophers is worth keeping next to the fixed one.
- Monitors move the synchronisation from the caller to the resource. With semaphores every
  caller has to remember to signal; with a monitor, forgetting is not an option the caller
  has. That is the whole difference between practices 1 and 2.
- **Limitations, kept as handed in:**
  - `src/practice-1-semaphores/smokers/smokers.cpp` **does not compile**: it calls `fumar()`
    at line 75, and the function is defined at line 83 with no forward declaration. It is
    listed in `tools/known-build-failures.txt` with the reason, and the build script fails
    if it ever starts building, so the list cannot rot. It is not patched.
  - Practice 3 keeps the base programs given with the assignment next to my versions,
    because the versions are edits of them and separating them would hide what changed.
  - Identifiers, comments and the captured output are in Spanish, as handed in. Translating
    them would mean editing code that was graded.

## Author and licence

Ismael Sallami Moreno. Released under the MIT licence (see `LICENSE`).
