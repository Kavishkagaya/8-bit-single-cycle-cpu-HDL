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

module LeftShift (
    in,
    out,
    shift
);

    input [7:0] in;
    input [2:0] shift;
    output [7:0] out;

    reg [7:0] result;

    always @(*) begin
        case (shift)
            3'b000: result = in; // No shift
            3'b001: result = {in[6:0], 1'b0}; // Shift left by 1 bit
            3'b010: result = {in[5:0], 2'b0}; // Shift left by 2 bits
            3'b011: result = {in[4:0], 3'b0}; // Shift left by 3 bits
            3'b100: result = {in[3:0], 4'b0}; // Shift left by 4 bits
            3'b101: result = {in[2:0], 5'b0}; // Shift left by 5 bits
            3'b110: result = {in[1:0], 6'b0}; // Shift left by 6 bits
            3'b111: result = {in[0], 7'b0}; // Shift left by 7 bits
            default: result = in; // No shift (default case)
        endcase
    end

    // this will need 3 of 2to1 mux levels. so #1 for each and give #3 delay
    assign #3 out = result;

endmodule

module RightShift (
    in,
    out,
    shift
);
    
    input [7:0] in;
    input [2:0] shift;
    output [7:0] out;
    
    reg [7:0] result;

    always @(*) begin
        case (shift)
            3'b000: result = in; // No shift
            3'b001: result = {1'b0, in[7:1]}; // Shift right by 1 bit
            3'b010: result = {2'b0, in[7:2]}; // Shift right by 2 bits
            3'b011: result = {3'b0, in[7:3]}; // Shift right by 3 bits
            3'b100: result = {4'b0, in[7:4]}; // Shift right by 4 bits
            3'b101: result = {5'b0, in[7:5]}; // Shift right by 5 bits
            3'b110: result = {6'b0, in[7:6]}; // Shift right by 6 bits
            3'b111: result = {7'b0, in[7]}; // Shift right by 7 bits
            default: result = in; // No shift (default case)
        endcase
    end

    // this will need 3 of 2to1 mux levels. so #1 for each and give #3 delay
    assign #3 out = result;

endmodule

module LeftShiftArith (
    in,
    out,
    shift
);

    input [7:0] in;
    input [2:0] shift;
    output [7:0] out;

    reg [7:0] result;

    always @(*) begin
        case (shift)
            3'b000: result = in; // No shift
            3'b001: result = {in[7], in[5:0], 1'b0}; // Shift left by 1 bit
            3'b010: result = {in[7], in[4:0], 2'b0}; // Shift left by 2 bits
            3'b011: result = {in[7], in[3:0], 3'b0}; // Shift left by 3 bits
            3'b100: result = {in[7], in[2:0], 4'b0}; // Shift left by 4 bits
            3'b101: result = {in[7], in[1:0], 5'b0}; // Shift left by 5 bits
            3'b110: result = {in[7], in[0], 6'b0}; // Shift left by 6 bits
            3'b111: result = {in[7], 7'b0}; // Shift left by 7 bits
            default: result = in; // No shift (default case)
        endcase
    end

    // this will need 3 of 2to1 mux levels. so #1 for each and give #3 delay
    assign #3 out = result;

endmodule

module RightShiftArith (
    in,
    out,
    shift
);
    
    input [7:0] in;
    input [2:0] shift;
    output [7:0] out;
    
    reg [7:0] result;

    always @(*) begin
        case (shift)
            3'b000: result = in; // No shift
            3'b001: result = {in[7], 1'b0, in[6:1]}; // Shift right by 1 bit
            3'b010: result = {in[7], 2'b0, in[6:2]}; // Shift right by 2 bits
            3'b011: result = {in[7], 3'b0, in[6:3]}; // Shift right by 3 bits
            3'b100: result = {in[7], 4'b0, in[6:4]}; // Shift right by 4 bits
            3'b101: result = {in[7], 5'b0, in[6:5]}; // Shift right by 5 bits
            3'b110: result = {in[7], 6'b0, in[6]}; // Shift right by 6 bits
            3'b111: result = {in[7], 7'b0}; // Shift right by 7 bits
            default: result = in; // No shift (default case)
        endcase
    end

    // this will need 3 of 2to1 mux levels. so #1 for each and give #3 delay
    assign #3 out = result;

