// Forward Function
module FORWARD (
    DATA1,
    DATA2,
    RESULT
);
    // Define Inputs
    input [7:0] DATA1, DATA2;
    // Define Outputs
    output reg [7:0] RESULT;

    always @(DATA1, DATA2) begin
        #1
        RESULT = DATA2; 
    end
    
endmodule


// bitvise AND
module AND (
    DATA1,
    DATA2,
    RESULT
);

    // Define Inputs
    input [7:0] DATA1, DATA2;
    // Define Outputs
    output reg [7:0] RESULT;

    always @(DATA1, DATA2) begin  
        #1      
        RESULT = DATA1 & DATA2;
    end
    
endmodule

// Bitwise OR
module OR (
    DATA1,
    DATA2,
    RESULT
);

    // Define Inputs
    input [7:0] DATA1, DATA2;
    // Define Outputs
    output reg [7:0] RESULT;

    always @(DATA1, DATA2) begin
        #1
        RESULT = DATA1 | DATA2;
    end
    
endmodule

// Module ADD
module ADD (
    DATA1,
    DATA2,
    RESULT
);

    // Define Inputs
    input [7:0] DATA1, DATA2;
    // Define Outputs
    output reg [7:0] RESULT;

    always @(DATA1, DATA2) begin
        #2
        RESULT = DATA1 + DATA2;
    end
    
endmodule

module ALU (
    DATA1,
    DATA2,
    RESULT,
    SELECT
);
    // Define Inputs
    input [7:0] DATA1,DATA2;
    input [2:0] SELECT;
    // Define Output
    output reg [7:0] RESULT;
    wire [7:0] wire1,wire2,wire3,wire4;
    
    FORWARD forward1(DATA1,DATA2,wire1);            
    ADD add1(DATA1,DATA2,wire2);            
    AND and1(DATA1,DATA2,wire3);            
    OR or1(DATA1,DATA2,wire4);  

    always @(SELECT) begin
        case (SELECT)
            3'b000: assign RESULT = wire1;
            3'b001: assign RESULT = wire2;
            3'b010: assign RESULT = wire3;
            3'b011: assign RESULT = wire4;
        endcase
    end    

endmodule
