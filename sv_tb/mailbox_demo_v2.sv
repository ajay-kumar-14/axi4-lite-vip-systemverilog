class packet;

    int data;

endclass


module mailbox_demo_v2;

    mailbox mbx;

    packet pkt_tx;
    packet pkt_rx;

    initial begin

        mbx = new();

        pkt_tx = new();
        pkt_tx.data = 100;

        mbx.put(pkt_tx);

        pkt_rx = new();

        mbx.get(pkt_rx);

        $display("DATA = %0d", pkt_rx.data);

    end

endmodule