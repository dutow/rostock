steel = [0.8, 0.8, 0.9];


// Bearing dimensions are [ID, OD, W]
function inside_diameter(size) = size[0];
function outside_diameter(size) = size[1];
function width(size) = size[2];


module bearing(dims) {
    id = dims[0];
    od = dims[1];
    translate([0,0,width(dims)/2])
    color(steel) 
    render()
    difference() {
	cylinder(h=width(dims), r=outside_diameter(dims)/2, center=true);
	cylinder(h=width(dims)*2, r=inside_diameter(dims)/2, center=true);
    }
}


bearing([8, 22, 7]); // 608 skateboard ball bearing.

translate([30, 0, 0]) 
bearing([8, 15, 25]);  // Linear bearing for 8mm smooth rod.
