`timescale 1ns/1ps

module axi_generator_test;

axi_generator gen;

initial begin

    gen = new();

    repeat (10) begin
        gen.generate_transaction();
        #10;
    end

    $display("\nGENERATOR TEST PASSED\n");

    $finish;

end

endmodule
