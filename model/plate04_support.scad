//Includes parts of Deltatron that are printed using support generated by Slic3r

use <connector_plate.scad>;
use <ramps_bracket.scad>;

% translate([0, 0, -3]) cylinder(r=75, h=3);
union() {
    translate([-50, -40, 0]) ramps_bracket();
    translate([-15, 0, 0]) rotate([0, 0, 0]) drawPowerPart();

}
