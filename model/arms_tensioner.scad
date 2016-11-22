//Arms tensioner for Mini Kossel

width=2;       //tensioner width
height=10;      //tensioner height
armspan=38.2;   //kossel arms span
tension=25;    //how much to make tensioner smaller than arms span
arc_dia=5;    //arc inner diameter
$fn=40;

main();

module main(){
    union(){
        translate([arc_dia/2, -width/2,0]) cube([armspan-tension, width, height]);
        rotate([0,0,-90]) arc();
        translate([arc_dia + armspan - tension, 0, 0]) arc();
    }
}

module arc(){
    difference(){
        cylinder(d=arc_dia + 2*width, h=height);
        cylinder(d=arc_dia, h=height);
        translate([-arc_dia/2 - width, 0, 0]) cube([0 + 2*width, arc_dia/2 + width, height]);
    }
}