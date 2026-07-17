// Example SystemVerilog module used in the tool's "Load example" demo.
// Intentionally contains three mismatches vs the schematic dump in
// examples/portdump_alu.txt:
//   * en (schematic) vs enable (SV)   -> name mismatch
//   * b is [7:0] (schematic) vs [3:0] -> width mismatch
//   * zero is output (schematic) vs input -> direction mismatch
module alu (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        enable,
  input  logic [2:0]  opcode,
  input  logic [7:0]  a,
  input  logic [3:0]  b,
  output logic [7:0]  result,
  input  logic        zero,
  inout  wire         sda
);
  // ... body omitted ...
endmodule
