class packet;

    int addr;

endclass


class generator;

    mailbox mbx;

    function new(mailbox mbx);

        this.mbx = mbx;

    endfunction

task create_packets();

    packet pkt;

    for (int i = 1; i <= 5; i++) begin

        pkt = new();

        pkt.addr = i * 16;

        mbx.put(pkt);

        $display("Generator Sent Packet");
        $display("ADDR = %0d", pkt.addr);

    end

endtask

endclass


class driver;

    mailbox mbx;

    function new(mailbox mbx);

        this.mbx = mbx;

    endfunction

task drive();

    packet pkt;

    for (int i = 1; i <= 5; i++) begin

        mbx.get(pkt);

        $display("Driver Received Packet");
        $display("ADDR = %0d", pkt.addr);

    end

endtask

endclass


module multi_transaction_demo;

    mailbox mbx;

    generator gen;
    driver    drv;

initial begin

    mbx = new();

    gen = new(mbx);
    drv = new(mbx);

    gen.create_packets();

    drv.drive();

end

endmodule