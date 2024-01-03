module color_generator (
    input clk, rst, blank_n,
    input [8:0] row,
    input [9:0] column,
    input [2:0] block,
    input [2:0] next_block,
    input [2:0] q,
    input [1:0] q_counting,
    input [23:0] ram_color,
    input [9:0] sq1 [3:0], sq2 [3:0], sq3 [3:0], sq4 [3:0],
    output board,
    output reg [23:0] block_color,
    output [7:0] red, green, blue
);

    reg [23:0] rgb;
    assign red = blank_n ? rgb [23:16] : 0;
    assign green = blank_n ? rgb [15:8] : 0;
    assign blue = blank_n ? rgb [7:0] : 0;

    //block types
    localparam [2:0] 	I = 3'b111, T = 3'b001, O = 3'b010, L = 3'b011, 
					    J = 3'b100, S = 3'b101, Z = 3'b110;
    //brakuje 6
    //colors
    localparam [23:0]   LIGHT_ROSE = {8'd255, 8'd204, 8'd229}, 
                        PURPLE = {8'd255, 8'd153, 8'd255},
                        LIGHT_GREY = {8'd160, 8'd160, 8'd160},
                        DARK_GREY = {8'd96, 8'd96, 8'd96},
                        MINTY = {8'd153, 8'd255, 8'd204},
                        BLUE = {8'd102, 8'd178, 8'd255},
                        PINK = {8'd255, 8'd51, 8'd153},
                        DARK_PURPLE = {8'd127, 8'd0, 8'd255},
                        YELLOW = {8'd255, 8'd255, 8'd102},
                        WHITE = {8'd255, 8'd255, 8'd255},
                        GREEN = {8'd102, 8'd255, 8'd102},
                        PLUM = {8'd153, 8'd0, 8'd153};

    localparam [2:0]	START_SCREEN = 3'b000, COUNTING = 3'b001, 
                        START_FALLING = 3'b010, FALLING = 3'b011, 
                        DISTROY_LINE = 3'b101, FAIL = 3'b111;

    wire [23:0] i_color, t_color, o_color, l_color, j_color, s_color, z_color;
    //reg [23:0] block_color;
    assign i_color = MINTY;
    assign t_color = BLUE;
    assign o_color = PINK;
    assign l_color = DARK_PURPLE;
    assign j_color = YELLOW;
    assign s_color = GREEN;
    assign z_color = PLUM;

    always @* case(block)

        I: block_color = i_color;
        T: block_color = t_color;
        O: block_color = o_color;
        L: block_color = l_color;
        J: block_color = j_color;
        S: block_color = s_color;
        Z: block_color = z_color;
        default: block_color = LIGHT_ROSE;

    endcase

    //screen elements
    wire frames;
    wire next_block_field;
    assign frames = row >= 9'd20 && row < 9'd40 && 
                        (column >= 10'd200 && column < 10'd440 || column >= 10'd460 && column < 10'd620)
                    || row >= 9'd20 && row < 9'd460 && 
                        (column >= 10'd200 && column < 10'd220 || column >= 10'd420 && column < 10'd440)
                    || row >= 9'd20 && row < 9'd140 && 
                        (column >= 10'd460 && column < 10'd480 || column >= 10'd600 && column < 10'd620)
                    || row >= 9'd120 && row < 9'd140 && (column >= 10'd460 && column < 10'd620)
                    || row >= 9'd440 && row < 9'd460 && (column >= 10'd200 && column < 10'd440);
    assign board = column >= 10'd220 && column < 10'd420 && row >= 9'd40 && row < 9'd440;
    assign next_block_field = column >= 10'd480 && column < 10'd600 && row >= 9'd40 && row < 9'd120;

    //where are we now?
    wire [2:0] pos = {board, frames, next_block_field}; //do zmiany przy dodatkowych elementach
    localparam [2:0] BOARD = 3'b100, FRAME = 3'b010, NEXT_FIELD = 3'b001;


    always @* begin
        
        case(pos)

        BOARD:  begin
                    case(q)

                    COUNTING:   case(q_counting)

                                2'd0:   if  (column >= 10'd300 && column < 10'd340 && row >= 9'd190 && row < 9'd290
                                            && !(column >= 10'd317 && column < 10'd323 && row >= 9'd210 && row < 9'd270))
                                                rgb = WHITE;
                                        else rgb = LIGHT_ROSE;
                                2'd1:   if  (column >= 10'd300 && column < 10'd340 && row >= 9'd190 && row < 9'd290
                                            && !(column < 10'd320 && row >= 9'd210))
                                                rgb = WHITE;
                                        else rgb = LIGHT_ROSE;
                                2'd2:   if  (column >= 10'd300 && column < 10'd340 && row >= 9'd190 && row < 9'd290
                                            && !(column < 10'd320 && row >= 9'd210 && row < 9'd230)
                                            && !(column >= 10'd320 && row >= 9'd250 && row < 9'd270))
                                                rgb = WHITE;
                                        else rgb = LIGHT_ROSE;
                                2'd3:   if  (column >= 10'd300 && column < 10'd340 && row >= 9'd190 && row < 9'd290
                                            && !(column < 10'd320 && row >= 9'd210 && row < 9'd230)
                                            && !(column < 10'd320 && row >= 9'd250 && row < 9'd270))
                                                rgb = WHITE;
                                        else rgb = LIGHT_ROSE;

                                endcase

                    FALLING :
                        if(column >= sq1[3] && column < sq1[2] && row >= sq1[1] [8:0] && row < sq1[0] [8:0]
                        || column >= sq2[3] && column < sq2[2] && row >= sq2[1] [8:0] && row < sq2[0] [8:0]
                        || column >= sq3[3] && column < sq3[2] && row >= sq3[1] [8:0] && row < sq3[0] [8:0]
                        || column >= sq4[3] && column < sq4[2] && row >= sq4[1] [8:0] && row < sq4[0] [8:0])
                            rgb = block_color;
                        else if(|ram_color)
                            rgb = ram_color;
                        else
                            rgb = LIGHT_ROSE;

                    FAIL:
                        if(row >= 9'd190 && row < 9'd290 && column >= 10'd223 && column < 10'd417 && !(column >= 10'd260 && column < 10'd280)
                        && !(row >= 9'd250 && column >= 10'd240 && column < 10'd280)
                        && !(column >= 10'd320 && column < 10'd340)
                        && !(column >= 10'd360 && column < 10'd380)
                        && !(column >= 10'd400 && row < 9'd270)
                        && !(column >= 10'd297 && column < 10'd303 && (row >= 9'd250 || row >= 9'd210 && row < 9'd230))
                        && !(column >= 10'd240 && column < 10'd280 && row >= 9'd210 && row < 9'd230))
                            rgb = WHITE;
                        else 
                            rgb = LIGHT_ROSE;

                    default: rgb = LIGHT_ROSE;
                    
                    endcase
                end

        FRAME: rgb = LIGHT_GREY;

        NEXT_FIELD: if(q == START_SCREEN) rgb = PURPLE;
                    else case(next_block)

                    I: rgb = (row >= 9'd70 && row < 9'd90 && column >= 10'd500 && column < 10'd580) ? i_color : PURPLE;
                    T: rgb = (row >= 9'd60 && row < 9'd80 && column >= 10'd510 && column < 10'd570
                                || row >= 9'd80 && row < 9'd100 && column >= 10'd530 && column < 10'd550) ? t_color : PURPLE;
                    O: rgb = (row >= 9'd60 && row < 9'd100 && column >= 10'd520 && column < 10'd560) ? o_color : PURPLE;
                    L: rgb = (row >= 9'd80 && row < 9'd100 && column >= 10'd510 && column < 10'd570
                                || row >= 9'd60 && row < 9'd80 && column >= 10'd550 && column < 10'd570) ? l_color : PURPLE;
                    J: rgb = (row >= 9'd80 && row < 9'd100 && column >= 10'd550 && column < 10'd570
                                || row >= 9'd60 && row < 9'd80 && column >= 10'd510 && column < 10'd570) ? j_color : PURPLE;
                    S: rgb = (row >= 9'd60 && row < 9'd80 && column >= 10'd530 && column < 10'd570
                                || row >= 9'd80 && row < 9'd100 && column >= 10'd510 && column < 10'd550) ? s_color : PURPLE;
                    Z: rgb = (row >= 9'd60 && row < 9'd80 && column >= 10'd510 && column < 10'd550
                                || row >= 9'd80 && row < 9'd100 && column >= 10'd530 && column < 10'd570) ? z_color : PURPLE;
                    default: rgb = PURPLE;

                    endcase

        default: rgb = DARK_GREY;

        endcase

    end

endmodule