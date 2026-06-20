`timescale 1ns/1ps

module axi_driver_test;

axi_transaction tr;
axi_driver      drv;

axi_if vif();

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

initial begin
    vif.ACLK = 0;
end

always #5 vif.ACLK = ~vif.ACLK;

initial begin

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

    tr = new();

    drv = new(vif);

    assert(tr.randomize());

    tr.display();

    drv.write(tr);

    #100;

    $display("DRIVER TEST PASSED");

    $finish;

end

initial begin

    #2000;

    $display("TIMEOUT ERROR");

    $finish;

end

endmodule
