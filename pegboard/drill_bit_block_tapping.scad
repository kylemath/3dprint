/*
each row is [diameter, horizontal_spacing, vertical_spacing, num_bits]
diameter is in inches, spacings are in mm, num_bits is an integer
*/
row_specs = [
    [1/8, 20, 5, 10], // Row 1: 1/8 inch bits, 22mm horizontal spacing, 25mm vertical spacing, 8 bits
    [1/8, 17, 20, 11], // Row 2
    [1/8, 13, 17, 15], // Row 3: Double density horizontally, 16 bits
    [3/32, 8, 13, 24]  // Row 4: Double density horizontally, 16 bits
];

num_rows = len(row_specs);

extra_diameter_mm = 0.5; // This will be added to each hole for a bit of wiggle room
block_depth_mm = 15.4;

// Calculate the block dimensions
block_width = max([for (row = row_specs) row[1] * row[3]]);
block_height = sum([for (row = row_specs) row[2]])*1.2;

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
    pegboard_clips();
}
module drill_bit_holes() {
    for (r=[0:num_rows-1]) {
        diameter_mm = row_specs[r][0] * 25.4; // Convert inches to mm
        h_spacing = row_specs[r][1];
        v_spacing = row_specs[r][2];
        num_bits = row_specs[r][3];
        
        z_offset = block_height - sum([for (i=[0:r]) row_specs[i][2]]);
        
        echo("Row", r, "z_offset:", z_offset);  // Debug output
        
        for (c=[0:num_bits-1]) {
            x_offset = (h_spacing/2) + (h_spacing * c);
            translate([x_offset,-4,z_offset])
                rotate([-120,0,0])  // This is the original angle
                    cylinder(h=block_depth_mm-3, 
                             d=diameter_mm + extra_diameter_mm,
                             $fn=32);
        }
    }
}
// Function to sum an array of numbers
function sum(v, i = 0, r = 0) = i < len(v) ? sum(v, i + 1, r + v[i]) : r;

module pegboard_clips() {
    first_x = ((block_width % pegboard_hole_spacing)-clip_width) / 2;
    for (i=[first_x:pegboard_hole_spacing:block_width]) {
        translate([i,block_depth_mm-clip_depth,block_height-clip_height])
            scale([clip_xy_scale,clip_xy_scale,1])
                import("clip_modified.stl");
    }
}