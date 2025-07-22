module timer_434us (
	input wire clk, reset,
	output wire rollover
);

reg [7:0] i;
reg roll;

assign rollover = roll;

initial begin
	roll = 1'b0;
	i = 8'h00;
end

always @ (*) begin
	if (i == 8'hd8) begin //8'hd9 is 217 in decimal
		roll = 1'b1;
	end 
	else begin
		roll = 1'b0;
	end
end

always @ (posedge clk) begin
	case (reset)
		1'b0: i <= (i < 8'hd8) ? (i + 8'h01) : 8'h00;
		1'b1: i <= 8'h00;
	endcase
end

endmodule 