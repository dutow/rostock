include <configuration.scad>
use <polyholes.scad>
use <bearing.scad>
use <carriage.scad>

//$fa=1;
//$fs=2;

print=1;  // set to 1 to get print version

shaftDiameter = smooth_rod_radius * 2 + 0.1;  // diameter of shafts
shaftGap = 2;        // gap around shafts

washerM3 =  [3, 8, 0.75]; // M3 washer dimensions: ID, OD, W
boltM4 = [8, 4.3, 8.5];   // Head, bolt, nut
boltM3 = [6.5, 3.3, 6.5]; // Head, bolt, nut

bearing = bearing623;
washer =  washerM3;
bearingBolt = boltM3;
tensionBolt = boltM3;

bearingSpacing = 20; // vertical space between bearings
bearingClearanceOuter = outside_diameter(bearing) + 4; // Space around the outer diameter of the bearing
bearingClearanceWidth = width(bearing) + width(washer) * 2 + 0.25; // Space around the outer diameter of the bearing


module bearingMountHole() {
    headRad = bearingBolt[0]/2;
    boltRad = bearingBolt[1]/2;
    nutRad = bearingBolt[2]/2;
    render(convexity = 3) rotate([0,90,0]) {
        difference() {
            cylinder(r=bearingClearanceOuter / 2, h=bearingClearanceWidth, center=true);
            translate([0,0,-bearingClearanceWidth / 2 + width(washer)/2]) cylinder(r1=outside_diameter(washer)/2+width(washer), r2=outside_diameter(washer)/2, h=width(washer), center=true);
            translate([0,0, bearingClearanceWidth / 2 - width(washer)/2]) cylinder(r2=outside_diameter(washer)/2+width(washer), r1=outside_diameter(washer)/2, h=width(washer), center=true);
        }
        // Axle
        poly_cylinder(r=boltRad, h=20, center=true);
        // Room for nut / bolt head
        translate([0,0,-(4+width(bearing)/2+3.5)]) cylinder(r=nutRad, h=8, center=true, $fn=6);
        translate([0,0,(10+width(bearing)/2+3.5)]) cylinder(r=headRad, h=20, center=true);
    }
}

module tensionBoltHole() {
    headRad = tensionBolt[0]/2;
    boltRad = tensionBolt[1]/2;
    nutRad = tensionBolt[2]/2;
    rotate([0,90,0]) {
        cylinder(r=boltRad, h=40, center=true);
        translate([0,0,(10+width(bearing)/2+3.5)]) cylinder(r=nutRad, h=20, center=true, $fn=6);
        translate([0,0,-(10+width(bearing)/2+3.5)]) cylinder(r=headRad, h=20, center=true);
    }
}

module bearingAndBolt(angle, zoffset) {
    rotate([0,90,0]) {
        //color("grey") translate([0, 0, -(width(bearing)/2+width(washer)/2)]) bearing(washer);
        color("silver") bearing(bearing);
        //color("grey") translate([0, 0, width(bearing)/2+width(washer)/2]) bearing(washer);
        color("darkgrey") cylinder(r=inside_diameter(bearing)/2, h=20, center=true);
    }
}


module positionOnShaft(angle, zoffset, radius=(shaftDiameter+outside_diameter(bearing))/2) {
    rotate([0,0,angle]) translate([0,0,zoffset]) translate([0,-radius,0]) children(0);
}

module bearingPositions() {
    // gaps around bearings, "constrained" rod
    translate([-smooth_rod_separation/2,0,0]) {
        mirror([1, 0, 0]) positionOnShaft(angle=0, zoffset=0) children(0);
        for (t=[-1,1], u=[-1,1]) {
            positionOnShaft(angle=-120*t, zoffset=u*bearingSpacing) children(0);
        }
    }
    
    // gaps around bearings, "unconstrained" rod
    translate([smooth_rod_separation/2,0,0]) {
        for (t=[0,1]) {
            mirror([t,0,0]) positionOnShaft(angle=180*t, zoffset=-5) children(0);
        }
    }
}

module clampPositions() {
    // Hole for tension clamp bolt, "constrained" rod
    translate([-smooth_rod_separation/2,0,0]) {
        for (u=[-1,1]) positionOnShaft(angle=-60, zoffset=u*bearingSpacing/2, radius=(shaftDiameter+tensionBolt[1])/2+shaftGap) children(0);
    }
    
