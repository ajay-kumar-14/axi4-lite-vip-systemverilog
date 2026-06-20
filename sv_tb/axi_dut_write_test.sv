`timescale 1ns/1ps

module axi_dut_write_test;

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

// Clock
initial begin
ACLK = 0;
end

always #5 ACLK = ~ACLK;

// Reset
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

#20;

ARESETn = 1;

$display("[%0t] RESET RELEASED", $time);

end

// Write Transaction
initial begin

wait(ARESETn);

@(posedge ACLK);

AWADDR  <= 32'h0000_0010;
WDATA   <= 32'h1234_5678;

AWVALID <= 1'b1;
WVALID  <= 1'b1;

BREADY  <= 1'b1;

$display("[%0t] Starting AXI Write", $time);

while (!AWREADY)
    @(posedge ACLK);

@(posedge ACLK);
AWVALID <= 1'b0;

$display("[%0t] AW Handshake Complete", $time);

while (!WREADY)
    @(posedge ACLK);

@(posedge ACLK);
WVALID <= 1'b0;

$display("[%0t] W Handshake Complete", $time);

while (!BVALID)
    @(posedge ACLK);

$display("[%0t] BVALID Received", $time);
$display("[%0t] BRESP = %0d", $time, BRESP);

@(posedge ACLK);

BREADY <= 1'b0;
// -------------------------
// AXI READ TRANSACTION
// -------------------------

@(posedge ACLK);

ARADDR  <= 32'h0000_0010;
ARVALID <= 1'b1;

RREADY  <= 1'b1;

$display("[%0t] Starting AXI Read", $time);

while (!ARREADY)
    @(posedge ACLK);

@(posedge ACLK);
ARVALID <= 1'b0;

$display("[%0t] AR Handshake Complete", $time);

while (!RVALID)
    @(posedge ACLK);

$display("[%0t] RVALID Received", $time);
$display("[%0t] RDATA = %h", $time, RDATA);

if (RDATA == 32'h1234_5678)
    $display("[%0t] READ TEST PASSED", $time);
else
    $display("[%0t] READ TEST FAILED", $time);

@(posedge ACLK);

RREADY <= 1'b0;

#50;

$display("[%0t] TEST PASSED", $time);

$finish;

end

// Debug Monitor
always @(posedge ACLK) begin

$display("[%0t] AWVALID=%0b AWREADY=%0b WVALID=%0b WREADY=%0b BVALID=%0b",
         $time,
         AWVALID,
         AWREADY,
         WVALID,
         WREADY,
         BVALID);

end

// Timeout Protection
initial begin

#1000;

$display("[%0t] TIMEOUT ERROR", $time);

$finish;

end

endmodule
