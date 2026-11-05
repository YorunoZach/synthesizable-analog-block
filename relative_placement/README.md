# Relative placement

`relative_placement.tcl` shows `create_relative_floorplan` case by case. Each case is two cells: a reference `ref_<case>` and a target `obj_<case>`. The script prints the orientation each target asked for and the one it got, then runs `check_place`.

```tcl
# in Innovus (Stylus), after create_floorplan; source relative_placement.tcl
```

## Edges

Edges are numbered clockwise, starting from the left edge nearest the origin. Even numbers are vertical edges, odd numbers are horizontal.

A rectangle has four edges:

```
              edge 1 (top)
           +--------------+
  edge 0   |              |   edge 2
  (left)   +--------------+   (right)
              edge 3 (bottom)
```

`-vertical_edge_separate` uses the even (vertical) edges, `-horizontal_edge_separate` uses the odd (horizontal) ones. Positive offsets go right and up, negative offsets go left and down. `-ref_type core_boundary` measures from the core instead of a cell.

### Rectilinear shapes

A rectilinear shape (here a rectangle with its top-right corner cut out) has more, and the numbers move on around the outline:

```
               edge 1
           +----------+
           |          | edge 2
  edge 0   |          +----------+
           |            edge 3   |  edge 4
           +---------------------+
                     edge 5
```

## Orientation and rows

```
      R0           MY           MX           R180
  === VDD ===  === VDD ===  --- VSS ---  --- VSS ---
  | A -> Z  |  |  Z <- A |  | A -> Z  |  |  Z <- A |
  --- VSS ---  --- VSS ---  === VDD ===  === VDD ===
```

Rows alternate so that neighbours share a rail:

```
  --------- VSS ---------
    flipped row: MX or R180
  ========= VDD =========
    normal row:  R0 or MY
  --------- VSS ---------
```

- A standard cell must match its row: **R0/MY** in a normal row, **MX/R180** in a flipped row. **R90, R270, MX90, MY90 are never legal** for a standard cell. Ask for the wrong one and the tool uses the row's orientation; the script prints what each cell got.
- A **macro** is not placed in rows, so all orientations are allowed.
- Identical cells that should get identical wires go **two rows apart**: same row type, same orientation, same pins.
