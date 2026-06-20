class axi_transaction;

    bit [31:0] addr;
    bit [31:0] data;

    bit write;

    function void display();

        $display("ADDR  = %h", addr);
        $display("DATA  = %h", data);
        $display("WRITE = %0d", write);

    endfunction

endclass


module transaction_demo;

    axi_transaction tx1;
    axi_transaction tx2;
    axi_transaction tx3;

    initial begin

        tx1 = new();
        tx1.addr  = 32'h00000010;
        tx1.data  = 32'hAAAA5555;
        tx1.write = 1;

        tx2 = new();
        tx2.addr  = 32'h00000020;
        tx2.data  = 32'hBBBB6666;
        tx2.write = 1;

        tx3 = new();
        tx3.addr  = 32'h00000030;
        tx3.data  = 32'h00000000;
        tx3.write = 0;

        $display("TRANSACTION 1");
        tx1.display();

        $display("TRANSACTION 2");
        tx2.display();

        $display("TRANSACTION 3");
        tx3.display();

    end

endmodule