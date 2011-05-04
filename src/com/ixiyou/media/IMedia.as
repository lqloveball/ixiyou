package com.ixiyou.media
{
	import flash.media.SoundTransform;
	
	/**
	 * 播放器控制接口 播放声音与视频
	 * @author ChenXiaolin
	 */
	public interface IMedia 
	{
		/**
		 * 媒体地址
		 */
		function get url():String;
		function set url(value:String):void;
		
		/**
		 * 当前播放时间
		 */
		function get time():Number;
		/**
		 * 是否循环播放
		 */
		function get loop():Boolean;
		function set loop(value:Boolean):void;
		/**
		 * 播放
		 * @param	value
		 */
		function play(value:Number = 0):void;
		/**
		 * 暂停
		 */
		function pause():void;
		/**
		 * 播放/暂停
		 */
		function togglePause():void;
		
		/**
		 * 声音选项
		 */
		function get soundTransform():SoundTransform;
		function set soundTransform(value:SoundTransform):void;
		
		/**
		 * 时间长度
		 */
		function get duration():Number;
		
		/**
		 * 加载进度
		 */
		function get loadProgress():Number;
		
		/**
		 * 缓冲时间
		 */
		function get bufferTime():Number;
		function set bufferTime(value:Number):void;
		/**
		 * 关闭下载的流
		 */
		function close():void;
	}
	
}