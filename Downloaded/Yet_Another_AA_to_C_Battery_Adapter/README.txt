                   .:                     :,                                          
,:::::::: ::`      :::                   :::                                          
,:::::::: ::`      :::                   :::                                          
.,,:::,,, ::`.:,   ... .. .:,     .:. ..`... ..`   ..   .:,    .. ::  .::,     .:,`   
   ,::    :::::::  ::, :::::::  `:::::::.,:: :::  ::: .::::::  ::::: ::::::  .::::::  
   ,::    :::::::: ::, :::::::: ::::::::.,:: :::  ::: :::,:::, ::::: ::::::, :::::::: 
   ,::    :::  ::: ::, :::  :::`::.  :::.,::  ::,`::`:::   ::: :::  `::,`   :::   ::: 
   ,::    ::.  ::: ::, ::`  :::.::    ::.,::  :::::: ::::::::: ::`   :::::: ::::::::: 
   ,::    ::.  ::: ::, ::`  :::.::    ::.,::  .::::: ::::::::: ::`    ::::::::::::::: 
   ,::    ::.  ::: ::, ::`  ::: ::: `:::.,::   ::::  :::`  ,,, ::`  .::  :::.::.  ,,, 
   ,::    ::.  ::: ::, ::`  ::: ::::::::.,::   ::::   :::::::` ::`   ::::::: :::::::. 
   ,::    ::.  ::: ::, ::`  :::  :::::::`,::    ::.    :::::`  ::`   ::::::   :::::.  
                                ::,  ,::                               ``             
                                ::::::::                                              
                                 ::::::                                               
                                  `,,`


http://www.thingiverse.com/thing:1719966
Yet Another AA to C Battery Adapter by enif is licensed under the Creative Commons - Attribution - Share Alike license.
http://creativecommons.org/licenses/by-sa/3.0/

# Summary

This simple project provides an battery adapter that allows using AA size cells in appliances made for C size cells.

The construction consists of two thin cylinder which are not entirely close but joined by two tight turns which form a small gap.  The construction is inherently flexible forming a kind of spring that encloses the AA cell.  On top and bottom the outer cylinder is chamfered, whereas the inner cylinder is chamfered only on the top and has a brim on the bottom, so that the inserted battery cannot slip out.

To insert and release the battery, it is easiest to slightly spread the gap with the two thumbs, so that the cylinders get widened, so that the battery cell easily slides in or out.

Given the springy nature of the sabot, the material of choice for printing is ABS.

The OpenScad source for this project is based on the _snakeline_ approach, a library which makes extensive use of OpenScad's child concept.  Each curve is coded as a single statement where each subsequent child adds another segment starting at the point and direction the last segment ended. The SCAD source is as always fully parametrized and could easily be adapted for other sizes, if ever the need for this arises.

# Print Settings

Printer Brand: RepRap
Printer: DIY box-frame Prusa i3
Rafts: Doesn't Matter
Supports: No

Notes: 
I printed these battery holders on my DIY box-frame Prusa i3 using a 0.40mm nozzle with 0.25mm layer height and 0.56mm extrusion width. 

By default, the thickness of the springy cylinders is twice the extrusion width _ew_. If you have a significantly different extrusion width, for obtaining optimal spring strength, you might want to modify the _eh_ and _ew_ parameters in the SCAD file to fit your printer, and then rebuild all the STLs you need.

I print on a clear mirror without Kapton tape but thoroughly cleaned with acetone and double concentrated lemon juice.