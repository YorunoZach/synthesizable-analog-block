# 3. Routing a critical net by hand

`copy_ndr_routing.tcl` lists the commands, one per line, for five steps:

1. **Create shape / disable timing-related routing** -- draw the critical net with `create_shape`; turn off timing- and SI-driven routing so the router does not re-route it.
2. **Select, copy paste, deselect, fix** -- copy the critical net's wires onto an identical net (`edit_copy dx dy -net <net>`), then fix them.
3. **NDR (2W2S)** -- wider wires and more spacing on a net, e.g. for signal integrity.
4. **Shielding** -- GND (VSS) wires beside a sensitive net.
5. **Fill and routing blockage** -- keep metal fill and other signal wires away from the critical path.

Notes:

- Copy two rows away (2 x row height), so both nets see the same row type and pins.
- 2W2S: wider wire, lower resistance; more spacing, lower coupling. Any multiples work (e.g. 1W2S, 3W3S) as long as the result passes DRC; 2W2S is just the most common combination.
- NDR and shielding are separate tools: an NDR alone is often enough for signal integrity; a shield adds a fixed GND neighbour. Both can be set on the same net (`set_route_attributes -nets <net> -route_rule ndr_2W2S -shield_nets VSS`).
- The fill blockage keeps metal fill from adding capacitance to the critical path; the routing blockage (`-except_pg_nets`) keeps other signals from coupling to it, while power can still pass.
- The routing blockage also stops the router from reaching pins inside the box: draw every wire in the box by hand, or keep the box tight.
