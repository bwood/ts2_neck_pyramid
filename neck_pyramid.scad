sideLength=36;
frontLength=44;

sideHalf=sideLength / 2;
frontHalf=frontLength / 2;


// TODO: Increase the height for the extension accessory?
neckHeight=21.2;
height=neckHeight+8;

// Neck extension accessory bottom diameter.
neckDiameterBottom=19.55;
// Neck extension accessory top diameter just before cutout for mouthpiece.
neckDiameterTop=18.25;
neckRadiusBottom=neckDiameterBottom / 2;
neckRadiusTop=neckDiameterTop / 2;

baseOffset=4;





// Remove space for existing neck.
module pyramid (
    sideHalf,
    frontHalf,
    height
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
        cylinder(h=height, r1=neckRadiusBottom, r2=neckRadiusTop);
    }
}

// Remove points from pyramid support.
module pyramid01(
    sideHalf,
    frontHalf,
    height
) {
    
    
    difference() {
        pyramid(sideHalf,frontHalf,height);
        translate([0, 0, neckHeight - 2]) cylinder(h=6, r1=neckRadiusBottom + 6, r2=neckRadiusTop + 6);
    }
}

// Create the base plate
module base (
    sideHalf,
    frontHalf,
    height,
    baseOffset
) {

    x = sideHalf - baseOffset;
    y = frontHalf - baseOffset;
    z = height - baseOffset;

    difference() {
        pyramid(x,y,z);
        translate([0,0, (z / 2) + baseOffset]) cube([y * 2, y * 2, z], center = true);
    }        
}

// The base with the neck base removed.
module baseNeckBase(
    sideHalf,
    frontHalf,
    height,
    baseOffset
) {
    
    // Local Variables
    // There is a raised ring at the base of the existing TS2 neck.  We will call this the "neck base".
    neckBaseDiameter=21.65;
    neckBaseRadius=neckBaseDiameter / 2;
    neckBaseHeight=3;

    // remove short cylinder for neck base
    difference() {
        base(sideHalf,frontHalf,height,baseOffset);
        cylinder(h=neckBaseHeight, r1=neckBaseRadius, r2=neckBaseRadius);
    }
}

//TODO: Reinforce clip base connection.
module clip0(x, y, z) {
    color("Lime") {
        cube([x, y, z], center = true);
        translate([0, 0, (z / 2) - y]) sphere(r = y); 
    }
}

clipHeight = 8;
clipWidth = 2; 
clipThickness = 2; 

// Better clip with fillets
module clip(h, w, t) {
    color("Lime") {
        rotate([90, 0, 0]) {
            linear_extrude(t/2) {
                translate([0, w/2, 0])
                    offset(-2) offset(2) {
                        square([h, w], center = true);
                        translate([0, (h/2) + (w/2), 0])
                            // Bottom square
                            square([w, h], center = true);
                    }
            }
        }
    }
}

// Base with clips.
module baseClips (
    sideHalf,
    frontHalf,
    height,
    baseOffset,
    clipX,
    clipY,
    clipZ
) {
    baseNeckBase(sideHalf,frontHalf,height,baseOffset);
    
    translate([0, 13, (clipZ / 2) + baseOffset]) 
        clip(clipX, clipY, clipZ);
    translate([0, -13, (clipZ / 2) + baseOffset]) 
        clip(clipX, clipY, clipZ);

// For simplicty and ease of removal, try just 2 clips first. 
//    rotate([0, 0, 90]) 
//        translate([0, 10.5, (clipZ / 2) + baseOffset]) 
//            clip(clipX, clipY, clipZ);
//    rotate([0, 0, 90]) 
//        translate([0, -10.5,(clipZ / 2) + baseOffset]) 
//            clip(clipX, clipY, clipZ);    
}

// Remove the base plate from the pyramid.
module pyramid02 (
    sideHalf,
    frontHalf,
    height
) {
     difference() {
        pyramid01(sideHalf,frontHalf,height);
        
        //TODO: BaseClipsNeg: internal ridge for bump. Extra space behind the clip to allow for flex
        // Remove base, not baseNeckBase. The latter would leave material where the neck base ring was removed.
        base(sideHalf,frontHalf,height,baseOffset);
    }   
}



pyramid02(sideHalf,frontHalf,height);

bZ = -25;

translate([0, 0, bZ]) 
    baseClips(
        sideHalf,
        frontHalf,
        height,
        baseOffset,
        clipHeight,
        clipWidth,
        clipThickness
        );
//

//clip(clipHeight, clipWidth, clipThickness);


