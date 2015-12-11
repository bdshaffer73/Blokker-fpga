```
module Blokker(clk, VGA_R,VGA_B,VGA_G,VGA_BLANK_N, VGA_SYNC_N , VGA_HS, VGA_VS, rst, VGA_CLK, Button3, Button2, Button1, Button0, restart);

//======Borrowed Code======//
//outputs the colors, determined from the color module.
output [7:0] VGA_R, VGA_B, VGA_G;

//Makes sure the screen is synced right.
output VGA_HS, VGA_VS, VGA_BLANK_N, VGA_CLK, VGA_SYNC_N;

//Basic inputs. Switches and buttons.
input clk, rst; //clk is taken from the onboard clock. rst is taken from a switch.
input Button0, Button1, Button2, Button3;//control Blokker
input restart;//restart game -- This was not fully implemented.

wire WireButton0, WireButton1, WireButton2, WireButton3; //Carry the button signals to various places.
wire CLK108; //Clock for the VGA
wire [30:0]X, Y; //Coordinates of the pixel being assigned. Moves top to bottom, left to right.

//Not sure what these are, probably have to do with the display output system.
wire [7:0]countRef;
wire [31:0]countSample;

//======New code======// 
/*Coordinates of blokker. Used only when the game is started for the 
first time. Had we implemented a true restart, these coordinates would
be called at the beginning of each restart. True for all coordinates
in this code block.*/
reg [31:0]blokkerX = 31'd640, blokkerY = 31'd825;

reg [31:0]car1X = 31'd0, car1Y = 31'd675;		//coordinates of car1
reg [31:0]car2X = 31'd200, car2Y = 31'd675;	//coordinates of car2
reg [31:0]car3X = 31'd400, car3Y = 31'd675;	//coordinates of car3
reg [31:0]car4X = 31'd600, car4Y = 31'd675;	//coordinates of car4
reg [31:0]car5X = 31'd800, car5Y = 31'd675;	//coordinates of car5
reg [31:0]car6X = 31'd1000, car6Y = 31'd675;	//coordinates of car6

reg [31:0]truck1X = 31'd1180, truck1Y = 31'd425;	//coordinates of truck1
reg [31:0]truck2X = 31'd980, truck2Y = 31'd425;		//coordinates of truck2
reg [31:0]truck3X = 31'd780, truck3Y = 31'd425;		//coordinates of truck3
reg [31:0]truck4X = 31'd580, truck4Y = 31'd425;		//coordinates of truck4
reg [31:0]truck5X = 31'd380, truck5Y = 31'd425;		//coordinates of truck5
reg [31:0]truck6X = 31'd180, truck6Y = 31'd425;		//coordinates of truck6

reg [31:0]bike1X = 31'd0, bike1Y = 31'd225;		//coordinates of bike1
reg [31:0]bike2X = 31'd300, bike2Y = 31'd225;	//coordinates of bike2
reg [31:0]bike3X = 31'd600, bike3Y = 31'd225;	//coordinates of bike3
reg [31:0]bike4X = 31'd900, bike4Y = 31'd225;	//coordinates of bike4

//======Borrowed Code======//
//This doesn't actually do anything because the restart wasn't implemented.
//Just an open ended switch.
assign restartGame = (restart);

//Gets the inputs from the buttons so that Blokker can be controlled.
assign WireButton0=Button0;
assign WireButton1=Button1;
assign WireButton2=Button2;
assign WireButton3=Button3;	 
assign refresh= (X==0)&&(Y==0);

//======New Code======//
/*This code block creates a 'game object' with parameters for its boundaries.
Each game block's name is a True/False signal, set by logic that goes true if
the pixel being displayed is within the boundaries of the object.
*/
wire Blokker, Edge, EdgeR, EdgeT, Car1, Car2, Car3, Car4, Car5, Car6, Truck1, Truck2, Truck3, Truck4, Truck5, Truck6, Bike1, Bike2, Bike3, Bike4, Grass, Win;

//========= EDGE =========//
//Edge_Parameters
assign Edge = ((X >= 31'd0) && (X <= 31'd150) && (Y >= 31'd0) && (Y <= 31'd1024));

//EdgeR_Parameters
assign EdgeR = ((X >= 31'd1180) && (Y >= 31'd0) && (Y <= 31'd1024));

//grass_Parameters
assign Grass = ((X >= 31'd0) && (Y >= 31'd900));

//win_Parameters
assign Win = ((X >= 31'd0) && (Y >= 31'd101) && (Y <= 31'd176));

/*The T and L parameters of each object set the top left corner of the object's
reference frame. If Blokker_L is not Zero, then all of Blokker's positions will
be shifted right by the value of Blokker_L. This only affects how much usable screen 
there is, so we left it zeroed.
The B and R parameters of each object set the size of the object, where B sets the 
height and R sets the width. Changing B changes the place of the bottom edge, never
the top. Changing R works in the same way.
*/
//======== BLOKKER =======//
//blokker_Parameters
localparam Blokker_L = 31'd0;
localparam Blokker_R = Blokker_L + 31'd50;
localparam Blokker_T = 31'd0;
localparam Blokker_B = Blokker_T + 31'd75;
assign Blokker =((X >= Blokker_L + blokkerX)&&(X <= Blokker_R + blokkerX)&&(Y >= Blokker_T+ blokkerY)&&(Y <= Blokker_B+ blokkerY));


//========= CARS ========//
//car1_Parameters
localparam Car1_L = 31'd0;
localparam Car1_R = Car1_L + 31'd50;
localparam Car1_T = 31'd0;
localparam Car1_B = Car1_T + 31'd75;
assign Car1 =((X >= Car1_L + car1X)&&(X <= Car1_R + car1X)&&(Y >= Car1_T+ car1Y)&&(Y <= Car1_B + car1Y));

//car2_Parameters
localparam Car2_L = 31'd0;
localparam Car2_R = Car2_L + 31'd50;
localparam Car2_T = 31'd0;
localparam Car2_B = Car2_T + 31'd75;
assign Car2 =((X >= Car2_L + car2X)&&(X <= Car2_R + car2X)&&(Y >= Car2_T+ car2Y)&&(Y <= Car2_B + car2Y));

//car3_Parameters
localparam Car3_L = 31'd0;
localparam Car3_R = Car3_L + 31'd50;
localparam Car3_T = 31'd0;
localparam Car3_B = Car3_T + 31'd75;
assign Car3 =((X >= Car3_L + car3X)&&(X <= Car3_R + car3X)&&(Y >= Car3_T+ car3Y)&&(Y <= Car3_B + car3Y));

//car4_Parameters
localparam Car4_L = 31'd0;
localparam Car4_R = Car4_L + 31'd50;
localparam Car4_T = 31'd0;
localparam Car4_B = Car4_T + 31'd75;
assign Car4 =((X >= Car4_L + car4X)&&(X <= Car4_R + car4X)&&(Y >= Car4_T+ car4Y)&&(Y <= Car4_B + car4Y));

//car5_Parameters
localparam Car5_L = 31'd0;
localparam Car5_R = Car5_L + 31'd50;
localparam Car5_T = 31'd0;
localparam Car5_B = Car5_T + 31'd75;
assign Car5 =((X >= Car5_L + car5X)&&(X <= Car5_R + car5X)&&(Y >= Car5_T+ car5Y)&&(Y <= Car5_B + car5Y));

//car6_Parameters
localparam Car6_L = 31'd0;
localparam Car6_R = Car6_L + 31'd50;
localparam Car6_T = 31'd0;
localparam Car6_B = Car6_T + 31'd75;
assign Car6 =((X >= Car6_L + car6X)&&(X <= Car6_R + car6X)&&(Y >= Car6_T+ car6Y)&&(Y <= Car6_B + car6Y));

//========= TRUCKS ========//
//truck1_Parameters
localparam Truck1_L = 31'd0;
localparam Truck1_R = Truck1_L + 31'd100;
localparam Truck1_T = 31'd0;
localparam Truck1_B = Truck1_T + 31'd75;
assign Truck1 =((X >= Truck1_L + truck1X)&&(X <= Truck1_R + truck1X)&&(Y >= Truck1_T+ truck1Y)&&(Y <= Truck1_B + truck1Y));

//truck2_Parameters
localparam Truck2_L = 31'd0;
localparam Truck2_R = Truck2_L + 31'd100;
localparam Truck2_T = 31'd0;
localparam Truck2_B = Truck2_T + 31'd75;
assign Truck2 =((X >= Truck2_L + truck2X)&&(X <= Truck2_R + truck2X)&&(Y >= Truck2_T+ truck2Y)&&(Y <= Truck2_B + truck2Y));

//truck3_Parameters
localparam Truck3_L = 31'd0;
localparam Truck3_R = Truck3_L + 31'd100;
localparam Truck3_T = 31'd0;
localparam Truck3_B = Truck3_T + 31'd75;
assign Truck3 =((X >= Truck3_L + truck3X)&&(X <= Truck3_R + truck3X)&&(Y >= Truck3_T+ truck3Y)&&(Y <= Truck3_B + truck3Y));

//truck4_Parameters
localparam Truck4_L = 31'd0;
localparam Truck4_R = Truck4_L + 31'd100;
localparam Truck4_T = 31'd0;
localparam Truck4_B = Truck4_T + 31'd75;
assign Truck4 =((X >= Truck4_L + truck4X)&&(X <= Truck4_R + truck4X)&&(Y >= Truck4_T+ truck4Y)&&(Y <= Truck4_B + truck4Y));

//truck5_Parameters
localparam Truck5_L = 31'd0;
localparam Truck5_R = Truck5_L + 31'd100;
localparam Truck5_T = 31'd0;
localparam Truck5_B = Truck5_T + 31'd75;
assign Truck5 =((X >= Truck5_L + truck5X)&&(X <= Truck5_R + truck5X)&&(Y >= Truck5_T+ truck5Y)&&(Y <= Truck5_B + truck5Y));

//truck6_Parameters
localparam Truck6_L = 31'd0;
localparam Truck6_R = Truck6_L + 31'd100;
localparam Truck6_T = 31'd0;
localparam Truck6_B = Truck6_T + 31'd75;
assign Truck6 =((X >= Truck6_L + truck6X)&&(X <= Truck6_R + truck6X)&&(Y >= Truck6_T+ truck6Y)&&(Y <= Truck6_B + truck6Y));

//========= BIKES ========//
//bike1_Parameters
localparam Bike1_L = 31'd0;
localparam Bike1_R = Bike1_L + 31'd25;
localparam Bike1_T = 31'd0;
localparam Bike1_B = Bike1_T + 31'd25;
assign Bike1 =((X >= Bike1_L + bike1X)&&(X <= Bike1_R + bike1X)&&(Y >= Bike1_T+ bike1Y)&&(Y <= Bike1_B + bike1Y));

//bike2_Parameters
localparam Bike2_L = 31'd0;
localparam Bike2_R = Bike2_L + 31'd25;
localparam Bike2_T = 31'd0;
localparam Bike2_B = Bike2_T + 31'd25;
assign Bike2 =((X >= Bike2_L + bike2X)&&(X <= Bike2_R + bike2X)&&(Y >= Bike2_T+ bike2Y)&&(Y <= Bike2_B + bike2Y));

//bike3_Parameters
localparam Bike3_L = 31'd0;
localparam Bike3_R = Bike3_L + 31'd25;
localparam Bike3_T = 31'd0;
localparam Bike3_B = Bike3_T + 31'd25;
assign Bike3 =((X >= Bike3_L + bike3X)&&(X <= Bike3_R + bike3X)&&(Y >= Bike3_T+ bike3Y)&&(Y <= Bike3_B + bike3Y));

//bike4_Parameters
localparam Bike4_L = 31'd0;
localparam Bike4_R = Bike4_L + 31'd25;
localparam Bike4_T = 31'd0;
localparam Bike4_B = Bike4_T + 31'd25;
assign Bike4 =((X >= Bike4_L + bike4X)&&(X <= Bike4_R + bike4X)&&(Y >= Bike4_T+ bike4Y)&&(Y <= Bike4_B + bike4Y));

//======Borrowed Code======//
//==========DO NOT EDIT==========//
countingRefresh(X, Y, clk, countRef );
clock108(rst, clk, CLK_108, locked);

wire hblank, vblank, clkLine, blank;

//Sync the display
H_SYNC(CLK_108, VGA_HS, hblank, clkLine, X);
V_SYNC(clkLine, VGA_VS, vblank, Y);
//=======CONTINUE EDITING=======//

//======New Code======//
/*This code block sets the priority of the game objects so that they're displayed in the right order. 
Changing the placement of an object in the list changes what is displayed on top of it, and what is
displayed under it. In most cases, this doesn't change anything. The important one is the Edge being 
before everything except Blokker.
The lowercase variables translate the object-to-be-displayed decision to the color module.
*/
reg player, car, truck, bike, grass, side, win;

//drawing shapes	
always@(*)
begin
	if(Blokker) begin
		player = 1'b1;
		side = 1'b0;
		car = 1'b0;
		truck = 1'b0;
		bike = 1'b0;
		grass = 1'b0;
		win = 1'b0;
		end
	else if(Edge | EdgeR) begin
		player = 1'b0;
		side = 1'b1;
		car = 1'b0;
		truck = 1'b0;
		bike = 1'b0;
		grass = 1'b0;
		win = 1'b0;
		end
	else if(Car1 | Car2 | Car3 | Car4 | Car5 | Car6) begin
		player = 1'b0;
		side = 1'b0;
		car = 1'b1;
		truck = 1'b0;
		bike = 1'b0;
		grass = 1'b0;
		win = 1'b0;
		end
	else if(Truck1 | Truck2 | Truck3 | Truck4 | Truck5 | Truck6) begin
		player = 1'b0;
		side = 1'b0;
		car = 1'b0;
		truck = 1'b1;
		bike = 1'b0;
		grass = 1'b0;
		win = 1'b0;
		end
	else if(Bike1 | Bike2 | Bike3 | Bike4) begin
		player = 1'b0;
		side = 1'b0;
		car = 1'b0;
		truck = 1'b0;
		bike = 1'b1;
		grass = 1'b0;
		win = 1'b0;
		end
	else if(Grass) begin
		player = 1'b0;
		side = 1'b0;
		car = 1'b0;
		truck = 1'b0;
		bike = 1'b0;
		grass = 1'b1;
		win = 1'b0;
		end
	else if(Win) begin
		player = 1'b0;
		side = 1'b0;
		car = 1'b0;
		truck = 1'b0;
		bike = 1'b0;
		grass = 1'b0;
		win = 1'b1;
		end
	else begin
		player = 1'b0;
		side = 1'b0;
		car = 1'b0;
		truck = 1'b0;
		bike = 1'b0;
		grass = 1'b0;
		win = 1'b0;
		end
	end

/*This next block is tricky. temp and count were borrowed from the other project.
They keep everything running smoothly and at a good speed. We're not sure why temp is
necessary, but without it the code consistently breaks. It MUST be included in the else
statement of any if/else structure in this block, not including else if's. All code besides
temp, count, and the WireButtons is new code.
*/
reg temp;
reg [31:0]count;

//Speed control
reg [2:0]thing1  = 1'd1; //Cars
reg [3:0]thing2  = 1'd1; //Trucks
reg [1:0]thing3  = 2'd1; //Bikes

//controls game objects	
always@(posedge clk)	
begin
		if(count>=31'd100010)
			count<=0;
		else begin
			count<=count+1;
			
			//Collision detection
			if(Blokker && (Car1 | Car2 | Car3 | Car4 | Car5 | Car6 | Truck1 | Truck2 | Truck3 | Truck4 | Truck5 | Truck6 | Bike1 | Bike2 | Bike3 | Bike4)) begin
				blokkerX <= 31'd640;
				blokkerY <= 31'd825;
				end
			else begin
				//blokker movement X axis
				if(WireButton0 == 1'b0 && count == 31'd100000) //count == 31'd100000 is the timer. All actions run at 500hz unless modified.
					blokkerX <= blokkerX + 31'd1;//move blokker right when right key is pressed
				else 
					temp <= temp;
					
				if(WireButton1 == 1'b0 && count == 31'd100000)
					blokkerX <= blokkerX - 31'd1;//move blokker left when left key is pressed
				else
					temp <= temp;
				
				if(blokkerX >= 31'd1130) begin //Right-edge boundary
					blokkerX <= 31'd1129;
					end
				else 
					temp <= temp;
				
				if(blokkerX <= 31'd150) begin //Left-edge boundary
					blokkerX <= 31'd151;
					end
				else
					temp <= temp;
				
				//blokker movement Y axis
				if(WireButton2 == 1'b0 && count == 31'd100000)
					blokkerY <= blokkerY + 31'd1;	//move blokker down when down key is pressed
				else
					temp <= temp;
					
				if(WireButton3 == 1'b0 && count == 31'd100000)
					blokkerY <= blokkerY - 31'd1;	//move blokker up when up key is pressed
				else
					temp <= temp;
				
				if(blokkerY >= 31'd825) begin
					blokkerY <= 31'd824; //Bottom boundary
					end
				else
					temp <= temp;

				if(blokkerY <= 31'd100) begin
					blokkerX <= 31'd640; //Top boundary. Different because once Blokker reaches the top,
					blokkerY <= 31'd825; //he gets reset to the bottom because he wins.
					end
				else
					temp <= temp;
				temp <= temp;
				end
			
			//Shift all cars left by the same distance as their separation to make the illusion of infinite cars.
			if(car6X >= 31'd1280) begin
				car1X <= car1X - 200;
				car2X <= car2X - 200;
				car3X <= car3X - 200;
				car4X <= car4X - 200;
				car5X <= car5X - 200;
				car6X <= car6X - 200;
				end
			else 
				temp <= temp;
				
			//Shift all trucks left by the same distance as their separation to make the illusion of infinite trucks.
			if(truck6X <= 31'd0) begin
				truck1X <= truck1X + 200;
				truck2X <= truck2X + 200;
				truck3X <= truck3X + 200;
				truck4X <= truck4X + 200;
				truck5X <= truck5X + 200;
				truck6X <= truck6X + 200;
				end
			else 
				temp <= temp;
				
			//Shift all bikes left by the same distance as their separation to make the illusion of infinite bikes.
			if(bike4X >= 31'd1280) begin
				bike1X <= bike1X - 300;
				bike2X <= bike2X - 300;
				bike3X <= bike3X - 300;
				bike4X <= bike4X - 300;
				end
			else 
				temp <= temp;
			
			//Move all cars right one pixel
			//thing1 is the divisor to slow down the cars. They move at (500 / thing1) pixels/second. Currently at ~60.
			if(count == 31'd100000 && thing1 == 3'd7) begin
				car1X <= car1X + 1;
				car2X <= car2X + 1;
				car3X <= car3X + 1;
				car4X <= car4X + 1;
				car5X <= car5X + 1;
				car6X <= car6X + 1;
				thing1 <= 1'd0;
				end
			else begin
				temp <= temp;
				thing1 <= thing1 + 1'd1;
				end
				
			//Move all trucks right one pixel
			//thing2 is the divisor to slow down the trucks. They move at (500 / thing2) pixels/second. Currently at ~30.
			if(count == 31'd100000 && thing2 == 4'd15) begin
				truck1X <= truck1X - 1'd1;
				truck2X <= truck2X - 1'd1;
				truck3X <= truck3X - 1'd1;
				truck4X <= truck4X - 1'd1;
				truck5X <= truck5X - 1'd1;
				truck6X <= truck6X - 1'd1;
				thing2 <= 1'd0;
				end
			else begin
				temp <= temp;
				thing2 <= thing2 + 1'd1;
				end
				
			//Move all bikes right one pixel
			//thing3 is the divisor to slow down the bikes. They move at (500 / thing3) pixels/second. Currently at ~120.
			if(count == 31'd100000 && thing3 == 2'd1) begin
				bike1X <= bike1X + 1;
				bike2X <= bike2X + 1;
				bike3X <= bike3X + 1;
				bike4X <= bike4X + 1;
				thing3 <= 2'd0;
				end
			else begin
				temp <= temp;
				thing3 <= thing3 + 2'd1;
				end
			end
			
end

//======Modified Borrowed Code======//
//Determines the color output based on the decision from the priority block
color(clk, VGA_R, VGA_B, VGA_G, player, car, truck, side, bike, grass, win);

//======Borrowed code======//
assign VGA_CLK = CLK_108;
assign VGA_BLANK_N = VGA_VS&VGA_HS;
assign VGA_SYNC_N = 1'b0;
	 
endmodule

//Controls the counter
module countingRefresh(X, Y, clk, count);
input [31:0]X, Y;
input clk;
output [7:0]count;
reg[7:0]count;
always@(posedge clk)
begin
	if(X==0 &&Y==0)
		count<=count+1;
	else if(count==7'd11)
		count<=0;
	else
		count<=count;
end

endmodule

//======Formatted like Borrowed code, but all new parameters======//
//============================//
//========== COLOR ===========//
//============================//
module color(clk, red, blue, green, player, car, truck, side, bike, grass, win);

input clk, player, car, truck, side, bike, grass, win;

output [7:0] red, blue, green;

reg[7:0] red, green, blue;

always@(*)
begin
	if(side) begin
		red = 8'd0;
		blue = 8'd0;
		green = 8'd0;
		end
	else if(player) begin
		red = 8'd50;
		blue = 8'd50;
		green = 8'd255;
		end
	else if(car) begin
		red = 8'd255;
		blue = 8'd50;
		green = 8'd50;
		end
	else if(truck) begin
		red = 8'd225;
		blue = 8'd225;
		green = 8'd50;
		end
	else if(bike) begin
		red = 8'd225;
		blue = 8'd50;
		green = 8'd225;
		end
	else if(grass) begin
		red = 8'd0;
		blue = 8'd50;
		green = 8'd200;
		end
	else if(win) begin
		red = 8'd0;
		blue = 8'd200;
		green = 8'd200;
		end
	else begin
		red = 8'd150;
		blue = 8'd150;
		green = 8'd150;
		end
	end
	
endmodule

//======All Borrowed code past here======//
//====================================//
//========DO NOT EDIT PAST HERE=======//
//====================================//
module H_SYNC(clk, hout, bout, newLine, Xcount);

input clk;
output hout, bout, newLine;
output [31:0] Xcount;
	
reg [31:0] count = 32'd0;
reg hsync, blank, new1;

always @(posedge clk) 
begin
	if (count <  1688)
		count <= Xcount + 1;
	else 
      count <= 0;
   end 

always @(*) 
begin
	if (count == 0)
		new1 = 1;
	else
		new1 = 0;
   end 

always @(*) 
begin
	if (count > 1279) 
		blank = 1;
   else 
		blank = 0;
   end

always @(*) 
begin
	if (count < 1328)
		hsync = 1;
   else if (count > 1327 && count < 1440)
		hsync = 0;
   else    
		hsync = 1;
	end

assign Xcount=count;
assign hout = hsync;
assign bout = blank;
assign newLine = new1;

endmodule

module V_SYNC(clk, vout, bout, Ycount);

input clk;
output vout, bout;
output [31:0]Ycount; 
	  
reg [31:0] count = 32'd0;
reg vsync, blank;

always @(posedge clk) 
begin
	if (count <  1066)
		count <= Ycount + 1;
   else 
            count <= 0;
   end 

always @(*) 
begin
	if (count < 1024) 
		blank = 1;
   else 
		blank = 0;
   end

always @(*) 
begin
	if (count < 1025)
		vsync = 1;
	else if (count > 1024 && count < 1028)
		vsync = 0;
	else    
		vsync = 1;
	end

assign Ycount=count;
assign vout = vsync;
assign bout = blank;

endmodule

//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module clock108 (areset, inclk0, c0, locked);

input     areset;
input     inclk0;
output    c0;
output    locked;

`ifndef ALTERA_RESERVED_QIS
 //synopsys translate_off
