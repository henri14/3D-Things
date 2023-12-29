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

// Tabs
tab_width = 10.7;
tab_length = 28 - 0.7; // 0.2 adjustment for printer calibration
tab_height = 19;
tab_wall_thickness = 2;
tab_inset = [2.8, 1.2, 0];
// Gap between first two tabs
tab_gap = 2.5 + 0.5;
nub_width = 6.3;
nub_z = 7.4 + base_thickness;

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
        notch_y_offset = length - notch_y_max - notch_y_min;
        translate([0, notch_y_offset,0])
            linear_extrude(thickness)
                polygon(points=notches);

    }
}
module tab(width, length, height, wall_thickness) {
    difference() {
        union() {
            cube([width, length, height]);
            translate([0,(length + nub_width)/2, nub_z])
                nub();
        }
        translate([wall_thickness,wall_thickness, 0])
            cube([width - wall_thickness, length - 2*wall_thickness, height+1]);
    }
}

module tabs() {
    translate(tab_inset)
        tab(tab_width, tab_length, tab_height, tab_wall_thickness);
    tab2_inset = tab_inset + [0, tab_length + tab_gap, 0];
    translate(tab2_inset)
        tab(tab_width, tab_length, tab_height, tab_wall_thickness);
    // should be a 21 mm gap between pairs
    tab4_inset = [tab_inset.x, base_length - tab_length - tab_inset.y, 0];
    tab3_inset = [tab2_inset.x, base_length - tab_length - tab2_inset.y, 0];

    translate(tab3_inset)
//    translate (tab_inset + [0, base_length-59.9, 0])
        tab(tab_width, tab_length, tab_height, tab_wall_thickness);
//    translate(tab_inset + [0, base_length-29,0])
    translate(tab4_inset)
        tab(tab_width, tab_length, tab_height, tab_wall_thickness);
}

module nub () {
    rotate([90,270,0]){
        linear_extrude(nub_width)
            polygon(points=[[0,0], [0,1.7], [4.7,0]]);
    }

}