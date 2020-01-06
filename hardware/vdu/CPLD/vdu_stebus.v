module vdu_stebus (

	// 16Mhz bus clock
	input clk,
	
	// stebus
	input cs,
	output datack
	
	
	);	
	
	reg [1:0] ack = 2'b00;
	reg r_datack=1;
	
	assign datack=r_datack;
	
	always @(negedge clk)
	 begin	
			case (ack)
				2'b00:
					if ( cs == 0 ) 
					begin		
						r_datack <= 1;
						ack <= 2'b01;
					end
				2'b01:
					begin
						r_datack <= 0;
						ack <= 2'b10;
					end
				default:
					if (cs == 1)
						ack<=2'b00;
			endcase
		
	end
	
	
endmodule

// iverilog vdu_stebus.v
// vvp a.out
// gtkwave vdu_stebus.vcd
module vdu_stebus_testbench;


	parameter PERIOD=1;
	
	reg clk;
	reg cs;
	wire datack;
	
	initial
	begin
		clk=0;
	end
	
	vdu_stebus BUS(clk,cs,datack);
	
	always #PERIOD clk=~clk;
	
	initial
	begin
		$dumpfile("vdu_stebus.vcd");
		$dumpvars(0,vdu_stebus_testbench);
		#0
		cs=1;
		#6
		cs=0;
		#16
		cs=1;
		#30 $finish;
   end




endmodule