class axi_generator;

    mailbox gen2drv;

    int tx_count;

    function new(mailbox gen2drv);
        this.gen2drv = gen2drv;
        tx_count = 0;
    endfunction

    task run();

        axi_transaction tr;

        repeat (20)
        begin
            tr = new();

            assert(tr.randomize());

            tr.display();

            gen2drv.put(tr);
        end

    endtask

endclass