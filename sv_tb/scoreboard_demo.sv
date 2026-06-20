class axi_transaction;

    bit [31:0] addr;
    bit [31:0] data;
    bit        write;

endclass


class scoreboard;

    function new();
    endfunction


task check_transaction(axi_transaction tx);

    if (tx.write == 1)
        $display("SCOREBOARD PASS : WRITE Transaction");

    else
        $display("SCOREBOARD FAIL : Invalid WRITE Field");

endtask

endclass


module scoreboard_demo;

    scoreboard sb;
    axi_transaction tx;

initial begin

    sb = new();

    tx = new();

    tx.addr  = 32'h10;
    tx.data  = 32'h64;
    tx.write = 1;

    sb.check_transaction(tx);

end

endmodule
