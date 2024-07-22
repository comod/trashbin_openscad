$fn=50;
//$fn=100;
//$fn=4;

//use <roundedcube.scad>

// 5.985 liters (7l bag)
bag_x = 190;
bag_y = 140;
bag_z = 225;

nozzle = 0.6;
//r=0.5;
//r=1.5;
//r=1;
r=nozzle*2;
//r=4;
center = true;
thickness = nozzle*6;
fitting_tollerance = 1.2;

bag_plus = 10;
base_x = bag_x+bag_plus;
base_y = bag_y+bag_plus;
bottom_z = 5+bag_plus;

funnel_x = bag_x+80;
funnel_y = bag_y+40;

middle_z = bag_z;

funnel_z = 26; // [10:100]
top_inlay_z = 50;

middle_part_offset_delta = 20; // [1:60]
top_part_offset_delta = 150; // [50:250]

module minkowski_spehere() {
    minkowski() {
        children();
        cylinder(r=r);
//           sphere(r);
    }
}

// kontroll objekt
module bag() {
    translate([0, 0, -10])
        cube([bag_x, bag_y, bag_z], center);
}

module base() {
    z = bottom_z;
    minkowski_spehere()
    cube([base_x, base_y, z], center);

}

module inlay(factor=1, z, tollerance=0) {
    //    z = bottom_z;
    x = (base_x-thickness*factor) - tollerance;
    y = (base_y-thickness*factor) - tollerance;
    //    translate([0, 0, z/2])

    //    minkowski_spehere()
    cube([x, y, z], center);
}

module bottom_inlay(tollerance=0) {
    translate([0, 0, thickness])
        minkowski_spehere()
        inlay(1, bottom_z, tollerance);

}

module top_inlay(factor=1) {
    //    translate([0, 0, 1])

    minkowski_spehere()
    inlay(factor, top_inlay_z);
}

// bottom part
module bottom() {
    difference() {
        base();
        bottom_inlay();
    }
}

// Example usage of the module
module middle() {

    // Parameters
    trashbin_height = middle_z-25;  // Height of the trashbin
    trashbin_diameter = 150; // Diameter of the trashbin
    hole_diameter = 10; // Diameter of the holes
    hex_radius = 10; // Radius of the hexagons
    z_spacing = 8; // Spacing between layers in the Z direction

    // Calculate max values for loops
    max_i = trashbin_diameter / 2 - hex_radius;
    max_j = trashbin_diameter / 2 - hex_radius;
    max_z = trashbin_height;

    offset = (middle_z / 2) + bottom_z / 2;

    //    honeycomb(middle_z, trashbin_diameter, hole_diameter, z_spacing, hex_radius, max_i, max_j, max_z)
    difference() {
        group() {
            translate([0, 0, -offset])
                bottom_inlay(fitting_tollerance);

            minkowski_spehere()
            cube([base_x, base_y, middle_z], true);
        }

        // hole
        minkowski_spehere()
        inlay(2, middle_z+offset);
    }

}

module funnel() {

    adapter_factor = 10;

    // funnel

    difference() {
        hull() {
            translate([0, 0, funnel_z])
                minkowski_spehere()
                cube([funnel_x, funnel_y, 1], true);

            translate([0, 0, 0])
                top_inlay();

        }

        // hole
        hull() {
            translate([0, 0, funnel_z+1])
                minkowski_spehere()
                cube([funnel_x-thickness, funnel_y-thickness, 1], true);

            translate([0, 0, -1])
                top_inlay(adapter_factor+3);

            //            translate([0, 0, 25])
            //                cube([funnel_x, funnel_y, 30], true);

        }
    }

    // fitting lip

    // adapter
    translate([0, 0, -top_inlay_z])
        difference() {
            group() {
                // fitting lip
                top_inlay_lip = 10;
                translate([0, 0, top_inlay_z/2-top_inlay_lip/2])
                    minkowski_spehere()
                    inlay(2, top_inlay_lip, fitting_tollerance);

                // inner funnel

                minkowski_spehere()
                inlay(adapter_factor, top_inlay_z);
            }

            // hole
            translate([0, 0, 1])
                minkowski_spehere()
                inlay(adapter_factor+1, top_inlay_z+thickness+2);

        }
}



// ===

// kontroll objekt
//#translate([0, 0, -6])
//cube([100, 100, thickness], true);

//import_stl("corner.stl");
//roundedcube([base_x, base_y, bag_z], center=true, radius=r);

//bottom();

//middle_part_offset = middle_z/2+middle_part_offset_delta;
//translate([0, 0, middle_part_offset ]) {
////    #bag();
//    middle();
//}
//
//// top
//top_part_offset = middle_part_offset + top_part_offset_delta;
//translate([0, 0, top_part_offset ])
funnel();