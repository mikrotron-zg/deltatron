//Connector plate for Kossel Mini 1515

//smoothing of curves
$fn=50;

//extra dimension to remove ambiguity of walls
ex=0.10;

//aluminium extrusion dimension
profile=15;

//mounting
edgeWidth=2;
screwDiameter=3.1;
screwHeadDiameter=5.5; 
screwHeadHeight=3; 
mountWidth=screwHeadDiameter+edgeWidth;
mountThickness=screwHeadHeight+1.5;

//USB B connector dimensions
usbWidth=12+2*ex;
usbHeight=11+2*ex;
usbScrewsDistance=30;
usbFullWidth=38;

//power connector dimensions
powerHeight=9;
powerWidth=10.5;
powerRadius=4.5;

//switch dimensions
switchInnerLength=20;
switchInnerWidth=12.7;
switchOuterLength=21;
switchOuterWidth=15;

//plate dimensions
overlap=5;
height=3*profile;
roundingRadius=4;
widthUSBpart=usbFullWidth+switchOuterLength+3.5*overlap+2*mountWidth+roundingRadius+3;
widthPowerPart=powerWidth+overlap+1.5*mountWidth+roundingRadius;
thickness=2;

//support settings
support = true; // include support
support_wall = 0.3; // support wall thickness
support_gap = 0.3; // gap between support and model
support_brim = 5; // brim to fix thin support walls

// ENTRY POINT

draw();

module draw(){
    drawUSBpart();
    translate([widthUSBpart*1.25, 0, 0]){
        drawPowerPart();
        if (support) power_supports();
    }
    %translate([0, 0, thickness]) cube([200, 15, 15]);
    %translate([0, 30, thickness]) cube([200, 15, 15]);
//      clamp();
//    switch();
}

module drawUSBpart(){
    transx=switchOuterLength+2*overlap;
    difference(){
        union(){
            rounded_rect(widthUSBpart, height, thickness, roundingRadius);
            translate([widthUSBpart-overlap, 0, 0])
                cube([overlap, height, thickness]);
            translate([roundingRadius+mountWidth, 2*profile, thickness])
                rotate([0,0,180]) clampClip();
            translate([roundingRadius, profile, thickness])
                clampClip();
            translate([widthUSBpart-mountWidth-overlap-3, profile, thickness])
                clampClip();
            translate([widthUSBpart-overlap-3, 2*profile, thickness])
                rotate([0,0,180]) clampClip();
//            translate([roundingRadius, 2*profile-mountThickness, thickness])
//                mount();
//            translate([widthUSBpart-overlap-3, profile+mountThickness, thickness]) 
//                rotate([0,0,180]) mount();
        }
        //USB cutout
        translate([transx+mountWidth+roundingRadius+usbFullWidth/2, height/2, -ex])
            USBcutout();
        //switch cutout
        translate([mountWidth/2+roundingRadius+usbFullWidth/2, height/2, -ex])
            switchCutout();
        //overlap
        translate([widthUSBpart-overlap, -ex, thickness/2-ex])
            cube([overlap+ex, height+2*ex, thickness/2+2*ex]);
        translate([widthUSBpart-overlap, height/2-powerHeight/2, -ex])
            cube([overlap+ex, powerHeight, thickness]);
    }
}

module USBcutout(){
    translate([-usbWidth/2, -usbHeight/2, 0])
            cube([usbWidth, usbHeight, thickness+2*ex]);
        translate([-usbScrewsDistance/2, 0, 0])
            cylinder(d=screwDiameter, h=thickness+2*ex);
        translate([usbScrewsDistance/2, 0, 0])
            cylinder(d=screwDiameter, h=thickness+2*ex);
}

module switchCutout(){
        translate([-switchInnerLength/2, -switchInnerWidth/2, 0]) cube([switchInnerLength, switchInnerWidth, thickness*2]);
        translate([-switchOuterLength/2, -switchOuterWidth/2, 0]) cube([switchOuterLength, switchOuterWidth, 1/3*thickness+ex]); 
}

