# Blokker-fpga
A Frogger inspired road race through varying lanes of traffic.

ECE 287 Project - Blokker

Ben Shaffer
Grant Picker

Project Description:
--------------------
	Our project was to use an Altera DE2-115 FPGA to build a game. We chose to build a game similar to Frogger since it’s simple to control, yet still has enough action taking place to make the project interesting. The main challenges we faced included outputting to a VGA display, taking user input to control an object on the screen, having endless lines of moving traffic, and collision detection to determine player deaths and victories.

Background Info:
----------------
Blokker was built in Verilog HDL, a form of code that directly describes logic gate organization to achieve a goal. The code was compiled in Altera Quartus II v14.0, and deployed to an Altera DE2-115 FPGA. Input to the FPGA utilized 4 buttons that were available on the DE2 board. Output from the FPGA was sent via VGA protocol to a 1280x1024 display. The name was chosen due to the game actors’ rectangular nature and similarity to Frogger.

Construction:
-------------
	To build Blokker, we first needed to output to a VGA display. A VGA display creates images by assigning red, blue and green color values to each pixel. It starts with the top-most line of pixels, assigning from left to right, until it reaches the right-most pixel. Then it moves to the next line down and assigns pixels in the same order, left to right. Once it reaches the last pixel on the bottom row, it moves back to the top row. All pixels on the screen receive an assignment 60 times per second. Sixty hertz allows the display to trick the eye into seeing motion, which allows for animation and video.
To assign each pixel, the VGA needs to receive data in a specific pattern. First, there’s a brief period of waiting called the “front porch.” Then the FPGA outputs a sync pulse to sync the display’s clock with the output clock. Another wait period, the “back porch,” follows, and finally pixel data is sent to the display. Since this process requires a large amount of code and understanding of the hardware involved, we chose to use the VGA controller from a previous project done by Patryk Giza and Zach Morgan to save time, and so we could focus more on the other mechanics of our game.
	The VGA controller receives the X and Y coordinates of each pixel to be assigned, along with the RGB color values and a clock signal. Displaying anything involves using logic to dynamically choose the color of the pixel being assigned. To show a game, that logic needs input from the player(s) and information on the game objects. In Blokker, our logic broke down into several sets of simple pieces. First, each game object is described by its boundaries, so any pixel being assigned within that object gets colors based on that object. For example, when a pixel within Blokker’s boundaries is being assigned, Blokker is the first game object with a true state at that location and so the pixel is assigned Blokker’s color, green. This process is repeated for each game object. When objects overlap, such as Blokker on the background, the object shown is determined from sequential priority, where pixels are assigned the color value of the more important object. Blokker’s color assignment has priority over all others, since Blokker must be visible at all times. Vehicles entering or leaving the play area should not be seen, so the black bars on the sides have the next highest priority, “covering up” the vehicles where they disappear and reappear.  Next priority goes to the vehicles, and lastly to the background colors.
The black sidebars also help produce the illusion of endless traffic lines. As mentioned before, the display outputs static images at a constant rate. Using this to our advantage, we set the vehicles to move in a such a way that when the first one reaches the edge of the screen, all are set back so that they replace each other during motion without skipping, giving the appearance of constant motion. Instead of needing to continually generate new cars, we only needed to use 6 permanent ones.
Blokker has the ability to move in 8 directions: Left, Right, Up, Down, Left-Up, Right-Up, Left-Down, Right-Down. To input the signals necessary for any of these movements, we needed 4 keys. Four keys are conveniently built onto the DE2 board already, so we used those.
Finally, collisions are important in a game about traffic accidents and giant blocky frogs. Collision detection ended up being much simpler than we expected; Blokker is the only object that can collide with something, so any collision would be a case where Blokker’s boundaries overlap with another object’s. By defining the game’s reaction to Blokker “colliding” with another object, we were able to set up play area boundaries to prevent the player from escaping, enable roadkill, and have a winning zone. If Blokker encounters a boundary, he is set back 1 pixel in the opposite direction of attempted movement. If Blokker collides with a car or reaches the “victory” space unharmed, he is returned to his starting location at the bottom of the play area.

Conclusion:
-----------
	By completing this project, we utilized hardware description to build a machine that can play a pretty basic game, but one which has much room for additions and improvements.  We learned about how intricate VGA displays are, how to control pixels, and how to use logic to determine macroscopically what the colors each pixel should be assigned. 
Things we could have changed:
We didn’t design a Finite State Machine to build Blokker, so there are several places in the code that this could have been implemented where it likely would have made the code more efficient.  Several additional features were planned, but removed or remained unimplemented due to time constraints.  We put some work into building an audio module, consisting of an Arduino with a small speaker that could play tunes based on input from the DE2’s general purpose outputs. The Arduino side of this feature worked, but took too much time to interface with the FPGA. We also considered interfacing with a PS/2 type keyboard for more user-friendly input and more potential for expansion, but this also proved too time-consuming. Score counters, a life system, and a way to make the game progressively harder as time went on would have made it more interesting, and gone a long way to make the game feel more complete.

Citations:
----------
All VGA output code was borrowed from Patryk and Zach’s project. Link to Patryk and Zach’s repository: https://code.google.com/p/fpga-pong/source/browse/

Some of the input code and structural code was also borrowed from their project since it worked with what we were designing. 

Here’s a video of the game in action: https://www.youtube.com/watch?v=iMEPIw0ktdI

Borrowed Code:
Each space in the blocks indicates new code.

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
```
```
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
```
```
//======Borrowed Code======//
//==========DO NOT EDIT==========//
countingRefresh(X, Y, clk, countRef );
clock108(rst, clk, CLK_108, locked);

wire hblank, vblank, clkLine, blank;

//Sync the display
H_SYNC(CLK_108, VGA_HS, hblank, clkLine, X);
V_SYNC(clkLine, VGA_VS, vblank, Y);
//=======CONTINUE EDITING=======//
```
```
reg temp;
reg [31:0]count;
```
```
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
```
```
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
