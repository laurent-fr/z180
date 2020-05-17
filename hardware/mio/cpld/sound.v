module sound(

	input clk,
	input [7:0] data_in,
	input wr,
	
	output snd

);

reg [8:0] pwm;
reg [7:0] preset;

assign snd = pwm[8];

	
	always @(posedge clk)
	begin
		if (wr==1)
			preset<=data_in;
	end
	
	always@(posedge clk)
	begin
		pwm<=pwm[7:0]+preset;
	end
	

		
endmodule



module sound_testbench;


	parameter PERIOD=1;
	
	reg clk;
	reg [7:0] data_in;
	reg wr;
	
	wire  snd;
	
	initial
	begin
		clk=0;
		wr=0;
		data_in=8'b0;
		
	end
	
	sound SOUND(clk,data_in,wr,snd);
	
	always #PERIOD clk=~clk;
	
	initial
	begin
		$dumpfile("mio_sound.vcd");
		$dumpvars(0,sound_testbench);
		#0
		data_in=10;
		#2
		wr=1;
		#4
		wr=0;
		#100
		data_in=101;
		#102
		wr=1;
		#104
		wr=0;
		#400
		data_in=0;
		#402
		wr=1;
		#404
		wr=0;
		#500 $finish;
   end




endmodule