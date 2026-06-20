class axi_driver;

virtual axi_if vif;

mailbox gen2drv;

function new(virtual axi_if vif,
             mailbox gen2drv);

    this.vif     = vif;
    this.gen2drv = gen2drv;

endfunction

task write(input axi_transaction tr);

    @(posedge vif.ACLK);

    vif.AWADDR  <= tr.addr;
    vif.AWVALID <= 1'b1;

    vif.WDATA   <= tr.data;
    vif.WVALID  <= 1'b1;

    vif.BREADY  <= 1'b1;

    while (!vif.AWREADY)
        @(posedge vif.ACLK);

    @(posedge vif.ACLK);
    vif.AWVALID <= 1'b0;

    while (!vif.WREADY)
        @(posedge vif.ACLK);

    @(posedge vif.ACLK);
    vif.WVALID <= 1'b0;

    while (!vif.BVALID)
        @(posedge vif.ACLK);

    $display("[DRIVER] WRITE ADDR=%h DATA=%h",
             tr.addr,
             tr.data);

    @(posedge vif.ACLK);

    vif.BREADY <= 1'b0;

endtask

task run();

    axi_transaction tr;

    forever begin

        gen2drv.get(tr);

        if(tr.write)
            write(tr);
        else
            read(tr);

    end

endtask

task read(input axi_transaction tr);

    @(posedge vif.ACLK);

    vif.ARADDR  <= tr.addr;
    vif.ARVALID <= 1'b1;

    vif.RREADY  <= 1'b1;

    while(!vif.ARREADY)
        @(posedge vif.ACLK);

    @(posedge vif.ACLK);

    vif.ARVALID <= 1'b0;

    while(!vif.RVALID)
        @(posedge vif.ACLK);

    $display("[DRIVER] READ ADDR=%h DATA=%h",
             tr.addr,
             vif.RDATA);

    @(posedge vif.ACLK);

    vif.RREADY <= 1'b0;

endtask

endclass
