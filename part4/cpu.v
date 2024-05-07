// Control Unit
module ControlUnit (
    opcode,
    signSelect,
    sourceSelect,
    jumpSelect,
    eqSelect,
    ALUOP,
    writeEn
);
    // opcode
    input [7:0] opcode;
    // signselect for sub and source select for imidiate, register
    output reg signSelect,sourceSelect,jumpSelect,eqSelect;
    // op-code for alu
    output reg [2:0] ALUOP;
    output reg writeEn;

    always @(opcode) begin
        // Loadi 
        if (opcode == 8'b00000000) begin
            #1
            ALUOP = 3'b000;
            signSelect = 1'b0;
            sourceSelect = 1'b1;
            writeEn = 1'b1;
            jumpSelect = 1'b0;
            eqSelect = 1'b0;
        // mov
        end else if (opcode == 8'b00000001) begin
            #1
            ALUOP = 3'b000;
            signSelect = 1'b0;
            sourceSelect = 1'b0;
            writeEn = 1'b1;
            jumpSelect = 1'b0;
            eqSelect = 1'b0;
        // add
        end else if (opcode == 8'b00000010) begin
            #1
            ALUOP = 3'b001;
            signSelect = 1'b0;
            sourceSelect = 1'b0;
            writeEn = 1'b1;
            jumpSelect = 1'b0;
            eqSelect = 1'b0;
        // sub
        end else if (opcode == 8'b00000011) begin
            #1
            ALUOP = 3'b001;
            signSelect = 1'b1;
            sourceSelect = 1'b0;
            writeEn = 1'b1;
            jumpSelect = 1'b0;
            eqSelect = 1'b0;
        // and
        end else if (opcode == 8'b00000100) begin
            #1
            ALUOP = 3'b010;
            signSelect = 1'b0;
            sourceSelect = 1'b0;
            writeEn = 1'b1;
            jumpSelect = 1'b0;
            eqSelect = 1'b0;
        // or
        end else if (opcode == 8'b00000101) begin
            #1
            ALUOP = 3'b011;
            signSelect = 1'b0;
            sourceSelect = 1'b0;
            writeEn = 1'b1;
            jumpSelect = 1'b0;
            eqSelect = 1'b0;
        // j
        end else if (opcode == 8'b00000110) begin
            #1
            ALUOP = 3'b000;
            signSelect = 1'b0;
            sourceSelect = 1'b0;
            writeEn = 1'b0;
            jumpSelect = 1'b1;
            eqSelect = 1'b0;
        // beq
        end else if (opcode == 8'b00000111) begin
            #1
            ALUOP = 3'b111;
            signSelect = 1'b1;
            sourceSelect = 1'b0;
            writeEn = 1'b0;
            jumpSelect = 1'b0;
            eqSelect = 1'b1;
        end else begin
            
        end
    end
    
endmodule

// Program Counter
module pcAdder(PC, PCplus4);
	
	//Declaration of input and output ports
	input [31:0] PC;
	output [31:0] PCplus4;

	//Assign PC+4 value to the output after 1 time unit delay
	assign PCplus4 = PC + 4;
	
endmodule

// module negation
module Negator (
    Input,
    Output
);

input [7:0] Input;
output [7:0] Output;

assign #1 Output = ~Input + 8'b00000001;
    
endmodule

module mux (
    input1,
    input2,
    result,
    select
);

input [7:0] input1,input2;
output reg [7:0] result;
input select;

always @(*) begin
    if (select) begin
        result = input2;
    end else begin
        result = input1;
    end
end
    
endmodule

module muxPC (
    input1,
    input2,
    result,
    select1,
    select2,
    select3
);

input [31:0] input1,input2;
output reg [31:0] result;
input select1,select2,select3;

always @(*) begin
    if (select1 || select2 && select3) begin
        result = input2;
    end else begin
        result = input1;
    end
end
    
endmodule

// branch adder
module branchAdder (
    currPC,
    offset,
    finalPC
);

input [31:0] currPC, offset;
output [31:0] finalPC;

assign finalPC = currPC + offset;
    
endmodule

// sign extender
module SignExtender (
    short,
    long
);

input [7:0] short;
output [31:0] long;

assign long = {{24{short[7]}}, short} << 2;
    
endmodule

// Main CPU module
module cpu (
    PC,
    INSTRUCTION,
    CLK,
    RESET
);

// Instruction input
input [31:0] INSTRUCTION;
// input clock and reset
input CLK,RESET;
// output pc to get instruction
output reg [31:0] PC;
wire [31:0] PCout;
// Wires for sign and source select
wire signSelect, sourceSelect, jumpSelect, eqSelect;
// Alu opcode wire
wire [2:0] ALUopcode;
// wire for alu result, regout1 and regout2
wire [7:0] ALUres,regout1,regout2;
// mux outputs
wire [7:0] muxNegOut,muxSourceOut;
// negator out
wire [7:0] negOut;
// wire for write enable
wire writeEn;
// wire reg add in
wire [2:0] readreg1,readreg2;
// Extended value
wire [31:0] extendedValue;
// Jumped pc value
wire [31:0] jumpedPC, finalPC;
// alu zero output
wire Zero;

// instantiate control module
ControlUnit control(INSTRUCTION[31:24],signSelect,sourceSelect,jumpSelect,eqSelect,ALUopcode,writeEn);
reg_file register(ALUres,regout1,regout2,INSTRUCTION[18:16],INSTRUCTION[10:8],INSTRUCTION[2:0],writeEn,CLK,RESET);
ALU myalu(regout1,muxSourceOut,ALUres,ALUopcode,Zero);
Negator neg(regout2,negOut);    
mux muxSrc(muxNegOut,INSTRUCTION[7:0],muxSourceOut,sourceSelect);
mux muxNeg(regout2,negOut,muxNegOut,signSelect);
pcAdder pcadd(PC,PCout);
branchAdder badder(PCout, extendedValue, jumpedPC);
SignExtender signext(INSTRUCTION[23:16], extendedValue);
muxPC jump(PCout, jumpedPC, finalPC, jumpSelect, Zero, eqSelect);

always @ (posedge CLK)
	begin
		if (RESET == 1'b1) 
		begin
			#1
			PC = 0;		//If RESET signal is HIGH, set PC to zero
		end
		else #1 PC = finalPC;		//Else, write new PC value
	end

endmodule