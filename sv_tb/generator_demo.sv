module generator_demo;

    integer i;

    initial begin

        for (i = 1; i <= 5; i = i + 1) begin

            $display("---------------------");
            $display("TRANSACTION %0d", i);
            $display("ADDR = %h", i * 16);

        end

    end

endmodule