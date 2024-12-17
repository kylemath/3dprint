        //===========================================================================
//
// MiseryBot Box / Combination Compact Wrench Holder Hanger
// https://www.thingiverse.com/thing:6449412
//
// Thingiverse user MiseryBot
// https://www.thingiverse.com/miserybot/designs
//
// This is kind of an embarrasing, horrible mash up between:
//
//   Schraubenschluesselhalter "Wrench holder"
//   https://www.thingiverse.com/thing:3242936
//   Detlev Ahlgrimm, 11.2018
//   Wrench Holder (parameterized)
//   November 27, 2018
//   Thingiverse user dede67
//   https://www.thingiverse.com/dede67/designs
//
// and
//
//   Wrench Hanger
//   https://www.thingiverse.com/thing:2995526
//   Customizable Wrench Holder
//   July 08, 2018
//   Thingiverse user varnerrants
//   https://www.thingiverse.com/varnerrants/designs
//
// I wanted the wall hanging style of varnerrants, but more compact. I loved
// the coding style of dede67. So of course I mangled it up with a complete
// lack of regard for coding style and standards of either source.
//
// #whiteside_c_formatting_forever
//
//---------------------------------------------------------------------------
// Pegboard hack / add on
//
// Pegboard specs from: 
//   https://www.wallwerx.com/blogs/blog-1/these-are-standard-pegboard-specifications
//
//   thickness     = 6.35mm = 1/4"
//   hole diameter = 6.35mm = 1/4"
//   hole grid     = 25.4mm = 1" centers
//
//---------------------------------------------------------------------------
pegboard_version=true;
pegboard_thick=  6.35;
pegboard_gap=    0.5;
pegboard_hole_r= (6.35/2);
pegboard_centers=25.4;
pegboard_pin_r= (5/2);  //guess, might need to be tweaked
hook_vertical_stub=1;      //May need to fuss these
hook_torus_sweep_r=4;      //May need to fuss these
//===========================================================================
//Disable $fn and $fa
$fn=0;
$fa=0.01;
//Use only $fs -- smaller number is smaller facets
$fs=0.25; //build = smooth and slow
//$fs=1; //iterate = chunky & fast(er)
//---------------------------------------------------------------------------
//how to debug
//  echo("(pb_Y1-pb_Y0)=",(pb_Y1-pb_Y0));  
//===========================================================================
//rotate axes
X=[1,0,0];
Y=[0,1,0];
Z=[0,0,1];
//===========================================================================
// from dede67
// Returns the sum of the elements in "arr" up to
// Element "maxidx" (exkl.).
// Example:  sum_to([1, 2, 4, 8], 3) == 7
//    Index:          0  1  2  3
//---------------------------------------------------------------------------
function sum_to(arr, maxidx, idx=0) = idx>=maxidx ? 0 : arr[idx]+sum_to(arr, maxidx, idx+1);
//===========================================================================
// from dede67
// like cube() - just rounded
//---------------------------------------------------------------------------
module BoxWithRoundedCorners(v, r=1)
  {
  hull()
    {
    translate([    r,     r,     r]) sphere(r=r);
    translate([v.x-r,     r,     r]) sphere(r=r);
    translate([    r, v.y-r,     r]) sphere(r=r);
    translate([v.x-r, v.y-r,     r]) sphere(r=r);

    translate([    r,     r, v.z-r]) sphere(r=r);
    translate([v.x-r,     r, v.z-r]) sphere(r=r);
    translate([    r, v.y-r, v.z-r]) sphere(r=r);
    translate([v.x-r, v.y-r, v.z-r]) sphere(r=r);
    }
  }
//======================================================================================
// 2d rounded rounded rectangle with different radii
//---------------------------------------------------------------------------------------
module rounded_rounded_rectangle(v,r1,r2)
  {
  minkowski()
    {
    union()
      {
      //core object
      translate([0,0,-((v.z)-(2*r2))/2])      
        linear_extrude(height=((v.z)-(2*r2)))
          offset(r=r1-r2)
            square([v.x-(2*r1),v.y-(2*r1)],center=true);
      }
    union()
      {
      //object to coat it with
      sphere(r2);
      }
    }    
  }
//=======================================================================================  
// upper half of rounded_rounded_rectangle(v,r1,r2)
//---------------------------------------------------------------------------------------
module rounded_rounded_cap(v,r1,r2)
  {
  difference()
    {
    union()
      {
      //positive
       rounded_rounded_rectangle([v.x,v.y,v.z*2],r1,r2);
      }
    union()
      {
      //negative
      translate([0,0,-(v.z/2)-0.1])
        cube([v.x+0.2,v.y+0.2,v.z+0.2],center=true); 
      }
    }    
  }  
