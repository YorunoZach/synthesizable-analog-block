# Keep hand-instantiated cells through synthesis

`keep_cells.tcl` lists the commands needed for three steps during synthesis:

1. **Keep the cells, names and hierarchy** (right after `elaborate`) -- `.dont_touch true` and `.preserve true` on the modules and instances: no resize, remove, rename or remap. `.ungroup_ok false`: the hierarchy stays, so instance paths match the placement script. `delete_unloaded_insts false`: cells whose outputs drive nothing (varactors, dummy loads) are kept.
2. **Cut the ring loop** (after `syn_opt`) -- Genus breaks a combinational loop with its own `cdn_loop_breaker` cells; remove them and cut the loop on your pin with `set_disable_timing`.
3. **Check** -- `.dont_touch_effective` is the value Genus actually honours.

Notes:

- Put the same `set_disable_timing` line in your SDC, so Innovus cuts the timing analysis at that pin as well.
- The cut must stay: without it, any later timing command inserts the loop breakers again, which would break the oscillator or delay line.
- `dont_touch` and `preserve` take the same values; `preserve` is the older name (`set_attribute preserve true` in older scripts). A preserved module is also kept as its own hierarchy, but the manual documents only `ungroup_ok false` for that, so set it as well.
- `hdl_preserve_unused_registers` is not needed for purely combinational design: it only affects registers inferred from RTL.
- After synthesis, compare the netlist with your RTL: they shall contain the same cells, names and hierarchy.
