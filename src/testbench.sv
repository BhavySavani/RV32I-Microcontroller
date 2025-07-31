`timescale 1ps/1ps

module testbench;

  // Parameters
  parameter CLK_PERIOD = 10; // Clock period in ps

  // Signals
  reg clk;
  reg reset;

  // Instantiate the DUT (Device Under Test)
  top dut (
    .clk(clk),
    .reset(reset)
    // Add other ports here if your top module has more I/O
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #(CLK_PERIOD / 2) clk = ~clk; // Toggle clock every half period
  end

  // Reset generation
  initial begin
    reset = 1;
    #10; // Hold reset for a while
    reset = 0;
  end

  // Simulation control
  initial begin
    // Wait for reset deassertion
    @(negedge reset);
    // Run simulation for some time
    #1000000000;
    $finish;
  end

  // Optional: Monitor signals
  initial begin
    $monitor("Time=%0t | reset=%b | clk=%b", $time, reset, clk);
  end

endmodule