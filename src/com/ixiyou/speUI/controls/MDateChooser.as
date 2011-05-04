package com.ixiyou.speUI.controls 
{
	import com.ixiyou.events.ListEvent;
	import com.ixiyou.speUI.controls.skins.ButtonSkin;
	import com.ixiyou.speUI.core.SpeComponent;
	import com.ixiyou.utils.display.DisplayCopy;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import com.greensock.TweenLite
	
	/**
	 * 日期选择器
	 * @author magic
	 */
	public class MDateChooser extends SpeComponent
	{
		private var _tempBitmapData:BitmapData;
		private var _tempA:Bitmap;
		private var _tempB:Bitmap;
		private var _tempC:Bitmap;
		private var _tempDate:Date;
		private var _swapBox:Sprite;
		private var _imgMonthDateA:Shape;
		private var _imgMonthDateB:Shape;
		private var _monthText:Array = ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"];
		private var _headSpace:Number = 25;
		private var _monthSKin:Class = ButtonSkin;
		protected var _dateTable:MDateTable;
		protected var _monthTable:Sprite;
		protected var _yearBtn:MButton;
		protected var _rightBtn:MButton;
		protected var _leftBtn:MButton;
		protected var _shower:Sprite;
		protected var _showType:uint = 0;
		protected var _monthBtns:Array;
		protected var _fc:FormatCell;
		
		
		public static const DATE:uint = 0;
		public static const MONTH:uint = 1;
		
		public function MDateChooser(config:*=null) 
		{
			super(config);
			_fc = new FormatCell();
		}
		/**
		 * 初始化
		 */
		override public function initialize():void 
		{
			super.initialize();
			_dateTable = new MDateTable();
			_dateTable.setCellSize(30, 15);
			_dateTable.y = _headSpace;
			_tempDate = _dateTable.date;
			_yearBtn = new MButton( { width:100, height:20 } );
			_yearBtn.addEventListener(MouseEvent.CLICK, onYearClick);
			_yearBtn.label = String(2010);
			_shower = new Sprite();
			_swapBox = _dateTable;
			_shower.addChild(_dateTable);
			_yearBtn.x = (_shower.width - _yearBtn.width) * .5;
			_shower.addChild(_yearBtn);
			addChild(_shower);
			_rightBtn = new MButton( { width:30, height:20, x:270, label :"next" } );
			_leftBtn = new MButton( { width:30, height:20, label:"prev" } );
			addChild(_rightBtn);
			addChild(_leftBtn);
			_rightBtn.addEventListener(MouseEvent.CLICK,onRightClick);
			_leftBtn.addEventListener(MouseEvent.CLICK, onLeftClik);
			scrollRect = new Rectangle(0, 0, 310, 222);
			upSize();
		}
		/**
		 * 更新组件
		 */
		override public function upSize():void 
		{
			if (!_initialized) return;
			_dateTable.setSize(_width, _height - _headSpace);
			_yearBtn.x = (_width - _yearBtn.width) * 0.5;
			_rightBtn.x = (_width - _rightBtn.width);
			flushMonthTable();
			scrollRect = new Rectangle(-50, 0, _width+50, _height);
		}
		
		/**
		 * 跳到指定的时间
		 * @param	date
		 */
		public function goto(date:Date):void {
			_tempDate = date;
			var temp:int = date.getFullYear() - _dateTable.year;
			if(_tempBitmapData==null){
				_tempBitmapData = DisplayCopy.copyAsBitmapData(_shower);
				_tempA = new Bitmap(_tempBitmapData);
				_tempB = new Bitmap(_tempBitmapData);
				_tempC = new Bitmap(_tempBitmapData);
				_shower.addChild(_tempA);
				_shower.addChild(_tempB);
				_shower.addChild(_tempC);
				_shower.filters = [new BlurFilter(16, 0, 1)];
			}
			TweenLite.to(_shower,0.2,{ x:-300 * temp,onUpdate:onMoving,onComplete:onMoveOver } );
		}
		
		/**
		 * 刷新月份表
		 */
		public function flushMonthTable():void {
			var temp:Sprite = getMonthTable();
			_fc.distanceX = _width / 4;
			_fc.distanceY = (_height-_headSpace) / 3;
			_fc.initX = (_fc.distanceX - _fc.width) * 0.5;
			_fc.initY = (_fc.distanceY - _fc.height) * 0.5;
			for (var i:int = 0; i < 12; i++) {
				var mb:MButton = _monthBtns[i];
				mb.setSize(_fc.width, _fc.height);
				mb.y = int(int(i / 4) * _fc.distanceY+_fc.initY);
				mb.x = int((i % 4) * _fc.distanceX+_fc.initX);
			}
		}
		
		/**
		 * 设置月份列表单元宽高
		 * @param	w
		 * @param	h
		 */
		public function setMonthSize(w:Number, h:Number):void {
			_fc.width = w;
			_fc.height = h;
			flushMonthTable();
		}
		
		/**
		 * 后一年
		 */
		public function nextYear():void {
			_tempDate.fullYear++;
			goto(_tempDate);
		}
		/**
		 * 前一年
		 */
		public function prevYear():void {
			_tempDate.fullYear--;
			goto(_tempDate);
		}
		
		/**
		 * 当前显示的类型 MONTH||DATE
		 */
		public function get showType():uint { return _showType; }
		public function set showType(value:uint):void 
		{
			if (value == _showType) return;
			if (value != MONTH && value != DATE) return;
			_imgMonthDateA = DisplayCopy.copyAsShape(_swapBox);
			_shower.addChild(_imgMonthDateA);
			_shower.removeChild(_swapBox);
			_showType = value;
			if (_showType == MONTH) {
				_swapBox = getMonthTable();
			}else if (_showType == DATE) {
				_swapBox = _dateTable;
				stage.addChild(_swapBox);
				stage.removeChild(_swapBox);
			}
			_imgMonthDateB = DisplayCopy.copyAsShape(_swapBox);
			_shower.addChild(_imgMonthDateB);
			monthDateChange();
		}
		/**
		 * 月份值
		 */
		public function get monthText():Array { return _monthText; }
		public function set monthText(value:Array):void 
		{
			_monthText = value;
			for (var i:int = 0; i < 12; i++) {
				_monthBtns[i].label = _monthText[i];
			}
		}
		
		/**
		 * 月份按钮
		 */
		public function get monthBtns():Array { return _monthBtns; }
		
		/**
		 * 月份按钮皮肤
		 */
		public function get monthSKin():Class { return _monthSKin; }
		public function set monthSKin(value:Class):void 
		{
			_monthSKin = value;
			if (_monthTable != null) {
				for (var i:int = 0; i < 12; i++) {
					_monthBtns[i].skin = new _monthSKin();
				}
			}
		}
		
		/**
		 * 获取月份表
		 * @return
		 */
		protected function getMonthTable():Sprite {
			if (_monthTable == null) {
				_monthTable = new Sprite();
				_monthTable.y = _headSpace;
				_monthBtns = new Array(12);
				for (var i:int = 0; i < 12; i++) {
					var mb:MButton = new MButton();
					_monthBtns[i] = mb;
					_monthTable.addChild(mb);
					mb.label = _monthText[i];
					mb.addEventListener(MouseEvent.CLICK, onMonthClik);
				}
			}
			return _monthTable;
		}
		
		/**
		 * 年份过渡动画更新
		 */
		private function onMoving():void {
			_tempA.x = -int(_shower.x / 300) * 300;
			_tempB.x = -int(_shower.x / 300) * 300-300;
			_tempC.x = -int(_shower.x / 300) * 300+300;
		}
		/**
		 * 年分过渡动画结束
		 */
		private function onMoveOver():void {
			_shower.removeChild(_tempA);
			_shower.removeChild(_tempB);
			_shower.removeChild(_tempC);
			_tempBitmapData.dispose();
			_tempBitmapData = null;
			_shower.x = 0;
			_dateTable.date = _tempDate;
			_yearBtn.label = String(_tempDate.getFullYear());
			_shower.filters = null;
		}
		/**
		 * 月份按钮被点击
		 * @param	me
		 */
		private function onMonthClik(me:MouseEvent):void {
			_dateTable.month = _monthBtns.indexOf(me.currentTarget);
			showType = DATE;
			
		}
		/**
		 * 前一年按钮被点击
		 * @param	me
		 */
		private function onLeftClik(me:MouseEvent):void {
			prevYear();
		}
		 /**
		  * 下一年按钮被点击
		  * @param	me
		  */
		private function onRightClick(me:MouseEvent):void {
			nextYear();
		}
		/**
		 * 年份按钮被点击
		 * @param	me
		 */
		private function onYearClick(me:MouseEvent):void {
			showType = MONTH;
		}
		
		/**
		 * 切换日期月份显示
		 */
		private function monthDateChange():void {
			var mb:MButton = _monthBtns[_dateTable.month];
			var time:Number = .3;
			if (_showType == DATE) {
				_imgMonthDateB.scaleY = _imgMonthDateB.scaleX = 1;
				_imgMonthDateB.x = 0;
				_imgMonthDateB.y = _headSpace;
				TweenLite.from(_imgMonthDateB, time, { alpha:0, x:mb.x, y:mb.y + 25, width:mb.width, height:mb.height } );
				TweenLite.to(_imgMonthDateA, time, { alpha:0 ,onComplete:overChange} );
			}else {
				TweenLite.to(_imgMonthDateA, time, { alpha:0,x:mb.x,y:mb.y+45,width:mb.width,height:mb.height} );
				TweenLite.from(_imgMonthDateB, time, { alpha:0,onComplete:overChange } );
			}
		}
		/**
		 * 日期月份切换动画结束
		 */
		private function overChange():void {
			_shower.removeChild(_imgMonthDateA);
			_shower.removeChild(_imgMonthDateB);
			_shower.addChild(_swapBox);
		}
	}
}

class FormatCell {
	public var width:Number = 50;
	public var height:Number = 30;
	public var distanceX:Number = 0;
	public var distanceY:Number = 0;
	public var initX:Number=0;
	public var initY:Number=0;
}
