package com.ixiyou.managers.html 
{
	import flash.events.EventDispatcher;
	import com.ixiyou.utils.core.Singleton;
	import flash.external.ExternalInterface
	/**
	 * 参考flashyiyi的BrowerManager类，主要负责FLASH嵌入的HTML的页面的控制
	 * http://code.google.com/p/ghostcat/
	 * 
	 * 
	 * @author spe
	 */
	public class HtmlManager extends EventDispatcher
	{
		[Embed(source = "HtmlManager.js",mimeType="application/octet-stream")]
		private static var jsCode:Class;
		ExternalInterface.available && ExternalInterface.call("eval", new jsCode().toString());
		/**
		 * 单例模式获取
		 */
		static public function get instance():HtmlManager
		{
			return Singleton.getInstanceOrCreate(HtmlManager) as HtmlManager;
		}
		/**
		 * 浏览器完整地址
		 * @return 
		 * 
		 */
		public function get url():String
        {
        	return ExternalInterface.call("BrowerManager.getURL");
        };
		
	}

}