//===========================================================================
//uncomment for SAE

/*
//SAE GearWrench ratchet head set
number_of_wrenches=10;
//Size:          1/4, 5/16,11/32,  3/8, 7/16,  1/2, 9/16,  5/8,11/16,  3/4
neck_thick=   [ 2.78, 3.38, 3.61, 3.62, 4.05, 3.89, 4.30, 4.89, 5.22, 5.46];
neck_wide=    [ 7.33, 7.98, 8.88, 9.84,10.60,11.75,12.74,14.45,15.68,16.68];
head_thick=   [ 6.57, 6.94, 7.00, 7.93, 8.31, 8.65, 9.67,10.34,10.77,11.16];
head_diameter=[16.85,17.77,19.25,21.31,24.27,26.58,27.54,32.21,35.12,36.28];
*/

//uncomment for metric

//Metric GearWrench ratchet head set (plus eBay 19mm)
number_of_wrenches=8;
//Size:            5/16,  3/8,   7/16, 1/2, 9/16, 5/8, 3/4
neck_thick=   [ 4.60, 3.61, 4.57, 5.23, 5.76, 5.80, 6.10,     7.20];
neck_wide=    [ 10.37, 9.85, 12.11, 13.01, 13.58, 17.21, 17.89  ,20.74];
head_thick=   [ 8.34, 9.01, 9.07, 9.55, 9.55, 10.58, 10.95,    13.73  ];
head_diameter=[19.82, 22.18, 26.19, 28.09, 29.95, 35.71, 36.66, 35.03 ];


spacing_between_heads=4;
min_wall_thick=7;
clearance=0.5;
//---------------------------------------------------------------------------
// uses the global arrays above
module Wrench(index=0)
  {
  translate([head_diameter[index]/2,0,head_diameter[index]/2])
    {
    //The head.
    rotate(90,Z)
      rotate(90,Y)
        cylinder(r=head_diameter[index]/2,h=head_thick[index],center=true);
    //The handle. All are 100 mm long, because I have no imagination
    translate([-neck_wide[index]/2,-neck_thick[index]/2,-100])
      BoxWithRoundedCorners([neck_wide[index],
                             neck_thick[index],
                             100],
                            r=neck_thick[index]/2);
    }
  }
//===========================================================================
// Hull idea from varnerrants
// Sizes and positions are kinda freehand.
//these are hand tweaked
z_fix=5;
x_fix_small=1;
x_fix_large=3.5;
y_fix_small=1;
module wrench_holder_body_positive()
  {
  //these are hand tweaked
  z_fix=5;
  x_fix_small=1;
  x_fix_large=3.5;
  y_fix_small=1;
  hull()
    {
    //Small end
    translate([-min_wall_thick,
               -1.5*(head_thick[0]+y_fix_small),
               -min_wall_thick-z_fix])
      BoxWithRoundedCorners([head_diameter[0]+min_wall_thick+x_fix_small,
                             head_thick[0]+y_fix_small,
                             min_wall_thick+0.5*head_diameter[0]],
                            r=min_wall_thick/2);  
    //Large end
    translate([-min_wall_thick,
               sum_to(head_thick, number_of_wrenches-1)
                 +((number_of_wrenches-1)*spacing_between_heads)
                 +head_thick[number_of_wrenches-1]/2,
               -min_wall_thick-z_fix])
      BoxWithRoundedCorners([head_diameter[number_of_wrenches-1]
                               +min_wall_thick
                               +x_fix_large,
                             head_thick[number_of_wrenches-1],
                             min_wall_thick
                               +0.5*head_diameter[number_of_wrenches-1]],
                            r=min_wall_thick/2);  
    } //hull()
  }
//===========================================================================
// Make the  back flat
module wrench_holder_body_negative()
  {
  // Really? You have never done a horrible copy & paste?
  translate([-10-min_wall_thick/2,
              -50,
              -min_wall_thick-20])
    cube([10,
          sum_to(head_thick, number_of_wrenches-1)
            +((number_of_wrenches-1)*spacing_between_heads)
            +head_thick[number_of_wrenches-1]/2
            +100,
          min_wall_thick+0.5*head_diameter[number_of_wrenches-1]+40]);  
  }  
