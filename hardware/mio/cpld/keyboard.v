module keyboard(

	input clk,
	input reset,
	output [7:0] data_out,
	input addr,
	output kb_int,
		
	input in_clk,
	input in_data
);

	reg [7:0] serial_in;
	reg r_int=0;
	reg r_finish_rd=0;
	reg r_parity;
	
	assign data_out = addr ? { 5'b00000 , in_clk, r_parity, r_finish_rd } : serial_in[7:0];
	
	assign kb_int=r_int;
	
	parameter WAIT_START=4'b0000  , GET_BIT0=4'b0001, GET_BIT1=4'b0010,
		GET_BIT2=4'b0011, GET_BIT3=4'b0100, GET_BIT4=4'b0101, GET_BIT5=4'b0110, GET_BIT6=4'b0111,
		GET_BIT7=4'b1000, GET_PARITY=4'b1001 , GET_STOP=4'b1010 , FINISH=4'b1011;
	reg [3:0] state = WAIT_START;
	
	
	reg sync_in_clk;
	
	always @(posedge clk)
		sync_in_clk<=in_clk;
	
	reg [1:0] delay_reset;
	reg [2:0] slow_clk;
	
	always @(posedge clk)
	begin
		slow_clk<=slow_clk+1;
	end
	
	
	always @(posedge slow_clk[2])
	begin 
			delay_reset<= { delay_reset[0], reset };
	end

	wire pulse_reset = (delay_reset==2'b10);
	
	//RX
	always @(negedge sync_in_clk or posedge pulse_reset)
	begin
	
		if (pulse_reset==1)
			begin
				r_finish_rd=0;
				state<= #1 WAIT_START;
			end
		else
		
		begin 
	if (sync_in_clk==0)
		case(state)
			WAIT_START:	
			begin 
					state<= GET_BIT0;
					serial_in<=  8'b0;
					r_finish_rd<= 0;
			end
			GET_BIT0:
			begin
				serial_in[0] <= in_data;
				state<=  GET_BIT1;
			end
			GET_BIT1:
			begin
				serial_in[1] <=  in_data;
				state<=  GET_BIT2;
			end
			GET_BIT2:
			begin
				serial_in[2] <=  in_data;
				state<=  GET_BIT3;
			end
			GET_BIT3:
			begin
				serial_in[3] <=  in_data;
				state<=  GET_BIT4;
			end
			GET_BIT4:
			begin
				serial_in[4] <=  in_data;
				state<=  GET_BIT5;
			end
			GET_BIT5:
			begin
				serial_in[5] <=  in_data;
				state<=  GET_BIT6;
			end
			GET_BIT6:
			begin
				serial_in[6] <=  in_data;
				state<=  GET_BIT7;
			end
			GET_BIT7:
			begin
				serial_in[7] <=  in_data;
				state<=  GET_PARITY;
			end
			GET_PARITY:
			begin
				r_parity<=  in_data;
				state<=  GET_STOP;
			end
			GET_STOP:	
			begin
				r_finish_rd<=  1;
				state<=  FINISH;
			end
		endcase
			
	  end
		

	end
	
	
	//  interruption
	reg [2:0] int_state=3'b000;
	always @(posedge slow_clk[2])
	begin
	
		case(int_state)
			3'b000: if (r_finish_rd==1)
				begin
				r_int<=1;
				int_state<= #1 3'b001;
				end
			3'b111:
			begin
					r_int<=0;
				if (r_finish_rd==0)
					int_state<= #1 3'b000;
		   end
			default:
				int_state<=int_state+1;
		 endcase	
	end
	
	
	
	
endmodule

module keyboard_testbench;


	parameter PERIOD=1;
	
	reg clk;
	reg reset;
	wire [7:0] data_out;
	reg addr;
	wire kb_int;
		
	reg in_clk;
	reg in_data;
	
	initial
	begin
		clk=0;
		reset=0;
		addr=0;
		in_clk=1;
		in_data=0;
		
	end
	
	keyboard KBD( 
		.clk(clk),
		.reset(reset),
		.data_out(data_out),
		.addr(addr),
		.kb_int(kbint),
		.in_clk(in_clk),
		.in_data(in_data)
		);
	
	
	always #PERIOD clk=~clk;
	
	initial
	begin
		$dumpfile("mio_kbd.vcd");
		$dumpvars(0,keyboard_testbench);
		#1
		reset=1;
		#2
		in_data=0; //START
		#3
		in_clk=0;
		#5
		in_clk=1;
		#10
		in_data=1 ; // DATA 1
		#11
		in_clk=0;
		#15
		in_clk=1;
		#20
		in_data=1 ; // DATA 2
		#21
		in_clk=0;
		#25
		in_clk=1;
		#30
		in_data=1 ; // DATA 3
		#31
		in_clk=0;
		#35
		in_clk=1;
		#40
		in_data=1 ; // DATA 4
		#41
		in_clk=0;
		#45
		in_clk=1;
		#50
		in_data=1 ; // DATA 5
		#51
		in_clk=0;
		#55
		in_clk=1;
		#60
		in_data=1 ; // DATA 6
		#61
		in_clk=0;
		#65
		in_clk=1;
		#70
		in_data=1 ; // DATA 7
		#71
		in_clk=0;
		#75
		in_clk=1;
		#80
		in_data=1 ; // DATA 8
		#81
		in_clk=0;
		#85
		in_clk=1;
		#90
		in_data=0 ; // PARITY
		#91
		in_clk=0;
		#95
		in_clk=1;
		#100
		in_data=1 ; // STOP
		#101
		in_clk=0;
		#105
		in_clk=1;
		
		#201
		in_data=0; //START
		#203
		in_clk=0;
		#205
		in_clk=1;
		#210
		in_data=1 ; // DATA 1
		#211
		in_clk=0;
		#215
		in_clk=1;
		#220
		in_data=1 ; // DATA 2
		#221
		in_clk=0;
		#225
		in_clk=1;
		#230
		in_data=1 ; // DATA 3
		#231
		in_clk=0;
		#235
		in_clk=1;
		#240
		in_data=0 ; // DATA 4
		#241
		in_clk=0;
		#245
		in_clk=1;
		#250
		in_data=1 ; // DATA 5
		#251
		in_clk=0;
		#255
		in_clk=1;
		#260
		in_data=0 ; // DATA 6
		#261
		in_clk=0;
		#265
		in_clk=1;
		#270
		in_data=1 ; // DATA 7
		#271
		in_clk=0;
		#275
		in_clk=1;
		#280
		in_data=1 ; // DATA 8
		#281
		in_clk=0;
		#285
		in_clk=1;
		#290
		in_data=0 ; // PARITY
		#291
		in_clk=0;
		#295
		in_clk=1;
		#300
		in_data=1 ; // STOP
		#301
		in_clk=0;
		#305
		in_clk=1;
		
		
		
		
		#500 $finish;
   end




endmodule