`endif

tri0      areset;

`ifndef ALTERA_RESERVED_QIS
 //synopsys translate_on
`endif

wire [0:0] sub_wire2 = 1'h0;
wire [4:0] sub_wire3;
wire  sub_wire5;
wire  sub_wire0 = inclk0;
wire [1:0] sub_wire1 = {sub_wire2, sub_wire0};
wire [0:0] sub_wire4 = sub_wire3[0:0];
wire  c0 = sub_wire4;
wire  locked = sub_wire5;
	 
altpll  altpll_component (
            .areset (areset),
            .inclk (sub_wire1),
            .clk (sub_wire3),
            .locked (sub_wire5),
            .activeclock (),
            .clkbad (),
            .clkena ({6{1'b1}}),
            .clkloss (),
            .clkswitch (1'b0),
            .configupdate (1'b0),
            .enable0 (),
            .enable1 (),
            .extclk (),
            .extclkena ({4{1'b1}}),
            .fbin (1'b1),
            .fbmimicbidir (),
            .fbout (),
            .fref (),
            .icdrclk (),
            .pfdena (1'b1),
            .phasecounterselect ({4{1'b1}}),
            .phasedone (),
            .phasestep (1'b1),
            .phaseupdown (1'b1),
            .pllena (1'b1),
            .scanaclr (1'b0),
            .scanclk (1'b0),
            .scanclkena (1'b1),
            .scandata (1'b0),
            .scandataout (),
            .scandone (),
            .scanread (1'b0),
            .scanwrite (1'b0),
            .sclkout0 (),
            .sclkout1 (),
            .vcooverrange (),
            .vcounderrange ());
defparam
    altpll_component.bandwidth_type = "AUTO",
    altpll_component.clk0_divide_by = 25,
    altpll_component.clk0_duty_cycle = 50,
    altpll_component.clk0_multiply_by = 54,
    altpll_component.clk0_phase_shift = "0",
    altpll_component.compensate_clock = "CLK0",
    altpll_component.inclk0_input_frequency = 20000,
    altpll_component.intended_device_family = "Cyclone IV E",
    altpll_component.lpm_hint = "CBX_MODULE_PREFIX=clock108",
    altpll_component.lpm_type = "altpll",
    altpll_component.operation_mode = "NORMAL",
    altpll_component.pll_type = "AUTO",
    altpll_component.port_activeclock = "PORT_UNUSED",
    altpll_component.port_areset = "PORT_USED",
    altpll_component.port_clkbad0 = "PORT_UNUSED",
    altpll_component.port_clkbad1 = "PORT_UNUSED",
    altpll_component.port_clkloss = "PORT_UNUSED",
    altpll_component.port_clkswitch = "PORT_UNUSED",
    altpll_component.port_configupdate = "PORT_UNUSED",
    altpll_component.port_fbin = "PORT_UNUSED",
    altpll_component.port_inclk0 = "PORT_USED",
    altpll_component.port_inclk1 = "PORT_UNUSED",
    altpll_component.port_locked = "PORT_USED",
    altpll_component.port_pfdena = "PORT_UNUSED",
    altpll_component.port_phasecounterselect = "PORT_UNUSED",
    altpll_component.port_phasedone = "PORT_UNUSED",
    altpll_component.port_phasestep = "PORT_UNUSED",
    altpll_component.port_phaseupdown = "PORT_UNUSED",
    altpll_component.port_pllena = "PORT_UNUSED",
    altpll_component.port_scanaclr = "PORT_UNUSED",
    altpll_component.port_scanclk = "PORT_UNUSED",
    altpll_component.port_scanclkena = "PORT_UNUSED",
    altpll_component.port_scandata = "PORT_UNUSED",
    altpll_component.port_scandataout = "PORT_UNUSED",
    altpll_component.port_scandone = "PORT_UNUSED",
    altpll_component.port_scanread = "PORT_UNUSED",
    altpll_component.port_scanwrite = "PORT_UNUSED",
    altpll_component.port_clk0 = "PORT_USED",
    altpll_component.port_clk1 = "PORT_UNUSED",
    altpll_component.port_clk2 = "PORT_UNUSED",
    altpll_component.port_clk3 = "PORT_UNUSED",
    altpll_component.port_clk4 = "PORT_UNUSED",
    altpll_component.port_clk5 = "PORT_UNUSED",
    altpll_component.port_clkena0 = "PORT_UNUSED",
    altpll_component.port_clkena1 = "PORT_UNUSED",
    altpll_component.port_clkena2 = "PORT_UNUSED",
    altpll_component.port_clkena3 = "PORT_UNUSED",
    altpll_component.port_clkena4 = "PORT_UNUSED",
    altpll_component.port_clkena5 = "PORT_UNUSED",
    altpll_component.port_extclk0 = "PORT_UNUSED",
    altpll_component.port_extclk1 = "PORT_UNUSED",
    altpll_component.port_extclk2 = "PORT_UNUSED",
    altpll_component.port_extclk3 = "PORT_UNUSED",
    altpll_component.self_reset_on_loss_lock = "OFF",
    altpll_component.width_clock = 5;

endmodule
```
