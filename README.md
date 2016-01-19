## SVG Image Loader

*Vector SVG for Starling (Adobe AIR) using SvgWeb*

### Description
Modified code from: SVG Web: https://code.google.com/p/svgweb/  (see their license)
Simple container to download, resterize and display SVG images 

* Dipatches Event.COMPLETE when loading finished.
* Specify width and height to display placeholder (otherwise 20x20 px).
* Scale this loader (scaleX,scaleY) before loading and it will scale the vector image before rasterizing.  

### Example
var ld:SVGImageLoader = new SVGImageLoader();      			
ld.load( "http://server.com/resource.svg" );
ld.scaleX = ld.scaleY = 3; 					
addChild(ld);  								

