class axi_transaction;

    rand bit write;

    rand bit [31:0] addr;
    rand bit [31:0] data;

    bit [1:0] bresp;
    bit [1:0] rresp;

    constraint addr_c {
        addr inside {
            32'h0,
            32'h4,
            32'h8,
            32'hC
        };
    }

function void display();

    $display("--------------------------------");
    $display("AXI Transaction");

    if(write)
    begin
        $display("TYPE  = WRITE");
        $display("ADDR  = %h", addr);
        $display("DATA  = %h", data);
        $display("BRESP = %0d", bresp);
    end
    else
    begin
        $display("TYPE  = READ");
        $display("ADDR  = %h", addr);
        $display("DATA  = %h", data);
        $display("RRESP = %0d", rresp);
    end

    $display("--------------------------------");

endfunction

endclass