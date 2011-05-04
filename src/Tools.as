package
{

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.*;
	import flash.display.*;
	import flash.system.System

	import com.ixiyou.utils.display.MovieUtils;
	/**
	 * 常用工具
	 * @author spe email:md9yue@@q.com
	 */
	public class Tools
	{
		/**
		 * 动画播放控制
		 * @param movie 影片对象
		 * @param value 播放的帧 或着帧的标签
		 * @param endFun 播放结束执行事件
		 *
		 */
		public static function movieFrame(movie:MovieClip, value:*,endFun:Function=null):void{
			MovieUtils.movieFrame(movie,value,endFun)
		}
		/**
		 * 删除动画控制
		 * @param movie
		 *
		 */
		public static function removeMovie(movie:MovieClip):void{
			MovieUtils.removeMovie(movie)
		}
		/**
		 * 编码转换 是否GBK或UTF8
		 * @param	value
		 */
		public static function toGBKUTF8(value:Boolean):void
		{
			System.useCodePage=value;
		}

		/**
		 * js 调用
		 * @param	fun
		 * @param	value
		 */
		public static function callJs(fun:String, value:String):void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.call(fun, value)
			}
		}

		/**
		 *
		 * @param fun
		 * @param value
		 * @param value1
		 */
		public static function callJs2(fun:String, value:String, value1:String):void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.call(fun, value, value1)
			}
		}

		/**
		 *
		 * @param fun
		 * @param arr
		 */
		public static function callJsArr(fun:String, ... arr):void
		{
			if (ExternalInterface.available)
			{
				if (arr.length == 0)
					ExternalInterface.call(fun)
				if (arr.length == 1)
					ExternalInterface.call(fun, arr[0])
				if (arr.length == 2)
					ExternalInterface.call(fun, arr[0], arr[1])
				if (arr.length == 3)
					ExternalInterface.call(fun, arr[0], arr[1], arr[2])
				if (arr.length == 4)
					ExternalInterface.call(fun, arr[0], arr[1], arr[2], arr[3])
				if (arr.length == 5)
					ExternalInterface.call(fun, arr[0], arr[1], arr[2], arr[3], arr[4])
			}
		}

		/**
		 * 简单数据提交交互
		 */
		public static function getDataUrl(url:String, barkFun:Function, errorFun:Function=null):URLLoader
		{
			var request:URLRequest=new URLRequest(url)
			var loader:URLLoader=new URLLoader()
			if (errorFun == null)
			{
				loader.addEventListener(IOErrorEvent.IO_ERROR, function():void
					{
						trace('提交 ERROR: ' + url + '\n')
					})
			}
			else
			{
				loader.addEventListener(IOErrorEvent.IO_ERROR, errorFun)
			}
			loader.addEventListener(Event.COMPLETE, barkFun)
			loader.load(request)
			return loader
		}

		/**
		 *
		 * @param url
		 */
		public static function getToURL(url:String):void
		{
			sendToURL(new URLRequest(url))
		}

		/**
		 * 简单数据提交交互
		 */
		public static function postDataUrl(url:String, barkFun:Function, data:Object=null, errorFun:Function=null, contentType:String='application/x-www-form-urlencoded'):URLLoader
		{
			var request:URLRequest=new URLRequest(url)
			request.contentType=contentType
			if (data)
			{
				var variables:URLVariables=new URLVariables();
				for (var prop:*in data)
				{
					variables[prop]=data[prop]
				}
				//trace(url,' post>>>: ',variables.toString())
				request.data=variables
			}
			request.method=URLRequestMethod.POST;
			var loader:URLLoader=new URLLoader()
			if (errorFun == null)
			{
				loader.addEventListener(IOErrorEvent.IO_ERROR, function():void
					{
						trace('提交 ERROR: ' + url + '\n')
					})
			}
			else
			{
				loader.addEventListener(IOErrorEvent.IO_ERROR, errorFun)
			}
			loader.addEventListener(Event.COMPLETE, barkFun)
			loader.load(request)
			return loader
		}

		/**
		 * 打开窗口
		 * @param	url
		 * @param	window
		 */
		public static function getUrl(url:String, window:String='_blank'):void
		{
			navigateToURL(new URLRequest(url), window)
		}

		/**
		 * 返回交互错误提取
		 * @param	value
		 * @return
		 */
		public static function getNetError(value:String):String
		{
			if (value.indexOf('Error') == 0)
			{
				var num:uint=value.indexOf(':')
				return value.slice(num + 1)
			}
			else
			{
				return 'true'
			}
		}
	}

}