module drawPowerPart(){
    difference(){
        union(){
            rounded_rect(widthPowerPart, height, thickness, roundingRadius);
            cube([overlap, height, thickness]);
            translate([widthPowerPart-roundingRadius-mountWidth, profile, thickness])
                    clampClip();
            translate([widthPowerPart-roundingRadius, 2*profile, thickness])
                rotate([0,0,180]) clampClip();
//            translate([widthPowerPart-roundingRadius-mountWidth, 2*profile-mountThickness, thickness])
//                mount(); 
        }
        translate([-ex, -ex, -ex])
            cube([overlap+ex, height+2*ex, thickness/2+ex]);
        translate([-ex, height/2-powerHeight/2, -ex])
            cube([powerWidth-powerRadius+ex, powerHeight, thickness+2*ex]);
        translate([powerWidth-powerRadius, height/2, -ex])
            cylinder(r=powerRadius, h=thickness+2*ex);
    }
}

// TEST

module switch(){
    difference(){
    rounded_rect(widthPowerPart, height, thickness, roundingRadius);
    translate([widthPowerPart/2-switchInnerWidth/2, height/2-switchInnerLength/2, 0-ex])
        cube([switchInnerWidth, switchInnerLength, thickness*2]);
    translate([widthPowerPart/2-switchOuterWidth/2, height/2-switchOuterLength/2, 0-ex])
        cube([switchOuterWidth, switchOuterLength, 1/3*thickness+ex]);
    }
}

clampWidth=mountWidth;

module clamp(){
    
    rounded_rect(widthPowerPart, height, thickness, roundingRadius);
    translate([widthPowerPart/2-clampWidth/2, profile, thickness])
        clampClip();
    translate([widthPowerPart/2+clampWidth/2, profile*2, thickness])
        rotate([0,0,180]) clampClip();
}

module clampClip(clipWidth=3, clipHeight=0.35){
    cube([clampWidth, clampWidth-2*clipHeight, 2/3*profile]);
    //new clip design
    difference(){
        translate ([0, (clampWidth - 2*clipHeight)/2,1/2*profile]) 
            rotate([0, 90,0]) cylinder(h=clampWidth, d=clampWidth + clipHeight);
        translate ([0-ex, 0, 0]) cube([clampWidth+2*ex, clampWidth, profile]);
    }
//    translate([0, -clipHeight, profile/2-clipWidth/2]) rotate([-atan(clipHeight/clipWidth),0,0]) cube([clampWidth, clipHeight, clipWidth]);
}


// SUPPORTS

module power_supports(){
    power_part_support();
}

module power_part_support(){
    
    difference(){
        union(){
            cube([overlap - support_gap, 3*profile, support_wall]);
            for (i = [0 : 5*support_wall : overlap])
                translate([i, 0, 0])
                    cube([support_wall, 3*profile, thickness/2 - support_gap]);
            for (i = [0 : 3*support_wall : 3*profile])
                translate([0, i, 0])
                    cube([overlap - support_gap, support_wall, thickness/2 - support_gap]);
        }
        translate([-ex, height/2-powerHeight/2, -ex])
            cube([powerWidth-powerRadius+ex, powerHeight, thickness+2*ex]);
    }
}

// UTILITY

// Make a rounded rectangle
module rounded_rect(x, y, z, radius) {
    translate([radius,radius,0]) //move origin to outer limits
	linear_extrude(height=z)
		minkowski() {
			square([x-2*radius,y-2*radius]); //keep outer dimensions given by x and y
			circle(r = radius);
		}
}

//make mounting
module mount(){
    difference(){
        cube([mountWidth, mountThickness, profile]);
        translate([mountWidth/2, -ex, profile/2]) rotate([-90,0,0])
        union(){
            cylinder(d=screwHeadDiameter+2*ex, h=screwHeadHeight+2*ex);
            cylinder(d=screwDiameter, h=mountThickness+2*ex);
        }
    }
}