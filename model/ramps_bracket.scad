// RAMPS bracket for Deltatron by Mikrotron d.o.o.

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
//screw_3x8_cap_height = 3.2;
screw_2_5_dia = 2.5;

// bracket dimensions
wall = 3;
wall_strong = 4;
bracket_low_height = 12;
bracket_bottom_indent = 4;
bracket_length = 101;
bracket_left_offset = 5;
bracket_left_indent_width = 1.4;
bracket_right_indent_width = 1.6;
bracket_right_indent_length = 85;
bracket_back_wall = 2.5;
ramps_bed_height = 15;
mega_width = 53.6; //MEGA board width = 53.0
frame_mount_span = bracket_left_offset + wall_strong + mega_width -     
                bracket_left_indent_width;


// ENTRY POINT

ramps_bracket();

module ramps_bracket(){
    translate([-10, -profile, 0]) %frame();
    union(){
        frame_mount();
        translate([frame_mount_span + profile, 0, 0]) frame_mount();
        translate([profile, 0, 0]) bracket_body();
    }
    if (support) color("Gray") supports();
}

module bracket_body(){
    color("Blue") bracket_front();
    translate([bracket_left_offset, wall_strong, 0]) color("Green") bracket_left();
    translate([bracket_left_offset + wall_strong - bracket_left_indent_width, 
                wall_strong + bracket_length - bracket_back_wall, 0]) 
                    color("Cyan") bracket_back();
    translate([frame_mount_span, wall_strong, 0]) 
                    color("Purple") bracket_right();
}

module bracket_right(){
    indent_length = bracket_right_indent_length;
    indent_width = bracket_right_indent_width;
    screw_mount_width = 5.5;
    screw_mount_length = 4;

    cube([wall_strong, bracket_length, ramps_bed_height + 1.5]);
    translate([-indent_width, 0, bracket_bottom_indent])
        cube([indent_width, indent_length, ramps_bed_height - bracket_bottom_indent]);
    translate([-screw_mount_width, indent_length - screw_mount_length, 
            bracket_bottom_indent]) difference(){
                rounded_rect(screw_mount_width, screw_mount_length, ramps_bed_height -
                        bracket_bottom_indent);
                translate([2.5, 1.9, -ex]) 
                    cylinder(d = screw_2_5_dia, 
                            h = ramps_bed_height - bracket_bottom_indent +2*ex);
            }
    //reinforcement triangle
    difference(){
       cube([profile, profile, wall]);
       translate([profile, 0, -ex]) rotate([0, 0, 45]) 
            cube([profile*2, profile*2, wall + 2*ex]);
    } 
}

module bracket_back(){
    cube([mega_width, bracket_back_wall, bracket_bottom_indent]);
}

module bracket_left(){
    high_part_length = 7;
    indent_width = bracket_left_indent_width;
    
    difference(){
        cube([wall_strong, bracket_length, ramps_bed_height]);
        translate([-ex, -ex, bracket_low_height])
            cube([wall_strong + 2*ex, bracket_length - high_part_length + ex, 
                    ramps_bed_height - bracket_low_height +ex]);
        translate([wall_strong - indent_width, 0, -ex]) 
            cube([indent_width + ex, bracket_length + ex, bracket_bottom_indent + ex]);
    }
    //reinforcement triangle
    translate([-profile -bracket_left_offset, 0, 0]) difference(){
       cube([profile + bracket_left_offset, profile + bracket_left_offset, wall]);
       translate([0, 0, -ex]) 
        rotate([0, 0, 45]) cube([profile*2, profile*2, wall + 2*ex]);
    } 
}

module bracket_front(){
    high_part_length = 13;
    screw_mount_width = 5;
    
    difference(){
        union(){
            cube([high_part_length, wall_strong, bracket_low_height]);
            translate([high_part_length - screw_mount_width, 0, 0])
                cube([screw_mount_width, wall_strong, ramps_bed_height]);
            translate([high_part_length, 0, 0]) 
                cube([frame_mount_span - high_part_length, wall_strong, profile/2 + profile_gap/2]);
            translate([0, 0, profile/2]) rotate([90, 0, 0]) 
                slider(frame_mount_span);
            translate([8, 0, bracket_bottom_indent]) difference(){
                rounded_rect(screw_mount_width, wall_strong + screw_mount_width,
                            ramps_bed_height - bracket_bottom_indent);
                translate([2.6, wall_strong + 2.4, -ex]) 
                    cylinder(d = screw_2_5_dia + ex, h = ramps_bed_height - bracket_bottom_indent + 2*ex);
            }
        }
        translate([11.8, wall_strong - 2.4 , -ex]) 
            cube([34.6, 2.4 + ex, bracket_bottom_indent + ex]);
        translate([11.5, wall_strong, -ex]) rotate([0, 0, -80]) 
            cylinder($fn = 3, r = 2.4, h = bracket_bottom_indent + ex);
        translate([12.2 + 34.6, wall_strong, -ex]) rotate([0, 0, -100]) 
            cylinder($fn = 3, r = 2.4, h = bracket_bottom_indent + ex);
    }
    translate([-profile, wall, 0]) 
        cube([profile, wall, profile + wall]);
    translate([frame_mount_span, wall, 0]) 
        cube([profile, wall, profile + wall]);
}

