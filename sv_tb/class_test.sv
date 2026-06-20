class packet;

    int data;

endclass


module class_test;

    packet p;

    initial begin

        p = new();

        p.data = 100;

        $display("DATA = %0d", p.data);

    end

endmodule