    // Hole for tension clamp bolt, "unconstrained" rod
    translate([smooth_rod_separation/2,0,0]) {
        mirror([0, 1, 0]) positionOnShaft(angle=90, zoffset=-bearingSpacing*3/4, radius=(shaftDiameter+tensionBolt[1])/2+shaftGap) children(0);
    }
}

module bearingsAndShafts() {
    for (u=[-1,1]) {
        translate([u*smooth_rod_separation/2,0,0]) {
            cylinder(r=shaftDiameter/2,h=200,center=true);
        }
    }
    bearingPositions() bearingAndBolt();
}

module bearingBulge() {
    difference() {
        for (u=[-1, 1]) translate([u*bearingClearanceWidth/5, 0, 0]) sphere(r=bearingClearanceOuter/2);
        rotate([0, 90, 0]) poly_tube(r=bearingClearanceOuter, h=bearingClearanceWidth, thickness=bearingClearanceOuter-outside_diameter(washer)/2-width(washer), center=true);
    }
}

module housing() {
    totalHeight=2*bearingSpacing+outside_diameter(bearing)+2;
    shortHeight=totalHeight/2+bearingClearanceOuter/2;
    translate([0, 0, totalHeight/2 - (ball_joints ? cup_offset : 0)]) 
    difference() {
        union() {
            // bearing holders around shaft
            translate([-smooth_rod_separation/2,0,-totalHeight/2]) 
                cylinder(r=(shaftDiameter+outside_diameter(bearing))/2+inside_diameter(bearing),h=totalHeight);
            translate([smooth_rod_separation/2,0,-totalHeight/2]) 
                cylinder(r=(shaftDiameter+outside_diameter(bearing))/2+inside_diameter(bearing),h=shortHeight);
            // connection between shafts
            translate([-smooth_rod_separation/2, -8, -totalHeight/2]) cube([smooth_rod_separation, 5, shortHeight]);

            // Protruberances around bearings
            bearingPositions() bearingBulge();

            // Rod attachments
            translate([0, -carriage_hinge_offset, -totalHeight/2+4])
            if (ball_joints) {
                ball_parallel_joints(smooth_rod_bearing[1]+1);
            } else {
                parallel_joints(smooth_rod_bearing[1]+1);
            }

            translate([0, 0, -totalHeight/4]) belt_mount(totalHeight/2);

        }
        union() {
            // Snip off the top and bottom due to the spherical bearing protruberances
            translate([0, 0, -(totalHeight+20)/2]) cube([100, 100, 20], center=true);
            translate([0, 0, (totalHeight+20)/2]) cube([100, 100, 20], center=true);
            
            // gaps around shafts
            for (u=[-1,1]) {
                translate([u*smooth_rod_separation/2,0,0]) {
                    cylinder(r=shaftDiameter/2+shaftGap,h=totalHeight+1,center=true);
                }
            }

            // Gap for clamping adjustment of bearings to rods
            translate([-smooth_rod_separation/2,0,0]) rotate([0,0,210]) translate([smooth_rod_separation/2,0,0]) cube([smooth_rod_separation,2,4*bearingSpacing], center=true);
            translate([smooth_rod_separation/2,0,0]) rotate([0,0,0]) translate([smooth_rod_separation/2,0,0]) cube([smooth_rod_separation,2,4*bearingSpacing], center=true);

            bearingPositions() bearingMountHole();

            clampPositions() tensionBoltHole();
        }
    }
}

module separator() {
  hull() {
    for (u=[-1,1]) {
      translate([u*smooth_rod_separation/2,0,0]) {
        for (v=[-bearingSpacing/2,2*bearingSpacing]) {
          translate([0,0,v]) sphere(r=0.25);
          translate([0,0,v]) rotate([0,0,-90+60*u]) translate([100,0,0]) sphere(r=0.25);
        }
      }
    }
  }
}

if (0) {
    //%bearingPositions() sphere(r=outside_diameter(bearing)/2 + width(bearing)/2);
    //bearingPositions() bearingAndBolt();
    //bearingMountHole();
    bearingBulge();
} else {
    if (print==1) {
        housing();
    } else {
        housing();
        % bearingsAndShafts();
    }
}


