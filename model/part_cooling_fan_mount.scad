// New part cooling fan mount, used in E3D Lite update of Deltatron

use <chamfers.scad>;

fan_dimension = 40; // for 40x40 mm fan
fan_height = 10; // most common, can be 7 or 12 mm
fan_mount_hole_dia = 3.4; // diameter of corner mount holes
fan_mount_hole_offset = 3.9; // distance from center of mounthole to fan edge
fan_diameter = 38.2; 


ex = 0.01; // auxiliary variable

//part_cooling_fan_mount();
fan(); // TODO: print fan and confirm

module part_cooling_fan_mount(){
    
}

module fan(){
    dr = sqrt(2*pow(fan_dimension/2, 2)) -sqrt(2*pow(fan_mount_hole_offset, 2));
    difference(){
        rounded_rect(fan_dimension, fan_dimension, fan_height, 3);
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