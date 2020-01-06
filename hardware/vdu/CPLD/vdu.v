module vdu(

	// 16Mhz bus clock
	input clk,
	
	// stebus
	input cs,
	output datack,
	
	
	// VGEN
	input vclk,
	output [10:0] addr,
	output [3:0] row,
	output hsync,
	output vsync,
	output blank,
	output cload
	
	);

	vdu_stebus BUS(clk,cs,datack);
	
	vgen VGEN(vclk,addr,row,hsync,vsync,blank,cload);
	
endmodule