`timescale 1ns/1ps

module axi_multi_rw_test;

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

reg [31:0] test_addr [0:3];
reg [31:0] test_data [0:3];

integer i;
integer error_count;

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

initial begin
ACLK = 0;
end

always #5 ACLK = ~ACLK;

initial begin

ARESETn = 0;

AWREADY_DELAY_EN = 0;
WREADY_DELAY_EN  = 0;
ARREADY_DELAY_EN = 0;

AWADDR  = 0;
AWVALID = 0;

WDATA   = 0;
WVALID  = 0;

BREADY  = 0;

ARADDR  = 0;
ARVALID = 0;

RREADY  = 0;

error_count = 0;

test_addr[0] = 32'h0000_0000;
test_addr[1] = 32'h0000_0004;
test_addr[2] = 32'h0000_0008;
test_addr[3] = 32'h0000_000C;

test_data[0] = 32'd100;
test_data[1] = 32'd200;
test_data[2] = 32'd300;
test_data[3] = 32'd400;

#20;

ARESETn = 1;

$display("[%0t] RESET RELEASED", $time);

end

initial begin

wait(ARESETn);

//-----------------------------------
// WRITE PHASE
//-----------------------------------

for(i=0; i<4; i=i+1) begin

    @(posedge ACLK);

    AWADDR  <= test_addr[i];
    WDATA   <= test_data[i];

    AWVALID <= 1'b1;
    WVALID  <= 1'b1;
    BREADY  <= 1'b1;

    $display("[%0t] WRITE ADDR=%h DATA=%h",
             $time,
             test_addr[i],
             test_data[i]);

    while(!AWREADY)
        @(posedge ACLK);

    @(posedge ACLK);
    AWVALID <= 0;

    while(!WREADY)
        @(posedge ACLK);

    @(posedge ACLK);
    WVALID <= 0;

    while(!BVALID)
        @(posedge ACLK);

    @(posedge ACLK);
    BREADY <= 0;

end

//-----------------------------------
// READ PHASE
//-----------------------------------

for(i=0; i<4; i=i+1) begin

    @(posedge ACLK);

    ARADDR  <= test_addr[i];
    ARVALID <= 1'b1;
    RREADY  <= 1'b1;

    while(!ARREADY)
        @(posedge ACLK);

    @(posedge ACLK);
    ARVALID <= 0;

    while(!RVALID)
        @(posedge ACLK);

    if(RDATA == test_data[i]) begin

        $display("[%0t] PASS ADDR=%h DATA=%h",
                 $time,
                 test_addr[i],
                 RDATA);

    end
    else begin

        error_count = error_count + 1;

        $display("[%0t] FAIL ADDR=%h EXPECTED=%h ACTUAL=%h",
                 $time,
                 test_addr[i],
                 test_data[i],
                 RDATA);

    end

    @(posedge ACLK);
    RREADY <= 0;

end

//-----------------------------------
// SUMMARY
//-----------------------------------

if(error_count == 0)
    $display("ALL TESTS PASSED");
else
    $display("TOTAL FAILURES = %0d", error_count);

#50;

$finish;


end

initial begin

#5000;

$display("TIMEOUT ERROR");

$finish;


end

endmodule
