/////////////////////////////////////////////////////////////////////////////
/// 
/// SnakeLine - A library of modules for buildng "snake lines"
///
/// This file implements my so-called snakeline approach, a library
/// of functions that allow implementing line-typed objects as a sequence
/// of segments that are constructed in a relative manner, where each segment 
/// is defined relative to the end point and end direction of the last
/// segment.
///
/// The implementation is based on the child concept of OpenScad, each segment
/// is coded as a child of the previous segment. Branches are constructed
/// by defining several children for the same preceding segment, which is
/// done by using braces.
/// 
/// The following modules are available for defining snakeline segments:
///
///    slini:  initial segment defining the starting point and
///            direction
///
///    sllin:  straight line segment with a given length
///
///    slrad:  circle arc segment with given radius and turning angle
///
///    slrlr:  arc/line/arc segment with given starting radius, ending
///            radius and (relative!) end point
///
///    slend:  end segment
///
/////////////////////////////////////////////////////////////////////////////
///
///  2015-09-25 Heinz Spiess, Switzerland
///  2015-04-04 Heinz Spiess, Switzerland (initial version)
///
///  released under:
///  Creative Commons - Attribution - Share Alike licence (CC BY-SA)
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
// draw an conic arc width height h between radius r1..r2 and angles a1..a2
/////////////////////////////////////////////////////////////////////////////
module arc(r1,w,h,a1=0,a2=0,skew=0){
      if(r1+h*skew>=0) // simple case - cone vertex not in arc
         intersection(){
	    // construct full cone or cylinder
            difference(){
               mycone(r1=r1-w/2,r2=r1+h*skew-w/2,h=h,w=w);
               translate([0,0,-0.1])
	          mycone(r1=r1-0.1*skew-w/2,r2=r1+(h+0.1)*skew-w/2,h=h+0.2,w=0);
            }
      
            // now retain only the selected angles
            assign(n=ceil(abs(a2-a1)/90)*3)
	       for(i1=[0:3:n-1])
                  hull()for(i=[i1:i1+3]){
                     rotate(a1+i*(a2-a1)/n)translate([0,-0.01,-0.1])
	                cube([2*abs(r1+w)+max(h*skew,0),0.02,h+0.2]);
            }
      }else assign(hm=-r1/skew){  // cone contains vertex - split into 2 simple cones
         arc(r1,w,hm,a1,a2,skew);
	 translate([0,0,hm])arc(0,w,h-hm,a2-180,a1+180,-skew);
      }
}

//////////////////////////////////////////////////////////////////////////////////////
//
// mycone - draw a cone which can extend over the cone vertex (using negative radius)
//
//////////////////////////////////////////////////////////////////////////////////////
// Heinz Spiess, 2015-04-04 (CC BY-SA)
/////////////////////////////////////////////////////////////////////////////////
module mycone(r1,r2,h,w=0){
   if((r1>=0 && r2>=0) || r1==r2 ) // simple case, vertex not included
      cylinder(r1=abs(r1)+w,r2=abs(r2)+w,h);
   else assign(hm=h*r1/(r1-r2)){   // vertex included, draw 2 simple cones
      if(hm>0 && hm<h){
         //echo(r1,r2,hm,h);
         if(r1+w>0)cylinder(r1=abs(r1+w),r2=0+w,h=hm);
	 if(r2+w>0)translate([0,0,hm])cylinder(r1=0+w,r2=abs(r2+w),h=h-hm);
      }else // vertex outside selected height - also a simple cone
         cylinder(r1=abs(r1)+w,r2=abs(r2)+w,h=h);
   }
}

////////////////////////////////////////////////////////////////////////
// slini - start a snake line
////////////////////////////////////////////////////////////////////////
module slini(
  pos0,       // start position
  angle,      // starting angle
  shape,      // shape 0=open,1=closed,2=circled 
  w,          // wall thickness (mm)
  h,          // wall height (mm)
  skew=0,     // skewness of snake line
  eps=0.1,    // gap bridging distance between segments
  ){

  translate(pos0)
  rotate(angle+(shape*180))
  slrad(shape*180,0,w=w,h=h,skew=skew,eps=eps)
  if($children>0)children([0:$children-1]);
}

////////////////////////////////////////////////////////////////////////
// slend - end and close a snake line
////////////////////////////////////////////////////////////////////////
module slend(
  w,        // wall thickness (mm)
  h,        // wall height (mm)
  skew=0,   // skewness of snake line
  shape=1,  // shape 0=open,1=closed,2=circled 
  eps=0.1,  // gap bridging distance between segments
  ){
  slrad(shape*180,0,w=w,h=h,skew=skew,eps=eps)
  if($children>0)children([0:$children-1]);
}

/////////////////////////////////////////////////////////////////////////////////
// slrad - generate a curved "snake line" segment of width w and height h 
// with a arbitrary sequence of segments defined by a radius and a turning angle
//
//   angle > 0  left turn / counter-clockwise
//   angle < 0  left turn / clockwise
//   angle = 0  straight segment with length radius[i]
//   radius = 0 sharp angle 
//
/////////////////////////////////////////////////////////////////////////////////
// Heinz Spiess, 2015-04-04 (CC BY-SA)
/////////////////////////////////////////////////////////////////////////////////

