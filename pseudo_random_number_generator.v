module pseudo_random_number_generator#(parameter W = 2) (
    //input [W:0] maxvalue,
    input next, rst,
    input [8:0] d,
    output [W:0] o
);

reg [8:0] q;
wire [8:0] w;

assign w = q >> (8 - W);
assign o = w[W:0];

always @(posedge next or posedge rst)
    if (rst) q <= d;// + 146;
    else q <= {q[7:0], q[8] ^ q[4]};
    
endmodule