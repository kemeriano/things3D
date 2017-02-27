////////////////////////////////////////////////////////////////////////////////
///
///  AA2C - Yet Another Battery Sabot to Use AA Cells instead of C Size Cells
///
///  This simple project provides an battery adapter that allows using AA size
///  cells in appliances made for C size cells.
///
///  The construction consists of two thin cylinder which are not entirely close
///  but joined by two tight turns which form a small gap.  The construction is
///  inherently flexible forming a kind of spring that encloses the AA cell.
///  On top and bottom the outer cylinder is chamfered, whereas the inner cylinder
///  is chamfered only on the top and has a brim on the bottom, so that the 
///  inserted battery cannot slip out.
///
///  To insert and release the battery, it is easiest to slightly spread the gap
///  with the two thumbs, so that the cylinders get widened, so that the battery
///  cell easily slides in or out.
///
///  Given the springy nature of the sabot, the material of choice for printing
///  is ABS.
///
///  The OpenScad source for this project is based on the snakeline approach,
///  a library which makes extensive use of OpenScad's child concept.  Each curve
///  is coded as a single statement where each subsequent child adds another segment
///  starting at the point and direction the last segment ended.
///  
////////////////////////////////////////////////////////////////////////////////
///
///  2016-08-14 Heinz Spiess, Switzerland
///
///  released under Creative Commons - Attribution - Share Alike licence
////////////////////////////////////////////////////////////////////////////////
use <snakeline.scad>;

ew=0.56;     // extrusion width
eh=0.252;    // extrusion height

$fn=72;      // angular precision

module batadap(
   di=14.0,  // inner diameter
   do=24.5,  // outer diameter
   h=48.0,   // height
   w=2*ew,   // wall thickness
   hb=2*eh,  // brim height
   wb=ew,    // brim width to keep battery from falling out at the bottom
   ht=2,     // chamfer height on top and bottom
   hs=-0.4,  // chamfer skewness
   a=320,    // angular coverage 
){
   // outer radius
   ro=do/2-w/2; 
   // inner radius
   ri=di/2+w/2;

   // Note the "missing" semicolons in the calls to the snakeline modules!
   // They make the next segment become a "child" to the previous line(s),
   // so that they are executed relatively to where the last segment ended.

   // small initial radius to connect bottom chamfer to brim
   slini([0,ri-hs*ht,0],90,0,w=w,h=ht+0.01)
   slrad(90,w,w=w,h=ht+0.01,skew=hs)
   ;
   // chamfer part on bottom
   slini([0,ri-hs*ht,0],-90,0,w=w,h=ht+0.01)         // position to inner cylinder
   slrad(180,(ro-ri)/2+hs*ht,w=w,h=ht+0.01,skew=-hs) // tight turn to outer cylinder
   slrad(a,ro+hs*ht,w=w,h=ht+0.01,skew=-hs)          // outer cylinder
   slrad(180,(ro-ri)/2+hs*ht,w=w,h=ht+0.01,skew=-hs) // tight turn back to inner cylinder
   slrad(-90,w,w=w,h=ht+0.01,skew=-hs) // small final radius to connect bottom chamfer to brim
   ;
   slini([0,ri,0],90,0,w=w,h=ht+0.01) // reposition for inner cylinder
   slrad(a,ri,w=w,h=ht+0.01)          // inner cylinder
   ;
   // main middle cylinder part
   translate([0,0,ht])
   slini([0,ro,0],90,0,w=w,h=h-2*ht)  // position to outer cylinder
   slrad(a,ro,w=w,h=h-2*ht)           // outer cylinder
   slrad(180,(ro-ri)/2,w=w,h=h-2*ht)  // tight turn to inner cylinder
   slrad(-a,ri,w=w,h=h-2*ht)          // inner cylinder
   slrad(180,(ro-ri)/2,w=w,h=h-2*ht)  // tight turn back to outer cylinder
   ;
   // chamfer part on top
   translate([0,0,h-ht-0.01])
   slini([0,ro,0],90,0,w=w,h=ht,skew=hs) // position to outer cylinder
   slrad(a,ro,w=w,h=ht,skew=hs)          // outer cylinder
   slrad(180,(ro-ri)/2,w=w,h=ht,skew=hs) // tight turn to inner cylinder
   slrad(-a,ri,w=w,h=ht,skew=hs)         // inner cylinder
   slrad(180,(ro-ri)/2,w=w,h=ht,skew=hs) // tight turn back to outer cylinder
   ;

   // brim on bottom to keep battery from falling out
   slini([0,ri-w/2,0],90,0,w=2*wb,h=hb,skew=wb/hb) // position to inner edge of inner cylinder
   slrad(a,ri-w/2,w=2*wb,h=hb,skew=wb/hb)  // brim at inner cylinder with inward skew
   ;

}

batadap();
//translate([48,0,48])rotate([180,0,0])rotate(15) batadap();
//translate([-12,-42,12.25])rotate(25)rotate([0,90,0]) rotate(120)batadap();
