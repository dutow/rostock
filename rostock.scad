include <configuration.scad>;
use <belt.scad>;
use <bearing.scad>;
use <nema.scad>;
use <motor_end.scad>;
use <idler_end.scad>;
use <carriage.scad>;
use <platform.scad>;
use <rod.scad>;

aluminum = [0.9, 0.9, 0.9];
steel = [0.8, 0.8, 0.9];
use_stls=false;

tower_radius = rod_radius + carriage_hinge_offset + platform_hinge_offset;
belt_length = smooth_rod_length - (motor_end_total - (motor_end_height/2+motor_height_offset)) - (idler_end_total-idler_height_offset);

//build radius for animation.
br = rod_radius;

echo(str("Marlin firmware config:"));
echo(str("DELTA_DIAGONAL_ROD =", rod_length));
echo(str("DELTA_SMOOTH_ROD_OFFSET =", tower_radius));
echo(str("DELTA_EFFECTOR_OFFSET =", platform_hinge_offset));
echo(str("DELTA_CARRIAGE_OFFSET =", carriage_hinge_offset));
echo(str("DELTA_RADIUS =", rod_radius));

echo(str("Smoothieware firmware config:"));
echo(str("arm_solution linear_delta"));
echo(str("arm_length ", rod_length));
echo(str("arm_radius ", rod_radius));

echo(str("Build volume:"));
echo(str("BUILD VOLUME_Z =", (smooth_rod_length - rod_length - motor_end_total - bed_thickness - idler_end_total)));
echo(str("BUILD VOLUME_RADIUS =", rod_radius));

echo(str("BELT LENGTH (each) =", belt_length * 2 + PI * outside_diameter(idler_bearing)));

function rodpos(angle, side = 1) = [
    tower_radius * sin(angle) + smooth_rod_separation / 2 * sin(angle + side * 90),
    tower_radius * cos(angle) + smooth_rod_separation / 2 * cos(angle + side * 90), 
    -10];

smooth_rod_side_separation = rodpos(120,1)[0] - rodpos(240,-1)[0];
echo(str("IDLER END TOTAL HEIGHT = ", idler_end_total)); // E.g. height if making wooden framing for idler end
echo(str("MOTOR END TOTAL HEIGHT = ", motor_end_total)); // E.g. height if making wooden framing for motor end
echo(str("SMOOTH ROD SIDE SEPARATION =", smooth_rod_side_separation)); // E.g. rod-to-rod side panel distance

platformxyz=[cos($t*360)*br,sin($t*360)*br,30];

module smooth_rod() 
{
	color(steel) cylinder(r=smooth_rod_radius, h=smooth_rod_length);
}

module tower(height) 
{
        carriage_pivot_z_offset = 8;
	translate([0, tower_radius, 0]) 
	{
		translate([0, 0, motor_end_total]) 
		rotate([0,180,180])
		if (use_stls) import ("motor_end.stl"); else render() motor_end();

                if (fixing_ends) {
		    translate([0, 0, fixing_end_height]) rotate([0,180,180]) fixing_bracket();
                    translate([0, 0, smooth_rod_length-fixing_end_height]) rotate([0,0,180]) fixing_bracket();
                }

		translate([0, 0, smooth_rod_length-idler_end_total]) 
		rotate(180)
		if (use_stls) import ("idler_end.stl"); else idler_end();

		translate([smooth_rod_separation/2, 0, 0]) smooth_rod();
		translate([-smooth_rod_separation/2, 0, 0]) smooth_rod();

		translate([0, 0, motor_end_total+bed_thickness+pcb_thickness+carriage_pivot_z_offset+platformxyz[2]+height]) 
		rotate([0, 180, 0]) 
		{
			if (use_stls) import ("carriage.stl"); else render() carriage();
			for(j=[-smooth_rod_separation/2,smooth_rod_separation/2])
			translate([j,0,0])
			bearing(smooth_rod_bearing);
		}

		translate([0, 17-10, motor_end_total - (motor_end_height/2 + motor_height_offset)]) nema17(47);

		// Ball bearings for timing belt
		translate([0,-4, smooth_rod_length-(idler_end_total - (idler_end_height-idler_height_offset))])
		rotate([-90, 0, 0]) bearing(idler_bearing);

		// Timing belt
                for (i = [-1, 1])
		translate([i * idler_bearing[1]/2, -4+7/2, belt_length/2+(motor_end_total - (motor_end_height/2+motor_height_offset))]) 
		rotate([0, 90, 0]) timing_belt(belt_length);
	}
}

module rod_pair(lean_y,lean_x)
{
    for(i=[-1,1]) {
	translate([rod_separation/2*i,platform_hinge_offset,0])
	rotate([lean_x,0,0])
	rotate([0,lean_y,0])
	rotate([0, -90, 0]) 
	if (use_stls) import ("rod.stl"); else 
	if (ball_joints) {
            ball_rod(rod_length);
        } else {
            rod(rod_length);
        }
    }
}

module rostock() 
{
    for(i=[0:2])
    assign(angle=120*i)
    assign(carriage_xy=[0,tower_radius-carriage_hinge_offset],
	platform_xy=[platformxyz[0]*cos(angle)+platformxyz[1]*sin(angle),
	    platformxyz[1]*cos(angle)-platformxyz[0]*sin(angle)+
	    platform_hinge_offset])
    assign(rod_dist=carriage_xy-platform_xy)
    assign(dist=sqrt(rod_dist[0]*rod_dist[0]+rod_dist[1]*rod_dist[1]))
    assign(height=sqrt(rod_length*rod_length-dist*dist))
    assign(lean_y=90-acos(rod_dist[0]/rod_length), lean_x=-atan2(rod_dist[1],height))
    {
	rotate(angle) tower(height);

	translate(platformxyz)
	rotate(angle)
	translate([0,0,motor_end_total+bed_thickness+pcb_thickness+ platform_thickness/2])
	rod_pair(lean_y,lean_x);

        if (side_panels) %rotate(angle) translate([-(smooth_rod_side_separation - 20) / 2, rodpos(120,1)[1] - 11, 0]) {
            translate([0, 0, smooth_rod_length - idler_end_total]) cube([smooth_rod_side_separation - 20, 6, idler_end_total]);
            cube([smooth_rod_side_separation - 20, 6, motor_end_total]);
        }
    }

    translate(platformxyz + [0, 0, motor_end_total+bed_thickness+pcb_thickness]) 
    rotate([0, 0, 60]) 
    if (use_stls) import ("platform.stl"); else platform();

    // Lower bed
    % translate([0, 0, motor_end_total+bed_thickness/2])
    cylinder(r=(tower_radius-smooth_rod_radius)/cos(30), h=bed_thickness, center=true, $fn=6);
    // Roof
    % translate([0, 0, smooth_rod_length+bed_thickness/2])
    cylinder(r=(tower_radius-smooth_rod_radius)/cos(30), h=bed_thickness, center=true, $fn=6);

    // PCB
    color([0.9, 0, 0]) 
    translate([0, 0, motor_end_total+bed_thickness+pcb_thickness/2])
    cube([pcb_side, pcb_side, pcb_thickness], center=true);
    //cube([tower_radius*1.4, tower_radius*1.4, pcb_thickness], center=true);
}

rostock();