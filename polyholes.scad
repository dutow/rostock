//
// Mendel90
//
// GNU GPL v2
// nop.head@gmail.com
// hydraraptor.blogspot.com
//
// See http://hydraraptor.blogspot.com/2011/02/polyholes.html
//
function sides(r) = max(round(4 *r),3);
function corrected_radius(r,n) = 0.1 + r / cos(180 / n);
function corrected_diameter(d) = 0.2 + d / cos(180 / sides(d / 2));

module poly_circle(r, center = false) {
    n = sides(r);
    circle(r = corrected_radius(r,n), $fn = n, center = center);
}

module poly_cylinder(r, h, center = false) {
    n = sides(r);
    cylinder(h = h, r = corrected_radius(r,n), $fn = n, center = center);
}

module poly_d_cylinder(r, center = false) {
    n = sides(r);
    r = corrected_radius(r,n);
    cylinder(h = h, r = r, $fn = n, center = center);
    translate([0, -r, 0])
        cube([r, 2 * r, h]);
}

/**
 * Make a thin-walled cylindrical tube.
 * @param r outside radius
 * @param h height of tube
 * @param thickness wall thickness
 */
module poly_tube(r = 5, h = 5, thickness = 1, center = false) {
    translate(center ? [0, 0, -h / 2] : 0) linear_extrude(height = h) difference() {
        circle(r);
        poly_circle(r - thickness);
    }
}
