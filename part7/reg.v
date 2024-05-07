`timescale  1ns/100ps

module reg_file(IN, OUT1, OUT2, INADDRESS, OUT1ADDRESS, OUT2ADDRESS, WRITE, CLK, RESET);
    // Declare input
    input [7:0] IN;
	input [2:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS;
	input WRITE, CLK, RESET;
    // Declare output
	output [7:0] OUT1, OUT2;
	
	
	
	// 8 x 8 register
	reg [7:0] REGISTER [7:0];

	//iterative variable
	integer i;
	
	
	//assigning the outputs
	assign #2 OUT1 = REGISTER[OUT1ADDRESS];		//assign the value that storesd in OUT1ADDRESS
	assign #2 OUT2 = REGISTER[OUT2ADDRESS];		//assign the value that storesd in OUT2ADDRESS
	
	
	always @ (posedge CLK)
	begin
		if (RESET == 1'b1)		
		begin		
			for (i = 0; i < 8; i = i + 1)			
			begin
				REGISTER[i] = 8'b00000000;		
			end			
		end
		else if (WRITE == 1'b1)			
		begin		
			#1 REGISTER[INADDRESS] = IN;			
		end		
	end	
    initial begin
	    $monitor($time, "\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d", REGISTER[0], REGISTER[1],REGISTER[2],REGISTER[3],REGISTER[4],REGISTER[5],REGISTER[6],REGISTER[7]);        
    end
endmodule