endmodule

module LeftRotate (
    in,
    out,
    shift
);

    input [7:0] in;
    input [2:0] shift;
    output [7:0] out;    

    reg [7:0] result;

    always @(*) begin
        case (shift)
            3'b000: result = in; // No rotate
            3'b001: result = {in[6:0], in[7]}; // rotate left by 1 bit
            3'b010: result = {in[5:0], in[7:6]}; // rotate left by 2 bits
            3'b011: result = {in[4:0], in[7:5]}; // rotate left by 3 bits
            3'b100: result = {in[3:0], in[7:4]}; // rotate left by 4 bits
            3'b101: result = {in[2:0], in[7:3]}; // rotate left by 5 bits
            3'b110: result = {in[1:0], in[7:2]}; // rotate left by 6 bits
            3'b111: result = {in[0], in[7:1]}; // rotate left by 7 bits
            default: result = in; // No rotate (default case)
        endcase
    end

    // this will need 3 of 2to1 mux levels. so #1 for each and give #3 delay
    assign #3 out = result;

endmodule

module RightRotate (
    in,
    out,
    shift
);

    input [7:0] in;
    input [2:0] shift;
    output [7:0] out;

    reg [7:0] result;

    always @(*) begin
        case (shift)
            3'b000: result = in; // No rotate
            3'b001: result = {in[0], in[7:1]}; // rotate right by 1 bit
            3'b010: result = {in[1:0], in[7:2]}; // rotate right by 2 bits
            3'b011: result = {in[2:0], in[7:3]}; // rotate right by 3 bits
            3'b100: result = {in[3:0], in[7:4]}; // rotate right by 4 bits
            3'b101: result = {in[4:0], in[7:5]}; // rotate right by 5 bits
            3'b110: result = {in[5:0], in[7:6]}; // rotate right by 6 bits
            3'b111: result = {in[6:0], in[7]}; // rotate right by 7 bits
            default: result = in; // No rotate (default case)
        endcase
    end

    // this will need 3 of 2to1 mux levels. so #1 for each and give #3 delay
    assign #3 out = result;

endmodule

module Shifter (
    out,
    in,
    im
);

    input [7:0] in, im;
    output reg [7:0] out;
    // im is the imidiate value in instruction
    wire [7:0] lshift,rshift,lshiftA,rshiftA,rrotate,lrotate;

    LeftShift ls(in,lshift,im[2:0]);
    RightShift rs(in,rshift,im[2:0]);
    LeftShiftArith lsa(in,lshiftA,im[2:0]);
    RightShiftArith rsa(in,rshiftA,im[2:0]);
    LeftRotate lr(in,lrotate,im[2:0]);
    RightRotate rr(in,rrotate,im[2:0]);

    always @(im) begin
        case (im[7:5])
            3'b000: assign out = lshift;
            3'b001: assign out = rshift;
            3'b010: assign out = lshiftA;
            3'b011: assign out = rshiftA;
            3'b100: assign out = lrotate;
            3'b101: assign out = rrotate;
            default assign out = im;
        endcase
    end    
    
endmodule

module ALU (
    DATA1,
    DATA2,
    RESULT,
    SELECT,
    ZERO
);
    // Define Inputs
    input [7:0] DATA1,DATA2;
    input [2:0] SELECT;
    // Define Output
    output reg [7:0] RESULT;
    wire [7:0] wire1,wire2,wire3,wire4,wire5,wire6,wire7,wire8;
    output reg ZERO;
    
    FORWARD forward1(DATA1,DATA2,wire1);            
    ADD add1(DATA1,DATA2,wire2);            
    AND and1(DATA1,DATA2,wire3);            
    OR or1(DATA1,DATA2,wire4); 
    Shifter shift(wire5,DATA1,DATA2);    

    always @(SELECT) begin
        case (SELECT)
            3'b000: assign RESULT = wire1;
            3'b001: assign RESULT = wire2;
            3'b010: assign RESULT = wire3;
            3'b011: assign RESULT = wire4;
            3'b100: assign RESULT = wire5;
        endcase
    end    

    always @(wire2) begin
        if(wire2 == 0)begin
            ZERO = 1;
        end
        else begin
            ZERO = 0;
        end
    end

endmodule

