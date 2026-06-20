class packet;

    int data;

    function void set_data();

        data = 123;

    endfunction

endclass


module class_method_test;

    packet p;

    initial begin

        p = new();

        p.set_data();

        $display("DATA = %0d", p.data);

    end

endmodule