package com.ixiyou.managers 
{
	
	
	/**
	 * 区块拖动拉伸管理器
	 * @author spe
	 */
	import flash.events.EventDispatcher;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.ixiyou.utils.display.BitmapData2String;
	public class DragHaulRectManager 
	{
		private static var instance:DragHaulRectManager;
		/**
		 * 返回这个类的实例，做为静态方法返回实例。这样保证这个实例是唯一
		 * @param 
		 * @return 
		*/
		public static function getInstance() : DragHaulRectManager {
			if (instance == null)
				instance = new DragHaulRectManager();
			return instance;
		}
		public var _stage:Stage
		/**
		 * 直接拖动
		 */
		public static const DIRECT:String = "direct";
		/**
		 * 复制一个区块并拖动
		 */
		public static const CLONERECT:String = "cloneRect";
		//事件对象
		private var cloneRectSpr:Sprite
		private var cloneRectShape:Shape
		private var cloneRectBmp:BitmapData
		private var currentObj:Sprite;
		private var currentType:uint;
		private var oldPoint:Point
		private var drawSize:uint=2
		private var max:Object
		private var min:Object
		public function DragHaulRectManager()
		{
			//[Embed(source='../../../../lib/bg.png')]
			//var _temp1:Class
			//var bmp:BitmapData
			//bmp= new _temp1().bitmapData
			//trace(BitmapData2String.encode64(bmp))
			cloneRectSpr = new Sprite()
			cloneRectSpr.mouseChildren = false
			cloneRectSpr.mouseEnabled=false
			cloneRectShape = new Shape()
			cloneRectSpr.addChild(cloneRectShape)
			cloneRectBmp = BitmapData2String.decode64('eNpjYGBg6AbiHgYoYGJgYgQAEHkBHQ==')
			
		}
		private function setRectObj(obj:Sprite):void {
			var w:uint=obj.width
			var h:uint = obj.height
			
			oldPoint = obj.parent.localToGlobal(new Point(obj.x, obj.y))
			cloneRectSpr.x = oldPoint.x
			cloneRectSpr.y = oldPoint.y
			cloneRectShape.graphics.clear()
			cloneRectShape.graphics.beginBitmapFill(cloneRectBmp)
			cloneRectShape.graphics.moveTo(0, 0)
			cloneRectShape.graphics.lineTo(w, 0)
			cloneRectShape.graphics.lineTo(w, h)
			cloneRectShape.graphics.lineTo(0, h)
			cloneRectShape.graphics.lineTo(0, 0)
			cloneRectShape.graphics.moveTo(drawSize, drawSize)
			cloneRectShape.graphics.lineTo(w - drawSize, drawSize)
			cloneRectShape.graphics.lineTo(w - drawSize, h - drawSize)
			cloneRectShape.graphics.lineTo(drawSize, h -drawSize)
			cloneRectShape.graphics.lineTo(drawSize, drawSize)
			cloneRectShape.graphics.endFill()
		}
		private function setRect(w:uint, h:uint):void {
			cloneRectShape.graphics.clear()
			cloneRectShape.graphics.beginBitmapFill(cloneRectBmp)
			cloneRectShape.graphics.moveTo(0, 0)
			cloneRectShape.graphics.lineTo(w, 0)
			cloneRectShape.graphics.lineTo(w, h)
			cloneRectShape.graphics.lineTo(0, h)
			cloneRectShape.graphics.lineTo(0, 0)
			cloneRectShape.graphics.moveTo(drawSize, drawSize)
			cloneRectShape.graphics.lineTo(w - drawSize, drawSize)
			cloneRectShape.graphics.lineTo(w - drawSize, h - drawSize)
			cloneRectShape.graphics.lineTo(drawSize, h - drawSize)
			cloneRectShape.graphics.lineTo(drawSize,drawSize)
			cloneRectShape.graphics.endFill()
		}
		/**
		 * 开始拖动
		 * @param	obj 拉伸对象
		 * @param	value 拉伸点
		 *   ┌1─────2───────3─┐
		 *   │                │
		 *   │4      5       6│
		 *   │                │
		 * 	 └7──────8───────9┘
		 * @param	_min {w:1,h:1} 拉伸最小范围
		 * @param	_max {w:1,h:1} 拉伸最大范围
		 */
		public function startDrag(obj:Sprite, value:uint=9,_min:Object=null,_max:Object=null):void {
				if (!obj.stage) return
				stopDrag()
				if (value == 1 || value == 2 || value == 3 || value == 4 || value == 6 || value == 7 || value == 8 || value == 9) currentType = value
				else return
				currentObj = obj
				if (_min) min = _min
				else min = { w:1, h:1 }
				max=_max
				_stage = obj.stage
				setRectObj(currentObj)
				_stage.addChild(cloneRectSpr)
				_stage.addEventListener(MouseEvent.MOUSE_UP, MOUSE_UP)
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, MOUSE_MOVE)
				currentObj.addEventListener(Event.REMOVED_FROM_STAGE,REMOVED);
		}
		/**
		 * 默认停止当前
		 * @param	obj
		 */
		private function stopDrag():void {
			var obj:Sprite=currentObj
			if (!obj) return
			//停止拖动
			obj.stopDrag()
			obj.addEventListener(Event.REMOVED,REMOVED);
			//场景
			if (!_stage && obj.stage)_stage = obj.stage
			if (!_stage) return
			var newPoint:Point = currentObj.parent.globalToLocal(new Point(cloneRectSpr.x,cloneRectSpr.y))
			obj.x = newPoint.x
			obj.y = newPoint.y
			obj.width = cloneRectSpr.width
			obj.height=cloneRectSpr.height
			if (_stage && _stage.contains(cloneRectSpr))_stage.removeChild(cloneRectSpr)
			_stage.removeEventListener(MouseEvent.MOUSE_UP, MOUSE_UP)
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, MOUSE_MOVE)
			currentObj.removeEventListener(Event.REMOVED_FROM_STAGE,REMOVED);
			currentObj=null
			currentType=0
			oldPoint=null
			max=null
			min=null	
		}
		private function MOUSE_MOVE(e:MouseEvent):void {
			var w:Number
			var h:Number
			var x:Number
			var y:Number
			//trace(currentType)
			if (currentType == 1) {
				//算w
				w =(oldPoint.x-_stage.mouseX)+currentObj.width
				if (w < min.w) w = min.w
				if (max && w > max.w) w = max.w
				if (w < 1) w = 1
				//算X
				if (w >= currentObj.width) x=oldPoint.x-(w-currentObj.width)
				else x=oldPoint.x+(currentObj.width-w)
				cloneRectSpr.x=x
				//算h
				h =(oldPoint.y-_stage.mouseY)+currentObj.height
				if (h < min.h) h = min.h
				if (max && h > max.h) h = max.h
				if (h < 1) h = 1
				//算Y
				if (h >= currentObj.height) y=oldPoint.y-(h-currentObj.height)
				else y = oldPoint.y + (currentObj.height - h)
				cloneRectSpr.y=y
				setRect(w, h)
			}
			else if (currentType == 2) {
				//算h
				h =(oldPoint.y-_stage.mouseY)+currentObj.height
				if (h < min.h) h = min.h
				if (max && h > max.h) h = max.h
				if (h < 1) h = 1
				//算Y
				if (h >= currentObj.height) y=oldPoint.y-(h-currentObj.height)
				else y = oldPoint.y + (currentObj.height - h)
				cloneRectSpr.y=y
				setRect(currentObj.width, h)
			}
			else if (currentType == 3) {
				//算w
				w = _stage.mouseX - oldPoint.x
				if (w < min.w) w = min.w
				if (max && w > max.w) w = max.w
				if(w<1)w=1
				//算h
				h =(oldPoint.y-_stage.mouseY)+currentObj.height
				if (h < min.h) h = min.h
				if (max && h > max.h) h = max.h
				if (h < 1) h = 1
				//算Y
				if (h >= currentObj.height) y=oldPoint.y-(h-currentObj.height)
				else y = oldPoint.y + (currentObj.height - h)
				cloneRectSpr.y=y
				setRect(w, h)
			}
			else if (currentType == 4) {
				//算w
				w =(oldPoint.x-_stage.mouseX)+currentObj.width
				if (w < min.w) w = min.w
				if (max && w > max.w) w = max.w
				if (w < 1) w = 1
				//算X
				if (w >= currentObj.width) x=oldPoint.x-(w-currentObj.width)
				else x=oldPoint.x+(currentObj.width-w)
				cloneRectSpr.x=x
				setRect(w, cloneRectSpr.height)
			}
			if (currentType == 6) {
				//算w
				w = _stage.mouseX - oldPoint.x
				if (w < min.w) w = min.w
				if (max && w > max.w) w = max.w
				if(w<1)w=1
				setRect(w,cloneRectSpr.height)
			}
			else if (currentType == 7) {
				//算w
				w =(oldPoint.x-_stage.mouseX)+currentObj.width
				if (w < min.w) w = min.w
				if (max && w > max.w) w = max.w
				if (w < 1) w = 1
				//算X
				if (w >= currentObj.width) x=oldPoint.x-(w-currentObj.width)
				else x=oldPoint.x+(currentObj.width-w)
				cloneRectSpr.x = x
				//算h
				h = _stage.mouseY - oldPoint.y
				if (h < min.h) h = min.h
				if (max && h > max.h) h = max.h
				if (h < 1) h = 1
				setRect(w, h)
			}
			else if (currentType == 8) {
				//算h
				h = _stage.mouseY - oldPoint.y
				if (h < min.h) h = min.h
				if (max && h > max.h) h = max.h
				if (h < 1) h = 1
				setRect(cloneRectSpr.width, h)
			}
			else if (currentType == 9) {
				//if(!currentObj)return
				//算w
				w = _stage.mouseX - oldPoint.x
				if (w < min.w) w = min.w
				if (max && w > max.w) w = max.w
				if(w<1)w=1
				//算h
				h = _stage.mouseY - oldPoint.y
				if (h < min.h) h = min.h
				if (max && h > max.h) h = max.h
				if (h < 1) h = 1
				setRect(w,h)
			}

		}
		/**
		 * 场景上放开鼠标
		 * @param	e
		 */
		private function MOUSE_UP(e:MouseEvent):void {
			//trace('MOUSE_UP')
			stopDrag()
		}
		/**
		 * 显示列表中移除
		 * @param	e
		 */
		private function REMOVED(e:Event):void {
			if(e.target!=currentObj)return
			var obj:DisplayObject = e.target as DisplayObject
			if(obj.stage&&obj.stage.hasEventListener(MouseEvent.MOUSE_UP))obj.stage.removeEventListener(MouseEvent.MOUSE_UP,MOUSE_UP)
			stopDrag()
		}
	}

}