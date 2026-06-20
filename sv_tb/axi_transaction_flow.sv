class axi_transaction;

    bit [31:0] addr;
    bit [31:0] data;
    bit        write;

endclass


class generator;

    mailbox mbx;

    function new(mailbox mbx);

        this.mbx = mbx;

    endfunction

task create_transactions();

    axi_transaction tx;

    for (int i = 1; i <= 5; i++) begin

        tx = new();

        tx.addr  = i * 16;
        tx.data  = i * 100;
        tx.write = 1;

        mbx.put(tx);

        $display("Generator Sent Transaction");
        $display("ADDR  = %h", tx.addr);
        $display("DATA  = %h", tx.data);
        $display("WRITE = %0d", tx.write);
        $display("---------------------");

    end

endtask

endclass


class driver;

    mailbox mbx;

    function new(mailbox mbx);

        this.mbx = mbx;

    endfunction

task drive();

    axi_transaction tx;

    for (int i = 1; i <= 5; i++) begin

        mbx.get(tx);

        $display("Driver Received Transaction");
        $display("ADDR  = %h", tx.addr);
        $display("DATA  = %h", tx.data);
        $display("WRITE = %0d", tx.write);
        $display("---------------------");

    end

endtask

endclass


module axi_transaction_flow;

    mailbox mbx;

    generator gen;
    driver    drv;

initial begin

    mbx = new();

    gen = new(mbx);
    drv = new(mbx);

    gen.create_transactions();

    drv.drive();

end

endmodule