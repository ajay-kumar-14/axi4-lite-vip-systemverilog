`timescale 1ns/1ps

module axi_env_test;

axi_if vif();

mailbox gen2drv;
mailbox mon2scb;
mailbox mon2cov;

axi_generator  gen;
axi_driver     drv;
axi_monitor    mon;
axi_scoreboard scb;
axi_coverage cov;
axi_protocol_checker proto_chk;

reg AWREADY_DELAY_EN;
reg WREADY_DELAY_EN;
reg ARREADY_DELAY_EN;

simple_axi_slave dut (

.ACLK(vif.ACLK),
.ARESETn(vif.ARESETn),

.AWREADY_DELAY_EN(AWREADY_DELAY_EN),
.WREADY_DELAY_EN(WREADY_DELAY_EN),
.ARREADY_DELAY_EN(ARREADY_DELAY_EN),

.AWADDR(vif.AWADDR),
.AWVALID(vif.AWVALID),
.AWREADY(vif.AWREADY),

.WDATA(vif.WDATA),
.WVALID(vif.WVALID),
.WREADY(vif.WREADY),

.BRESP(vif.BRESP),
.BVALID(vif.BVALID),
.BREADY(vif.BREADY),

.ARADDR(vif.ARADDR),
.ARVALID(vif.ARVALID),
.ARREADY(vif.ARREADY),

.RDATA(vif.RDATA),
.RRESP(vif.RRESP),
.RVALID(vif.RVALID),
.RREADY(vif.RREADY)

);

axi_assertions assertions_i(vif);

initial begin
vif.ACLK = 0;
end

always #5 vif.ACLK = ~vif.ACLK;

initial begin
proto_chk = new(vif);
vif.ARESETn = 0;

AWREADY_DELAY_EN = 0;
WREADY_DELAY_EN  = 0;
ARREADY_DELAY_EN = 0;

vif.AWADDR  = 0;
vif.AWVALID = 0;

vif.WDATA   = 0;
vif.WVALID  = 0;

vif.BREADY  = 0;

vif.ARADDR  = 0;
vif.ARVALID = 0;

vif.RREADY  = 0;

#20;

vif.ARESETn = 1;

$display("[%0t] RESET RELEASED", $time);

end

initial begin

wait(vif.ARESETn);

gen2drv = new();
mon2scb = new();
mon2cov = new();

gen = new(gen2drv);

drv = new(
    vif,
    gen2drv
);

mon = new(
    vif,
    mon2scb,
    mon2cov
);
scb = new(
    mon2scb
);

cov = new(
    mon2cov
);

fork

    gen.run();
    drv.run();
    mon.run();
    scb.run();
    cov.run();
    proto_chk.run();
join_none


end

initial begin

#5000;

scb.report();

$display("ENVIRONMENT TEST PASSED");
cov.report();
$finish;

end
endmodule
