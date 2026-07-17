# Verilog Pin Mismatch Debugger

A single-page, browser-only tool for catching port mismatches between a
**Cadence Virtuoso schematic** and its **SystemVerilog** module.

**Live tool:** https://borenw.github.io/verilog-pin-mismatch-debugger/

No install, no server, no upload — everything runs locally in your browser.
You can also just open `index.html` from disk (`file://`).

## Why

When a schematic and its RTL are maintained separately, ports drift: a pin gets
renamed, a bus width changes, a direction flips. This tool gives you a fast,
side-by-side diff of the two port lists.

## Workflow

1. **Dump the schematic ports.** Open your schematic in Virtuoso, then copy the
   SKILL block from step 1 of the tool (source: [`skill/dump_ports.il`](skill/dump_ports.il))
   into the CIW (the `icfb` command window) and press Enter. It prints the
   current view's terminals as `PORT|<name>|<direction>` lines.
2. **Paste the output back** into the tool (step 2). Everything between the
   `###PORTDUMP_BEGIN###` / `###PORTDUMP_END###` markers is parsed; extra CIW
   noise is ignored.
3. **Provide the SystemVerilog** (step 3): pick a `.sv`/`.v` file with the native
   file picker, or paste the source. If the file has several modules, choose one
   from the dropdown (it auto-selects the module whose name matches the cell).
4. **Compare.** The result table highlights each pin:

   | Color  | Meaning |
   |--------|---------|
   | green  | name, direction, and width all match |
   | yellow | direction or width mismatch |
   | red    | pin exists on only one side |

## What it checks

- **Pin name** — union of both sides; a pin missing on either side is flagged.
- **Direction** — Cadence `input` / `output` / `inputOutput` (and `tristate`)
  are normalized and compared against SV `input` / `output` / `inout`.
- **Width** — Cadence bus notation `data<7:0>` is compared against SV `[7:0]`.
  Parametric ranges like `[W-1:0]` are shown but treated as unknown width (not
  flagged). Use the **ignore width** toggle to compare names + directions only.

Options: **case-insensitive names** and **ignore width**.

## SystemVerilog coverage

The parser handles the common cases without needing a full HDL toolchain:

- ANSI headers (`module m (input logic [7:0] a, output b);`), including
  direction carry-over (a port with no direction inherits the previous one).
- Non-ANSI headers (`module m(a,b); input a; output [3:0] b;`).
- `#(...)` parameter lists, `//` and `/* */` comments, multiple modules per file.

It is a pragmatic lexer, not a compliant SV elaborator: it does not evaluate
parameters, resolve `` `include``/macros, or expand generate/interface ports.
For those, treat a "width unknown" result as "check by hand."

## Files

```
index.html              the tool (self-contained; no dependencies)
skill/dump_ports.il     the Virtuoso SKILL port dumper
examples/alu.sv         example module (3 deliberate mismatches)
examples/portdump_alu.txt  matching example CIW dump
```

Click **Load example** in the tool to see a populated comparison.

## License

MIT — see [LICENSE](LICENSE).
