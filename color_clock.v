// Author: Ryan Wolters

module color_clock(clk_50, h_sync, v_sync, R, G, B, clk, sw);
input clk_50;
input reg[2:0] sw;
output h_sync, v_sync, R, G, B, clk;

// generate 25MHz clock signal
reg clk;
always@(posedge clk_50)
	clk = ~clk;

wire onscreen;
hvsync_gen sync_gen(clk, h_sync, v_sync, onscreen);

// clk divider
reg[31:0] count;
reg[2:0] color;
wire msb_count = count[31];
always@(negedge v_sync)
begin
	count <= count + 1;
	if(msb_count)
		color = color + 1;
end

// Mode switcher
always@(negedge v_sync)
	case(sw)
		3'd0:
			begin // generate white screen
			assign R = onscreen;
			assign G = onscreen;
			assign B = onscreen;
			end
		3'd1:
			begin // shifting color patterns
			assign R = color[0] & onscreen;
			assign G = color[1] & onscreen;
			assign B = color[2] & onscreen;
			end
		default:
			begin // generate white screen
			assign R = onscreen;
			assign G = onscreen;
			assign B = onscreen;
			end
	endcase

end

endmodule