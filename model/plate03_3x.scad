//Includes parts of Deltatron that are printed three times

//include <configuration.scad>;

use <frame_motor.scad>;
use <frame_top.scad>;
use <carriage.scad>;
use <vertical_carriage_base.scad>
use <endstop.scad>;


% translate([0, 0, -3]) cylinder(r=75, h=3);
union() {
  translate([-15, -50, 22.5]) frame_motor();
  translate([15, 55, 7.5]) rotate([0, 0, 180]) frame_top();
  translate([-40, 30, 0]) rotate([0, 0, -30]) carriage();
//  translate([0, 0, 7.5]) endstop();
  translate([-15, -25, 0]) endstop();
  translate([30, -38, 0]) rotate([0, 0, -35]) vertical_carriage_base();
}
