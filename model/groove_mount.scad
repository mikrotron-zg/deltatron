// Overall mount dimensions
mount_radius = 18;
mount_thickness = 6;

// Through holes
hole_radius = 12.5;
m3_wide_radius=1.6;

// Slot and lip for installation
slot_radius = 6.25;
lip_radius = 8.1;
lip_thickness = 1.5;

$fn = 40;

module groove_mount(){
    translate([0, 0, mount_thickness/2])
    difference() {
      cylinder(r=mount_radius, h=mount_thickness, center=true);
    
      // Thru holes
      for (hole_angle = [0:60:360]) {
        translate([sin(hole_angle)*hole_radius,cos(hole_angle)*hole_radius,0]) cylinder(r=m3_wide_radius, h=mount_thickness, center=true);
      }
    
      // Thru slot
      cylinder(r=slot_radius, h=mount_thickness, center=true);
      translate([0, -mount_radius/2, 0]) cube([2*slot_radius, mount_radius, mount_thickness], center=true);
    
      // Lip 
      translate([0, 0, (mount_thickness-lip_thickness)/2]) cylinder(r=lip_radius, h=lip_thickness, center=true);
      translate([0, -mount_radius/2, (mount_thickness-lip_thickness)/2]) cube([2*lip_radius, mount_radius, lip_thickness], center=true);
    
      // Cut off the sharp edges at the front
      translate([0, -7/4*mount_radius, 0]) cube([2*mount_radius, 2*mount_radius, mount_thickness], center=true);
    };
}

groove_mount();