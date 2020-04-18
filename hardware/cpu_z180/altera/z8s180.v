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
	 output adrstrb,
	 output datastrb,
	 input datack,
	 input trferr,
	 
	 // bus dir
	 output busdir, // 0: output , 1: input 
	 
	 // cpu
	 input iorq,
	 input mreq,
	 input m1,
	 input wr,
	 input rd,
	 output zwait
    
	 );
	 
	 reg r_cm0, r_cm1, r_cm2, r_adrstrobe,r_datastrobe;
	
	 reg r_wait =1'b1;
	 
	 reg[2:0] waits = 3'b00;
	 
	 assign cs_ram = ~addr[2]; // A19..A17 == 1xx
	 assign cs_rom = addr[2] | addr[1] | addr[0]; // A19..A17 == 000
	 assign cs_stebus = ~((addr>0) & (addr<4)) & iorq ;  
	 //assign cs_stebus = 0; // TMP
	 
	 assign mem_rd = mreq | rd;
	 assign mem_wr = mreq | wr;
  
	 assign cm0=r_cm0;
	 assign cm1=r_cm1;
	 assign cm2=r_cm2;
	 assign adrstrb=r_adrstrobe;
	 assign datastrb=r_datastrobe;
	 assign zwait=r_wait;
	 
	 assign busdir=~rd; 
  
	 always @(posedge clk)
	 begin
		r_cm0 <= ~rd ;
		r_cm1 <= ~mreq ;
	   r_cm2 <= ~cs_stebus ;
		r_adrstrobe <= (mreq & iorq ) ; 
	   r_datastrobe <= (rd & wr ) ;
	 end
	
	
	always @(posedge clk)
	 begin	
		// RAM = 1 wait state
		if ( cs_ram == 0 ) 
		begin 
			case (waits)
				3'b000:
					if ((mreq == 0) & ( (rd==0)|(wr==0)) )
					begin
						r_wait <= 0;
						waits <= 3'b001;
					end
				3'b001:
					begin
						r_wait <= 1;
						waits <= 3'b010;
					end
				default: 
					if (mreq==1)
					begin
						waits<=3'b000;
					end
			endcase
		// ROM = 2 wait states
		end else if (cs_rom == 0) 
		begin
				case (waits)
				3'b000:
					if ((mreq == 0) & ( (rd==0)|(wr==0)) )
					begin
						r_wait <= 0;
						waits <= 3'b001;
					end
				3'b001:
					waits <= 3'b010;
				3'b010:
					begin
						waits<=3'b011;
						r_wait<=1;
				   end
				3'b011:
					if (mreq==1)
					begin
						waits<=2'b00;
					end
			endcase
		end else if (cs_stebus==0)
		// STEBUS wait states
		begin
		case (waits)
				3'b000:
					if ((r_datastrobe==0) & (datack==1)) 
					begin
						r_wait <= 0;
						waits <= 3'b001;
					end
				3'b110: // timeout
						begin
						r_wait<=1;
						waits<=3'b111;
						end
				3'b111:
					if (mreq==1)
						begin
							waits <= 3'b000;
						end
				default:
					if (datack==1)
					begin
						waits <= waits+1;
					end
					else
					begin
						r_wait <=1;
						waits <= 3'b111; 
					end
					
			endcase
		end
		
	 end
	 
  endmodule 
  
  

  module z8s180_testbench;
  
    
	parameter PERIOD=1;
  
	reg clk;
	wire cs_ram,cs_rom,cs_bus;
	reg[2:0] addr;
	wire mem_wr,mem_rd;
	wire cm0,cm1,cm2,adrstrb,datatstrb;
   reg datack,trferr;
	reg iorq,mreq,m1,wr,rd;
	wire wt;
	wire busdir;
	
	z8s180 CPLD(clk,cs_ram,cs_rom,cs_bus,addr,mem_rd,mem_wr,cm0,cm1,cm2,adrstrb,datastrb,datack,trferr,busdir,iorq,mreq,m1,wr,rd,wt);
	
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
		
		#2
		addr=3'b001;
		#4
		addr=3'b010;
		#6
		addr=3'b011;
		#8
		addr=3'b100;
		#10
		addr=3'b101;
		#12
		addr=3'b110;
		#14
		addr=3'b111;
		
		#21
		mreq=0;
		#22
		rd=0;
		#23
		datack=0;
		
		#24
		datack=1;
		#25
		rd=1;
		mreq=1;
		#31
		mreq=0;
		#32
		wr=0;
		#33
		wr=1;
		datack=0;
		#34
		datack=1;
		mreq=1;
		#41
		mreq=1;
		#45
		addr=3'b000;
		#50
		mreq=0;
		#60
		mreq=1;
		#65 $finish;
   end
  
  endmodule
