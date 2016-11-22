//Includes parts of Deltatron that are printed only once


use <connector_plate.scad>;
use <clip.scad>;

% translate([0, 0, -3]) cylinder(r=75, h=3);
union() {
    //translate([35, -30, 0]) rotate([0, 0, 90]) fan_mount();
    translate([-50, -25, 0]) drawUSBpart();
    for (x = [-30:15:30])
        for (y = [30:10:50])
           translate([x, y, 0]) clip();
    for (x = [-15:15:15])
        translate([x, -40, 0]) hook();
}
