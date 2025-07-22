module timer_250ms (
	input wire clk, reset,
	output wire rollover
);

reg [23:0] i;
reg roll;

assign rollover = roll;

initial begin
	roll = 1'b0;
	i = 24'h000000;
end

always @ (*) begin
	if (i == 24'hbebc1f) begin //24'hbebc20 is 12,500,000 in decimal
		roll = 1'b1;
	end 
	else begin
		roll = 1'b0;
	end
end

always @ (posedge clk) begin
	case (reset)
		1'b0: i <= (i < 24'hbebc1f) ? (i + 24'h000001) : 24'h000000;
		1'b1: i <= 24'h000000;
	endcase
end

endmodule 