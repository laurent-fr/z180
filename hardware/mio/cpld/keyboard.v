module keyboard(

	input clk,
	input reset,
	output [7:0] data_out,
	input addr,
	input wr,
	output kb_int,
		
	input in_clk,
	input in_data
);

	reg [7:0] serial_in;
	reg [3:0] num = 4'b0;
	reg r_int=1;
	reg r_finish_rd=0;
	reg r_parity;
	
	assign data_out = addr ? { 6'b000000 , r_parity, r_finish_rd } : serial_in[7:0];
	
	assign kb_int=r_int;
	
	parameter WAIT_START=2'b00 , GET_KEYSCAN=2'b01 , GET_PARITY=2'b10 , GET_STOP=2'b11 ;
	reg [1:0] state = WAIT_START;
	

	//RX
	always @(negedge in_clk or negedge reset)
	begin
	
		if (reset==0)
			state<=WAIT_START;
		else
		begin 
		
		case(state)
			WAIT_START:
			
			begin 
				r_finish_rd<=0;
				if (in_data==0) 
				begin
					state<=GET_KEYSCAN;
					num<=0;
				end
			end
			GET_KEYSCAN:
			begin
				serial_in[num]<=in_data;  //!!!!! ou = ???
				num<=num+1'b1;
				if (num>=7) state<=GET_PARITY;
			end
			GET_PARITY:
			begin
				r_parity<=in_data;
				state<=GET_STOP;
			end
			GET_STOP:	
			begin
				/*if (in_data==1)
				begin
					in<=serial_in[7:0];
				end*/
				r_finish_rd<=1;
				state<=WAIT_START;
			end
		endcase
			
		end
		

	end
	
	
	// wr & interruption
	reg [1:0] int_state=2'b00;
	always @(posedge clk)
	begin
	
		case(int_state)
			2'b00: if (r_finish_rd==1)
				begin
				r_int<=1;
				int_state<=2'b01;
				end
			2'b01: int_state<=2'b10;
			2'b10: begin
				r_int<=0;
				int_state<=2'b11;
				end
			2'b11:
				if (r_finish_rd==0)
					int_state<=2'b00;
		 endcase	
	end
	
	
	
endmodule


