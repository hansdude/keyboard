include <MCAD/units.scad>
include <MCAD/regular_shapes.scad>

positive = [1, 1, 1];
origin = [0, 0, 0];
function hadamard(a, b) = [for (i = [0 : min(len(a), len(b)) - 1]) a[i] * b[i]];
module rect1(size, center = origin) {
    translate(-1/2*hadamard(center, size))
        cube(size);
}
module rect(size, octant = undef, center = undef) {
    shifter =
        octant == undef
            ? (center == undef ? [0, 0, 0] : -center/2)
            : (octant - [1, 1, 1])/2;
    translate(hadamard(shifter, size))
        cube(size=size);
}

module cyl(r=undef, d=undef, h, center=false, v) {
    module rot() {
        if (v == -Z) {
            // Deal with the 180deg default than the 90deg.
            mirror(Z) children();
        } else {
            // The rest of the supported directions are 90deg away.
            rotate(a=90, v=cross(v, -Z)) children();
        }
    }
    rot() cylinder(r=r, d=d, h=h, center=center);
}
width=290;
spacing_y=5;
key_y=14;
key_x=14;
//translate(-150*X-epsilon*Z)
//translate(14*X-epsilon*Z)

//                [middle2, 21.5],
//                [middle2, 40.25],
spacing=18.75;
middle1=140;
middle2=149.5;
middle3=145;
middle4=135.25;
module keyboard_half(paths) {
//TODO
    scale(1.005*positive)
    difference() {
        import("keyboard.stl");
//        color("#aaa", .25) %
        translate(-epsilon*Z) linear_extrude(height=1.5+2*epsilon) {
            polygon(
                points = [
                    [middle1, -1],
                    [middle1, 40.25],
                    [middle2, 40.25],
                    [middle2, 40.25+spacing],
                    [middle3, 40.25+spacing],
                    [middle3, 40.25+spacing+spacing],
                    [middle4, 40.25+spacing+spacing],
                    [middle4, 101],
                    [291, 101],
                    [291, -1],
                    [-1, 101],
                    [-1, -1],
                ],
                paths = paths
            );
        }
    }
}
//keyboard_half([[for(i=[0:9]) i]]);
intersection() {
    keyboard_half([[for(i=[0:7]) i, 10, 11]]);
    translate([145, 0, 0]) rect(size=[45, 22, 10], octant=X+Y);
}
