module mailbox_demo;

    mailbox mbx;

    integer data;

    initial begin

        mbx = new();

        mbx.put(100);

        $display("Data Put Into Mailbox");

        mbx.get(data);

        $display("Data Received = %0d", data);

    end

endmodule