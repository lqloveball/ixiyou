package  
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.*;
	import flash.events.TimerEvent
	/**
	 * .倒计时
	 * @author spe email:md9yue@qq.com
	 */
	public class timeDemo extends Sprite
	{
		private var someday:Date
		public function timeDemo() 
		{
			var myTimer:Timer=new Timer(1000,0);
			myTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			myTimer.start();
			someday = new Date(2010,5, 4, 20, 0);
			
		}
		public function function clearBox(value:DisplayObjectContainer):void {
			while(value.numChildren>0)value.removeChildAt(0)
		}
		private function timerHandler(e:TimerEvent):void {
			var now:Date = new Date()
			var time:Number = someday.getTime() - now.getTime()
			//someday.getSeconds
			//trace( time % (1000 * 60 * 60 * 24))
			//天 1000*60*60*24
			var sy:uint=(1000 * 60 * 60 * 24)
			var day:uint = time / sy >> 0
			sy=time % (1000 * 60 * 60 * 24)
			var hours:uint = sy / (1000 * 60 * 60) >> 0
			sy=sy%(1000 * 60 * 60) 
			var minutes:uint = sy / (1000 * 60 ) >> 0
			sy=sy%(1000 * 60 ) 
			var seconds:uint = sy/ (1000  ) >> 0
			trace('相差',
			someday.getFullYear() - now.getFullYear(), '年', 
			someday.getMonth() - now.getMonth() ,'月',
			day, '天',
			hours, '小时',
			minutes, '分钟',
			seconds, '秒'
			)
		}
	}

}