module slrad(
  angle,    // array with segment angles (degrees)
  radius,   // array with segment radii or straight segment lengths (mm)
  w,        // wall thickness (mm)
  h,        // wall height (mm)
  skew=0,   // skewness of snake line
  eps=0.1,  // gap bridging distance between segments
  ){
   assign(r=abs(radius))assign(a=abs(angle))
      scale([(angle>=0)?1:-1,1,1]){
         translate([a?-r:0,0,0]){
	    color("red")translate([(a?r:0)-w/2,(a?0:r)-eps/2,0])
	       multmatrix(m=[[1,0,angle<0?-skew:skew,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]])
	          cube([w,eps,h]); // tiny overlap!
	    if(a)arc(r,w,h,0,a,angle>0?skew:-skew,$fn=max(ceil($fn*r/60)*4,24));
	    else if(r>0)translate([-w/2,0,0])
	       multmatrix(m=[[1,0,skew,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]])
	          cube([w,r,h]);
      if($children>0)
           rotate(a)
	      translate([a?r:0,a?0:r,0])
                 scale([(angle>=0)?1:-1,1,1])
		 // now proceed to children (e.g. next segment)
	            children([0:$children-1]);
      }
  }
}


////////////////////////////////////////////////////////////////////////////////
// sllin - generate a straight "snake line" of length l, width w and height h 
// with a arbitrary sequence of segments defined by a radius and a turning angle
//
////////////////////////////////////////////////////////////////////////////////
// Heinz Spiess, 2015-04-04 (CC BY-SA)
////////////////////////////////////////////////////////////////////////////////

module sllin(
  l,        // array with segment radii or straight segment lengths (mm)
  w,        // wall thickness (mm)
  h,        // wall height (mm)
  skew=0,   // skewness of snake line
  eps=0.1,  // gap bridging distance between segments
  w2 = -1,  // wall thickness at end of segment
  h2 = -1,  // wall height at end of segment
  ){
   assign(w1=(len(w)>0)?w[0]:w)
   assign(w2=(len(w)>0)?w[1]:w)
   assign(h1=(len(h)>0)?h[0]:h)
   assign(h2=(len(h)>0)?h[1]:h)
   assign(skew1=(len(skew)>0)?skew[0]:skew)
   assign(skew2=(len(skew)>0)?skew[1]:skew)
   assign(steps = (len(skew)>0||len(w)>0||len(h)>0)?ceil(l/2):1)
   {
      // overlap with last segment
      if(eps>0)color("red")translate([-w2/2,l-eps/2,0])
         multmatrix(m=[[1,0,skew2,0],
	               [0,1,0,0],[0,0,1,0],[0,0,0,1]])
            cube([w2,eps,h2]); // tiny overlap!

      // linear segment 
      for(step0 = [0:steps-1])
         hull()for(step = [step0:step0+1])
            translate([-(w1+step*(w2-w1)/steps)/2,step*(l-0.1)/steps,0])
               multmatrix(m=[[1,0,skew1+step*(skew2-skew1)/steps,0],
	                  [0,1,0,0],[0,0,1,0],[0,0,0,1]])
                  cube([w1+step*(w2-w1)/steps,0.1,h1+step*(h2-h1)/steps]);

      // now proceed to children (e.g. next segment)
      if($children>0)
	      translate([0,l,0])
	            children([0:$children-1]);
   }
}

////////////////////////////////////////////////////////////////////////////////
// slrlr - generate a 3-part radius/line/radius "snake line" segment with
// starting radius r1, endpoint [x2,y2], ending radius r2, width w and height h 
////////////////////////////////////////////////////////////////////////////////
// Heinz Spiess, 2015-04-04 (CC BY-SA)
////////////////////////////////////////////////////////////////////////////////

module slrlr(
   r1,       // signed starting radius
   angle,    // ending angle
   x2,       // relative end x-position
   y2,       // relative end y-position
   r2,       // ending radius
   w,        // wall thickness (mm)
   h,        // wall height (mm)
   skew=0,   // skewness of snake line
   eps=0.1,  // gap bridging distance between segments
   w2 = -1,  // wall thickness at end of segment
   h2 = -1,  // wall height at end of segment
   showcirc = false,
   ){
    
   assign(xb=x2+r2*cos(angle))
   assign(yb=y2+r2*sin(angle))
   assign(d=sqrt(yb*yb+(xb+r1)*(xb+r1)))
   assign(l=sqrt(d*d-(r2+r1)*(r2+r1)))
   assign(beta=atan2(yb,xb+r1))
   assign(alpha=atan2(l,r1+r2)){
     echo("xb=",xb," yb=",yb," d=",d," l=",l," beta=",beta," alpha=",alpha);
     if(showcirc){
     %translate([-r1,0,0])cylinder(r=abs(r1),h=0.2);
     %translate([xb,yb,0])cylinder(r=abs(r2),h=0.1);
     %translate([x2,y2,0])cylinder(r=1,h=1);
     }
     slrad((180-alpha-beta),abs(r1),w=w,h=h,skew=skew,eps=eps,w2=w2,h2=h2)
     sllin(l,w=w,h=h,skew=skew,eps=eps,w2=w2,h2=h2)
     slrad(angle-(180-alpha-beta),r2,w=w,h=h,skew=skew,eps=eps,w2=w2,h2=h2)
     if($children>0)children([0:$children-1]);
   }
}

