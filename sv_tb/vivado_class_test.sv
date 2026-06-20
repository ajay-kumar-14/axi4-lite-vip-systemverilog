class packet;

    int data;

    function new();

        data = 1234;

    endfunction

endclass


module vivado_class_test;

    packet pkt;

    initial begin

        pkt = new();

        $display("DATA = %0d", pkt.data);

    end

endmodule