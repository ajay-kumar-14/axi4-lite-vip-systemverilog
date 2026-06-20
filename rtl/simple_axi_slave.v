`timescale 1ns/1ps

module simple_axi_slave (
input  wire        ACLK,
input  wire        ARESETn,

input  wire        AWREADY_DELAY_EN,
input  wire        WREADY_DELAY_EN,
input  wire        ARREADY_DELAY_EN,

input  wire [31:0] AWADDR,
input  wire        AWVALID,
output reg         AWREADY,

input  wire [31:0] WDATA,
input  wire        WVALID,
output reg         WREADY,

output reg  [1:0]  BRESP,
output reg         BVALID,
input  wire        BREADY,

input  wire [31:0] ARADDR,
input  wire        ARVALID,
output reg         ARREADY,

output reg  [31:0] RDATA,
output reg  [1:0]  RRESP,
output reg         RVALID,
input  wire        RREADY
);

reg [31:0] mem [0:15];

reg [31:0] awaddr_reg;
reg [31:0] wdata_reg;
reg [31:0] araddr_reg;   // <-- ADD THIS

reg read_in_progress;

reg aw_received;
reg w_received;

integer i;

always @(posedge ACLK or negedge ARESETn)
begin

if(!ARESETn)
begin

    AWREADY <= 0;
    WREADY  <= 0;

    BVALID  <= 0;
    BRESP   <= 0;

    ARREADY <= 0;

    RVALID  <= 0;
    RRESP   <= 0;
    RDATA   <= 0;
read_in_progress <= 0;
    aw_received <= 0;
    w_received  <= 0;

awaddr_reg <= 0;
wdata_reg  <= 0;
araddr_reg <= 0;  

    for(i=0;i<16;i=i+1)
        mem[i] <= 0;

end
else
begin

    //--------------------------------------------------
    // Default READY generation
    //--------------------------------------------------
    AWREADY <= (!aw_received && !BVALID);
    WREADY  <= (!w_received  && !BVALID);

    //--------------------------------------------------
    // AW Handshake
    //--------------------------------------------------
    if(AWVALID && AWREADY)
    begin

        awaddr_reg <= AWADDR;
        aw_received <= 1'b1;

        $display("[%0t] DUT AW Handshake AWADDR=%h",
                 $time,
                 AWADDR);

    end

    //--------------------------------------------------
    // W Handshake
    //--------------------------------------------------
    if(WVALID && WREADY)
    begin

        wdata_reg <= WDATA;
        w_received <= 1'b1;

        $display("[%0t] DUT W Handshake WDATA=%h",
                 $time,
                 WDATA);

    end

    //--------------------------------------------------
    // Generate Write Response
    //--------------------------------------------------
    if(aw_received &&
       w_received  &&
       !BVALID)
    begin

        mem[awaddr_reg[5:2]] <= wdata_reg;

        BVALID <= 1'b1;
        BRESP  <= 2'b00;

        aw_received <= 1'b0;
        w_received  <= 1'b0;

        $display("[%0t] DUT Generating BVALID",
                 $time);

    end

    //--------------------------------------------------
    // B Channel Handshake
    //--------------------------------------------------
    if(BVALID && BREADY)
    begin

        BVALID <= 1'b0;

        $display("[%0t] DUT B Handshake Complete",
                 $time);

    end

//--------------------------------------------------
// Read Address Channel
//--------------------------------------------------
ARREADY <= 1'b0;

if(ARVALID && !read_in_progress && !RVALID)
begin
    ARREADY <= 1'b1;

    araddr_reg <= ARADDR;

    RDATA <= mem[ARADDR[5:2]];
    RRESP <= 2'b00;
    RVALID <= 1'b1;

    read_in_progress <= 1'b1;

    $display("[%0t] DUT Read Request Addr=%h Data=%h",
             $time,
             ARADDR,
             mem[ARADDR[5:2]]);
end

//--------------------------------------------------
// Read Data Channel
//--------------------------------------------------
if(RVALID && RREADY)
begin
    RVALID <= 1'b0;
    read_in_progress <= 1'b0;
end
end

end

endmodule
