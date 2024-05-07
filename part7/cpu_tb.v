`timescale  1ns/100ps

module cpu_tb;

    reg CLK, RESET;
    wire [31:0] PC;
    wire [31:0] INSTRUCTION;

    wire inst_busywait,busywait,inst_read;
    wire [127:0] inst_readdata;       
    wire [5:0] inst_address; 
    
    /* 
    -----
     CPU
    -----
    */
    cpu mycpu(PC, INSTRUCTION, CLK, RESET, busywait);
    instruction_cache instrcache(PC,CLK,RESET,inst_readdata,inst_busywait,inst_read,INSTRUCTION,inst_address,busywait);
    instruction_memory instrmem(CLK, inst_read, inst_address, inst_readdata, inst_busywait);

    initial
    begin
    
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("cpu_wavedata.vcd");
		$dumpvars(0, cpu_tb);
        
        CLK = 1'b0;
        RESET = 1'b1;
        
        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution
        #5
        RESET = 1'b0;
        // finish simulation after some time
        #1000
        $finish;
        
    end
    
    // clock signal generation
    always
        #4 CLK = ~CLK;
        

endmodule