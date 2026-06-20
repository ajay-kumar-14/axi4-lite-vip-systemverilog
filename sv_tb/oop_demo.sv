class Student;

    string name;
    int marks;

endclass

module oop_demo;

    Student s1;

    initial begin

        s1 = new();

        s1.name  = "Ajay";
        s1.marks = 100;

        $display("Name  = %s", s1.name);
        $display("Marks = %0d", s1.marks);

    end

endmodule