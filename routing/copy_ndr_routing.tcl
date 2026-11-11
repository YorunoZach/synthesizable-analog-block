# copy_ndr_routing.tcl -- routing a critical net by hand (Innovus Stylus Common UI).
# n_a = critical net, n_b = identical net two rows up, n_c = net routed with an NDR, n_d = shielded net. Coordinates in um.

set W    <wire_width>      ;# wire width on desired metal (um), from your tech LEF, here I used M3 for example
set ROW  <row_height>      ;# standard-cell row height (um)
# n_a = a rectangle given by two diagonal corners; its short side is the wire width W
# (horizontal wire: Y1 - Y0 = W, vertical wire: X1 - X0 = W)
set X0   <x_ll>            ;# lower-left corner
set Y0   <y_ll>
set X1   <x_ur>            ;# upper-right corner
set Y1   <y_ur>
set M    <margin>          ;# fill-free margin around the critical wires (um)

# 1. create shape / disable timing-related routing
# router ignores timing
set_db route_with_timing_driven false
# router ignores signal integrity
set_db route_with_si_driven false
# draw net n_a by hand on M3, fixed so the router cannot change it
create_shape -net n_a -layer M3 -rect [list $X0 $Y0 $X1 $Y1] -status fixed

# 2. select, copy paste, deselect, fix
# select the wires of n_a
select_obj [get_db [get_db nets n_a] .special_wires]
# paste them 2 rows up, as net n_b
edit_copy 0 [expr {2 * $ROW}] -net n_b
# clear the selection
deselect_obj -all
# fix the copy
set_db [get_db [get_db nets n_b] .special_wires] .status fixed

# 3. NDR (2W2S), e.g. for signal integrity
# rule: 2x width, 2x spacing on M2-M3; any multiples work as long as DRC passes, 2W2S is just the most common
create_route_rule -name ndr_2W2S -width_multiplier {M2:M3 2} -spacing_multiplier {M2:M3 2}
# route n_c with that rule
set_route_attributes -nets n_c -route_rule ndr_2W2S

# 4. shielding
# route n_d with VSS shield wires beside it
set_route_attributes -nets n_d -shield_nets VSS

# 5. fill and routing blockage around the critical path
# box around n_a and n_b, M wider on every side (two diagonal corners, like n_a)
set BOX [list [expr {$X0 - $M}] [expr {$Y0 - $M}] [expr {$X1 + $M}] [expr {$Y1 + 2 * $ROW + $M}]]
# no metal fill on M2-M3 in the box
create_route_blockage -name fill_blk_crit -fills -layers {M2 M3} -rects $BOX
# no other signal routing on M2-M3 in the box (power may pass) as well
create_route_blockage -name route_blk_crit -except_pg_nets -layers {M2 M3} -rects $BOX
