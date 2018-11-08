/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/


module internal_register #(parameter width = 16)(

	input logic Clk,
	input logic Load,
	input logic Reset,
	input logic[width-1:0] D,
	output logic[width-1:0] Q
);

always_ff@(posedge Clk) begin
	if(Load)
		Q <= D;
	else if(Reset)
		Q <= 0;
	
end

endmodule



module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	input logic CONTINUE,
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);

logic[3:0] registerSelect;
logic [15:0][31:0]  Qout;
logic[31:0] mask;
logic[3:0][31:0] AES_MSG_DEC_AVALON;
logic AES_DONE;

assign AVL_READDATA = Qout[registerSelect];
assign EXPORT_DATA = {Qout[11][31:16], Qout[8][15:0]} & {32{AES_DONE}};
assign registerSelect = AVL_ADDR;
					


genvar i;
genvar j;
generate
	for (i=0;i<8;i++) begin: input_register_generate
		internal_register #(32) register(.D((AVL_WRITEDATA & mask) | (Qout[registerSelect] & ~mask)),
													.Q(Qout[i]),
													.Load(AVL_WRITE && AVL_CS && (registerSelect == i)),
													.Reset(RESET),
													.Clk(CLK));
	end
	for (j=8;j<12;j++) begin: output_register_generate
		internal_register #(32) register(.D(AES_MSG_DEC_AVALON[j-8]),
													.Q(Qout[j]),
													.Load(1'b1),
													.Reset(RESET),
													.Clk(CLK));
	end
endgenerate

internal_register #(32) start_register(.D((AVL_WRITEDATA & mask) | (Qout[registerSelect] & ~mask)),
													.Q(Qout[14]),
													.Load(AVL_WRITE && AVL_CS  && (registerSelect == 4'd14)),
													.Reset(RESET),
													.Clk(CLK));
internal_register #(32) done_register(.D(AES_DONE),
													.Q(Qout[15]),
													.Load(1'b1),
													.Reset(RESET),
													.Clk(CLK));


/*
registerFile registers(
	.Clk(CLK),
	.Reset_ah(RESET),
	
	.D((AVL_WRITEDATA & mask) | (Qout[registerSelect] & ~mask)),
	.DR(registerSelect),
	.LD_REG(AVL_WRITE && AVL_CS),
	.Q(Qout)
);
*/
AES AES_module(
	.CLK(CLK),
	.CONTINUE(CONTINUE),
	.AES_START(Qout[14][0]),
	.AES_DONE(AES_DONE),
	.AES_KEY(Qout[3:0]),
	.AES_MSG_ENC(Qout[7:4]),
	.AES_MSG_DEC(AES_MSG_DEC_AVALON[3:0])
	

);


always_comb begin

	case(AVL_BYTE_EN)
	
		4'b1111:
			mask = 32'hffffffff;
		4'b1100:
			mask = 32'hffff0000;
		4'b0011:
			mask = 32'h0000ffff;
		4'b1000:
			mask = 32'hff000000;
		4'b0100:
			mask = 32'h00ff0000;
		4'b0010:
			mask = 32'h0000ff00;
		4'b0001:
			mask = 32'h000000ff;
		default:
			mask = 32'h00000000;
	endcase
		



end




endmodule