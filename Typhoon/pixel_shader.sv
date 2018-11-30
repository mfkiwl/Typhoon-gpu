module pixel_shader (
	input logic[17:0] SW,
	input logic rasterTileID,
	output reg[15:0] cBufferTile0 [tileDim][tileDim],
	output reg[15:0] cBufferTile1 [tileDim][tileDim],
	input reg[15:0] zBufferTile [tileDim][tileDim],
	input logic[9:0] box [4], // x,y,w,h
	input logic BOARD_CLK,
	input logic[9:0] rasterxOffset, rasteryOffset, // offset of tile we are rasterizing
	input [9:0] start_x, start_y,
	
	input logic startRasterizing,
	output logic doneRasterizing = 0
);

parameter tileDim = 8'd8;
parameter numPixelShaders = 8'd4;

logic nextDoneRasterizing;

logic[9:0] x_temp;
logic[9:0] y_temp;

logic [9:0] x = 0, y = 0, nextX = 0, nextY = 0;


enum logic [4:0]{

	start,
	chooseNextPixel,
	done

} state, nextState;

always_ff @(posedge BOARD_CLK) begin
	if(x >= rasterxOffset && x < rasterxOffset+tileDim && y >= rasteryOffset && y < rasteryOffset+tileDim) begin
		if(rasterTileID == 0)
			cBufferTile0[x-rasterxOffset][y-rasteryOffset] <= SW;
		else
			cBufferTile1[x-rasterxOffset][y-rasteryOffset] <= SW;
	end
	
		
		
	state <= nextState;
	x <= nextX;
	y <= nextY;
	doneRasterizing <= nextDoneRasterizing;
end

always_comb begin
	/*
	if(x+1 >= tileDim) begin
		nextDoneRasterizing = 1;
		nextX = 0;
	end else begin
		nextDoneRasterizing = 0;
		nextX = x+1;
	end
	*/
	
	x_temp = x+numPixelShaders;
	if(x_temp >= box[2] || x_temp >= rasterxOffset + tileDim) begin
		y_temp = y+1;
	end
	else begin
		y_temp = y;
	end
	
	unique case(state)
	
		start: begin
			nextState = startRasterizing ? chooseNextPixel : start;
			nextX = start_x;
			nextY = start_y;
			nextDoneRasterizing = 0;
		end
		
		chooseNextPixel: begin
			nextDoneRasterizing = 0;
			if((x_temp >= box[2] || x_temp >= rasterxOffset + tileDim) && (y_temp >= box[3] || y_temp >= rasteryOffset + tileDim)) begin // Done with bounding box
				nextX = start_x;
				nextY = start_y;
				nextState = done;
			end	
			else if(x_temp >= box[2] || x_temp >= rasterxOffset + tileDim) begin
				nextX = start_x + x_temp - tileDim;
				nextY = y+1;
				nextState = chooseNextPixel;
			end
			else begin
				nextX = x_temp;
				nextY = y_temp;
				nextState = chooseNextPixel;
	
			end
		end
		
		done: begin
			nextDoneRasterizing = 1;
			nextState = start;
			nextX = start_x;
			nextY = start_y;
		end
		
		default: begin
			nextX = start_x;
			nextY = start_y;
			nextState = start;
		end
	
	endcase
	
	
	/*
	if(x_temp >= box[2] && y_temp >= box[3]) begin
		nextX = start_x;
		nextY = start_y;
		nextDoneRasterizing = 1;
	end
	else if(x_temp >= box[2]) begin
		nextX = x_temp - tileDim;
		nextY = y+1;
		nextDoneRasterizing = 0;
	end
	else begin
		nextX = x_temp;
		nextY = y_temp;
		nextDoneRasterizing = 0;
	
	end
	*/

end

endmodule