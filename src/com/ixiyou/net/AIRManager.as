package com.ixiyou.net 
{
	import adobe.utils.ProductManager;
	import com.ixiyou.utils.compareVersions;
	import flash.events.Event;
	import flash.net.LocalConnection;
	import flash.system.Capabilities;
	/**
	 * 在flash中探测、安装AIR运行环境
	 * 在flash中执行、下载安装AIR应用程序
	 * @author magic
	 */
	public class AIRManager
	{
		/**
		 * 该功能需要的flashplayer版本
		 */
		private static const FFVERSION:String = "9,0,115,0";
		private static const FFVERSION_LINUX:String = "10,0,15,3";
		
		private var _product:ProductManager;
		private var _airInstaller:ProductManager;
		private static var lcVersionID:uint = 0;
		public function AIRManager()
		{
			checkFlashPlayer();
			_product = new ProductManager("airappinstaller");
		}
		
		/**
		 * 是否安装AIR运行环境
		 */
		public function get installed():Boolean {
			return _product.installed;
		}
		
		/**
		 * 下载并安装AIR
		 */
		public function downAndInstallAIR(complete:Function):void {
			_airInstaller = new ProductManager("airinstaller1x0");
			_airInstaller.addEventListener(Event.COMPLETE, complete);
			_airInstaller.download();
		}
		
		/**
		 * 
		 * @param	appUrl AIR程序的位置 必须以"http://"或"https://"开头
		 */
		public function  installedApp(appUrl:String):void {
			if (_product.installed) {
				_product.launch("-url " + appUrl);
			}else {
				_airInstaller = new ProductManager("airinstaller1x0");
				if (_airInstaller.installed) {
					_airInstaller.launch("-x1 " + appUrl);
				}else {
					_airInstaller.addEventListener(Event.COMPLETE, function(e:Event):void {
							_airInstaller.launch("-x1 " + appUrl);
						})
					_airInstaller.download();
				}
			}
		}
		
		
		/**
		 * 运行一个AIR程序
		 * @param	appID		application Id  可在AIR程序的application.xml文件中查看
		 * @param	publisherid	publisher id	可在AIR程序的publisherid文件中查看
		 * @param	params		可选启动参数
		 */
		public function launchApp(appID:String, publisherid:String, params:Array = null):void {
			var args:String = "";
			if (params && params.length > 0) {
				args = params.join(" ");
			}
			_product.launch("-launch " + appID + " " + publisherid + " " + args);
		}
		
		/**
		 * 获取已有AIR Application的版本
		 * @param	appID		application Id  可在AIR程序的application.xml文件中查看
		 * @param	publisherid	publisher id	可在AIR程序的publisherid文件中查看
		 * @param	callBack	回调版本号
		 */
		public function getAppVersion(appID:String, pushID:String, callBack:Function):void {
			var localName:String = "air" + lcVersionID++;
			new AppVersion(localName, callBack);
			_product.launch("-isinstalled "+appID+" "+pushID+" adobe.com:"+localName+" onApplicationVersion");
		}
		
		/**
		 * AIR运行环境版本
		 */
		public function get vserion():String {
			return _product.installedVersion;
		}
		
		/**
		 * 检查flashplayer版本是否足够高
		 */
		private function checkFlashPlayer():void {
			var ffv:String = Capabilities.version;
			ffv = ffv.substr(ffv.indexOf(" "));
			var os:String = Capabilities.os;
			if (os.indexOf("Linux") == 0) {
				if (compareVersions(ffv, FFVERSION_LINUX) == -1) throw new Error("需要flashplyer"+FFVERSION_LINUX+"或更高版本");
			}else {
				if (compareVersions(ffv, FFVERSION) == -1) throw new Error("需要flashplyer"+FFVERSION+"或更高版本");
			}
		}
	}
}

import flash.events.TimerEvent;
import flash.net.LocalConnection;
import flash.utils.Timer;
/**
 * 检验AIR程序版本用
 */
class AppVersion {
	private var lc:LocalConnection;
	private var id:String;
	private var time:Timer;
	private var back:Function;
	public function AppVersion(id:String, back:Function):void {
		this.id = id;
		this.back = back;
		lc = new LocalConnection();
		lc.client = this;
		lc.connect(id);
		time = new Timer(1000, 1);
		time.addEventListener(TimerEvent.TIMER_COMPLETE, onTime);
		time.start();
	}
	
	public function onApplicationVersion(v:String):void {
		time.removeEventListener(TimerEvent.TIMER_COMPLETE, onTime);
		time.stop();
		lc.close();
		back(v);
	}
	
	private function onTime(e:TimerEvent):void {
		onApplicationVersion(null);
	}
}