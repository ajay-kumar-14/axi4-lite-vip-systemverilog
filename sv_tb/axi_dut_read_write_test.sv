`timescale 1ns/1ps

module axi_dut_read_write_test;

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

reg [31:0] expected_data;

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

expected_data = 32'h1234_5678;

#20;

ARESETn = 1;

$display("[%0t] RESET RELEASED", $time);

end

initial begin

wait(ARESETn);

//----------------------------------
// WRITE TRANSACTION
//----------------------------------

@(posedge ACLK);

AWADDR  <= 32'h0000_0010;
WDATA   <= expected_data;

AWVALID <= 1'b1;
WVALID  <= 1'b1;

BREADY  <= 1'b1;

$display("[%0t] START WRITE", $time);

while (!AWREADY)
    @(posedge ACLK);

@(posedge ACLK);
AWVALID <= 0;

while (!WREADY)
    @(posedge ACLK);

@(posedge ACLK);
WVALID <= 0;

while (!BVALID)
    @(posedge ACLK);

$display("[%0t] WRITE COMPLETE", $time);

@(posedge ACLK);
BREADY <= 0;

//----------------------------------
// READ TRANSACTION
//----------------------------------

@(posedge ACLK);

ARADDR  <= 32'h0000_0010;
ARVALID <= 1'b1;

RREADY  <= 1'b1;

$display("[%0t] START READ", $time);

while (!ARREADY)
    @(posedge ACLK);

@(posedge ACLK);
ARVALID <= 0;

while (!RVALID)
    @(posedge ACLK);

$display("[%0t] READ DATA = %h", $time, RDATA);

//----------------------------------
// CHECKER
//----------------------------------

if (RDATA == expected_data)
    $display("[%0t] TEST PASSED", $time);
else
    $display("[%0t] TEST FAILED Expected=%h Actual=%h",
             $time,
             expected_data,
             RDATA);

@(posedge ACLK);

RREADY <= 0;

#50;

$finish;


end

initial begin

#2000;

$display("[%0t] TIMEOUT ERROR", $time);

$finish;

end

endmodule
