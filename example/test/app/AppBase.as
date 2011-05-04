package  
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ProgressEvent;
	import br.com.stimuli.loading.BulkLoader
	import br.com.stimuli.loading.BulkProgressEvent;
	import meeting.model.*;
	import meeting.controller.*;
	import meeting.view.*;
	/**
	 * 程序单列
	 * @author spe
	 */
	public class AppBase
	{
		private static var _instance:AppBase
		public static function get instance():AppBase {
			if (_instance) return _instance
			_instance = new AppBase()
			return _instance
		}
		//场景
		public var stage:Stage
		//文档类位置
		public var root:Sprite
		//资源加载队列
		public var loadList:BulkLoader
		//默认数据
		public var defaultData:Object
		//界面
		public var ui:AppUI
		//网络通讯
		public var net:AppNet
		//数据
		public var data:AppData
		public var controller:AppController
		public function AppBase() 
		{
			loadList=new BulkLoader('meetingLib')
			data = new AppData()
			net=new AppNet()
			ui = new AppUI()
			controller=new AppController()
		}
		/**
		 * 开始执行
		 */
		public function start():void {
			defaultData=stage.loaderInfo.parameters
			if (defaultData) {
				if (defaultData.userID) data.user.userID = defaultData.userID
				if (defaultData.userPassword) data.user.userPassword = defaultData.userPassword
				if (defaultData.roomID) data.room.roomID = defaultData.roomID
			
			}
			loadList.add('skins/lib.swf',{id:'skin'})
			loadList.addEventListener(BulkProgressEvent.COMPLETE,libComplete)
			loadList.start()
		}
		/**
		 * 资源文件加载完毕
		 * @param	e
		 */
		private function libComplete(e:ProgressEvent):void 
		{
			var skibLib:MovieClip = loadList.getContent('skin')
			ui.skin.setUISkin(skibLib)
			controller.init()
			controller.setLogin()
		}
	}

}