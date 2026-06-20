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


class generator;

    axi_transaction tx;

    function new();

        tx = new();

    endfunction

function void create_transaction();

    tx.addr  = 32'h00000010;
    tx.data  = 32'hAAAA5555;
    tx.write = 1;

endfunction

endclass


module generator_demo;

    generator gen;

    initial begin

        gen = new();

gen.create_transaction();

        gen.tx.display();

    end

endmodule