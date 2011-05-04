package com.ixiyou.speUI.containers 
{
	import com.ixiyou.managers.DragHaulRectManager;
	import com.ixiyou.managers.MouseManager
	import com.ixiyou.speUI.containers.MPanelBase;
	import com.ixiyou.geom.DragEdge;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import com.ixiyou.speUI.mcontrols.CursorSprite
	/**
	 * 面板
	 * @author spe
	 */
	public class MPanel extends MPanelBase
	{
		//拉伸区域
		public var haulEdge:DragEdge
		protected var _minObj:Object = { w:100, h:100 }
		protected var _maxObj:Object = { w:100, h:100 }
		protected var _cursor:CursorSprite=CursorSprite.getInstance()
		public function MPanel(config:*=null) 
		{
			haulEdge = new DragEdge(this, 8)
			super(config)
		}
		/**
		 * 光标
		 */
		public function set cursor(value:CursorSprite):void 
		{
			if (_cursor == value) return
			_cursor=value
		}
		public function get cursor():CursorSprite { return _cursor; }
		/**
		 *最小区域  { w:100, h:100 }
		 */
		public function get min():Object { return _minObj; }
		/**
		 * 设置最小区域
		 * @param	w
		 * @param	h
		 */
		public function setMin(__w:uint=0,__h:uint=0):void 
		{
			if ((__w == 0 )&&( __h == 0))_minObj = null
			else _minObj = { w:__w, h:__h }
		}
		/**
		 *最大区域  { w:100, h:100 }
		 */
		public function get max():Object { return _maxObj; }
		/**
		 * 设置最大区域
		 * @param	w
		 * @param	h
		 */
		public function setMax(__w:uint=0,__h:uint=0):void 
		{
			if (__w == 0 && __h == 0)_maxObj = null
			else _maxObj={w:__w,h:__h}
		}
		/**
		 * 鼠标按下
		 * @param	e
		 */
		override protected function MOUSE_DOWN(e:MouseEvent):void {
		//	trace(e.target)
			if (e.target != this) return
			var num:uint = haulEdge.mouseRect(mouseX, mouseY)
			if (num==5) {
				super.MOUSE_DOWN(e)
			}else {
				DragHaulRectManager.getInstance().startDrag(this, num,_minObj)
			}
		}
		/**
		 * 鼠标放开
		 * @param	e
		 */
		override protected function MOUSE_UP(e:MouseEvent):void {
		
		}
		/**
		 * 鼠标移除
		 * @param	e
		 */
		override protected function MOUSE_OVER(e:MouseEvent):void {
			if (e.target != this)return
		}
		/**
		 * 鼠标移除
		 * @param	e
		 */
		override protected function MOUSE_MOVE(e:MouseEvent):void {
			//if (e.target != this) return
			var num:uint = haulEdge.mouseRect(mouseX, mouseY)
			//trace(num)
			if (num == 5) {
				MouseManager.getInstance().remove(this)
			}else {
				if (num == 1 || num == 9) cursor.setState(CursorSprite.RECT_1_9)
				else if (num == 2 || num == 8) cursor.setState(CursorSprite.RECT_2_8)
				else if (num == 3 || num == 7) cursor.setState(CursorSprite.RECT_3_7)
				else if(num == 4 || num == 6) cursor.setState(CursorSprite.RECT_4_6)
				MouseManager.getInstance().push(this,cursor)
			}
		}
		/**
		 * 重写绘制
		 */
		override public function upSize():void {
			super.upSize()
			haulEdge.upRect()
		}
	}

}