 module mio (
 
	// STEBUS
	input clk,
	input reset,
	
	//inout [7:0] data,
	input [7:0] data, // TMP
	input [4:0] addr,

	input cm0, // cm0=0 :  wr , cm0=1 : rd
	input ce,
	output datack,
	
	// chip select
	output cs_compactflash,
	output cs_printer,
	output cs_rtc,
	
	// rw
	output rd,
	output wr,

	// keyboard 
	input kbd_clk,
	input kbd_data,
	output int,

	// sound
	output snd
);

	wire [7:0] data_out;
	
	//assign data = (cs_keyboard & !rd) ? data_out : 8'bz;
	
	wire cs_keyboard,cs_sound;
	
	assign cs_keyboard = (addr[4:1]==4'b0000);
	assign cs_sound = (addr[4:1]==4'b0001);
	assign cs_printer = !(addr[4:2]==3'b001);
	assign cs_compactflash = !(addr[4:3]==3'b01);
	//assign cs_rtc = !addr[4:4];
	//assign cs_rtc = data[0]; //TMP
	
	assign wr = ce | cm0;
	assign rd = ce | !cm0;
		
	stebus BUS(
		.clk(clk),
		.cs(ce),
		.datack(datack)
		);
	
	wire wr_kb;
	
	/*keyboard KBD( 
		.clk(clk),
		.reset(reset),
		.data_out(data_out),
		.addr(addr[0]),
		.wr( cs_keyboard & !cm0 ),
		.kb_int(int),
		.in_clk(kbd_clk),
		.in_data(kbd_data)
		);*/
	
	sound S0UND(
		.clk(clk),
		.data_in(data),
		.wr(cs_sound & !cm0),
		.snd(snd)
		);
	

endmodule