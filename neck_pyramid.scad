sideLength=36;
frontLength=44;

sideHalf=sideLength / 2;
frontHalf=frontLength / 2;

neckHeight=21.2;
neckDiameter=15.98;

neckRadius=neckDiameter / 2;

height=neckHeight+8;


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
        //}
    }
}

// Remove points from pyramid support.
difference() {
    pyramid(sideHalf,frontHalf,height,neckRadius);
    translate([0, 0, neckHeight - 2]) cylinder(h=6, r1=neckRadius + 6, r2=neckRadius + 6);
}