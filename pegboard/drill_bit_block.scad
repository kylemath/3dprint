 /*
each items is a fraction, so [1,8] is 1/8
*/
column_sizes = [
    [3, 4,5,6,7,8,10], // Row 1 (metric sizes in mm)
    [[3,8],  [3,8], [3,8], [3,8], [3,8], [3,8], [3,8], [3,8]] // Row 2
    
          // Row 3 (continued)
];





second_row_labels = ["1/16", "5/64", "3/32", "7/64", "1/8", "9/64", "5/32", "11/64"];

num_rows = len(column_sizes);
num_cols = max([for (row = column_sizes) len(row)]);

spacing_between_holes_mm = 22;//make sure this is larger than your biggest drill bit

extra_diameter_mm = 0.4;//this will be added to each hole for a bit of wiggle room, go bigger if your print is too tight

block_depth_mm = 25.4;








/*
DO NOT MODIFY BELOW THIS
*/
$fn=50;

col_diameter_mm = [
    for (row = column_sizes) 
        [for (i = row) 
            if (is_num(i)) i 
            else (i[0]/i[1]) * 25.4
        ]
];

for (r=[0:num_rows-1], c=[0:num_cols-1]) {
    echo(str(column_sizes[r][c][0], "/", column_sizes[r][c][1], " in. == ", col_diameter_mm[r][c], " mm."));
}
    
height_for_labels = 12;

// Update the block_width calculation
block_width = num_cols * spacing_between_holes_mm ;

block_height = num_rows * spacing_between_holes_mm * 1.2;

/*
Reusing this for the actual hook --> https://www.thingiverse.com/thing:1540038
this unfortunately does mean this model requires 1/4" holes spaced 1" apart
*/
clip_xy_scale=1.1;//give a little wiggle room side to side
clip_depth=6.4 * clip_xy_scale;
clip_height=44;
clip_width=4.63 * clip_xy_scale;
pegboard_hole_spacing = 25.4;


/*
BUILD THE THING!
*/

difference() {
    cube([block_width, block_depth_mm, block_height]);
    drill_bit_holes();
    labels();
    pegboard_clips();
}


module drill_bit_holes() {
    for (r=[0:num_rows-1]) {
        row_spacing = spacing_between_holes_mm;
        for (c=[0:len(column_sizes[r])-1]) {
            x_offset = (spacing_between_holes_mm/2)+(spacing_between_holes_mm*c);
            z_offset = block_height - ((spacing_between_holes_mm/2)+(spacing_between_holes_mm*r));
            translate([x_offset,-4,z_offset])
                rotate([-120,0,0])
                    cylinder(h=block_depth_mm-(clip_depth/2), d=col_diameter_mm[r][c] + extra_diameter_mm);
        }
    }
    
    // Add hex hole in the top right corner
    hex_size = 2.5;
    hex_x = block_width - (spacing_between_holes_mm/2);
    hex_z = block_height - (spacing_between_holes_mm/2);
    translate([hex_x, -4, hex_z])
        rotate([-120,0,0])
            hex_hole(hex_size, block_depth_mm-(clip_depth/2));
}

module labels() {
    for (r=[0:num_rows-1], c=[0:num_cols-1]) {
        row_spacing = spacing_between_holes_mm;
        x_offset = (spacing_between_holes_mm/2)+(spacing_between_holes_mm*c);
        z_offset = block_height - height_for_labels - ((spacing_between_holes_mm/2)+(spacing_between_holes_mm*r));
        
        if (c < len(column_sizes[r])) {
            if (r == 0) {
                // Metric labels for the first row
                translate([x_offset, 1, z_offset]) draw_text(str(column_sizes[r][c], "mm"));
            } else {
                // Custom labels for the second row
                if (c < len(second_row_labels)) {
                    translate([x_offset, 1, z_offset]) draw_text(second_row_labels[c]);
                }
            }
        }
    }
}

module draw_text(t) {
    rotate([90, 0, 0])
        linear_extrude(height = 1)
            text(t, 
                size = 4,
                spacing=0.8,
                font = str("Gill Sans", ":style=Bold"),
                $fn = 16,
                valign="center",
                halign="center"
            );
}

module pegboard_clips() {
    first_x = ((block_width % pegboard_hole_spacing)-clip_width) / 2;
    for (i=[first_x:pegboard_hole_spacing:block_width]) {
        translate([i,block_depth_mm-clip_depth,block_height-clip_height])
            scale([clip_xy_scale,clip_xy_scale,1])
                import("clip_modified.stl");
    }
}

module hex_hole(size, height) {
    cylinder(h=height, d=size*2/sqrt(3), $fn=6);
}



