class axi_coverage;

mailbox mon2cov;

axi_transaction tr;

covergroup axi_cg;

    //------------------------------------
    // Address Coverage
    //------------------------------------
    ADDR_CP : coverpoint tr.addr
    {
        bins addr0 = {32'h0};
        bins addr4 = {32'h4};
        bins addr8 = {32'h8};
        bins addrC = {32'hC};
    }

    //------------------------------------
    // Read / Write Coverage
    //------------------------------------
    RW_CP : coverpoint tr.write
    {
        bins READ  = {0};
        bins WRITE = {1};
    }

    //------------------------------------
    // Response Coverage
    //------------------------------------
    RESP_CP : coverpoint (tr.write ? tr.bresp : tr.rresp)
    {
        bins OKAY   = {2'b00};
        bins SLVERR = {2'b10};
    }

    //------------------------------------
    // Address x Read/Write
    //------------------------------------
    ADDR_X_RW : cross ADDR_CP, RW_CP;

endgroup

function new(mailbox mon2cov);

    this.mon2cov = mon2cov;

    axi_cg = new();

endfunction

task run();

    forever begin

        mon2cov.get(tr);

        axi_cg.sample();

        $display("[COVERAGE] Coverage = %0.2f%%",
                 axi_cg.get_coverage());

    end

endtask

function void report();

    $display("FINAL COVERAGE = %0.2f%%",
             axi_cg.get_coverage());

endfunction

endclass
