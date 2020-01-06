 module vgen (
 
	// VGEN
	input clk,
	output [10:0] addr,
	output [3:0] row,
	output hsync,
	output vsync,
	output blank,
	output loadc

	);
	
	reg [10:0] r_addr =0;
	reg [6:0] r_offset =0;
	reg [9:0] r_x =0;
	reg [9:0] r_y =0;
	
	assign addr = r_addr;
	assign row = r_y[3:0];
	
	assign loadc = !((r_x[2:0]==3'b000)&clk);
	assign vsync = (r_y==450) | (r_y==451);
	assign hsync = (r_x[9:4]>41) & (r_x[9:4]<47);
	assign blank = !((r_y<400) & (r_x<640));
	
	//r_vsync <= (r_y==412) | (r_y==413);

	
	always @(posedge clk)
	begin
		if (r_x<799) 
				r_x<=r_x+1;
		else
		begin
			r_x<=0;
			//if (r_y<449)
			if (r_y<525)	
					r_y<=r_y+1;
			else
					r_y<=0;
		end
	end
	
	always @(posedge hsync)
	begin
		if (r_y==524)
			r_offset<=0;
		else if (row == 4'b1111)
			r_offset <= r_offset + 5;
	end
	
	always @(posedge clk)
	begin
	if (r_x[2:0]==3'b100)
	begin
		if (blank==0)
					r_addr<=r_addr+1;
		else
			begin
				r_addr[10:4]<=r_offset;
				r_addr[3:0]<=4'b0;
		
		   end
		end
	end
					
	/*always @(posedge clk)
	begin
		if ((r_x[2:0]==3'b000)  )
			r_loadc=1;
		else
			r_loadc=0;
	end*/
					
	
	
	
endmodule

// iverilog vgen.v
// vvp a.out
// gtkwave vgen.vcd
module vgen_testbench;

	parameter PERIOD=1;
	
	reg clk;
	wire [10:0] addr;
	wire [3:0] row;
	wire hsync,vsync,blank,loadc;
	
	vgen VGEN(clk,addr,row,hsync,vsync,blank,loadc);
	
	initial
	begin
		clk=0;
	end
	
	always #PERIOD clk=~clk;

	initial
	begin
		$dumpfile("vgen.vcd");
		$dumpvars(0,vgen_testbench);
		#0
		#1000000 $finish;
   end

endmodule