//===========================================================================
module neck_slots_negative()
  {
  for(i=[0:number_of_wrenches-1])
    {
    translate([head_diameter[i]/2,
               sum_to(head_thick, i)+(i*spacing_between_heads),
               head_diameter[i]/2])
      {
      //Slots for the handles. All are 100 mm long, because once again
      //I have no imagination.
      translate([-neck_wide[i]/2-clearance,-neck_thick[i]/2-clearance,-100])
        BoxWithRoundedCorners([neck_wide[i]+2*clearance+50,
                               neck_thick[i]+2*clearance,
                               100],
                              r=neck_thick[i]/2+clearance);
      }
    }
  }
//===========================================================================
module head_cutouts_negative()
  {
  for(i=[0:number_of_wrenches-1])
    {
    translate([head_diameter[i]/2,
               sum_to(head_thick, i)+(i*spacing_between_heads),
               head_diameter[i]/2])
      {
      //Cutouts for the heads
      rotate(90,Z)
        rotate(90,Y)
          cylinder(r=head_diameter[i]/2+clearance,
                   h=head_thick[i]+2*clearance,center=true);
      //There is a blend between the neck of the wrench
      //and the head. Let's try to simulate it a bit.
      //I'm not convinced.
      difference()
        {
        union() //positive
          {
          scale([1/1.5,1,1.4])
            translate([0,-(head_thick[i]/2+clearance),0])
              rotate(90,Z)
                rotate(90,Y)
                  cylinder(r1=(head_diameter[i]/2+clearance)/1.4,
                           r2=(1.3*head_diameter[i]/2)+clearance,
                           h=head_thick[i]/2+clearance);
          scale([1/1.5,1,1.4])
            rotate(90,Z)
              rotate(90,Y)
                cylinder(r1=(1.3*head_diameter[i]/2)+clearance,
                         r2=(head_diameter[i]/2+clearance)/1.4,
                         h=head_thick[i]/2+clearance);
          } //positive
        union() //negative
          {
          translate([-(0.666*head_diameter[i]+neck_wide[i]/2),
                     0,
                     -0.76*head_diameter[i]])
            rotate(90,Z)
              rotate(90,Y)
                cylinder(r=0.666*head_diameter[i],
                         h=head_thick[i]+2*clearance,center=true);
          } //negative
        } //difference  
      }
    }
  }
//===========================================================================
// A lot of hand tweaking in this . . . sorry.
module mounting_holes_negative()
  {
  //Small end
  translate([0,
             -0.75*head_thick[0]-0.75,
             -0.75*min_wall_thick])
    rotate(90,Y)
      cylinder(r=3/2,h=50,center=true);
  translate([25,
             -0.75*head_thick[0]-0.75,
             -0.75*min_wall_thick])
    rotate(90,Y)
      cylinder(r=6/2,h=25,center=true);

  //Large end
  translate([0,
             sum_to(head_thick, number_of_wrenches-1)
               +((number_of_wrenches-1)*spacing_between_heads)
               +head_thick[number_of_wrenches-1]/2
               +0.4*head_thick[number_of_wrenches-1],
             -0.75*min_wall_thick])
    rotate(90,Y)
      cylinder(r=3/2,h=150,center=true);
  translate([50,
             sum_to(head_thick, number_of_wrenches-1)
               +((number_of_wrenches-1)*spacing_between_heads)
               +head_thick[number_of_wrenches-1]/2
               +0.4*head_thick[number_of_wrenches-1],
             -0.75*min_wall_thick])
    rotate(90,Y)
      cylinder(r=6/2,h=50,center=true);
  }
