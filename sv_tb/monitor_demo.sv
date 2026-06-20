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

    for (int i = 1; i <= 3; i++) begin

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

class monitor;

    function new();
    endfunction

task observe(axi_transaction tx);

    $display("Monitor Observed Transaction");
    $display("ADDR  = %h", tx.addr);
    $display("DATA  = %h", tx.data);
    $display("WRITE = %0d", tx.write);
    $display("=====================");

endtask

endclass

class driver;

    mailbox mbx;
    monitor mon;

    function new(mailbox mbx, monitor mon);

        this.mbx = mbx;
        this.mon = mon;

    endfunction

task drive();

    axi_transaction tx;

    for (int i = 1; i <= 3; i++) begin

        mbx.get(tx);

        $display("Driver Received Transaction");
        $display("ADDR  = %h", tx.addr);
        $display("DATA  = %h", tx.data);
        $display("WRITE = %0d", tx.write);
        $display("---------------------");
mon.observe(tx);
    end

endtask

endclass

module monitor_demo;

    mailbox mbx;

    generator gen;
    driver    drv;
    monitor   mon;

initial begin

    mbx = new();

    gen = new(mbx);

    mon = new();

    drv = new(mbx, mon);

    gen.create_transactions();

    drv.drive();

end

endmodule