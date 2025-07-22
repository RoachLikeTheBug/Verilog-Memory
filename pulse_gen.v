module pulse_gen (
	input wire clk, load, Sample_Enable,
	output wire ShiftR,
	output wire [1:0] st, nextSt
);

localparam state0 = 2'b00;
localparam state1 = 2'b01;
localparam state2 = 2'b10;
localparam state3 = 2'b11;

reg ping;
reg [3:0] shift_count;
reg [1:0] state, next_state;

assign ShiftR = ping;
assign st = state;
assign nextSt = next_state;

initial begin
	state = state0;
	shift_count = 4'h0;
	ping = 1'b0;
end

// state and shift register 
always @ (posedge clk) begin 
	case (state) 
		state0: state <= (load) ? next_state : state;
		state1: state <= (Sample_Enable) ? next_state : state;
		state2: state <= (Sample_Enable) ? next_state : state;
		state3: state <= (Sample_Enable) ? next_state : state;
		default: state <= state;
	endcase
end

// state transition logic
always @ (*) begin
	case (state)
		state0: next_state = state1;
		state1: next_state = state2;
		state2: next_state = state3;
		state3: next_state = (shift_count < 4'ha) ? state2 : state0;
	endcase
end

// pulse generator
always @ (*) begin
	case (next_state) 
		state2: ping = (Sample_Enable) ? 1'b1 : 1'b0;
		default: ping = 1'b0;
	endcase
end

// pulse counter
always @ (posedge clk) begin
	if (state == state0) begin
		shift_count <= 4'h0;
	end
	else begin
		case (ping) 
			1'b1: shift_count <= shift_count + 4'h1;
			default: shift_count <= shift_count;
		endcase
	end
end

endmodule 