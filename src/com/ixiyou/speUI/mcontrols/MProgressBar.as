package com.ixiyou.speUI.mcontrols 
{
	
	import com.ixiyou.speUI.collections.skins.ProgressBarSkin;
	import com.ixiyou.speUI.core.ISkinComponent;
	import com.ixiyou.speUI.collections.MSprite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Loader
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	[Event(name="complete",type="flash.events.Event")]
	[Event(name="io_error",type="flash.events.IOErrorEvent")]
	/**
	 * 进度条组件
	 * @author spe
	 */
	public class MProgressBar extends MSprite implements ISkinComponent
	{
		//加载对象
		protected var _target:EventDispatcher;
		protected var startTime:int;
		protected var _bytesLoaded:int;
		protected var _bytesTotal:int;
		
		//进度条皮肤
		protected var _skin:*
		protected var _progerss:MovieClip
		protected var _text:TextField
		//文本显示模式
		public var mode:uint=1
		public function MProgressBar(config:*=null) 
		{
			super(config)
			if (config) {
				if (config.skin != null) skin = config.skin
				if(config.mode!=null)mode=config.mode
				if(config.target != null)target=config.target 
			}
			if(skin==null )skin=null
		}
		/**设置组件皮肤*/
		public function get skin():*{return _skin}
		public function set skin(value:*):void {
			if (value is Sprite) {
				try {
					var _skinSpr:Sprite
					if(_skin&&this.contains(_skin as Sprite))removeChild(_skin as Sprite)
					_skinSpr=_skin = value as Sprite;
					_skinSpr.x = _skinSpr.y = 0;
					addChild(_skinSpr);
					if (_skinSpr.getChildByName('_text'))_text = _skinSpr.getChildByName('_text') as TextField;
					if (_skinSpr.getChildByName('_progerss'))_progerss = _skinSpr.getChildByName('_progerss') as MovieClip
					_progerss.stop()
					setSize(_skinSpr.width,_skinSpr.height)
					//upSize()
				}catch (e:TypeError) {
					skin=new ProgressBarSkin()
				}
			}else if (value == null){skin=new ProgressBarSkin()}
		}
		/**
		 * 大小更新
		 */
		override public function upSize():void {
			trace('MProgressBar', width, height);
		}
		/**
		 * 设置进度条目标。请在load方法执行前设置。
		 * 
		 * @return 
		 * 
		 */
		public function get target():EventDispatcher{return _target;}
		public function set target(value:EventDispatcher):void
		{
			if (_target == value) return;
			removeEvents()
			_target = value
			_target.addEventListener(Event.OPEN,openHandler);
			_target.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			_target.addEventListener(Event.COMPLETE,completeHandler);
			_target.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			startTime = getTimer()
		}
		/**
		 * 开始加载
		 * @param	event
		 */
		private function openHandler(event:Event):void
		{
			startTime = getTimer();
		}
		/**
		 * 加载进度
		 * @param	event
		 */
		private function progressHandler(event:ProgressEvent):void
		{
			
			_bytesLoaded = event.bytesLoaded;
			_bytesTotal = event.bytesTotal;
			var str:String
			if (_text) {
				if (mode == 1) {
					str=(loadPercent * 100).toFixed(1) + "%"
				}else if (mode == 2) {
					str=bytesLoaded + "/" + bytesTotal
				}else {
					str= (loadPercent * 100).toFixed(1) + "%" + 
					"(" + bytesLoaded + "/" + bytesTotal + ")";
					str += "\n已用时：" + progressTimeString +
						"\n预计剩余时间：" + progressNeedTimeString;
				}
				_text.text=str
			}
			if (_progerss) {
				_progerss.gotoAndStop((event.bytesLoaded/event.bytesTotal* 100)>>0)
			}
			this.dispatchEvent(event);
		}
		/**
		 * 加载完成
		 * @param	event
		 */
		private function completeHandler(event:Event):void
		{
			//"加载完成";
			if (_progerss) _progerss.gotoAndStop(100)
			if (_text)_text.text="加载完成"	
			removeEvents();
			this.dispatchEvent(event);
		}
		/**
		 * 加载出现错误
		 * @param	event
		 */
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			//"加载失败";
			if (_text)_text.text="加载失败"	
			removeEvents();
			this.dispatchEvent(event);
		}
		/**
		 * 删除事件
		 */
		private function removeEvents():void
		{
			if (target)
			{
				target.removeEventListener(Event.OPEN,openHandler);
				target.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
				target.removeEventListener(Event.COMPLETE,completeHandler);
				target.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			}
		}
		/**
		 * 已加载的字节数
		 * 
		 * @return 
		 * 
		 */
		public function get bytesLoaded():int{return _bytesLoaded;}
		/**
		 * 总字节数
		 * 
		 * @return 
		 * 
		 */
		public function get bytesTotal():int{	return _bytesTotal;}
		/**
		 * 当前进度百分比
		 */
		public function get loadPercent():Number
		{
			return bytesLoaded/bytesTotal;
		}
		/**
		 * 加载已经用的时间
		 * 
		 * @return 
		 * 
		 */		
		public function get progressTime():int { return getTimer() - startTime; }
		public function get progressTimeString():String{	return timeToString(progressTime)}
		/**
		 * 预计还需要的时间
		 * 
		 * @return 
		 * 
		 */
		public function get progressNeedTime():int{return progressTime * (1 / loadPercent - 1);}
		public function get progressNeedTimeString():String{return timeToString(progressNeedTime)}
		/**
		 * 把时间转换成格式化得样式
		 * @param	t
		 * @return
		 */
		private function timeToString(t:int):String
		{
			t /= 1000;
			var min:int = int(t / 60);
			var sec:int = t % 60;
			return (min>0)?(min.toString()+"分"):""+sec.toString()+"秒";
		}		
		/**
		 * 摧毁
		 */
		override public function destory():void
		{
			super.destory();
			removeEvents();
		}
	}

}