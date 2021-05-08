// Author: Ryan Wolters
// generates VGA synchronization pulses & an onscreen flag 
// given a 25MHz clock
// VGA Format: 640x480 at 60Hz

module hvsync_gen(clk, h_sync, v_sync, onscreen);
input clk;
output h_sync, v_sync, onscreen;


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

// generate hv_sync
// at signal

// generate onscreen flag