// transaction_pkg.sv
// Package that holds the Transaction class used by the testbench.
// Keeps the class definition separate so both the program block and
// top level can include it cleanly.

package transaction_pkg;

    class Transaction;

        // regular (non-static) class variables
        rand logic [15:0] address;
        rand logic [7:0]  data_in;
        logic [8:0]       data_out;      // captured after read
        logic [8:0]       expected_data; // what we expect to read back

        // static variable shared across ALL Transaction objects
        // tracks total number of mismatches found during simulation
        static int error = 0;

        // custom constructor
        // randomizes address and data_in when a new transaction is created
        function new();
            if (!this.randomize()) begin
                $fatal(1, "Transaction randomize() failed!");
            end
        endfunction

        // deep copy: creates a brand new Transaction with the same field values
        // needed so that the queue holds independent copies, not references
        function Transaction copy();
            Transaction t = new();
            t.address       = this.address;
            t.data_in       = this.data_in;
            t.data_out      = this.data_out;
            t.expected_data = this.expected_data;
            return t;
        endfunction

        // print the data_out value along with simulation time
        function void print_data_out();
            $display("[%0t] data_out = 0x%0h (parity=%b, data=%0h)",
                     $time, data_out, data_out[8], data_out[7:0]);
        endfunction

        // static function to print total error count with timestamp
        // static so it can be called without an object handle
        static function void print_errors();
            $display("[%0t] Total errors so far: %0d", $time, error);
        endfunction

        // check if what we read back matches what we wrote
        // if they don't match, increment the shared static error counter
        function void check_result();
            if (data_out !== expected_data) begin
                $error("[%0t] MISMATCH at addr=0x%0h | expected=0x%0h | got=0x%0h",
                       $time, address, expected_data, data_out);
                error++;
            end else begin
                $display("[%0t] PASS addr=0x%0h | data=0x%0h", $time, address, expected_data);
            end
        endfunction

    endclass

endpackage
