//linear_extrude(20) circle(100);
//translate([0,-10,-10]) linear_extrude(20) square(size=[10, 20], center=false);
//sphere(10);

module JustTheCavity()
{
    difference() {
      sphere(10, $fn=24);
      translate([0,-10,-10]) linear_extrude(20) square(size=[10, 20], center=false);
    }

    rotate([0, 90, 0]) linear_extrude(5) circle(10, $fn=24);

    translate([5,0,0])
    mirror([1,0,0])
    difference() {
      sphere(10, $fn=24);
      translate([0,-10,-10]) linear_extrude(20) square(size=[10, 20], center=false);
    }
}

module Cavity(radi, inlet=4, exciter=1)
{
  translate([5 + 5 + 5 -inlet,0,0])
  difference() {
    union() {
      JustTheCavity();
      translate([15-3,0,0]) // 3 == overlap to spherical shell
      rotate([0,90,0])
      linear_extrude(inlet+3.25) circle(radi, $fn=36); // 0.25 to overlap the cut on octagon edge
      // Tube to microphone
      translate([-45,0,0]) rotate([0,90,0])
            linear_extrude(40) circle(0.5, $fn=36);
    };
    // 1mm exciter... half way along the inlet
    translate([15 + inlet/2 - exciter/2,0,-radi]) // -1 is radius of pier
    linear_extrude(radi*2) square([exciter, exciter * 1.2]);
  }
}

// What it looks like if filled in
//translate([30, 0, -12]) Cavity(2.5);

// One cavity in a block
/*
difference() {
    linear_extrude(30) square([40, 30]);
    translate([40-30, 15, 15]) Cavity(2.5);
}
*/

module Inside() {
// central void, with buffer
//translate([0,0,13])
difference() {
  union() {
    linear_extrude(17) circle(12, fn=$64);
    // excitation cavities
    translate([30, 0, 15]) Cavity(2.5);
    rotate([0,0,45]) translate([30, 0, 15]) Cavity(2.25);
    rotate([0,0,90]) translate([30, 0, 15]) Cavity(2);
    rotate([0,0,135]) translate([30, 0, 15]) Cavity(1.75);
    rotate([0,0,180]) translate([30, 0, 15]) Cavity(1.5);
    rotate([0,0,-135]) translate([30, 0, 15]) Cavity(1.25);
    rotate([0,0,-90]) translate([30, 0, 15]) Cavity(1);
    rotate([0,0,-45]) translate([30, 0, 15]) Cavity(0.75);
  };
  translate([0,0,13]) linear_extrude(4) circle(8, fn=$64);
}
}

//Inside();

// Large octagon. Comment diff to see the voids

difference() {
rotate([0,0,22.5]) linear_extrude(30) circle(65, $fn=8);
Inside();
}

