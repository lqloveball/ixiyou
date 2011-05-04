package com.ixiyou.utils.net
{
	
	import flash.net.*;
	/**
	* 多了本地保存
	* @author
	*/
	
	public class NetUtilCS4 
	{
		
		protected static var saveData:FileReference = new FileReference()
		/**保存数据
		 * 
		 * @param 
		 * @return 
		*/
		public static function save(Stream:*,defaultFileName:String = null):void {
			saveData.save(Stream,defaultFileName)
		}
		/**打开网页
		 * 
		 * @param 
		 * @return 
		*/
		public static function getUrll(url:String, window:String = "_blank"):void {
			var getURLRequest:URLRequest = new URLRequest(url)
			navigateToURL(getURLRequest,window);
		}
		/**
		 * post数据
		 * @param 
		 * @return 
		*/
		public static function post(url:String,data:*=null,window:String="_blank"):void {
			var getURLRequest:URLRequest = new URLRequest(url)
			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			getURLRequest.requestHeaders.push(header);
			getURLRequest.method = URLRequestMethod.POST;
			getURLRequest.data = data;
			navigateToURL(getURLRequest,window);
		}
	}
	
}