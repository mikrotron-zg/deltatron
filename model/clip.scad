$fn=100;
plate_thickness=1.5;
ex=0.1;

//clip();
hook();

module clip(x=10){
    difference(){
        union(){
            translate([0,plate_thickness/2,x/2]) cube([10,plate_thickness,x],center=true);
            //translate([-5, plate_thickness, 0]) hook(x);
            hull(){
                    translate([-0.8,0,0])cylinder(h=x,r=0.5);
                    translate([-2.6/2,-2,0])cylinder(h=x,r=0.6);
                }
                hull(){
                    translate([0.8,0,0])cylinder(h=x,r=0.5);
                    translate([2.6/2,-2,0])cylinder(h=x,r=0.6);
                } 
          } 
          translate([0,0.3,0])cylinder(h=x+1,r=0.6);
    }
}

module hook(x=10){
    union(){
        clip();
        translate([-5, plate_thickness, 0]) {
            r=5;
            s=2;
            cube([plate_thickness, s, x]);
            translate([r, s, 0]) difference(){
                cylinder(r=r, h=x);
                translate([-r, -r, -ex]) cube([2*r, r, x+2*ex]);
                translate([0, 0, -ex]) cylinder(r=r-plate_thickness, h=x+2*ex);
            }
        }
    }
}
