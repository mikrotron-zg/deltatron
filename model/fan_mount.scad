// Increase this if your slicer or printer make holes too tight.
extra_radius = 0.1;

// Input parameters
mount_thickness = 3;                             // Overall thickness (mm)
mount_angle = 60;      //was 45                          // Angle to mount the fan at (degrees)
hole_radius = 12.5;                              // Radius at which the effector mount holes are made (mm)
effector_offset = 15;    //was 25                        // Length of the side that offsets the fan from the effector (mm)
fan_radius = 20;                                 // overall fan radius, e.g. 40mm fan = 20 (mm)
fan_hole_pitch = 32;                             // pitch of the fan mounting holes (mm)
hole_offset = 2;                                 // space between thru holes and edges (mm)
hotend_radius = 8 + 0.25;                        // Radius of the hotend + buffer (mm)

// Major diameter of metric 3mm thread.
m3_major = 2.85;
m3_radius = m3_major/2 + extra_radius;
m3_wide_radius = m3_major/2 + extra_radius + 0.2;

// Calculated parameters
bracket_length = 2*(hole_offset+m3_wide_radius);                // Length of the angled portion (mm)
bracket_width = fan_hole_pitch+2*(hole_offset+m3_wide_radius);  // Overall bracket width (mm)

$fn = 40;

module fan_mount(){
    //rotate(a=90, v=[0,1,0]) // print on its side for a strong angle joint
    difference() {
      union() {
        translate([0, hotend_radius+effector_offset, 0])
        rotate(a=mount_angle, v=[1,0,0])
          difference() {
            cube([bracket_width, bracket_length, mount_thickness]);
            translate([bracket_width/2, fan_radius+hole_offset, 0])
              cylinder(r=fan_radius, h=mount_thickness);
    
            // Fan mounting holes
            translate([m3_wide_radius+hole_offset, m3_wide_radius+hole_offset, 0])
              cylinder(r=m3_wide_radius, h=mount_thickness);
            translate([bracket_width-m3_wide_radius-hole_offset, m3_wide_radius+hole_offset, 0])
              cylinder(r=m3_wide_radius, h=mount_thickness);
        }
    
        // Effector mounting side
        translate([0, hotend_radius/2, 0])
            difference(){
                cube([bracket_width, effector_offset+hotend_radius/2, mount_thickness]);
                translate([0, effector_offset+hotend_radius/2-1.2, mount_thickness/2]) 
                    cube ([bracket_width, 2, mount_thickness]);
            }
      }
    
      // Thru holes
      for (hole_angle = [-30:60:30]) {
        translate([bracket_width/2, 0, 0])
          translate([sin(hole_angle)*hole_radius,cos(hole_angle)*hole_radius,0])
          cylinder(r=m3_wide_radius, h=mount_thickness);
      }
    
      // Thru hole for hotend
      translate([bracket_width/2, 0, 0])
          cylinder(r=hotend_radius, h=mount_thickness);
    };
}

fan_mount();