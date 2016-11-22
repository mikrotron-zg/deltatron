//Includes parts of Deltatron that are printed only once

include <configuration.scad>;

use <effector.scad>;
use <retractable.scad>;
use <fan_mount.scad>;
use <groove_mount.scad>;
use <ramps_fan_mount.scad>;
use <compact_direct_drive_extruder.scad>

% translate([0, 0, -3]) cylinder(r=75, h=3);
translate([0, 30, 0]) union() {
    translate([-30, 0, 4]) effector();
    translate([35, -30, 0]) rotate([0, 0, 90]) fan_mount();
    translate([20, 20, 0]) retractable();
    translate([-15, -80, 0]) groove_mount(); 
    translate([40, -30, 0]) ramps_fan_mount();
    translate([30, -60, 0]) rotate([0, 0, -90]) compact_extruder();
    translate([-35, -70, 0]) rotate([0, 0, 90]) idler_608_v2_splitted();
}
