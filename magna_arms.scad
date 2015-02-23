// This Kossel delta printer magnetic arm end was inspired by:
//   http://forum.seemecnc.com/viewtopic.php?f=54&t=1704&p=10703
//
// Use cylindrical magnets like these:
//   http://shop.revolutionmachines.com/3-8-N52-Magnet-Cylinder-Set-12-Piece-ND3-8-12pc.htm
// 
// Use 3/8" chrome plated steel bearings like these:
//   http://www.ebay.com/itm/380140413083
//
// Use carbon fiber rods like these:
//   http://www.tridprinting.com/Mechanical-Parts/#3D-Printer-Rod-Kit
//
// This work is licensed under a Creative Commons Attribution-ShareAlike 4.0
// International License.
// Visit:  http://creativecommons.org/licenses/by-sa/4.0/
//
// This can be printed with a layer height of 0.2mm or 0.1mm.
// Use a shell thickness of 2mm, so that all of the walls will be printed with
// concentric circles, instead of back-and-forth infill.
// For PLA, use a relatively low temperature, like 185C, so that the overhangs
// inside of the ball bearing sockets come out as cleanly as possible.
// Use a little bit of lithium grease in the ball bearing socket.
// Use a file to roughen up a patch on the ball bearings, then use acetone to
// clean the 3mm screws and ball bearings, and use JB Weld epoxy to join them
// together.
//
// This version works with Slic3r.
//
// Haydn Huntley
// haydn.huntley@gmail.com

$fa = 1;
$fs = 0.4;

// All measurements in mm.
smidge              = 0.1;
mmPerInch           = 25.4;
minWallWidth        = 1.0;
magnetDiameter      = 9.5;
magnetHeight        = 9.6;
magnetRadius        = (magnetDiameter+2*smidge)/2;
rodDiameter         = 6; // 0.230 * mmPerInch;
rodRadius           = (rodDiameter+2*smidge)/2;
ballBearingDiameter = 3/8 * mmPerInch;
ballBearingRadius   = ballBearingDiameter/2;

height              = 30;
magnetOffset        = 3.5; // Can decrease this to 3.4 for more force.
ballBearingOffset   = 1.4;
rodEndLipHeight		= 1;
rodEndHeight        = height + rodEndLipHeight - magnetHeight - magnetOffset;


module ballBearingHolder()
{
	difference()
	{
		// The body.
		cylinder(r=magnetRadius+minWallWidth, h=height);
		
		// Hollow out the inside for the magnet and rod end to slide into.
		translate([0, 0, magnetOffset])
		cylinder(r=magnetRadius, h=height);

		// Make a hole through the center to try to eliminate the badly formed
		// plastic from almost horizontal overhangs.
		cylinder(r=ballBearingRadius/2, h=height);

		// Hollow out the socket for the ball bearing to rest in.
		translate([0, 0, -ballBearingOffset])
		sphere(r=ballBearingRadius);

		// Put a hole in the side for gluing the rodEnd and magnet.
		translate([0, 0, magnetHeight+magnetOffset])
		rotate([0, 90, 0])
		cylinder(r=1, h=magnetRadius+minWallWidth);
	}
}


module rodEnd()
{
	difference()
	{
		union()
		{
			// To fit inside of the magnet's pocket.
			cylinder(r=magnetRadius-smidge, h=rodEndHeight);

			cylinder(r=magnetRadius+minWallWidth, h=rodEndLipHeight);
		}
		
		// Space for the rod.
		translate([0, 0, -smidge/2])
		cylinder(r=rodRadius, h=rodEndHeight+smidge);
	}
}


module printPair()
{
	space = 7;
	translate([space, 0, 0])
	ballBearingHolder();

	translate([-space, 0, 0])
	rodEnd();
}


module print12Pair()
{
	for (i = [1:3])
		for (j = [1:4])
		{
			translate([30 * (i-2), 20 * (j-2.5), 0])
			printPair();
		}
}

module assembled() {
    %ballBearingHolder();
    translate([0, 0, height + rodEndLipHeight]) rotate([0, 180, 0]) rodEnd();
    translate([0, 0, magnetOffset]) color("silver") cylinder(r=magnetRadius, h=magnetHeight);
}

module jig(rad=magnetRadius, length=magnetHeight) {
    width=(rad+minWallWidth*2) * 2;
    difference() {
        union() {
            translate([-2, -width/2, -width/2]) cube([length + 4, width, width]);
            translate([length, -width/2, -width/2]) cube([15, width, 3]);
        }
        rotate([0, 90, 0]) cylinder(r=rad, h=length+smidge);
        translate([0, -rad, 0]) cube([length+smidge, rad * 2, rad * 2]);
        translate([length/2, 0, rad/2-width/2]) rotate([90, 0, 0]) cylinder(r=1, h=width+2, center=true);
        translate([20, 0, -width/2]) cylinder(r=2, h=width, center=true);
    }
}


// Use print12Pair() to print an entire set for a printer, or use the other
// modules to print individual pairs or parts.
//print12Pair();
printPair();
//assembled();
//jig(rad=10/2);