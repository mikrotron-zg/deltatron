// Bed bracket for Deltatron by Mikrotron d.o.o.

use <chamfers.scad>;

// smoothing of curves
$fn = 50;

// extra dimension to remove ambiguity of walls
ex = 0.10;

// include support
support = true;
support_wall = 0.3; // support wall thickness
support_gap = 0.3; // gap between support and model
support_brim = 5; // brim to fix thin support walls

// aluminium extrusion dimension
profile = 15;
profile_gap = 3.6; // frame groove width

// screw dimensions
screw_3x8_cap_dia = 6.4;
screw_3x8_cap_height = 3.2;

bed_dia = 170; //glass bed diameter

wall = 5;
bracket_width = 25;

// ENTRY POINT

bed_bracket();

module bed_bracket(){
    %frame();
    translate([bed_dia/2, -(bed_dia/2 + 2), profile]) %glass_bed();
    translate([bed_dia/2 - bracket_width, profile, 0]) draw_bracket();
    if (support) supports();
}

module draw_bracket(){
    
    
    bracket_length = 40; // will be cut off to fit to frame
    
    translate([0, 0, profile + wall]) rotate([180, 0, 0]) difference(){
            difference(){
            union(){
                rotate([0, 0, -30]) cube([bracket_width, bracket_length, wall]);

                translate([0, profile/2, wall]) slider();
            }

        }
        
        
        // screw hole
        translate([bracket_width/2, profile/2, -ex]) {
            cylinder(d = screw_3x8_cap_dia/2 + 0.5, h = wall+2);
            cylinder(d = screw_3x8_cap_dia + 0.5, h = wall/2 + ex);
        }
    }
    
}

module slider(slider_length = bracket_width - 2){
    // part that slides in frame groove
    difference(){
        rotate([0,90,0]) cylinder(d = profile_gap - ex, h = slider_length);
        translate([-ex, -profile_gap/2 - 2*ex, -profile_gap/2 - 2*ex])
            cube([slider_length + 2*ex, profile_gap + 2*ex, profile_gap/2 + 2*ex]);
    }
}


// SUPPORTS

module supports(){

}



// NON-PRINTED PARTS

module frame(profile_length = bed_dia){
    // draws basic aluminium extrusion frame
    difference(){
        cube([profile_length, profile, profile]);
        translate([-ex, profile/2 - profile_gap/2, profile - profile_gap])
            cube([profile_length + 2*ex, profile_gap, profile_gap + ex]);
        translate([-ex, profile - profile_gap, profile/2 - profile_gap/2])
            cube([profile_length + 2*ex, profile_gap + ex, profile_gap]);
        translate([-ex, -ex, profile/2 - profile_gap/2])
            cube([profile_length + 2*ex, profile_gap + ex, profile_gap]);
        translate([-ex, profile/2 - profile_gap/2, -ex])
            cube([profile_length + 2*ex, profile_gap, profile_gap + ex]);
    }
}

module glass_bed(){
    cylinder(d = bed_dia, h = 4, $fn = 200);
}

//UTILITY

//draws a rounded rectangle
module rounded_rect(x, y, z, radius = 1) {
    translate([radius,radius,0]) //move origin to outer limits
	linear_extrude(height=z)
		minkowski() {
			square([x-2*radius,y-2*radius]); //keep outer dimensions given by x and y
			circle(r = radius, $fn=100);
		}
}