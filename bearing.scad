steel = [0.8, 0.8, 0.9];


module bearing(dims) {
    id = dims[0];
    od = dims[1];
    w = dims[2];
    translate([0,0,w/2])
    color(steel) 
    render()
    rotate([0, 0, 0]) difference() {
		cylinder(h=w, r=od/2, center=true);
		cylinder(h=w*2, r=id/2, center=true);
    }
}

// Bearing dimensions are [ID, OD, W]
bearing608 = [8, 22, 7];  // 608 skateboard ball bearing.
bearinglm8uu = [8, 15, 25]; // Linear bearing for 8mm smooth rod.

bearing(bearing608);
translate([30, 0, 0]) bearing(bearinglm8uu);
