package cz.fishtrone.util
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import org.svgweb.core.SVGViewer;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	/**
	 * SVG Image Loader
	 * dipatches Event.COMPLETE when loading finished.
	 * Specify width and height to display placeholder (otherwise 20x20 px).
	 * Scale this loader (scaleX,scaleY) before loading and it will scale the vector image before rasterizing.  
	 * <br>
	 * Example: <br>
	 * 			var ld:SVGImageLoader = new SVGImageLoader();      			<br>
				ld.load( "http://server.com/resource.svg" ); 	<br>
				ld.scaleX = ld.scaleY = 3; 									<br>
				addChild(ld);  												<br>
	 */ 
	public class SVGImageLoader extends starling.display.Sprite
	{
		public function SVGImageLoader(url:String = null, width:int = -1, height:int = -1)
		{
			if( url )
			{
				load( url, width, height );
			}
		}
		
		public function load(url:String, width:int = -1, height:int = -1):void
		{
			var svg:SVGViewer = new SVGViewer();	
			
			var attrWidth:Number = width > 0 ? width : 20 ;
			var attrHeight:Number = height > 0 ? height : 20;
			
			// A placeholder image, set to 1 px to save memory
			var bmpData:BitmapData = new BitmapData( 1, 1, false, 0xCACACA);
			var tempTexture:Texture = Texture.fromBitmapData(bmpData);
			var img:Image = new Image(tempTexture);
			img.scaleX = attrWidth;
			img.scaleY = attrHeight;
			
			addChild(img);
			
			if( url.indexOf("svg") < 0 )
			{
				trace("UNSUPPORTED IMAGE:"+url);
				return;
			} 
			
			svg.addEventListener(Event.COMPLETE, onComplete);
			
			svg.loadURL(url);
			
			function onComplete(e:Object):void
			{
				dispatchEventWith(Event.COMPLETE);
				var maxScale:Number = 2048/svg.width; //max texture size
				svg.scaleX = Math.min( scaleX, maxScale);
				svg.scaleY = Math.min( scaleY, maxScale);
				var a:flash.display.Sprite = new flash.display.Sprite();//hack to scale correctly
				a.addChild(svg);
				bmpData = new BitmapData(a.width, a.height, true, 0x0);
				bmpData.draw(a);
				img.scaleX = 1/svg.scaleX; 
				img.scaleY = 1/svg.scaleY;
				img.texture = Texture.fromBitmapData(bmpData);
				img.readjustSize();
				svg.removeEventListener(e.type, arguments.callee);
				svg.dispose();
			}
			
		}
		
	}
}