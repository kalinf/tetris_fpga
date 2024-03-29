module bin_bcd_dl(
    input clk, gen,
    input [9:0] bin,
    output reg [15:0] bcd
);
   
reg [4:0]cnt;

always @(posedge clk) begin
    if(gen) begin
        cnt <= 5'd1;
        bcd <= 0;
    end

  if(cnt > 5'd0 && cnt < 5'd21) begin
        if(cnt[0]) begin
          if (bcd[3:0] >= 4'd5) bcd[3:0] <= bcd[3:0] + 4'd3;	
          if (bcd[7:4] >= 4'd5) bcd[7:4] <= bcd[7:4] + 4'd3;
          if (bcd[11:8] >= 4'd5) bcd[11:8] <= bcd[11:8] + 4'd3;
          if (bcd[15:12] >= 4'd5) bcd[15:12] <= bcd[15:12] + 4'd3;
            cnt <= cnt + 1;
        end
        else begin
          bcd <= {bcd[14:0],bin[10-(cnt >> 1)]};
            cnt <= cnt + 1;
        end
        
    end
end

endmodule