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

class receiver;

    mailbox mbx;

    function new(mailbox mbx);

        this.mbx = mbx;

    endfunction

task receive();

        packet pkt;

        mbx.get(pkt);

        $display("Receiver Got Packet");
        $display("ADDR = %0d", pkt.addr);

    endtask

endclass

module generator_mailbox_demo;

    mailbox mbx;

    generator gen;

    receiver recv;

 initial begin

    mbx = new();

    gen  = new(mbx);
    recv = new(mbx);

gen.create_packet();

    recv.receive();

end

endmodule