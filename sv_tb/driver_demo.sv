class packet;

    int addr;

endclass


class generator;

    mailbox mbx;

    function new(mailbox mbx);

        this.mbx = mbx;

    endfunction

    task create_packet();

        packet pkt;

        pkt = new();

        pkt.addr = 100;

        mbx.put(pkt);

        $display("Generator Sent Packet");
        $display("ADDR = %0d", pkt.addr);

    endtask

endclass


class driver;

    mailbox mbx;

    function new(mailbox mbx);

        this.mbx = mbx;

    endfunction

    task drive();

        packet pkt;

        mbx.get(pkt);

        $display("Driver Received Packet");
        $display("ADDR = %0d", pkt.addr);

    endtask

endclass


module driver_demo;

    mailbox mbx;

    generator gen;
    driver    drv;

initial begin

    mbx = new();

    gen = new(mbx);
    drv = new(mbx);

    gen.create_packet();

    drv.drive();

end

endmodule