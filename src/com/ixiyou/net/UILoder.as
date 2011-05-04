package  com.ixiyou.net
{
	
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	import flash.system.ApplicationDomain
	import flash.events.EventDispatcher
	import flash.events.Event
	import flash.utils.ByteArray
	import com.ixiyou.net.ClassLoader
	
	public class UILoder extends EventDispatcher
	{
		private var uiLoad:ClassLoader=new ClassLoader()
		private var _Data:ApplicationDomain//UI对象类获取
		
		public function UILoder(obj:Object = null) 
		{
			uiLoad.addEventListener(Event.COMPLETE,COMPLETE)
			load(obj)
		}
		/**分装数据
		* @param 
		* @return 
		*/
		protected function completeEvent():void {
			/*这里进行数据封装*/
			this.dispatchEvent(new Event(Event.COMPLETE))
		}
		/**加载UI数据
		* @param 
		* @return 
		*/
		public function load(obj:Object = null):void {
			if (obj is ByteArray) {
				_Data=null
				uiLoad.loadBytes(obj as ByteArray);
				
			}else if (obj is String) {
				_Data=null
				uiLoad.load(obj as String);
			}
			else if (obj is ApplicationDomain) {
				_Data = (obj as ApplicationDomain)
				completeEvent()
			}
		}
		/**使用
		* @param 
		* @return 
		*/
		private function COMPLETE(e:Event):void {
			_Data = uiLoad.loader.loaderInfo.applicationDomain
			completeEvent()
		}
		public function get Data():ApplicationDomain { return _Data; }
		/**
		 * 获取定义
		 * @param 
		 * @return 
		*/
		
		public function getClass(className:String):Object {
			if (_Data) return _Data.getDefinition(className);
			else return null
			//throw new Error("错误:不存在");
		  
		}
		/**
		 * 是否含有该定义
		 * @param 
		 * @return 
		*/
		public function hasClass(className:String):Boolean {
			if (_Data) {
				return _Data.hasDefinition(className);
			}
			else {
				return false
			}
		}
	}
	
}