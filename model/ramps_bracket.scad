// RAMPS bracket for Deltatron by Mikrotron d.o.o.

// smoothing of curves
$fn = 50;

// extra dimension to remove ambiguity of walls
ex = 0.10;

// aluminium extrusion dimension
profile = 15;
profile_gap = 3.6; // frame groove width

// screw dimensions
screw_3x8_cap_dia = 6.2;
screw_3x8_cap_height = 3.2;

// bracket dimensions
wall = 3;

// ENTRY POINT

ramps_bracket();

module ramps_bracket(){
    translate([0, -profile, 0]) %frame();
    frame_mount();

}

module frame_mount(){
    // part of bracket used for mounting on frame
    // top part
    difference(){
        union(){
            cube([profile, profile, wall]);
            translate([0, profile/2, wall]) slider();
        }
        translate([profile/2, profile/2, -ex]) cylinder(d = screw_3x8_cap_dia/2, h = wall+2);
        translate([profile/2, profile/2, -ex]) cylinder(d = screw_3x8_cap_dia, h = wall/2);
    }
    // temp support
    difference(){
        translate([profile/2, profile/2, -ex]) cylinder(d = screw_3x8_cap_dia/2, h = wall/2);
        translate([profile/2, profile/2, -2*ex]) cylinder(d = screw_3x8_cap_dia/2.5, h = wall/2 + 2*ex);
    }
}

module slider(slider_length = profile){
    // part that slides in frame groove
    difference(){
        rotate([0,90,0]) cylinder(d = profile_gap - ex, h = slider_length);
        translate([-ex, -profile_gap/2 - 2*ex, -profile_gap/2 - 2*ex])
            cube([slider_length + 2*ex, profile_gap + 2*ex, profile_gap/2 + 2*ex]);
    }
}

module frame(profile_length = 200){
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