// New part cooling fan mount, used in E3D Lite update of Deltatron

use <chamfers.scad>;

fan_dimension = 40; // for 40x40 mm fan
fan_height = 10; // most common, can be 7 or 12 mm
fan_mount_hole_dia = 3.4; // diameter of corner mount holes
fan_mount_hole_offset = 3.9; // distance from center of mounthole to fan edge
fan_diameter = 38.2; 

rounding_radius = 3; // corner rounding radius
base_mount_height = 10; // fan mount base height
base_chamber_height = base_mount_height - 2; 

fan_duct_wall = 1;
fan_duct_width = fan_dimension/3;
fan_duct_height = base_chamber_height/2;

dr = sqrt(2*pow(fan_dimension/2, 2)) -sqrt(2*pow(fan_mount_hole_offset, 2)); // delta radius for corner mounting holes
ex = 0.01; // auxiliary variable

part_cooling_fan_mount();
translate([0, 0, base_mount_height]) %fan();

module part_cooling_fan_mount(){
    rotate([180,0,0]) translate([0, -fan_dimension, -base_mount_height])
    difference(){
        base_mount();
        translate([-ex, fan_dimension/2, 0]) cube([15, fan_dimension/2, base_mount_height], center=true);
//        fan_duct_intake();
    }
    fan_duct_2();
//    translate([0, fan_dimension/2 - fan_duct_width/2, base_chamber_height]) fan_duct();
    
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

module fan_duct_intake(){
    translate([-ex, fan_dimension/2, base_chamber_height/2])
        cube([fan_dimension/4, fan_duct_width - 2*fan_duct_wall, fan_duct_height - 2*fan_duct_wall], center=true);
}

module fan_duct(){
    difference() {
        rotate([0, 180, 0]) difference() {
            qcylinder(3/4*base_chamber_height, fan_duct_width);
            translate([0, -ex, -ex])
            qcylinder(3/4*base_chamber_height - fan_duct_height, fan_duct_width + 2*ex);
        }
        translate([0, fan_duct_wall, ex]) rotate([0, 180, 0]) difference() {
            qcylinder(3/4*base_chamber_height - fan_duct_wall, fan_duct_width - 2* fan_duct_wall);
            translate([0, -ex, 0])
            qcylinder(3/4*base_chamber_height - fan_duct_height + fan_duct_wall, fan_duct_width + 2*ex);
        }
    }
    translate([-3/4*base_chamber_height, 0, 0]) difference(){
        cube([fan_duct_height, fan_duct_width, 2]);
        translate([fan_duct_wall, fan_duct_wall, -ex]) 
            cube([fan_duct_height - 2*fan_duct_wall, fan_duct_width - 2*fan_duct_wall, 2 + 2*ex]);
    }
}

module fan_duct_2(){
    translate([-5, fan_dimension/2, base_mount_height/4])
        cube([10, fan_dimension/2, base_mount_height/2], center=true);
    translate([-5, 3/4*fan_dimension, base_mount_height]) rotate([90, 180, 0])   
        chamfer(fan_dimension/2, base_mount_height/2,rs=10);
    translate([-10, fan_dimension/4 - 1, 0]) cube([10, 1, base_mount_height]);
    translate([-10, 3*fan_dimension/4, 0]) cube([10, 1, base_mount_height]);
    translate([-11, fan_dimension/4 - 1, 0]) cube([1, fan_dimension/2 + 2, base_mount_height]);
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

//draws 3-sided rectangular prism
module prism(l, w, h){
       polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );
}

//draws quarter of cylinder
module qcylinder(r_cyl = 3, l_cyl = 20){
    rotate([90, 0, 0]) translate([0, 0, -l_cyl])
    difference(){
        cylinder(r = r_cyl, h = l_cyl, $fn = 100);
        translate([-r_cyl, -r_cyl, -ex]) cube([r_cyl, 2*r_cyl, l_cyl + 2*ex]);
        translate([-ex, -r_cyl, -ex]) cube([r_cyl + 2*ex, r_cyl, l_cyl + 2*ex]);
    }
}