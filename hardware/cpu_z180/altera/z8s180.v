module z8s180    (
    
	 //clk
	 input clk,
	 
	 // chip select
	 output cs_ram,
	 output cs_rom,
	 output cs_stebus,
	 input [2:0] addr,
	 
	 // mem rd/wr
	 output mem_rd,
	 output mem_wr,
	 
	 // stebus
	 output cm0,
	 output cm1,
	 output cm2,
	 output strobe,
	 input datack,
	 input trferr,
	 
	 // cpu
	 input iorq,
	 input mreq,
	 input m1,
	 input wr,
	 input rd,
	 output zwait
    
	 );
	 
	 reg r_cm0, r_cm1, r_cm2, r_strobe;
	
	 reg r_wait =1'b1;
	 
	 reg[1:0] waits = 2'b00;
	 
	 assign cs_ram = ~addr[2];
	 assign cs_rom = addr[2] | addr[1] | addr[0];
	 assign cs_stebus = (~(cs_rom & cs_ram)) & iorq; 
	 
	 assign mem_rd = mreq | rd;
	 assign mem_wr = mreq | wr;
  
	 assign cm0=r_cm0;
	 assign cm1=r_cm1;
	 assign cm2=r_cm2;
	 assign strobe=r_strobe;
	 assign zwait=r_wait;
	 
  
	 always @(posedge clk)
	 begin
		r_cm0 <= rd | m1 ;
		r_cm1 <= mreq | ( iorq & m1 ) ;
		r_cm2 <= mreq | ( iorq & ~m1 ) ;
		r_strobe <= ( mreq & (rd | wr ) ) | ( iorq & (rd | wr | m1 ) ) ;
	end
	
	
	always @(posedge clk)
	 begin	
		// RAM = 1 wait state
		if ( cs_ram == 0 ) 
		begin 
			case (waits)
				2'b00:
					if (mreq == 0) 
					begin
						r_wait <= 0;
						waits <= 2'b01;
					end
				2'b01:
					begin
						r_wait <= 1;
						waits <= 2'b10;
					end
				default: 
					if (mreq==1)
					begin
						waits<=2'b00;
					end
			endcase
		// ROM = 2 wait states
		end else if (cs_rom == 0) 
		begin
				case (waits)
				2'b00:
					if (mreq == 0) 
					begin
						r_wait <= 0;
						waits <= 2'b01;
					end
				2'b01:
					waits <= 2'b10;
				2'b10:
					begin
						waits<=2'b11;
						r_wait<=1;
				   end
				2'b11:
					if (mreq==1)
					begin
						waits<=2'b00;
					end
			endcase
		end else
		// STEBUS wait states
		begin
			r_wait <= (mreq | iorq ) & datack & trferr ;
		end
		
	 end
	 
  endmodule 
  
  

  module z8s180_testbench;
  
    
	parameter PERIOD=2;
  
	reg clk;
	wire cs_ram,cs_rom,cs_bus;
	reg[2:0] addr;
	wire mem_wr,mem_rd;
	wire cm0,cm1,cm2,strobe;
   reg datack,trferr;
	reg iorq,mreq,m1,wr,rd;
	wire wt;
	
	z8s180 CPLD(clk,cs_ram,cs_rom,cs_bus,addr,mem_rd,mem_wr,cm0,cm1,cm2,strobe,datack,trferr,iorq,mreq,m1,wr,rd,wt);
	
	initial
	begin
		clk=0;
	end
	
	always #PERIOD clk=~clk;
	
	initial
	begin
	
	$dumpfile("test.vcd");
     $dumpvars(0,z8s180_testbench);
		#0
	   addr=3'b000;
		mreq=1;
		iorq=1;
		m1=1;
		wr=1;
		rd=1;
		datack=1;
		trferr=1;
		
		#10
		mreq=1;
		#20
		mreq=0;
		#30
		mreq=1;
		#35
		addr=3'b100;
		#40
		mreq=0;
		#50
		mreq=1;
		#60 $finish;
   end
  
  endmodule
