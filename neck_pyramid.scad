sideLength=36;
frontLength=44;

sideHalf=sideLength / 2;
frontHalf=frontLength / 2;

neckHeight=21.2;
neckDiameter=15.98;

neckRadius=neckDiameter / 2;

height=neckHeight;

polyhedron(
  points=[ [sideHalf,frontHalf,0],[sideHalf,-frontHalf,0],[-sideHalf,-frontHalf,0],[-sideHalf,frontHalf,0], // the four points at base
           [0,0,height]  ],                                 // the apex point 
  faces=[ [0,1,4],[1,2,4],[2,3,4],[3,0,4],              // each triangle side
              [1,0,3],[2,1,3] ]                         // two triangles for square base
 );
 
color("Lime") {
    cylinder(h=neckHeight, r1=neckRadius, r2=neckRadius);
}