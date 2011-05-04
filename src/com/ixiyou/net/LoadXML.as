package  com.ixiyou.net
{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	public class LoadXML extends EventDispatcher {
		public static var COMPLETE:String="load_XML_COMPLETE";
		//事件对象列表
		private var objects:Dictionary;
		private var _xml:XML;
		public function LoadXML(path:String = null, Loaded:Function = null) {
			if(path!=null)load(path,Loaded)
		}
		public function load(path:String,Loaded:Function=null):void {
			_xml=null
			var loader:URLLoader=new URLLoader();
			var requestt:URLRequest = new URLRequest(path);
			loader.load(requestt);
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, io_Error);
			if(Loaded!=null)addEventListener(LoadXML.COMPLETE,Loaded)
		}
		private function io_Error(e:IOErrorEvent):void {

		}
		private function onComplete(event:Event):void {
			var loader:URLLoader = event.target as URLLoader;
			if (loader != null) {
			   _xml = new XML(loader.data);
			   dispatchEvent(new Event(LoadXML.COMPLETE));
			} else {
			    trace("错误");
			}
		}
		public function get xml():XML{return _xml}
	}//end LoadXML
}