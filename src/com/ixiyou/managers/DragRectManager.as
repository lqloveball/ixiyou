package com.ixiyou.managers 
{
	
	
	/**
	 * 简单拖动模式管理器
	 * 
	 * [区别]与flashyiyi写的DragManager功能上
	 * 缺少了复制一个图标并拖动模式
	 * 缺少拖动事件发报
	 * 缺少拖动所有显示对象
	 * [DragManager]适合绝大部分拖动管理，特别是一些游戏啊方面
	 * [DragRectManager]
	 * 只是适合做简单的拖动 处理比如 只能拖动Sprite类的，实时拖动还是模拟传统windows窗口的拖动
	 * 这个类我设计它也是就是为做窗口拖动使用的
	 * @author spe
	 */
	import flash.events.EventDispatcher;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.ixiyou.events.DragEvent;
	import com.ixiyou.utils.display.BitmapData2String;
	public class DragRectManager 
	{
		private static var instance:DragRectManager;
		/**
		 * 返回这个类的实例，做为静态方法返回实例。这样保证这个实例是唯一
		 * @param 
		 * @return 
		*/
		public static function getInstance() : DragRectManager {
			if (instance == null)
				instance = new DragRectManager();
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
		private var currentObj:Sprite;
		private var currentType:String;
		private var cloneRectSpr:Sprite
		private var cloneRectShape:Shape
		private var cloneRectBmp:BitmapData
		
		public function DragRectManager()
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
			var oldPoint:Point = obj.parent.localToGlobal(new Point(obj.x, obj.y))
			
			cloneRectSpr.startDrag()
			cloneRectSpr.x = oldPoint.x
			cloneRectSpr.y = oldPoint.y
			cloneRectShape.graphics.clear()
			cloneRectShape.graphics.beginBitmapFill(cloneRectBmp)
			cloneRectShape.graphics.moveTo(0, 0)
			cloneRectShape.graphics.lineTo(w, 0)
			cloneRectShape.graphics.lineTo(w, h)
			cloneRectShape.graphics.lineTo(0, h)
			cloneRectShape.graphics.lineTo(0, 0)
			cloneRectShape.graphics.moveTo(2, 2)
			cloneRectShape.graphics.lineTo(w - 2, 2)
			cloneRectShape.graphics.lineTo(w - 2, h - 2)
			cloneRectShape.graphics.lineTo(2, h - 2)
			cloneRectShape.graphics.lineTo(2, 2)
			cloneRectShape.graphics.endFill()
		}
		public function startDrag(obj:Sprite, type:String = DragRectManager.DIRECT):void {
				if(!obj.stage)return
				stopDrag()
				currentObj = obj
				currentType = type
				_stage = obj.stage
				
				if (currentType == DragRectManager.DIRECT) {
					currentObj.startDrag()
				}
				else {
					
					setRectObj(currentObj)
					_stage.addChildAt(cloneRectSpr,_stage.numChildren)
				}
				_stage.addEventListener(MouseEvent.MOUSE_UP, MOUSE_UP)
				//发事件
				var e:DragEvent = new DragEvent(DragEvent.DRAG_START,true,false);
				e.dragObj = obj;
				obj.dispatchEvent(e);
				//删除事件
				obj.addEventListener(Event.REMOVED_FROM_STAGE,REMOVED);
			
		}
		/**
		 * 默认停止当前
		 * @param	obj
		 */
		public function stopDrag():void {
			var obj:Sprite=currentObj
			if (!obj) return
			//停止拖动
			obj.stopDrag()
			obj.addEventListener(Event.REMOVED,REMOVED);
			//场景
			if (!_stage && obj.stage)_stage = obj.stage
			if (!_stage) return
			if (currentType == DragRectManager.CLONERECT) {
				var newPoint:Point = currentObj.parent.globalToLocal(new Point(cloneRectSpr.x,cloneRectSpr.y))
				obj.x = newPoint.x
				obj.y = newPoint.y
			}
			//发事件
			var e:DragEvent = new DragEvent(DragEvent.DRAG_STOP,true,false);
			e.dragObj = obj;
			obj.dispatchEvent(e);
			if(_stage&&_stage.contains(cloneRectSpr))_stage.removeChild(cloneRectSpr)
			_stage.removeEventListener(MouseEvent.MOUSE_UP,MOUSE_UP)
			currentObj=null
		}
		
		/**
		 * 场景上放开鼠标
		 * @param	e
		 */
		private function MOUSE_UP(e:MouseEvent):void {
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