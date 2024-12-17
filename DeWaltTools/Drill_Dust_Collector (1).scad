// Modded / Remixed by medooo
// - added back fold (to prevent dirt from spinning out)
// Licensed under the CC BY-NC-SA 3.0
// please refer the complete license here: http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode
// 28.07.2024
// v1.01
// 31.07.2024
// v1.02 (made back fold diameter 'hardcoded' for customizer apps

// Drill Dust Collector by xifle
// Licensed under the CC BY-NC-SA 3.0
// 10.04.2017
// v1

// Height of the Dust Collector
HEIGHT=20;

// Diameter of your Drill (add some clearing, 0.1-0.2mm should be fine)
DRILL_DIA=7.7;

// Upper Diameter of the Dust Collector
UPPER_DIAMETER=120;

// Lower Diameter of the Dust Collector
LOWER_DIAMETER=80;

// Upper Back fold height (put to 0 if not wanted)
BACK_FOLD_HEIGHT = 35;

// Upper Back fold Diameter
BACK_FOLD_DIAMETER = 135;

WALL=2;

$fn=100;

difference() {
  union() {
    difference() {
      cylinder(r1=LOWER_DIAMETER/2+WALL, r2=UPPER_DIAMETER/2+WALL, h=HEIGHT+WALL, center=false);
      translate([0,0,WALL+0.01]) cylinder(r1=LOWER_DIAMETER/2, r2=UPPER_DIAMETER/2, h=HEIGHT, center=false);
    }
  cylinder(r=DRILL_DIA/2+WALL,h=HEIGHT/3.5);
  }
  translate([0,0,-0.1]) cylinder(r=DRILL_DIA/2, h=HEIGHT);
}

if (BACK_FOLD_HEIGHT > 0)
  translate([0,0,HEIGHT+WALL]) 
    difference() {
      cylinder(r1=UPPER_DIAMETER/2+WALL, r2=BACK_FOLD_DIAMETER/2+WALL, h=BACK_FOLD_HEIGHT+WALL, center=false);
      translate([0,0,(-0.01)]) cylinder(r1=UPPER_DIAMETER/2, r2=BACK_FOLD_DIAMETER/2, h=BACK_FOLD_HEIGHT+WALL+0.02, center=false);
    }

