// test.sv
// Program block for the RAM testbench.
// Drives stimulus and checks results using the clocking block only.

program test (mem_if.tb mif);

    import transaction_pkg::*;

    // queues for passing transactions between tasks
    Transaction gen_q [$];
    Transaction mon_q [$];
    Transaction chk_q [$];

    parameter int NUM_TESTS = 20;

    // reference model to store what we wrote
    logic [8:0] ref_mem [logic [15:0]];

    // flags so tasks know when phases finish
    bit drive_done = 0;

    initial begin
        reset_signals();

        fork
            gen_transactions();
            drive_transactions();
            monitor_output();
            check_output();
        join

        $display("\n[%0t] *** Simulation complete. Total mismatches = %0d ***",
                 $time, Transaction::error);
        Transaction::print_errors();
        $finish;
    end

    task reset_signals();
        mif.cb.write   <= 1'b0;
        mif.cb.read    <= 1'b0;
        mif.cb.data_in <= 8'h00;
        mif.cb.address <= 16'h0000;
        repeat(2) @(mif.cb);
    endtask

    // generate NUM_TESTS writes then NUM_TESTS reads
    task gen_transactions();
        Transaction write_list[$];
        Transaction t;

        // write transactions
        for (int i = 0; i < NUM_TESTS; i++) begin
            t = new();
            t.expected_data = {^t.data_in, t.data_in};
            gen_q.push_back(t);
            write_list.push_back(t.copy());
            @(mif.cb);
        end

        // read transactions using same addresses
        for (int i = 0; i < NUM_TESTS; i++) begin
            t = new();
            t.address       = write_list[i].address;
            t.data_in       = 8'h00;
            t.expected_data = write_list[i].expected_data;
            gen_q.push_back(t);
            @(mif.cb);
        end
    endtask

    // pop from gen_q and drive the DUT
    task drive_transactions();
        Transaction t;
        int count = 0;
        int total = NUM_TESTS * 2;

        while (count < total) begin
            wait (gen_q.size() > 0);
            t = gen_q.pop_front();

            if (count < NUM_TESTS) begin
                do_write(t);
                ref_mem[t.address] = t.expected_data;
            end else begin
                t.expected_data = ref_mem[t.address];
                do_read(t);
                mon_q.push_back(t.copy());
            end
            count++;
        end

        drive_done = 1;
    endtask

    // one synchronous write
    task do_write(Transaction t);
        @(mif.cb);
        mif.cb.write   <= 1'b1;
        mif.cb.read    <= 1'b0;
        mif.cb.address <= t.address;
        mif.cb.data_in <= t.data_in;
        $display("[%0t] WRITE addr=0x%04h  data_in=0x%02h  expect_stored=0x%03h",
                 $time, t.address, t.data_in, t.expected_data);
        @(mif.cb);
        mif.cb.write <= 1'b0;
        @(mif.cb);
    endtask

    // one synchronous read
    task do_read(Transaction t);
        @(mif.cb);
        mif.cb.read    <= 1'b1;
        mif.cb.write   <= 1'b0;
        mif.cb.address <= t.address;
        mif.cb.data_in <= 8'h00;
        $display("[%0t] READ  addr=0x%04h  expecting=0x%03h",
                 $time, t.address, t.expected_data);
        @(mif.cb);
        mif.cb.read <= 1'b0;
        @(mif.cb);
    endtask

    // sample data_out after each read and push to chk_q
    task monitor_output();
        Transaction t;
        while (!drive_done || mon_q.size() > 0) begin
            if (mon_q.size() > 0) begin
                t = mon_q.pop_front();
                @(mif.cb);
                t.data_out = mif.cb.data_out;
                t.print_data_out();
                chk_q.push_back(t);
            end else begin
                @(mif.cb);
            end
        end
    endtask

    // compare expected vs actual for each transaction
    task check_output();
        Transaction t;
        int checked = 0;
        while (checked < NUM_TESTS) begin
            if (chk_q.size() > 0) begin
                t = chk_q.pop_front();
                t.check_result();
                checked++;
            end else begin
                @(mif.cb);
            end
        end
    endtask

endprogram
