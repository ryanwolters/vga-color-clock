// Author: Ryan Wolters

module color_clock(clk_50, h_sync, v_sync, R, G, B, clk);
input clk_50;
output h_sync, v_sync, R, G, B, clk;

// gen clk signal
always@(posedge clk_50)
	clk = ~clk;

wire onscreen;
hvsync_gen sync_gen(clk, h_sync, v_sync, onscreen);

// clk divider
reg[31:0] count;
reg[2:0] color;
wire msb_count = count[31];
always@(posedge clk)
begin
	count <= count + 1;
	if(msb_count)
		color = color + 1;
end

// color pattern
assign R = color[0] & onscreen;
assign G = color[1] & onscreen;
assign B = color[2] & onscreen;

endmodule