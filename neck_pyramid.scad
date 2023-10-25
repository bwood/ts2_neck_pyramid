sideLength=36;
frontLength=44;

sideHalf=sideLength / 2;
frontHalf=frontLength / 2;

// TODO: Increase the height for the extension accessory?
neckHeight=21.2;
// TODO: Change to diameter of extension accessory. Consider raised insignia.
neckDiameter=15.98;
// TODO: Implement the base diameter and height.

neckRadius=neckDiameter / 2;
height=neckHeight+8;

baseOffset=4;

clipX = 5;
clipY = 2; //TODO: Flex?
clipZ = 12;
clipR = clipX;


// Remove space for existing neck.
module pyramid (
    sideHalf,
    frontHalf,
    height,
    neckRadius
) {
    difference() {
        polyhedron(
          points=[ [sideHalf,frontHalf,0],[sideHalf,-frontHalf,0],[-sideHalf,-frontHalf,0],[-sideHalf,frontHalf,0], // the four points at base
                   [0,0,height]  ],                                 // the apex point 
          faces=[ [0,1,4],[1,2,4],[2,3,4],[3,0,4],              // each triangle side
                      [1,0,3],[2,1,3] ]                         // two triangles for square base
         );
        
        //Uncomment color and remove difference to reveal neck cylinder. 
        //color("Lime") {
        cylinder(h=height, r1=neckRadius, r2=neckRadius);
    }
}

// Remove points from pyramid support.
module pyramid01(
    sideHalf,
    frontHalf,
    height,
    neckRadius
) {
    difference() {
        pyramid(sideHalf,frontHalf,height,neckRadius);
        translate([0, 0, neckHeight - 2]) cylinder(h=6, r1=neckRadius + 6, r2=neckRadius + 6);
    }
}

// Create the base plate
module base (
    sideHalf,
    frontHalf,
    height,
    neckRadius,
    baseOffset
) {

    x = sideHalf - baseOffset;
    y = frontHalf - baseOffset;
    z = height - baseOffset;

    difference() {
        pyramid(x,y,z,neckRadius);
        translate([0,0, (z / 2) + baseOffset]) cube([y * 2, y * 2, z], center = true);
    }
}

// Remove the base plate from the pyramid.
module pyramid02 (
    sideHalf,
    frontHalf,
    height,
    neckRadius
) {
     difference() {
        pyramid01(sideHalf,frontHalf,height,neckRadius);
        base(sideHalf,frontHalf,height,neckRadius,baseOffset);
    }   
}

//TODO: Reinforce clip base connection.
module clip(x, y, z) {
    color("Lime") {
        cube([x, y, z], center = true);
        translate([0, 0, (z / 2) - y]) sphere(r = y); 
    }
}

// pyramid02(sideHalf,frontHalf,height,neckRadius);

bZ = -25;
translate([0, 13, bZ + (clipZ / 2) + baseOffset]) clip(clipX, clipY, clipZ);
translate([0, -13, bZ + (clipZ / 2) + baseOffset]) clip(clipX, clipY, clipZ);
rotate([0, 0, 90]) translate([0, 10, bZ + (clipZ / 2) + baseOffset]) clip(clipX, clipY, clipZ);
rotate([0, 0, 90]) translate([0, -10, bZ + (clipZ / 2) + baseOffset]) clip(clipX, clipY, clipZ);

translate([0, 0, bZ]) base(sideHalf,frontHalf,height,neckRadius,baseOffset);




