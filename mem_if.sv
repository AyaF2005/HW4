// mem_if.sv
// Interface for the my_mem module.
// Contains:
//   - clocking block for the testbench (posedge clk, 10MHz domain)
//   - modport for the DUT (does NOT include the clocking block per spec)
//   - modport for the testbench (uses the clocking block)
//   - checker to catch illegal read+write in same transaction

interface mem_if (input logic clk);

    // signal declarations that match the original my_mem port list
    logic        write;
    logic        read;
    logic [7:0]  data_in;
    logic [15:0] address;
    logic [8:0]  data_out;

    // clocking block for the testbench
    // posedge clk because DUT flip-flops are positive-edge triggered
    // input skew  #1 means we sample 1 time unit BEFORE the clock edge
    // output skew #1 means we drive 1 time unit AFTER the clock edge
    // this avoids race conditions between the TB and DUT
    clocking cb @(posedge clk);
        default input #1 output #1;
        output write;
        output read;
        output data_in;
        output address;
        input  data_out;
    endclocking

    // modport for the DUT - raw signals, no clocking block
    // the DUT should NOT see or use the clocking block
    modport dut (
        input  clk,
        input  write,
        input  read,
        input  data_in,
        input  address,
        output data_out
    );

    // modport for the testbench - only uses the clocking block
    modport tb (clocking cb);

    // checker: read and write should never both be 1 at the same time
    // this fires at every posedge clk and flags the error
    property no_sim_read_write;
        @(posedge clk) not (write && read);
    endproperty

    check_no_sim_rw: assert property (no_sim_read_write)
        else $error("CHECKER ERROR at time %0t: read and write both asserted in same transaction!", $time);

endinterface