//===========================================================================
module pegboard()
  {
  //First get the Y-Z outline of the entire part.
  //data copied from wrench_holder_body_positive()
  pb_Y0= -1.5*(head_thick[0]+y_fix_small) -(head_thick[0]+y_fix_small)-min_wall_thick/2;

  pb_Y1= sum_to(head_thick, number_of_wrenches-1)
                 +((number_of_wrenches-1)*spacing_between_heads)
                 +head_thick[number_of_wrenches-1]/2;
  //In order to have the pins working, we need to have at least pegboard_centers
  //plus the hole diameter in z
  pb_Z=max((min_wall_thick+0.5*head_diameter[number_of_wrenches-1]),
           (pegboard_hole_r*2+pegboard_centers));
 
  //Calculate the Y center
  Y_center=(pb_Y1-pb_Y0)/2 + pb_Y0/2; 
  //Get the Z offset
  pb_Z_pin_center=pb_Z-min_wall_thick-z_fix-pegboard_hole_r;

  //This is the pegboard
  difference()
    {
    union() //positive
      {
      translate([-min_wall_thick/2-1-gap_heads_to_peg_base-pegboard_thick-pegboard_gap, 
                 pb_Y0/2-(pegboard_centers/2),
                 -min_wall_thick-z_fix-(pegboard_centers/2)])
        cube([pegboard_thick,
              (pb_Y1-pb_Y0)+pegboard_centers,
              pb_Z+pegboard_centers]);
      }
    union() //negative
      {
      //We need to figure out how many pegs we can fit.
      //Start with our width, less a peg diameter (so the pegs will have to be
      //fully inside the Y outline). Then divide that by the spacing
      //and round down.
      number_of_y_pegs_less_1= floor((pb_Y1-pb_Y0-2*pegboard_hole_r)/pegboard_centers);

////Mark the center (debug)
//%translate([-30, Y_center, 0])
//  rotate(90,Y)
//    cylinder(r=1,h=60);
      
      //Peg count goes from 0 to number_of_y_pegs_less_1
      //so if number_of_y_pegs_less_1 is odd, we will have
      //no peg in the center
      if(number_of_y_pegs_less_1 % 2 == 0)
        {
        // Odd number of pegs, one in the center
        for(peg_count = [0 : 1 : number_of_y_pegs_less_1])
          {
          translate([-min_wall_thick/2-pegboard_thick-pegboard_gap-1,
                     Y_center-((number_of_y_pegs_less_1)*pegboard_centers)/2+
                      (peg_count*pegboard_centers),
                     pb_Z_pin_center])
          rotate(90,Y)
            {
            cylinder(r=pegboard_hole_r,h=pegboard_thick+2);
            translate([pegboard_centers,0,0])
              cylinder(r=pegboard_hole_r,h=pegboard_thick+2);
            }
          } //for
        } //if 
      else
        {
        // Even number of pegs, gap in the center
        for(peg_count = [0 : 1 : number_of_y_pegs_less_1])
          {
          translate([-min_wall_thick/2-pegboard_thick-pegboard_gap-1,
                     Y_center-((number_of_y_pegs_less_1+1)*pegboard_centers)/2+
                       pegboard_centers/2+
                      (peg_count*pegboard_centers),
                     pb_Z_pin_center])
          rotate(90,Y)
            {
            cylinder(r=pegboard_hole_r,h=pegboard_thick+2);
            translate([pegboard_centers,0,0])
              cylinder(r=pegboard_hole_r,h=pegboard_thick+2);
            }
          } //for
        } //else
      } //negative union
    } //difference    
  }
//======================================================================================
module torus(sweep_r, cross_section_r)
  {
  rotate_extrude()
    translate([sweep_r,0,0])
      circle(cross_section_r);
  }  
//===========================================================================
module Pegboard_Hook(pegboardthick,hook_r)
  {
  //The peg itself
  rotate(-90,Y)
    cylinder(r=hook_r,h=pegboardthick);
  //The hook -- a 1/4 torus
  difference()
    {
    union() //positive
      {
      translate([-pegboardthick,0,hook_torus_sweep_r])
      rotate(90,X)
        torus(sweep_r=hook_torus_sweep_r, cross_section_r=hook_r);

      }  //positive union
    union() //negative
      {
      //cut off right side of hook
      translate([-pegboardthick/2+0.501,
                 0,
                 +(hook_torus_sweep_r+hook_r+pegboardthick)/2])
        cube([pegboardthick+1,
              pegboardthick+1,
              hook_torus_sweep_r+hook_r+pegboardthick],
              center=true);
      //cut off the top of hook
      translate([-pegboardthick-(pegboardthick+1)/2+0.01,
                 0,
                 hook_torus_sweep_r+(hook_torus_sweep_r+hook_r+1)/2])
        cube([pegboardthick+1,
              pegboardthick+1,
              hook_torus_sweep_r+hook_r+1],center=true);
      } //negative union
    } //difference
  //A little bit of vertical
  translate([-pegboardthick-hook_torus_sweep_r,
             0,
             +hook_torus_sweep_r+hook_vertical_stub/2-0.05])
      cylinder(r=hook_r,h=hook_vertical_stub+0.1,center=true);
  //Roundy the end
  translate([-pegboardthick-hook_torus_sweep_r,
             0,
             +hook_torus_sweep_r+hook_vertical_stub])
    sphere(r=hook_r);
  }
