module hex_disp (
	input wire deci,
	input wire [3:0] hexVal,
	output wire [7:0] hexDisp
);

reg [7:0] hexConv;

assign hexDisp = hexConv;

// for a seven-segment display to illuminate, we need to send a 0 to the LED register
// deci controls the decimal place of the display (1 illumintes, 0 darkens)
always @ (*) begin
	case(hexVal)
		4'h0: hexConv = deci ? (8'hc0 - 8'h80) : 8'hc0;
		4'h1: hexConv = deci ? (8'hf9 - 8'h80) : 8'hf9;
		4'h2: hexConv = deci ? (8'ha4 - 8'h80) : 8'ha4;
		4'h3: hexConv = deci ? (8'hb0 - 8'h80) : 8'hb0;
		4'h4: hexConv = deci ? (8'h99 - 8'h80) : 8'h99;
		4'h5: hexConv = deci ? (8'h92 - 8'h80) : 8'h92;
		4'h6: hexConv = deci ? (8'h82 - 8'h80) : 8'h82;
		4'h7: hexConv = deci ? (8'hf8 - 8'h80) : 8'hf8;
		4'h8: hexConv = deci ? (8'h80 - 8'h80) : 8'h80;
		4'h9: hexConv = deci ? (8'h98 - 8'h80) : 8'h98;
		4'ha: hexConv = deci ? (8'h88 - 8'h80) : 8'h88;
		4'hb: hexConv = deci ? (8'h83 - 8'h80) : 8'h83;
		4'hc: hexConv = deci ? (8'ha7 - 8'h80) : 8'ha7;
		4'hd: hexConv = deci ? (8'ha1 - 8'h80) : 8'ha1;
		4'he: hexConv = deci ? (8'h86 - 8'h80) : 8'h86;
		4'hf: hexConv = deci ? (8'h8e - 8'h80) : 8'h8e;
		default: hexConv = 8'hff;
	endcase
end

endmodule
