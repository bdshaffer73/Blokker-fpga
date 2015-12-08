# Blokker-fpga
A Frogger inspired road race through varying lanes of traffic.

Blokker was created by Ben Shaffer (myself) and Grant Picker (my lab partner). The game was built using Verilog, compiled in Altera Quartus II v14.0, and deployed to an Altera DE2-115 FPGA. Blokker outputs to a VGA display, with a resolution of 1280x1024. The VGA output code was borrowed from _____. 

To design Blokker, first we needed to see output on a VGA display. We researched how to output to the display, but to save time we borrowed code from ______ as mentioned before. Once VGA output was working, we began building Blokker incrementally, starting with the player, Blokker. Blokker is controlled with 4 buttons for up, down, left, and right movement, and takes input from each button simultaneously (so he can move diagonally). The initial input for the controls was also borrowed from _____'s project. Building the "vehicles" was fairly simple, as they were in essence the same as Blokker, just a different size, color, or speed. Each vehicle was controlled using the same technique as blokker, but with the change of a set Y coordinate and a constant change in X. Considering Frogger uses infinite lines of traffic, we had to create the same illusion. To do this, we instantaneously moved each vehicle in a row back the exact distance that it's spaced from the vehicle behind it. Since each vehicle in the row is identical, we could trick the player into perceiving infinite vehicles while only drawing a few. 