//===========================================================================
module Pegboard_Pin(pegboardthick,hook_r)
  {
  //The peg itself
  rotate(-90,Y)
    cylinder(r=hook_r,h=pegboardthick);
  //Roundy the end
  translate([-pegboardthick,
             0,
             0])
    sphere(r=hook_r);
  }
//===========================================================================
peg_base_thick=6;
gap_heads_to_peg_base=2;
module base_and_pegboard_pins()
  {
  //First get the Y-Z outline of the entire part.
  //data copied from wrench_holder_body_positive()
  pb_Y0= -1.5*(head_thick[0]+y_fix_small) -(head_thick[0]+y_fix_small)-min_wall_thick/2;

  pb_Y1= sum_to(head_thick, number_of_wrenches-1)
                 +((number_of_wrenches-1)*spacing_between_heads)
                 +head_thick[number_of_wrenches-1]/2;
                 
  //In order to have the pins working, we need to have at least pegboard_centers
  //plus the hole diameter in z
  pb_Z=max((min_wall_thick+0.5*head_diameter[number_of_wrenches-1]),
           (pegboard_hole_r*2+pegboard_centers));
    
  //Calculate the Y center
  Y_center=(pb_Y1-pb_Y0)/2 + pb_Y0/2; 
    
  //Get the Z offset
  pb_Z_pin_center=pb_Z-min_wall_thick-z_fix-pegboard_hole_r;

  //This is the base
  difference()
    {
    union() //positive
      {
      translate([-min_wall_thick/2-1-gap_heads_to_peg_base,
                 pb_Y0/2 + (pb_Y1-pb_Y0)/2,
                 pb_Z/2-min_wall_thick-z_fix])
        rotate(90,Y)
          rounded_rounded_cap([pb_Z,
                               (pb_Y1-pb_Y0),
                               peg_base_thick],
                              0,
                              pegboard_hole_r);       
      //We need to figure out how many pegs we can fit.
      //Start with our width, less a peg diameter (so the pegs will have to be
      //fully inside the Y outline). Then divide that by the spacing
      //and round down.
      number_of_y_pegs_less_1= floor((pb_Y1-pb_Y0-2*pegboard_hole_r)/pegboard_centers);
      //Peg count goes from 0 to number_of_y_pegs_less_1
      //so if number_of_y_pegs_less_1 is odd, we will have
      //no peg in the center
      if(number_of_y_pegs_less_1 % 2 == 0)
        {
        // Odd number of pegs, one in the center
        for(peg_count = [0 : 1 : number_of_y_pegs_less_1])
          {
          translate([-min_wall_thick/2-1-gap_heads_to_peg_base,
                     Y_center-((number_of_y_pegs_less_1)*pegboard_centers)/2+
                      (peg_count*pegboard_centers),
                     pb_Z_pin_center])
            {
            Pegboard_Hook(pegboardthick=pegboard_thick,hook_r=pegboard_pin_r);
            translate([0,0,-pegboard_centers])
              Pegboard_Pin(pegboardthick=pegboard_thick,hook_r=pegboard_pin_r);
            }
          } //for
        } //if 
      else
        {
        // Even number of pegs, gap in the center
        for(peg_count = [0 : 1 : number_of_y_pegs_less_1])
          {
          translate([-min_wall_thick/2-1-gap_heads_to_peg_base,
                     Y_center-((number_of_y_pegs_less_1+1)*pegboard_centers)/2+
                       pegboard_centers/2+
                      (peg_count*pegboard_centers),
                     pb_Z_pin_center])
            {
            Pegboard_Hook(pegboardthick=pegboard_thick,hook_r=pegboard_pin_r);
            translate([0,0,-pegboard_centers])
              Pegboard_Pin(pegboardthick=pegboard_thick,hook_r=pegboard_pin_r);
            }
          } //for
        } //else                              
                              
      }
    union() //negative
      {

      } //negative union
    } //difference    
  }
//===========================================================================
//Wrench models for visualization
if(1)%for(i=[0:number_of_wrenches-1])
  {
  translate([0, sum_to(head_thick, i)+(i*spacing_between_heads), 0])
  Wrench(i);
  }

if(0 != pegboard_version)
  {
  base_and_pegboard_pins();
  //Pegboard for visualization
  %pegboard();  
  }
//The actual output section
if(1)difference()
  {
  //positive
  union()
    {
    wrench_holder_body_positive();
    }//positive
  //negative
  union()
    {
    wrench_holder_body_negative();
    neck_slots_negative();
    head_cutouts_negative();
    if(0 == pegboard_version)
      mounting_holes_negative();
    }//negative
  }
//===========================================================================
