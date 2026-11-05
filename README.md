# Hand-built cells in the digital flow

Tcl scripts for building a block cell by cell with the digital flow:
Keep the cells through synthesis, place each one exactly, and route the wires by hand. Useful when the digital flow has to build a block with analog-like behaviour, such as a ring oscillator, a delay line or a matched structural datapath.

## Before you run

- Written for the Cadence **Common UI** (Genus and Innovus Stylus, version 23.1).
- The scripts use generic names (`INV_X1`, pins `I` / `ZN`, layers `M2` / `M3`, net `VSS`). Set your library's names at the top of each script.
