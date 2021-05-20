// Author: Ryan Wolters
// generates VGA synchronization pulses & an onscreen flag 
// given a 25MHz clock
// VGA Format: 640x480 at 60Hz

module hvsync_gen(clk, h_sync, v_sync, onscreen);
input clk;
output reg h_sync, v_sync;
output wire onscreen;
reg h_onscreen, v_onscreen;

// generate horizontal counter
reg[9:0] h_count;
wire h_count_reset = (h_count==10'h31F);

always@(posedge clk)
begin
if(h_count_reset) // count to 800
	h_count <= 0;
else
	h_count <= h_count + 1;
end

// generate vertical counter
reg[9:0] v_count;
always@(posedge h_count_reset)
begin
if(v_count==10'h20C) // count to 525
	v_count <= 0;
else
	v_count <= v_count + 1;
end

// generate h_sync
always@(posedge clk)
begin
if(h_count == 10'd8)
	h_sync <= 1'b0;
else if(h_count == 10'd96)
	h_sync <= 1'b1;
else if(h_count == 10'd152)
	h_onscreen <= 1'b1;
else if(h_count == 10'd792)
	h_onscreen <= 1'b0;
end

// generate v_sync
always@(posedge clk)
begin
if(v_count == 10'd2)
	v_sync <= 1'b0;
else if(v_count == 10'd4)
	v_sync <= 1'b1;
else if(v_count == 10'd37)
	v_onscreen <= 1'b1;
else if(v_count == 10'd517)
	v_onscreen <= 1'b0;
end

// generate onscreen flag
assign onscreen = (h_onscreen & v_onscreen);

endmodule