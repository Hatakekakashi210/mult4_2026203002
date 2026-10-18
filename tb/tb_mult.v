module tb_mult;
	wire [7:0] out;
	reg rst, clock;
	reg [3:0] a, b;
	mult_array ma1 (.a(a), .b(b), .rst(rst), .clock(clock), .out(out));
	integer i, j;
	reg [7:0] expected_ans;
	integer errors = 0;
	integer vectors_checked = 0; 
	initial begin
	    clock = 0;
	    forever #5 clock = ~clock;
	end
	initial begin 
	    $dumpfile ("mult.vcd");
	    $dumpvars (0, tb_mult);
	    rst = 0;
	    a = 0;
	    b = 0;
	    #25 rst = 1;
	    for (i=0; i<16; i = i+1) begin
		for (j=0; j<16; j=j+1) begin
		    @(negedge clock);
		    a = i[3:0];
		    b = j[3:0];
		    expected_ans = a*b;

		    @(negedge clock);
		    @(negedge clock);
		    if (out != expected_ans) begin
		         $display ("Error!! a:%0d, b:%0d, expected:%0d, out:%0d", a,b,expected_ans,out);
			 errors = errors + 1;
		    end
		    vectors_checked = vectors_checked + 1;
		end
	    end
	    if (errors == 0) begin
	        $display("PASS!! vectors_checked : %0d, errors: %0d", vectors_checked, errors);
	    end else begin
	        $display ("FAILED errors: %0d", errors);
	    end	
    	    $finish;	    
	end		
endmodule
