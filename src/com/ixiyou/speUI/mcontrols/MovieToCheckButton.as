package com.ixiyou.speUI.mcontrols 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent
	import com.ixiyou.events.SelectEvent;
	import com.ixiyou.speUI.core.Iselect
	import com.ixiyou.speUI.core.IDestory
	
	/**
	 * 多选按钮
	 * @author spe email:md9yue@qq.com
	 */
	public class MovieToCheckButton extends Sprite implements Iselect,IDestory
	{
		//选择锁定
		protected var _selectLock:Boolean = false
		private var _data:Object
		protected var _skin:MovieClip
		public function MovieToCheckButton(value:MovieClip,
			formerly:Boolean = false, parentBool:Boolean = false,
			select:Boolean=false,selectLock:Boolean=false) 
			{
			//trace(value)
			_skin=MovieToCheckButton.add(value,select,selectLock)
			if (formerly) {
				this.x = _skin.x
				this.y = _skin.y
				
			}
			if (_skin.parent && parentBool) {
				_skin.parent.addChild(this)
				this.name=_skin.name
			}
			//this.mouseChildren=false
			_skin.x = 0
			_skin.y=0
			addChild(_skin)
			//this.select = select
			//this.selectLock=selectLock
		}
		/**
		 * 删除索引
		 */
		public function destory():void {
			remove(_skin)
		}
		/**
		 * 设置锁定
		 */
		public function set selectLock(value:Boolean):void {
			selectLockFun(_skin,value)
		}
		public function get selectLock():Boolean {
			if (_skin.selectLock != null) return _skin.selectLock
			else return false
		}
		/**
		 * 设置选择
		 */
		public function set select(value:Boolean):void {
			selectFun(_skin,value)
		}
		public function get select():Boolean { 
			if (_skin.select != null) return _skin.select
			else return false
		}
		
		public function get data():Object { return _skin.data; }
		
		public function set data(value:Object):void 
		{
			_skin.data = value;
		}
	
		/**
		 * 添加
		 * @param	value 
		 * @param	selectLock  是否锁定，这样就可以直接当普通button用
		 * @param	select 选择是否 
		 * @return
		 */
		public static function add(value:MovieClip,select:Boolean=false,selectLock:Boolean=false):MovieClip {
			/**
			 * default
			 * movieIn
			 * on
			 * movieOut
			 * 
			 * selet
			 * smovieIn
			 * smovieOut
			 */
			value.buttonMode = true
			value.mouseChildren = false
			value.mouseEnabled = true
			selectFun(value,select)
			value.selectLock = selectLock
			value.md_mouuseDown=false
			value.addEventListener(MouseEvent.MOUSE_OVER,mouseOver)
			value.addEventListener(MouseEvent.MOUSE_OUT, mouseOut)
			value.addEventListener(MouseEvent.CLICK, mouseClick)
			value.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			return value
		}
		
		
		/**
		 *  按钮是否锁定
		 * @param	value
		 * @param	selectLock
		 */
		static public function selectLockFun(value:MovieClip,selectLock:Boolean):void {
			value.selectLock = selectLock
		}
		/**
		 * 设置按钮选择项
		 * @param	value
		 * @param	select
		 */
		static public function selectFun(value:MovieClip, select:Boolean):void {
			if (value.select == select) return
			if (value.selectLock) return
			value.select = select
			//trace('selectFun',value.name,value.select)
			if (value.select) {
				value.gotoAndStop('selet')
				//trace(value.currentLabel)
				value.dispatchEvent(new SelectEvent(SelectEvent.SELECT))
			}else {
				value.gotoAndStop('default')	
				value.dispatchEvent(new SelectEvent(SelectEvent.RESELECT))
			}
			
			value.dispatchEvent(new SelectEvent(SelectEvent.UPSELECT,null,value.select))
			
		}
		/**
		 * 鼠标点击
		 * @param	e
		 */
		static private function mouseClick(e:MouseEvent):void 
		{
			
			var value:MovieClip = e.target as MovieClip
			if (value.md_mouuseDown) return
			value.md_mouuseDown=false
			if (value.select) selectFun(value,false)
			else selectFun(value,true)
		}
		
		/**
		 * 鼠标Over
		 * @param	e
		 */
		static private function mouseOver(e:MouseEvent):void 
		{
			var value:MovieClip = e.target as MovieClip
			//trace('mouseOver',value.select)
			value.md_mouuseDown=false
			if (value.select) {
				if(value.currentLabel!='smovieIn')value.gotoAndPlay('smovieIn')
			}else {
				if(value.currentLabel!='movieIn')value.gotoAndPlay('movieIn')
			}
		}
		/**
		 * 鼠标out
		 * @param	e
		 */
		static private function mouseOut(e:MouseEvent):void 
		{
			var value:MovieClip = e.target as MovieClip
			//trace('mouseOut',value.select)
			value.md_mouuseDown=false
			if (value.select) {
				if(value.currentLabel!='smovieOut'&&value.currentLabel!='selet')value.gotoAndPlay('smovieOut')
			}else {
				if(value.currentLabel!='movieOut'&&value.currentLabel!='default')value.gotoAndPlay('movieOut')
			}
		}
		static private function mouseDown(e:MouseEvent):void 
		{
			var value:MovieClip = e.target as MovieClip
			//trace('mouseDown',value.select)
			value.md_mouuseDown=true
			if (value.select) selectFun(value,false)
			else selectFun(value,true)
		}
		/**
		 * 删除
		 * @param	value
		 * @return
		 */
		public static function remove(value:MovieClip):MovieClip {
			value.removeEventListener(MouseEvent.MOUSE_OVER,mouseOver)
			value.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut)
			value.removeEventListener(MouseEvent.CLICK, mouseClick)
			value.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			return value
		}
	}

}