`timescale  1ns/100ps

module cache_controller (
	// port declaration
    input clock,
    input reset,
    input read,
    input write,
    input [7:0] address,
    input [31:0] writedata,
    output busywait,
    input mem_Busywait,
    input [2:0] Tag,
    input [2:0] Tag1,
    input [2:0] Index,
    input hit,
    input dirty,
    output mem_read,
    output mem_write,
    output [31:0] mem_writedata,
    output[5:0] mem_address 
);
    reg [31:0] mem_writedata;
    reg[5:0] mem_address;
    reg mem_read,mem_write,busywait;
      
    /* Cache Controller FSM Start */
    parameter IDLE = 3'b000, MEM_READ = 3'b001, MEM_WRITE = 3'b010;
    reg [2:0] state, next_state;

    // combinational next state logic
    always @(*) begin
        case (state)
            IDLE:
                if ((read || write) && !dirty && !hit)  
                    next_state = MEM_READ;
                else if ((read || write) && dirty && !hit)
                    next_state = MEM_WRITE;
                else
                    next_state = IDLE;
            
            MEM_READ:
                if (!mem_Busywait) 
                    next_state = IDLE;
                else    
                    next_state = MEM_READ;
            
            MEM_WRITE:
                if (!mem_Busywait)
                    next_state = MEM_READ;
                else    
                    next_state = MEM_WRITE;                
        endcase
    end

    // combinational output logic
    always @(*) begin
        case(state)
            IDLE: begin
                mem_read = 0;
                mem_write = 0;
                mem_address = 8'dx;
                mem_writedata = 8'dx;
                busywait = 0;
            end
         
            MEM_READ: begin
                mem_read = 1;
                mem_write = 0;
                mem_address = {Tag, Index};
                mem_writedata = 32'dx;
                busywait = 1;
            end

            MEM_WRITE: begin
                mem_read = 0;
                mem_write = 1;
                mem_address = {Tag1, Index};
                mem_writedata = writedata;
                busywait = 1;
            end
        endcase
    end

    // sequential logic for state transitioning 
    always @(posedge clock, reset)
    begin
        if(reset)
            state = IDLE;
        else
            state = next_state;
    end
    /* Cache Controller FSM End */
endmodule

module comparator(IN1,IN2,OUT);
	input[0:2] IN1,IN2;
	output OUT;

	//xnor each bit and did and operation 
	assign #0.9 OUT = IN1[0]~^IN2[0] && IN1[1]~^IN2[1] && IN1[2]~^IN2[2];   
endmodule

module mux4to1(IN1,IN2,IN3,IN4,OUT,SELECT);
	input[7:0] IN1,IN2,IN3,IN4;
	input[1:0] SELECT;
	output[7:0] OUT;

	assign OUT = (SELECT[1]) ? (SELECT[0]? IN4:IN3) : (SELECT[0]? IN2:IN1) ;

endmodule

module data_cache (clock, reset, read, write, address, writedata, readdata, busywait, mem_Read, mem_Write, mem_Address, mem_Writedata, mem_Readdata, mem_BusyWait);
	// Port declaration
	input clock;
	input reset;
	input read;
	input write;
	input [7:0] address;
	input [7:0] writedata;
	output [7:0] readdata;
	output busywait;
	output mem_Read;
	output mem_Write;
	output [5:0] mem_Address;
	output [31:0] mem_Writedata;
	input [31:0] mem_Readdata;
	input mem_BusyWait;

	// declare cache memory array 32x8-bits and other arrays
	reg [31:0] cache [7:0];
	reg [2:0] cacheTag [0:7];
	reg cacheDirty [0:7];
	reg cacheValid [0:7];

	reg [1:0] Offset;
	reg [2:0] Index;
	reg [2:0] Tag;

	/* Seperate address to tag index and offset */
	always @(address) begin
		if (read || write) begin #1
			Offset = address[1:0];
			Index = address[4:2];
			Tag = address[7:5];		
		end
	end
	
	// check whether there is a hit
	// comparator to compare tag 
	// bitwise and to check valid bit is set
	wire comparatorOut;
	wire hit,dirty;
	wire[2:0] comparatorTagIN;
	assign comparatorTagIN = cacheTag[Index];
	comparator comparator(Tag,comparatorTagIN,comparatorOut);
	assign hit = cacheValid[Index] && comparatorOut;

	assign dirty = cacheDirty[Index];

	// Extract data from data block and assigning
	wire[7:0] dataExtractMuxOut;
	wire[31:0] data;
	assign data = cache[Index];
	mux4to1 dataExtractMux(data[7:0],data[15:8],data[23:16],data[31:24],dataExtractMuxOut,Offset);
	assign #1 readdata = dataExtractMuxOut;

	// detecting an incoming cache memory access
	reg Busywait;
	reg READACCESS, WRITEACCESS;
	always @(read, write) begin
		Busywait = (read || write)? 1 : 0;
		READACCESS = (read && !write)? 1 : 0;
		WRITEACCESS = (!read && write)? 1 : 0;
	end

	// reading & writing cache memory
	always @(posedge clock) begin
		if(READACCESS & hit) begin
			Busywait = 0;
			READACCESS = 0;
		end
		if(WRITEACCESS & hit) begin
			Busywait = 0;
			WRITEACCESS = 0;
			
			// set dirty bit to 1 as cache and memory inconsistant
			#1 cacheDirty[Index] = 1'b1;            
			
			// Write data to the correct block in cache
			case(Offset)                         
				2'b11: cache[Index][31:24] = writedata;
				2'b10: cache[Index][23:16] = writedata;
				2'b01: cache[Index][15:8] = writedata;
				2'b00: cache[Index][7:0] = writedata;
			endcase 
		end
	end

	/* Set 32bit data block provided by data memory
	   to the correct place in cache */
	always @(mem_BusyWait) begin
		if(!mem_BusyWait) begin
		#1
		cache[Index] = mem_Readdata;
		cacheValid[Index] = 1'b1;
		cacheDirty[Index] = 1'b0;
		cacheTag[Index] = Tag;
		end
	end

	/* when there is a miss occured and 
	   the block is dirty (to complete WRITE_BACK state) */
	reg[2:0] Tag1;
	reg[31:0] writedata1;  
	always @(hit) begin
		if (!hit && dirty) begin
		   writedata1 = cache[Index];
		   Tag1 = cacheTag[Index];
		end
	end

	// cache controller to handle data memory control signals
	wire controllerBusywait;                                  
	cache_controller cachectrl(clock,reset,read,write,address,writedata1,controllerBusywait,mem_BusyWait,Tag,Tag1,Index,hit,dirty,mem_Read,mem_Write,mem_Writedata,mem_Address);

	/* overall busywait is set to zero whenever cachecontroller busywait 
	   and cachememory busywait both set to zero*/
	assign busywait = (Busywait || controllerBusywait)? 1:0; 

	// Reset cache memory
	integer i;
	always @(posedge reset) begin
		if (reset) begin
			for (i = 0; i < 32; i = i + 1) begin
				cache[i] = 0;
				cacheTag[i] = 0;
				cacheDirty[i] = 0;
				cacheValid[i] = 0;
			end
			Busywait = 0;
			READACCESS = 0;
			WRITEACCESS = 0;
		end
	end
endmodule
