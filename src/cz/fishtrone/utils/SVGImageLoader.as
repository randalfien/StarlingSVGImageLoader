package cz.fishtrone.utils
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import org.svgweb.core.SVGViewer;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
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
		private var _maxWidth:Number = Number.MAX_VALUE;
		
		private var _img:Image;
		private var _smoothing:String;
		
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
			_img = new Image(tempTexture);
			_img.scaleX = attrWidth;
			_img.scaleY = attrHeight;
			
			addChild(_img);
			
			svg.addEventListener(Event.COMPLETE, onComplete);		
			svg.loadURL(url);
			
			function onComplete(e:Object):void
			{
				dispatchEventWith(Event.COMPLETE);
				
				var maxScale:Number = Math.min( 2048/svg.width, 2048/svg.height ); //max texture size
				
				var w:Number = svg.declaredWidth || svg.width;
				var h:Number = svg.declaredHeight || svg.height;
				
				if( width > 0 )
				{
					svg.scaleX =  Math.min( scaleX * width/w , maxScale ); 
					svg.width = Math.min( svg.width, maxWidth );
					svg.scaleY = svg.scaleX; //keep aspect ratio
				}
				else if (height > 0)
				{
					svg.scaleY =  Math.min( scaleY * height/h , maxScale ); 
					svg.scaleX = svg.scaleY; //keep aspect ratio
				}else{   //width and height not set
					svg.width = Math.min( w*scaleX, maxWidth );
					svg.scaleX =  Math.min( svg.scaleX, maxScale ); 
					svg.scaleY = svg.scaleX; //keep aspect ratio
				}
				
				_img.scaleX = 1/scaleX;
				_img.scaleY = 1/scaleY;
				
				var a:flash.display.Sprite = new flash.display.Sprite();//hack to scale correctly
				a.addChild(svg);
				
				if( a.width <= 0 || a.height <= 0 ){
					trace("Warning: rendered svg empty "+url); //avoid Invalid BitmapData error
					return;
				}
				
				bmpData = new BitmapData(a.width, a.height, true, 0x0);
				bmpData.draw(a);
				
				_img.texture = Texture.fromBitmapData(bmpData);
				_img.smoothing = _smoothing;
				_img.readjustSize();
				svg.removeEventListener(e.type, arguments.callee);
				svg.dispose();
			}
			
		}
		
		public function get smoothing():String	{		return _smoothing;	}
		/**
		 * Smoothing to apply to the image  @see TextureSmoothing
		 */ 
		public function set smoothing(value:String):void	{	_smoothing = value;	if (_img ) _img.smoothing = value;	}
		
		public function get maxWidth():Number	{		return _maxWidth;	}
		/**
		 * Max width for the scaled image. When you specify exact width or height it gets ignored 
		 */ 
		public function set maxWidth(value:Number):void	{		_maxWidth = value;	}
		
	}
}