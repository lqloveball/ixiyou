package  com.ixiyou.net
{
	
	/**
	* swf，jpg，png，gif等文件以字节的形式加载进来
	* 参考http://www.xiaos8.com/article.asp?id=89学习 所得
	* import index.base.net.ByteLoader;
		var bl:ByteLoader = new ByteLoader;
		bl.load("http://www.xiaos8.com/uploads/pro/50preso3a2.swf");
		bl.addEventListener(Event.COMPLETE,completeFun);
		bl.addEventListener(ProgressEvent.PROGRESS,progressFun);

		function completeFun(e:Event):void{
		  var loader:Loader = new Loader;
		  loader.loadBytes(bl.data);
		  addChild(loader);
		  bl.removeEventListener(Event.COMPLETE,completeFun);
		  bl.removeEventListener(ProgressEvent.PROGRESS,progressFun);
		  bl.close();
		  bl = null;
		}

		function progressFun(e:ProgressEvent):void{
		  trace(e.bytesLoaded);
		  //如果是渐进式格式的jpeg图片，那么在发布这个事件的时候读取字节，用Loader.loadBytes加载，就可以形成边加载边显示
		}
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.net.*; 
	import flash.system.LoaderContext
	public class ByteLoader extends EventDispatcher
	{
		
		public var url:String;
		public var data:ByteArray;
		private var stream:URLStream;
		
		public function ByteLoader(url:String = ""){
		  if(url != ""){
			load(url);
		  }
		}
		/**
		 * 加载对象
		 * @param 
		 * @return 
		*/
		public function load(_url:String):void{
		  url = _url;
		  data = new ByteArray();
		  stream = new URLStream();
		  stream.load(new URLRequest(url));
		  stream.addEventListener(Event.COMPLETE,completeFun);
		  stream.addEventListener(ProgressEvent.PROGRESS,progressFun);
		}
		/**
		 * 加载中
		 * @param 
		 * @return 
		*/
		private function progressFun(e:ProgressEvent):void{
		  if(stream.bytesAvailable == 0) return;
		  updata();
		  dispatchEvent(e);
		}
		/**
		 * 加载完成
		 * @param 
		 * @return 
		*/
		private function completeFun(e:Event):void{
		  stream.removeEventListener(Event.COMPLETE,completeFun);
		  stream.removeEventListener(ProgressEvent.PROGRESS,progressFun);
		  updata();
		  if(isLoad) stream.close();
		  dispatchEvent(e);
		}
		/**
		 * 更新数据 在加载过程中 时时更新新的数据 如：图片格式为jpg，并且是渐进式格式jpeg，那么该类还可以帮助你边加载边显示
		 * @param 
		 * @return 
		*/
		public function updata():void{
		  if(isLoad) stream.readBytes(data,data.length);
		}
		/**
		 * 清除数据 以便重新加载
		 * @param 
		 * @return 
		*/
		public function close():void{
		  if(isLoad) stream.close();
		  stream = null;
		  data = null;
		}
		/**
		 * 获取是否有数据在加载
		 * @param 
		 * @return 
		*/
		public function get isLoad():Boolean{
		  if(stream == null) return false;
		  return stream.connected;
		}

		
	}
	
}