package com.ixiyou.geom 
{
	/**
	 * 计算边界拖动范围
	 * @author spe
	 */
	import flash.display.DisplayObject;
	import flash.geom.Rectangle
	public class DragEdge
	{
		private var _egde:uint
		//容器的Rectangle
		private var _rectp:Rectangle = new Rectangle()
		//内部区域的Rectangle
		private var _rectc:Rectangle = new Rectangle()
		private var _display:DisplayObject
		public function DragEdge(__display:DisplayObject=null,__egde:uint=5) 
		{
			if (__display) display = __display
			egde=__egde
		}
		/**
		 * 内部区域大小
		 */
		public function get neiRect():Rectangle { return _rectc; }
		/**
		 * 
		 * @param	x
		 * @param	y
		 * @return 不在下面范围就是0
		 *   ┌1─────2───────3─┐
		 *   │                │
		 *   │4      5       6│
		 *   │                │
		 * 	 └7──────8───────9┘
		 *  不在这范围内的尾0
		 */
		public function mouseRect(px:int, py:int):uint {
			if(!_rectp.contains(px, py))return 0
			if (_rectc.contains(px,py)) return 5
			if (px < _rectc.x  && _rectp.contains(px, py)) {
				if (py < _rectc.y) return 1
				if (py > _rectc.y && py < _rectc.y + _rectc.height) return 4
				if (py > _rectc.y + _rectc.height) return 7
			}
			if (px > _rectc.x&&px<(_rectc.x+_rectc.width)) {
				if (py < _rectc.y) return 2
				if (py > _rectc.y && py < _rectc.y + _rectc.height) return 5
				if (py > _rectc.y + _rectc.height) return 8
			}
			if (px>(_rectc.x+_rectc.width)&& _rectp.contains(px, py)) {
				if (py < _rectc.y) return 3
				if (py > _rectc.y && py < _rectc.y + _rectc.height) return 6
				if (py > _rectc.y + _rectc.height) return 9
			}
			return 0
		}
		/**
		 * 计算边界的对象
		 */
		public function set display(value:DisplayObject):void 
		{
			if (_display == value) return
			_display=value
			upRect()
		}
		public function get display():DisplayObject { return _display; }
		/**
		 * 更新现实对象区域
		 */
		public function upRect():void {
			_rectp.width = _display.width
			_rectp.height = _display.height
			_rectc.x = _egde
			_rectc.y = _egde
			_rectc.width = _rectp.width - _egde*2
			_rectc.height=_rectp.height- _egde*2
		}
		/**
		 * 没绑定显示对象纯粹计算时候使用
		 * @param	w
		 * @param	h
		 */
		public function upWHRect(w:uint,h:uint):void {
			_rectp.width =w
			_rectp.height =h
			_rectc.x = _egde
			_rectc.y = _egde
			_rectc.width = _rectp.width - _egde*2
			_rectc.height=_rectp.height- _egde*2
		}
		/**
		 * 设置边界
		 */
		public function set egde(value:uint):void 
		{
			_egde=value
		}
		public function get egde():uint { return _egde; }
	}

}