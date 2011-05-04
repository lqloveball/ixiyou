package com.ixiyou.utils 
{
	
	/**
	 * 垃圾回收
	 * @author spe
	 */
	import flash.net.LocalConnection
	import flash.system.System;
	public class Md9gc 
	{
		/**
		 * GC回收
		 */
		public static function gc():void{
			System.gc()
		}
		/**
		 * 强力回收
		 */
		public static function haymaker():void {
				try
			{
				 var lc1:LocalConnection = new LocalConnection();
				 var lc2:LocalConnection = new LocalConnection();
				 lc1.connect("gcConnection");
				 lc2.connect("gcConnection");
			}
			catch (e:Error) { }
			System.gc()
		}
	}
	
}