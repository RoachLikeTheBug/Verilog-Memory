module counter_fivebit (
	input wire clk, enable, reset,
	output wire [4:0] count
);

reg [4:0] counter;

initial begin
	counter = 5'b00000;
end

assign count = counter;

always @ (posedge clk) begin
	casez ({reset,enable})
		2'b1z: counter <= 5'b00000;
		2'b01: counter <= counter + 5'b00001;
		default: counter <= counter;
	endcase
end

endmodule 