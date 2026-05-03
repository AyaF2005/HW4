// my_mem.sv
// This is the DUT (Device Under Test) from HW2, now modified to use
// an interface instead of individual ports.

module my_mem (mem_if.dut mif);

    // 9-bit wide associative array (8 data bits + 1 parity bit)
    // using int as the key for the 64K address space
    logic [8:0] mem_array [int];

    always @(posedge mif.clk) begin
        if (mif.write) begin
            // store data along with even parity in bit 8
            // ^data_in XORs all bits to get even parity
            mem_array[mif.address] = {^mif.data_in, mif.data_in};
        end else if (mif.read) begin
            mif.data_out = mem_array[mif.address];
        end
    end

endmodule
