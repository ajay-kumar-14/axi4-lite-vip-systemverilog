class axi_scoreboard;

mailbox mon2scb;

// Reference memory model
bit [31:0] expected_mem [0:15];

// Statistics
int tx_count;
int write_count;
int read_count;
int error_count;

// Constructor
function new(mailbox mon2scb);

    this.mon2scb = mon2scb;

    $display("######## SCOREBOARD CONSTRUCTOR EXECUTED ########");

    tx_count    = 0;
    write_count = 0;
    read_count  = 0;
    error_count = 0;

    foreach(expected_mem[i])
        expected_mem[i] = 32'h0;

endfunction

//====================================================
// Main Scoreboard Task
//====================================================

task run();

axi_transaction tr;

forever begin

    mon2scb.get(tr);

    tx_count++;

    //--------------------------------------------------
    // Address Range Check
    //--------------------------------------------------
    if(tr.addr[5:2] > 15)
    begin

        error_count++;

        $display(
            "[SCB ERROR] INVALID ADDRESS = %h",
            tr.addr
        );

        continue;

    end

//--------------------------------------------------
// WRITE TRANSACTION
//--------------------------------------------------
if(tr.write)
begin

    write_count++;

    if(tr.bresp != 2'b00)
    begin
        error_count++;

        $display(
            "[SCB ERROR] WRITE BRESP=%0b ADDR=%h",
            tr.bresp,
            tr.addr
        );
    end

    expected_mem[tr.addr[5:2]] = tr.data;

    $display(
        "[SCB WRITE] ADDR=%h DATA=%h BRESP=%0d",
        tr.addr,
        tr.data,
        tr.bresp
    );

end

//--------------------------------------------------
// READ TRANSACTION
//--------------------------------------------------
else
begin

    read_count++;

    if(tr.rresp != 2'b00)
    begin
        error_count++;

        $display(
            "[SCB ERROR] READ RRESP=%0b ADDR=%h",
            tr.rresp,
            tr.addr
        );
    end

    if(tr.data !== expected_mem[tr.addr[5:2]])
    begin

        error_count++;

        $display(
            "[SCB ERROR] ADDR=%h EXPECTED=%h ACTUAL=%h",
            tr.addr,
            expected_mem[tr.addr[5:2]],
            tr.data
        );

    end
    else
    begin

        $display(
            "[SCB PASS ] ADDR=%h DATA=%h RRESP=%0d",
            tr.addr,
            tr.data,
            tr.rresp
        );

    end

end

end

endtask

//====================================================
// Final Report
//====================================================
task report();

$display("");
$display("=================================");
$display("      SCOREBOARD REPORT");
$display("=================================");
$display(" Total Transactions = %0d", tx_count);
$display(" Write Transactions = %0d", write_count);
$display(" Read Transactions  = %0d", read_count);
$display(" Error Count        = %0d", error_count);

if(error_count == 0)
    $display(" SCOREBOARD PASSED");
else
    $display(" SCOREBOARD FAILED");

$display("=================================");
$display("");

endtask

endclass
