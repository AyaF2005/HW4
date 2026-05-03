module top;

    logic clk;

    initial clk = 0;
    always #50 clk = ~clk;

    mem_if mif (.clk(clk));

    my_mem dut (.mif(mif.dut));

    test tb (.mif(mif.tb));

    initial begin
        $fsdbDumpfile("waves.fsdb");
        $fsdbDumpvars(0, top);
    end

endmodule
