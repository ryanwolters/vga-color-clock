// Author: Ryan Wolters

module color_clock(clk_50, h_sync, v_sync, R_out, G_out, B_out, clk, sw);
input clk_50;
input wire[2:0] sw;
output h_sync, v_sync, R_out, G_out, B_out, clk;
reg R, G, B;

// generate 25MHz clock signal
reg clk;
always@(posedge clk_50)
	clk = ~clk;

wire onscreen;
hvsync_gen sync_gen(clk, h_sync, v_sync, onscreen);

// clk divider
reg[9:0] count;
reg[2:0] color;
wire msb_count = count[9];
always@(negedge v_sync)
begin
	count <= count + 1;
	if(msb_count)
		color = color + 1;
end

assign R_out = R & onscreen;
assign G_out = G & onscreen;
assign B_out = B & onscreen;

// Mode switcher
always@(negedge v_sync)
	case(sw)
		3'd0:
			begin // generate white screen
			R = 1'b1;
			G = 1'b1;
			B = 1'b1;
			end
		3'd1:
			begin // seizure warning
			R = color[0];
			G = color[1];
			B = color[2];
			end
		3'd2:
			begin // generate red screen
			R = 1'b1;
			G = 1'b0;
			B = 1'b0;
			end
		3'd3:
			begin // generate green screen
			R = 1'b0;
			G = 1'b1;
			B = 1'b0;
			end
		3'd4:
			begin // generate blue screen
			R = 1'b0;
			G = 1'b0;
			B = 1'b1;
			end
		default:
			begin // generate white screen
			R = onscreen;
			G = onscreen;
			B = onscreen;
			end
	endcase

endmodule