module frame_mount(){
    // part of bracket used for mounting on frame
    // top part
    translate([0, 0, profile + wall]) rotate([180, 0, 0]) difference(){
        union(){
            cube([profile, profile, wall]);
            translate([0, profile/2, wall]) slider();
        }
        translate([profile/2, profile/2, -ex]) cylinder(d = screw_3x8_cap_dia/2 + 0.5, h = wall+2);
    }
    translate([0, wall, 0]) rotate([90, 0, 0]) union(){
            cube([profile, profile, wall]);
            translate([0, profile/2, wall]) slider();
   }
   translate([0, 0, profile]) cube([profile, wall, wall]);
}

module slider(slider_length = profile){
    // part that slides in frame groove
    difference(){
        rotate([0,90,0]) cylinder(d = profile_gap - ex, h = slider_length);
        translate([-ex, -profile_gap/2 - 2*ex, -profile_gap/2 - 2*ex])
            cube([slider_length + 2*ex, profile_gap + 2*ex, profile_gap/2 + 2*ex]);
    }
}

// SUPPORTS

module supports(){
    bracket_front_support();
    frame_mount_support();
    translate([frame_mount_span + profile, 0, 0]) frame_mount_support();
    translate([profile + bracket_left_offset + wall_strong - 3*support_wall, 
                wall_strong + support_gap, 0]) bracket_left_support();
    translate([bracket_left_offset + wall_strong + frame_mount_span , wall_strong + support_gap, 0]) bracket_right_support();
}

module bracket_right_support(){
    cube([support_brim, bracket_right_indent_length, support_wall]);
    translate([support_brim - 3*support_wall, 0, 0])
        cube([support_wall, bracket_right_indent_length, 
                bracket_bottom_indent - support_gap]);
    translate([support_brim - support_wall, 0, 0])
        cube([support_wall, bracket_right_indent_length, 
                bracket_bottom_indent - support_gap]);
    translate([2*support_wall, bracket_right_indent_length - 4, 0]){
        for (i = [0 : 3*support_wall : 3])
            translate([i, 0, 0]) 
                cube([support_wall, 4, bracket_bottom_indent - support_gap]);
    }
}

module bracket_left_support(){
    cube([support_brim, bracket_length - bracket_back_wall - 2*support_gap, 
        support_wall]);
    cube([support_wall, bracket_length - bracket_back_wall - 2*support_gap, 
        bracket_bottom_indent - support_gap]);
    translate([2*support_wall, 0, 0])
        cube([support_wall, bracket_length - bracket_back_wall - 2*support_gap, 
            bracket_bottom_indent - support_gap]);
}

module bracket_front_support(){
    front_support_length = 33.6;
    
    translate([profile + 13 - support_wall, wall_strong - support_wall + support_gap, 0]) {
        translate([0, -2, 0]) {
            cube([front_support_length, support_brim, support_wall]);
            for (i = [0 : (front_support_length - support_wall)/10 : front_support_length]) {
                translate([i, 0, 0]) 
                    cube([support_wall, 2, bracket_bottom_indent - support_gap]);
            }
        }
        translate([0, -support_gap, 0])
            cube([front_support_length, support_wall, bracket_bottom_indent - support_gap]);
        cube([support_wall, support_brim, bracket_bottom_indent - support_gap]);
    }
    translate([profile + 8, wall_strong + support_wall, 0]) {
        cube([support_brim, support_brim - 2*support_wall, support_wall]);
        translate([0, support_brim - 2*support_wall, 0])
            cube([support_brim, support_wall, bracket_bottom_indent - support_gap]);
        translate([2.6, 2.1, 0])
            difference(){
                cylinder(d = screw_2_5_dia + 2*support_wall, 
                        h = bracket_bottom_indent - support_gap);
                cylinder(d = screw_2_5_dia, h = bracket_bottom_indent);
            }
    }
}

module frame_mount_support(){
    // support for frame mount part of the model
    translate([0, -profile, 0]) cube([profile, profile - support_gap, support_wall]);
    translate([0, -profile/2 - support_wall/2, 0]) 
        cube([profile, support_wall, profile - profile_gap/2 - support_gap]);
    translate([0, -profile, 0]) 
        cube([profile, support_wall, profile - support_gap]);
    for (i = [0 : (profile - support_wall)/4 : profile - support_wall]) {
        translate([i, -profile, 0]) 
            cube([support_wall, profile - profile_gap/2, profile - support_gap]);
    }
}


// NON-PRINTED PARTS

module frame(profile_length = 120){
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