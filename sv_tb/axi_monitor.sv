class axi_monitor;

virtual axi_if vif;

mailbox mon2scb;
mailbox mon2cov;

//--------------------------------------------
// Constructor
//--------------------------------------------
function new(
    virtual axi_if vif,
    mailbox mon2scb,
    mailbox mon2cov
);

    this.vif     = vif;
    this.mon2scb = mon2scb;
    this.mon2cov = mon2cov;

endfunction

//--------------------------------------------
// Main Monitor Task
//--------------------------------------------
task run();

    axi_transaction tr;

    forever begin

        @(posedge vif.ACLK);

        //----------------------------------
        // WRITE TRANSACTION
        //----------------------------------
        if(vif.BVALID && vif.BREADY)
        begin

            tr = new();

            tr.write = 1;

            tr.addr  = vif.AWADDR;
            tr.data  = vif.WDATA;

            // Capture AXI response
            tr.bresp = vif.BRESP;

            mon2scb.put(tr);
            mon2cov.put(tr);

            $display(
                "[MONITOR] WRITE ADDR=%h DATA=%h BRESP=%0d",
                tr.addr,
                tr.data,
                tr.bresp
            );

        end

        //----------------------------------
        // READ TRANSACTION
        //----------------------------------
        if(vif.RVALID && vif.RREADY)
        begin

            tr = new();

            tr.write = 0;

            tr.addr  = vif.ARADDR;
            tr.data  = vif.RDATA;

            // Capture AXI response
            tr.rresp = vif.RRESP;

            mon2scb.put(tr);
            mon2cov.put(tr);

            $display(
                "[MONITOR] READ ADDR=%h DATA=%h RRESP=%0d",
                tr.addr,
                tr.data,
                tr.rresp
            );

            wait(!vif.RVALID);

        end

    end

endtask

endclass