package com.ixiyou.utils.net
{
	
	/**
	* 简单的通信处理
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	import flash.net.*
	public class NetUtil 
	{
		
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