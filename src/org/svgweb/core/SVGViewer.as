package org.svgweb.core
{

    import flash.display.Sprite;
    import flash.events.ContextMenuEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    
    import org.svgweb.events.SVGEvent;
    import org.svgweb.nodes.SVGSVGNode;

    public class SVGViewer extends Sprite
    {
        public var svgRoot:SVGSVGNode;
        
        // flag that indicates whether this viewer is in the middle of a 
        // suspendRedraw operation
        public var isSuspended:Boolean = false;
        protected var urlLoader:URLLoader;
		private var _url:String;
        public function SVGViewer() {
            XML.ignoreProcessingInstructions = false;
            XML.ignoreComments = false;
            super();
        }

        public function loadURL(url:String):void {
			_url = url;
            urlLoader = new URLLoader();
            urlLoader.load(new URLRequest(url));
            urlLoader.addEventListener(Event.COMPLETE, onComplete);
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
        }

        protected function onComplete(event:Event):void {
			try{
            	xml = new XML(urlLoader.data);
			}catch( e:TypeError ){
				trace("unsupported:" + _url);
			}
            urlLoader = null;
        }

        protected function onIOError(event:IOErrorEvent):void {
            trace("IOError: " + event.text);
            urlLoader = null;
        }

        protected function onSecurityError(event:SecurityErrorEvent):void {
            trace("SecurityError: " + event.text);
            urlLoader = null;
        }

        public function getWidth():Number {
            return 0;
        }

        public function getHeight():Number {
            return 0;
        }

        public function set xml(value:XML):void {
            if (svgRoot != null) {
                this.removeChild(svgRoot.topSprite);
            }
            svgRoot = new SVGSVGNode(null, value, null, this);
			svgRoot.addEventListener(SVGEvent.SVGLoad, onLoaded);
            this.addChild(svgRoot.topSprite);
        }
		
		protected function onLoaded(event:Event):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
        public function get xml():XML {
            return this.svgRoot.xml;
        }

        public function handleScript(script:String):void {

        }

        public function addActionListener(eventType:String, target:EventDispatcher):void {

        }

        public function removeActionListener(eventType:String, target:EventDispatcher):void {

        } 
        
		public function get loader():URLLoader{
			return urlLoader;
		}
		
		public function dispose():void
		{
			_url = null;
			svgRoot = null;
			removeChildren();
		}
	}
}
