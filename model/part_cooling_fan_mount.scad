// New part cooling fan mount, used in E3D Lite update of Deltatron

use <chamfers.scad>;

fan_dimension = 40; // for 40x40 mm fan
fan_height = 7; // most common, can be 7 or 12 mm
fan_mount_hole_dia = 3.6; // diameter of corner mount holes
fan_mount_hole_offset = 3.9; // distance from center of mounthole to fan edge
fan_diameter = 38.2; 

rounding_radius = 3; // corner rounding radius
base_mount_height = 10; // fan mount base height
base_chamber_height = base_mount_height - 2; 

fan_duct_wall = 1;
fan_duct_width = fan_dimension/3;
fan_duct_height = base_chamber_height/2;

arm_width = 8;
arm_length = 30; // how long is horizontal part of arm (when mounted) WAS 33
arm_height = 12; // how long is vertical part of arm (when mounted)
arm_thickness = 6;
arm_mount_hole_dia = 6.2; // M3 bolt head diameter
arm_mount_hole_height = 3.2; // M3 bolt hole height

dr = sqrt(2*pow(fan_dimension/2, 2)) -sqrt(2*pow(fan_mount_hole_offset, 2)); // delta radius for corner mounting holes
ex = 0.01; // auxiliary variable

part_cooling_fan_mount();
translate([0, 0, base_mount_height]) %fan();

module part_cooling_fan_mount(){
    //rotate([180,0,0]) translate([0, -fan_dimension, -base_mount_height])
    //difference(){
//        base_mount();
//        translate([-ex, fan_dimension/2, 0]) cube([15, fan_dimension/2, base_mount_height], center=true);
//    }
    //fan_duct();
    base_mount2();
    translate([fan_dimension, fan_dimension/2 - arm_width/2, 0]) arm();
}

module base_mount(){
     difference(){
        rounded_rect(fan_dimension, fan_dimension, base_mount_height, rounding_radius);
        // centered parts
        translate([fan_dimension/2, fan_dimension/2, -ex]){
            for (i = [45 : 90 : 315]) {
                translate([dr*sin(i), dr*cos(i), 0]){
                    // add M3 mount hole
                    cylinder(d = fan_mount_hole_dia, h = base_mount_height + 2*ex, $fn=30);
                    // add M3 nut trap
                    translate([0, 0, base_mount_height - 2])
                        cylinder(r=5.5 / 2 / cos(180 / 6) + 0.05, h=2 + 2*ex, $fn=6);
                }
            }
            cylinder(d = fan_diameter, h = base_chamber_height, $fn = 100);
        } // end of centered parts
        
     } //difference
     translate([fan_dimension/2, fan_dimension/2, -ex])
        cylinder_chamfer(fan_diameter/2,base_chamber_height,rs=20);
}

module base_mount2(){
    rot_ang=-15; //rotation angle of fan
    difference(){
        translate([fan_dimension*3/4,0,0]) 
            rounded_rect(fan_dimension/4, fan_dimension, arm_thickness, rounding_radius);
        translate([fan_dimension/2, fan_dimension/2, -ex]){
            for (i = [45 : 90 : 315]) {
                translate([dr*sin(i), dr*cos(i), -0.5]){
                    // add M3 mount hole
                    rotate([0,rot_ang,0])
                    cylinder(d = fan_mount_hole_dia, h = base_mount_height + 1, $fn=30);
                    // add M3 nut trap
                    translate([0,0,-0.5])
                        rotate([0,rot_ang,0])
                        cylinder(r=5.5 / 2 / cos(180 / 6) + 0.05, h=2.5 + 2*ex, $fn=6);
                }
            }
            cylinder(d = fan_diameter, h = base_chamber_height, $fn = 100);
        }
        translate([fan_dimension*3/4,0,arm_thickness-3])
            rotate([0,rot_ang,0])
            cube([fan_dimension/4+1, fan_dimension, arm_thickness]);
    }//difference
}

module fan_duct(){
    add = 3.5; //added vertical dimension
    translate([-10-add, fan_dimension/4, 0])
        cube([10+add, fan_dimension/2, base_mount_height/2]);
    translate([-5-add, 3/4*fan_dimension, base_mount_height]) rotate([90, 180, 0])   
        chamfer(fan_dimension/2, base_mount_height/2,rs=10);
    translate([-10-add, fan_dimension/4 - 1, 0]) cube([10+add, 1, base_mount_height+fan_height/2]);
    translate([-10-add, 3*fan_dimension/4, 0]) cube([10+add, 1, base_mount_height+fan_height/2]);
    translate([-11-add, fan_dimension/4 - 1, 0]) cube([1, fan_dimension/2 + 2, base_mount_height+fan_height/2]);
    translate([-5-add, fan_dimension/4-1, base_mount_height+fan_height/2-1])
        cube([5+add, fan_dimension/2+2, 1]);
}

module fan(){
    difference(){
        rounded_rect(fan_dimension, fan_dimension, fan_height, rounding_radius);
        translate([fan_dimension/2, fan_dimension/2, -ex]){
            cylinder(d = fan_diameter, h = fan_height + 2*ex, $fn=60);
               for (i = [45 : 90 : 315]) {
                translate([dr*sin(i), dr*cos(i), 0])
                    cylinder(d = fan_mount_hole_dia, h = fan_height + 2*ex, $fn=30);
                   }
        }
    }
}

module arm(){
    // vertical part of arm
    cube([arm_height, arm_width, arm_thickness]); 
    rotate([0, 0, 90]) translate([-arm_width, -arm_width, 0])
        chamfer(arm_thickness, arm_width, rs=20);
    rotate([0, 0, 180]) translate([-arm_width, -2*arm_width, 0])
        chamfer(arm_thickness, arm_width, rs=20);
    // horizontal part of arm
    translate([arm_height, 0, 0]) difference(){
        cube([arm_thickness, arm_width, arm_length]);
        translate([-ex, arm_width/2, arm_length - arm_mount_hole_dia/2 - 2])
            rotate([0, 90, 0]) cylinder(d=fan_mount_hole_dia, h=arm_thickness + 2*ex, $fn=20);
        translate([arm_thickness - arm_mount_hole_height, arm_width/2, arm_length - arm_mount_hole_dia/2 - 2])
            rotate([0, 90, 0]) cylinder(d=arm_mount_hole_dia, h=arm_mount_hole_height + ex, $fn=20);
    }
    translate([arm_height - arm_thickness, arm_width, 2*arm_thickness]) rotate([90, 90, 0])
        chamfer(arm_width, arm_thickness, rs=20);
}

//UTILITY

//draws a rounded rectangle
module rounded_rect(x, y, z, radius) {
    translate([radius,radius,0]) //move origin to outer limits
	linear_extrude(height=z)
		minkowski() {
			square([x-2*radius,y-2*radius]); //keep outer dimensions given by x and y
			circle(r = radius, $fn=100);
		}
}
