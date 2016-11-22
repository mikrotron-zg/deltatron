//RAMPS fan mount for 1515 Mini Kossel

//smoothing of curves
$fn=50;

//extra dimension to remove ambiguity of walls
ex=0.10;

//aluminium extrusion dimension
profile=15;

//fan dimensions
fan=40;
fanWidth=10.5; 
fanScrewPosition=16;

//dimensions
thickness=4;
edgeWidth=2;
screwDiameter=3.1;
screwHeadDiameter=5.5; 
screwHeadHeight=3; 
nutHeight=2.25+ex;
clampWidth=7.5;
width=screwHeadDiameter + 2*edgeWidth;
shorten=4;
length=3*profile-shorten;

//ENTRY POINT
ramps_fan_mount();

module ramps_fan_mount(){
    translate([thickness, 0, width+clampWidth]) rotate([0,180,0]){
    //profileMount();
    fanBracket();
    }
    
}

module profileMount(){
    
    difference(){
        cube([profile+fanWidth, thickness, width]);
        translate([profile/2, -ex, width/2]) rotate([-90,0,0])
            union(){
                cylinder(d=screwHeadDiameter+2*ex, h=screwHeadHeight+2*ex);
                cylinder(d=screwDiameter, h=thickness+2*ex);
            }
    }
}

module fanBracket(){
    difference(){
        union(){
            cube([thickness, length, width+clampWidth]);
            translate([-fanWidth, profile, width]) 
                cube([fanWidth, profile, clampWidth]);
            translate([-fanWidth, profile, width]) rotate([0, -90, 0])
                clampClip();
            translate([-fanWidth, 2*profile, width+clampWidth]) rotate([0, 90, 180])
                clampClip();
        }
        translate([-ex, length/2-fanScrewPosition, width/2]) rotate([0,90,0])
            nutTrap();
        translate([-ex, length/2+fanScrewPosition, width/2]) rotate([0,90,0])
            nutTrap();
        translate([-ex, length/2, width-edgeWidth-fan/2]) rotate([0,90,0])
            cylinder(d=fan, h=thickness+2*ex);
    }
}

module nutTrap(){
    union(){
        cylinder(d=screwDiameter, h=thickness+2*ex);
        translate([0,0, thickness-nutHeight])  M3nut(nutHeight+2*ex);
    }
}

module M3nut(nh=nutHeight){
    cylinder(r = 5.5 / 2 / cos(180 / 6) + 2*ex, h=nh, $fn=6);
}

module clampClip(clipWidth=3, clipHeight=0.35){
    cube([clampWidth, clampWidth-2*clipHeight, 2/3*profile]);
    //new clip design
    difference(){
        translate ([0, (clampWidth - 2*clipHeight)/2,1/2*profile]) 
            rotate([0, 90,0]) cylinder(h=clampWidth, d=clampWidth + clipHeight);
        translate ([0-ex, 0, 0]) cube([clampWidth+2*ex, clampWidth, profile]);
    }
}
