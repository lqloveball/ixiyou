package com.ixiyou.speUI.controls 
{
	import com.ixiyou.events.ResizeEvent;
	import com.ixiyou.speUI.controls.MDateTableBase;
	import com.ixiyou.speUI.core.VContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * 日期显示表格
	 * @author magic
	 */
	public class MDateTable extends MDateTableBase
	{
		protected var _weekHead:Sprite;
		protected var _weekDays:Array;
		protected var _dayCells:Array;
		public function MDateTable(config:*=null) 
		{
			super(config);
			__init__(config);
		}
		/**
		 * 初始化
		 * @param	config
		 */
		protected function __init__(config:*= null):void {
			_weekHead = new Sprite();
			_weekHead.opaqueBackground = 0xcccccc;
			_dayCells = new Array(7);
			for (var i:int = 0; i < 7; i++) {
				var tf:TextField = new TextField();
				_dayCells[i] = tf;
				tf.autoSize = "center";
				tf.selectable = false;
				_weekHead.addChild(tf);
			}
			weekDays = ["日", "一", "二", "三", "四", "五", "六"];
			addChild(_weekHead);
		}
		
		/**
		 * 更新大小
		 */
		override public function upSize():void 
		{
			var distance:Number = _width / 7;
			_weekHead.graphics.lineStyle(3, 0xcc0000,0);
			_weekHead.graphics.drawRect(0, 0, _width, 10);
			for (var i:int = 0; i < 7; i++) {
				var tf:TextField = _dayCells[i] as TextField;
				tf.x = i * distance;
				tf.width = distance;
			}
			var temp:Number = _height;
			_height -= _weekHead.height;
			super.upSize();
			_box.y=_weekHead.height;
			_height = temp;
			//graphics.clear();
			//graphics.lineStyle(1, 0xcccccc);
			//graphics.drawRect(0, 0, _width, _height);
		}
		
		/**
		 * 星期值
		 */
		public function get weekDays():Array { return _weekDays; }
		public function set weekDays(value:Array):void 
		{
			_weekDays = value;
			for (var i:int = 0; i <7 ; i++) {
				var ml:TextField = _dayCells[i] as TextField ;
				ml.text = value[i];
			}
		}
	}
}