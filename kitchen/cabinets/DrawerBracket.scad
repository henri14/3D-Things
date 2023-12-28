/*
 Face bracket for a kitchen drawer
 Bracket is symetrical and is used for both left and right hand sides
 
*/

// Dimensions in mm
// Base plate
base_width = 14.3;
base_length = 140;
base_thickness = 3.0;
// Mirror notch and two holes
base_notch = [[4.71, 5.72], [base_width+0.1, 5.72], [base_width+0.1, 9.15], [4.71, 9.15]];
base_holes = [[7.9, 18.8], [7.9, 45.4]];
base_hole_diameter = 3.6;
wall = 2;
length=140;

base_plate(base_width, base_length, base_thickness, base_notch, base_holes);
//tab is 5 from edge
tabs();

// Convert 2D vectors to 3D with given Z value
function vec_xy_to_xyz(vec_2d, z) = [for ( a= [0:len(vec_2d)-1]) [vec_2d[a].x, vec_2d[a].y, 0]];

// Draw base plate with notch and holes
module base_plate(width, length, thickness, notches, holes) {
    // Use these to mirror notch at far end
    notch_y_min = min([for (a = [0:3]) notches[a].y]);
    notch_y_max = max([for (a = [0:3]) notches[a].y]);
    notch_width = notch_y_max - notch_y_min;

    difference() {
        cube([width, length, thickness]);
        // punch holes
        for (hole = vec_xy_to_xyz(holes, 2)) {
            echo("Drilling hole at ", hole);
            translate(hole)
                cylinder(h=thickness, r=base_hole_diameter/2, $fn=8);
            // Mirror hole
            mirror_hole = [hole.x, length - hole.y, hole.z];
            echo("Drilling mirror hole at ", mirror_hole);
            translate(mirror_hole)
                cylinder(h=thickness, r=base_hole_diameter/2, $fn=8);
        }
        // Cut notch
        linear_extrude(thickness)
            polygon(points=notches);
        // Far end notch should finish on y-axis at first y point
        notch_y_offset = length - notch_y_max - notch_width;
        translate([0, notch_y_offset,0])
            linear_extrude(thickness)
                polygon(points=notches);

    }
}
module tab() {
    difference() {
        cube([11.4, 28, 19]);
        translate([wall,wall, 0])
        cube([11.4-wall, 28-2*wall, 19+1]);
    }
    translate([0,(28/2)+1,19/2])
    nub();
}

module tabs() {
    translate([0, 0, 0])
    tab();
    translate([0, 30.9, 0])
    tab();
    // should be a 21 mm gap between pairs
    translate ([0, length-59.9, 0])
    tab();
    translate([0, length-29,0])
    tab();
}

module nub () {
    rotate([90,270,0]){
    linear_extrude(6.3)
    polygon(points=[[0,0], [0,1], [1,0]]);
    }

}