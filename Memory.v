module Memory (
	input wire CLOCK_50,
	input wire [1:0] KEY,
	input wire [9:0] SW,
	inout wire [39:0] GPIO,
	output wire [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
	output wire [9:0] LEDR
);

wire w0, SE, blip;
wire [1:0] st, nextSt;
wire [3:0] w10, w11;
wire [4:0] w20, w21;
reg fedge, fedge1, redge, rst, ld;
reg [1:0] a, b, c;
reg [3:0] pulses;
reg [4:0] r20;
reg [9:0] a1, b1, c1, shiftReg;
reg [39:0] a2, b2, c2;

assign HEX1 = 8'hff;
assign HEX4 = 8'hff;
assign HEX5 = 8'hff;
assign LEDR = 10'b0000000000;

// synchronize the input signals KEY and SW
always @ (posedge CLOCK_50) begin
	a <= KEY;
	b <= a;
	c <= b;
	a1 <= SW;
	b1 <= a1;
	c1 <= b1;
	a2 <= GPIO;
	b2 <= a2;
	c2 <= b2;
end

// falling edge detector on KEY0 and GPIO[0], rising edge detector on GPIO[0]
always @ (*) begin
	fedge = c[0] & ~b[0];
	fedge1 = c2[0] & ~b2[0];
	redge = b2[0] & ~c2[0];
end

// display memory contents and shift read address every 250 ms
//timer_250ms U0 (.clk(CLOCK_50), .reset(1'b0), .rollover(w0));
//counter_fivebit U1 (.clk(CLOCK_50), .reset(1'b0), .enable(w0), .count(w20));
//ram32X4 U2 (.clock(CLOCK_50), .q(w10), .rdaddress(w20), .wren(fedge), .wraddress(c1[9:5]), .data(c1[3:0]));
//hex_disp U3 (.deci(1'b0), .hexVal(w10), .hexDisp(HEX0));
//hex_disp U4 (.deci(1'b0), .hexVal(w20[3:0]), .hexDisp(HEX2));
//hex_disp U5 (.deci(1'b0), .hexVal({3'b000,w20[4]}), .hexDisp(HEX3));

// UART RX modules
pulse_gen U6 (.clk(CLOCK_50), .load(rst), .Sample_Enable(SE), .st(st), .nextSt(nextSt), .ShiftR(blip));
timer_434us U7 (.clk(CLOCK_50), .reset(rst), .rollover(SE));
counter_fivebit U8 (.clk(CLOCK_50), .reset(fedge), .enable(rst), .count(w21));
ram32X4 U9 (.clock(CLOCK_50), .q(w11), .rdaddress(r20), .wren(ld), .wraddress(w21), .data(shiftReg[4:1]));
hex_disp U10 (.deci(1'b0), .hexVal(w11), .hexDisp(HEX0));
hex_disp U11 (.deci(1'b0), .hexVal(r20[3:0]), .hexDisp(HEX2));
hex_disp U12 (.deci(1'b0), .hexVal({3'b000,r20[4]}), .hexDisp(HEX3));

// timer reset 
always @ (*) begin
	case (fedge1)
		1'b1: rst = (st == 2'b00) ? 1'b1 : 1'b0;
		default: rst = 1'b0;
	endcase
end

// shift register
always @ (posedge CLOCK_50) begin
	case (blip) 
		1'b1: shiftReg <= {c2[0],shiftReg[9:1]};
		default: shiftReg <= shiftReg;
	endcase
end

// load lowest 4 bits from UART transaction into memory
always @ (*) begin
	ld = (pulses == 4'ha) ? 1'b1 : 1'b0;
end

// pulse counter
always @ (posedge CLOCK_50) begin
	if (rst) begin
		pulses <= 4'h0;
	end
	else begin
		case (blip)
			1'b1: pulses <= (pulses < 4'ha) ? (pulses + 4'h1) : 4'h0;
			default: pulses <= pulses;
		endcase
	end
end

// hex output control logic from SW[9]
always @ (posedge CLOCK_50) begin
	case (c1[9]) 
		1'b1: r20 <= w21;
		default: r20 <= c1[4:0];
	endcase
end

endmodule 