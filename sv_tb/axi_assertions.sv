module axi_assertions(axi_if vif);

//----------------------------------------
// AWVALID must remain asserted until AWREADY
//----------------------------------------
property awvalid_stable;
    @(posedge vif.ACLK)
    disable iff(!vif.ARESETn)
    vif.AWVALID |-> (vif.AWVALID until_with vif.AWREADY);
endproperty

assert property (awvalid_stable)
else
    $error("[SVA] AWVALID dropped before AWREADY");


//----------------------------------------
// WVALID must remain asserted until WREADY
//----------------------------------------
property wvalid_stable;
    @(posedge vif.ACLK)
    disable iff(!vif.ARESETn)
    vif.WVALID |-> (vif.WVALID until_with vif.WREADY);
endproperty

assert property (wvalid_stable)
else
    $error("[SVA] WVALID dropped before WREADY");


//----------------------------------------
// ARVALID must remain asserted until ARREADY
//----------------------------------------
property arvalid_stable;
    @(posedge vif.ACLK)
    disable iff(!vif.ARESETn)
    vif.ARVALID |-> (vif.ARVALID until_with vif.ARREADY);
endproperty

assert property (arvalid_stable)
else
    $error("[SVA] ARVALID dropped before ARREADY");


//----------------------------------------
// RVALID must remain asserted until RREADY
//----------------------------------------
property rvalid_stable;
    @(posedge vif.ACLK)
    disable iff(!vif.ARESETn)
    vif.RVALID |-> (vif.RVALID until_with vif.RREADY);
endproperty

assert property (rvalid_stable)
else
    $error("[SVA] RVALID dropped before RREADY");


//----------------------------------------
// Optional: BRESP must be valid when BVALID
//----------------------------------------
property bresp_valid;
    @(posedge vif.ACLK)
    disable iff(!vif.ARESETn)
    vif.BVALID |-> (vif.BRESP inside {2'b00,2'b01,2'b10,2'b11});
endproperty

assert property (bresp_valid)
else
    $error("[SVA] Invalid BRESP value");


//----------------------------------------
// Optional: RRESP must be valid when RVALID
//----------------------------------------
property rresp_valid;
    @(posedge vif.ACLK)
    disable iff(!vif.ARESETn)
    vif.RVALID |-> (vif.RRESP inside {2'b00,2'b01,2'b10,2'b11});
endproperty

assert property (rresp_valid)
else
    $error("[SVA] Invalid RRESP value");

endmodule
