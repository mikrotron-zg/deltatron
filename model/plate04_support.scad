//Includes parts of Deltatron that are printed using supports.
//If you want to use auto-generated supports, turn off or exclude supports.

use <connector_plate.scad>;
use <ramps_bracket.scad>;

% translate([0, 0, -3]) cylinder(r=75, h=3);
union() {
    translate([-50, -40, 0]) ramps_bracket(); //support can be turned off in ramps_bracket.scad
    translate([-15, 0, 0]) rotate([0, 0, 0]) {
        drawPowerPart();
        power_supports(); // comment this out if you want to use auto-generated support
    }

}
