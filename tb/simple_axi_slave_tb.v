`timescale 1ns/1ps

module simple_axi_slave_tb;

    reg         ACLK;
    reg         ARESETn;

    reg         AWREADY_DELAY_EN;
    reg         WREADY_DELAY_EN;
    reg         ARREADY_DELAY_EN;

    reg  [31:0] AWADDR;
    reg         AWVALID;
    wire        AWREADY;

    reg  [31:0] WDATA;
    reg         WVALID;
    wire        WREADY;

    wire [1:0]  BRESP;
    wire        BVALID;
    reg         BREADY;

    reg  [31:0] ARADDR;
    reg         ARVALID;
    wire        ARREADY;

    wire [31:0] RDATA;
    wire [1:0]  RRESP;
    wire        RVALID;
    reg         RREADY;

    integer pass_count;
    integer fail_count;
    integer protocol_error_count;

    reg bug_injection_enable;

    reg [31:0] prev_AWADDR;
    reg [31:0] prev_WDATA;
    reg [31:0] prev_ARADDR;
    reg [31:0] prev_RDATA;

    reg prev_aw_stall;
    reg prev_w_stall;
    reg prev_ar_stall;
    reg prev_r_stall;

    simple_axi_slave dut (
        .ACLK(ACLK),
        .ARESETn(ARESETn),

        .AWREADY_DELAY_EN(AWREADY_DELAY_EN),
        .WREADY_DELAY_EN(WREADY_DELAY_EN),
        .ARREADY_DELAY_EN(ARREADY_DELAY_EN),

        .AWADDR(AWADDR),
        .AWVALID(AWVALID),
        .AWREADY(AWREADY),

        .WDATA(WDATA),
        .WVALID(WVALID),
        .WREADY(WREADY),

        .BRESP(BRESP),
        .BVALID(BVALID),
        .BREADY(BREADY),

        .ARADDR(ARADDR),
        .ARVALID(ARVALID),
        .ARREADY(ARREADY),

        .RDATA(RDATA),
        .RRESP(RRESP),
        .RVALID(RVALID),
        .RREADY(RREADY)
    );

    always #5 ACLK = ~ACLK;

    always @(posedge ACLK or negedge ARESETn) begin
        if (!ARESETn) begin
            prev_AWADDR <= 32'h0000_0000;
            prev_WDATA  <= 32'h0000_0000;
            prev_ARADDR <= 32'h0000_0000;
            prev_RDATA  <= 32'h0000_0000;

            prev_aw_stall <= 1'b0;
            prev_w_stall  <= 1'b0;
            prev_ar_stall <= 1'b0;
            prev_r_stall  <= 1'b0;
        end else begin
            if (prev_aw_stall && AWVALID && !AWREADY && (AWADDR !== prev_AWADDR)) begin
                protocol_error_count = protocol_error_count + 1;
                $display("PROTOCOL ERROR: AWADDR changed while AWVALID=1 and AWREADY=0 at time %0t", $time);
            end

            if (prev_w_stall && WVALID && !WREADY && (WDATA !== prev_WDATA)) begin
                protocol_error_count = protocol_error_count + 1;
                $display("PROTOCOL ERROR: WDATA changed while WVALID=1 and WREADY=0 at time %0t", $time);
            end

            if (prev_ar_stall && ARVALID && !ARREADY && (ARADDR !== prev_ARADDR)) begin
                protocol_error_count = protocol_error_count + 1;
                $display("PROTOCOL ERROR: ARADDR changed while ARVALID=1 and ARREADY=0 at time %0t", $time);
            end

            if (prev_r_stall && RVALID && !RREADY && (RDATA !== prev_RDATA)) begin
                protocol_error_count = protocol_error_count + 1;
                $display("PROTOCOL ERROR: RDATA changed while RVALID=1 and RREADY=0 at time %0t", $time);
            end

            prev_AWADDR <= AWADDR;
            prev_WDATA  <= WDATA;
            prev_ARADDR <= ARADDR;
            prev_RDATA  <= RDATA;

            prev_aw_stall <= AWVALID && !AWREADY;
            prev_w_stall  <= WVALID  && !WREADY;
            prev_ar_stall <= ARVALID && !ARREADY;
            prev_r_stall  <= RVALID  && !RREADY;
        end
    end

    initial begin
        $dumpfile("waves/simple_axi_slave_tb.vcd");
        $dumpvars(0, simple_axi_slave_tb);
    end

    initial begin
        ACLK       = 1'b0;
        ARESETn    = 1'b0;

        AWREADY_DELAY_EN = 1'b0;
        WREADY_DELAY_EN  = 1'b0;
        ARREADY_DELAY_EN = 1'b0;

        AWADDR     = 32'h0000_0000;
        AWVALID    = 1'b0;
        WDATA      = 32'h0000_0000;
        WVALID     = 1'b0;
        BREADY     = 1'b0;

        ARADDR     = 32'h0000_0000;
        ARVALID    = 1'b0;
        RREADY     = 1'b0;

        pass_count = 0;
        fail_count = 0;
        protocol_error_count = 0;
        bug_injection_enable = 1'b0;

        prev_AWADDR = 32'h0000_0000;
        prev_WDATA  = 32'h0000_0000;
        prev_ARADDR = 32'h0000_0000;
        prev_RDATA  = 32'h0000_0000;

        prev_aw_stall = 1'b0;
        prev_w_stall  = 1'b0;
        prev_ar_stall = 1'b0;
        prev_r_stall  = 1'b0;

        #20;
        ARESETn = 1'b1;

        #10;

        write_and_check(32'h0000_0000, 32'h1111_1111);
        write_and_check(32'h0000_0004, 32'h2222_2222);
        write_and_check(32'h0000_0008, 32'h3333_3333);
        write_and_check(32'h0000_000C, 32'h4444_4444);

        write_with_bready_delay(32'h0000_0010, 32'hAAAA_5555, 3);
        read_with_rready_delay(32'h0000_0010, 32'hAAAA_5555, 4);

        AWREADY_DELAY_EN = 1'b1;
        WREADY_DELAY_EN  = 1'b1;
        ARREADY_DELAY_EN = 1'b1;

        write_and_check(32'h0000_0014, 32'hCAFE_BABE);

        AWREADY_DELAY_EN = 1'b0;
        WREADY_DELAY_EN  = 1'b0;
        ARREADY_DELAY_EN = 1'b0;

        if (bug_injection_enable) begin
            inject_awaddr_stability_bug();
        end

        #20;
        $display("----------------------------------------");
        $display("TEST SUMMARY");
        $display("PASS COUNT = %0d", pass_count);
        $display("FAIL COUNT = %0d", fail_count);
        $display("PROTOCOL ERROR COUNT = %0d", protocol_error_count);
        $display("----------------------------------------");

        if (fail_count == 0 && protocol_error_count == 0) begin
            $display("OVERALL RESULT: TEST PASSED");
        end else begin
            $display("OVERALL RESULT: TEST FAILED");
        end

        #20;
        $finish;
    end

    task axi_write;
        input [31:0] addr;
        input [31:0] data;
        begin
            @(posedge ACLK);
            AWADDR  <= addr;
            AWVALID <= 1'b1;
            WDATA   <= data;
            WVALID  <= 1'b1;
            BREADY  <= 1'b1;

            wait (AWREADY);
            @(posedge ACLK);
            AWVALID <= 1'b0;

            wait (WREADY);
            @(posedge ACLK);
            WVALID <= 1'b0;

            wait (BVALID);

            @(posedge ACLK);
            BREADY <= 1'b0;

            $display("WRITE: addr=%h data=%h response=%b", addr, data, BRESP);
        end
    endtask

    task axi_read;
        input  [31:0] addr;
        output [31:0] data;
        begin
            @(posedge ACLK);
            ARADDR  <= addr;
            ARVALID <= 1'b1;
            RREADY  <= 1'b1;

            wait (ARREADY);

            @(posedge ACLK);
            ARVALID <= 1'b0;

            wait (RVALID);

            data = RDATA;

            @(posedge ACLK);
            RREADY <= 1'b0;

            $display("READ : addr=%h data=%h response=%b", addr, data, RRESP);
        end
    endtask
    task inject_awaddr_stability_bug;
        reg aw_done;
        reg w_done;

        begin
            $display("STARTING INTENTIONAL AWADDR STABILITY BUG TEST");

            aw_done = 1'b0;
            w_done  = 1'b0;

            AWREADY_DELAY_EN = 1'b1;
            WREADY_DELAY_EN  = 1'b1;

            @(posedge ACLK);
            AWADDR  <= 32'h0000_0018;
            AWVALID <= 1'b1;
            WDATA   <= 32'h1234_5678;
            WVALID  <= 1'b1;
            BREADY  <= 1'b1;

            @(posedge ACLK);
            AWADDR <= 32'h0000_001C;

            while (!aw_done || !w_done) begin
                @(posedge ACLK);

                if (AWREADY && AWVALID) begin
                    AWVALID <= 1'b0;
                    aw_done = 1'b1;
                end

                if (WREADY && WVALID) begin
                    WVALID <= 1'b0;
                    w_done = 1'b1;
                end
            end

            wait (BVALID);

            @(posedge ACLK);
            BREADY <= 1'b0;

            AWREADY_DELAY_EN = 1'b0;
            WREADY_DELAY_EN  = 1'b0;

            $display("COMPLETED INTENTIONAL AWADDR STABILITY BUG TEST");
        end
    endtask

    task write_with_bready_delay;
        input [31:0] addr;
        input [31:0] data;
        input integer delay_cycles;
        begin
            @(posedge ACLK);
            AWADDR  <= addr;
            AWVALID <= 1'b1;
            WDATA   <= data;
            WVALID  <= 1'b1;
            BREADY  <= 1'b0;

            wait (AWREADY && WREADY);

            @(posedge ACLK);
            AWVALID <= 1'b0;
            WVALID  <= 1'b0;

            wait (BVALID);

            repeat (delay_cycles) begin
                @(posedge ACLK);
            end

            BREADY <= 1'b1;

            @(posedge ACLK);
            BREADY <= 1'b0;

            $display("WRITE WITH BREADY DELAY: addr=%h data=%h delay=%0d response=%b",
                     addr, data, delay_cycles, BRESP);
        end
    endtask

    task read_with_rready_delay;
        input [31:0] addr;
        input [31:0] expected_data;
        input integer delay_cycles;

        reg [31:0] actual_data;

        begin
            @(posedge ACLK);
            ARADDR  <= addr;
            ARVALID <= 1'b1;
            RREADY  <= 1'b0;

            wait (ARREADY);

            @(posedge ACLK);
            ARVALID <= 1'b0;

            wait (RVALID);

            repeat (delay_cycles) begin
                @(posedge ACLK);
            end

            actual_data = RDATA;
            RREADY <= 1'b1;

            @(posedge ACLK);
            RREADY <= 1'b0;

            if (actual_data == expected_data) begin
                pass_count = pass_count + 1;
                $display("RREADY DELAY CHECK PASS: addr=%h expected=%h actual=%h delay=%0d",
                         addr, expected_data, actual_data, delay_cycles);
            end else begin
                fail_count = fail_count + 1;
                $display("RREADY DELAY CHECK FAIL: addr=%h expected=%h actual=%h delay=%0d",
                         addr, expected_data, actual_data, delay_cycles);
            end
        end
    endtask
    task write_and_check;
        input [31:0] addr;
        input [31:0] expected_data;

        reg [31:0] actual_data;

        begin
            axi_write(addr, expected_data);

            #10;

            axi_read(addr, actual_data);

            if (actual_data == expected_data) begin
                pass_count = pass_count + 1;
                $display("CHECK PASS: addr=%h expected=%h actual=%h",
                         addr, expected_data, actual_data);
            end else begin
                fail_count = fail_count + 1;
                $display("CHECK FAIL: addr=%h expected=%h actual=%h",
                         addr, expected_data, actual_data);
            end

            #10;
        end
    endtask

endmodule