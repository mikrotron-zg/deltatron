include <configuration.scad>;

use <microswitch.scad>;
use <effector.scad>;

height = 26;
height2 = 26;
tunnel = 2.4;
face_offset = 4;
extra_radius=0.1;

module foot() {
  difference() {
    translate([12.5, 0, 0]) rotate([0, 0, -60])
      translate([-12.5, 0, 1]) rotate([0, 0, -60]) union() {
        cylinder(r=5, h=2, center=true, $fn=24);
        translate([10, 0, 0])
          cube([20, 10, 2], center=true);
    }
//    translate([0, -10, 0])
//      cube([40, 20, 20], center=true);
    translate([13.5, 0, 0]) {
      // Space for bowden push fit connector.
      cylinder(r=6.49, h=3*height, center=true, $fn=32);
      for (a = [60:120:359]) {
	    rotate([0, 0, a]) translate([-12.5, 0, 0])
          cylinder(r=m3_wide_radius, h=20, center=true, $fn=12);
      }
    }
  }
}

module retractable() {
  difference() {
    union() {
      translate([0, 0, height/2])
        cylinder(r=6, h=height, center=true, $fn=32);
      translate([0, -3, height/2])
        cube([12, 6, height], center=true);
      // Lower part on the left.
      translate([-6, 0, height2/2])
        cube([12, 12, height], center=true);
        //cylinder(r=6, h=height2, center=true, $fn=32);
      translate([-3, 0, height2/2])
        cube([6, 12, height2], center=true);
      translate([-3, -3, height2/2])
        cube([18, 6, height2], center=true);
      translate([3, -3, height2/2])
        cube([17, 15, height2], center=true);
      // Feet for vertical M3 screw attachment.
      translate ([0, 6, 0]) rotate([0, 0, 90]) {
        foot();
        scale([1, -1, 1]) foot();
      }
      translate([-12, -5, 0])  
        cube([23.5,14,2]);
    }
    translate([-19, 0, height/2+6]) rotate([0, 15, 0])
      cube([20, 20, height], center=true);
    translate([18, 0, height/2+6]) rotate([0, -15, 0])
      cube([20, 20, height], center=true);
    cylinder(r=tunnel/2+extra_radius, h=3*height, center=true, $fn=12);
    translate([0, -6, height/2+12])
      cube([tunnel-0.5, 12, height], center=true);
    // Wider probe parking tray
    rotate([0, 0, 45]) translate([0, -6, height/2+22])
      cube([tunnel, 12, height], center=true);
    rotate([0, 0, 30]) translate([0, -6, height/2+22])
      cube([tunnel, 12, height], center=true);
    // Probe parking groove
    translate([0.5, 0.5, height/2+9]) rotate([0, 90, -45])
      cylinder(r=0.5, h=20, $fn=12);
    // Safety needle spring.
    translate([-4.5, 0, height-8.5]) rotate([90, 0, 0])
      cylinder(r=2.5/2, h=40, center=true, $fn=12);
    translate([-4, 0, height-2]) rotate([90, 0, 0])
      cylinder(r=1/2, h=40, center=true, $fn=12);
    // Third mount screw hole
    translate([0, 7, 0])
      cylinder(r=m3_wide_radius, h=20, center=true, $fn=12);
    // Effector screw heads.
//    rotate([0, 0, 330]) translate([-3.25, 7, 2])
//      color("Red") cylinder(r=4, h=30, $fn=24);
    // Flat back face
    translate([-12, 4, 2])
      cube([25, 5, height]);
    // Flat front face.
    translate([0, -face_offset-10, height/2]) difference() {
      cube([30, 20, 2*height], center=true);
    }
    // Sub-miniature micro switch.
    translate([-2.5, -face_offset-3, 5]) {
      % microswitch();
      for (x = [-9.5/2, 9.5/2]) {
        translate([x, 0, 0]) rotate([90, 0, 0])
          cylinder(r=2.5/2, h=40, center=true, $fn=12);
      }
    }
  }
}

translate([0, 14.5, -4]) % effector();
translate([0, -5, 0]) retractable();
