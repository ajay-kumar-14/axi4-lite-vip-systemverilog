class axi_protocol_checker;

virtual axi_if vif;

int error_count;

function new(virtual axi_if vif);

    this.vif = vif;
    error_count = 0;

endfunction

task run();

    $display("######## PROTOCOL CHECKER STARTED ########");

    forever begin

        @(posedge vif.ACLK);

        if(vif.AWVALID && !vif.AWREADY)
        begin

            @(posedge vif.ACLK);

            if(!vif.AWVALID)
            begin

                error_count++;

                $display(
                    "[PROTOCOL ERROR] AWVALID dropped before AWREADY"
                );

            end

        end

    end

endtask


endclass