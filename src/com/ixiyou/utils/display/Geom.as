package com.ixiyou.utils.display 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	/**
	 * 一些区域与点的计算,处理矩形区域的方法,处理点
	 * 这个类的无类型参数可能的类型都是矩形或者显示对象
	 * 其中坐标系若不作说明指的都是父对象坐标系
	 * 部分算法参考 ghostcat.util.display.Geom
	 * 
	 * 更多强大的几何区域计算推荐使用http://code.google.com/p/ghostcat/
	 * 的ghostcat.util.display.Geom
	 * @author spe
	 */
	public class Geom
	{
		
		/**
		 * 点是否在某区域范围内
		 * @param	px
		 * @param	py
		 * @param	rect
		 *  1 │        2       │3
		 *  ──┌────────────────┐──
		 *    │                │
		 *  4 │        5       │6
		 *    │                │
		 * 	──└────────────────┘──
		 *  7 │        8       │9
		 */
		public static function pointInRectLocal(px:int, py:int, rect:*):uint {
			if (rect is DisplayObject) rect = new Rectangle(rect.x, rect.y, DisplayObject(rect).width, DisplayObject(rect).height)
			if (rect.contains(px,py)) return 5
			if (px < rect.x) {
				if (py < rect.y) return 1
				if (py > rect.y && py < rect.y + rect.height) return 4
				if (py > rect.y + rect.height) return 7
			}
			if (px > rect.x&&px<(rect.x+rect.width)) {
				if (py < rect.y) return 2
				if (py > rect.y && py < rect.y + rect.height) return 5
				if (py > rect.y + rect.height) return 8
			}
			if (px>(rect.x+rect.width)&& rect.contains(px, py)) {
				if (py < rect.y) return 3
				if (py > rect.y && py < rect.y + rect.height) return 6
				if (py > rect.y + rect.height) return 9
			}
			return 0
		}
		/**
		 * 获得矩形（以父容器为基准），这个方法主要是为了和scaleToFit方法配套，实现矩形和显示对象的转换
		 * 当源是stage时，获取的将不是图形矩形，而是舞台的矩形。必要的时候请用root代替。
		 * 
		 * @param obj	显示对象或者矩形，矩形将会被直接返回
		 * @param space	当前坐标系，默认值为父显示对象，父级不存在就返回自生区域坐标系
		 * @return 
		 * 
		 */	
		public static function getRect(obj:*, space:DisplayObject = null):Rectangle {
			if (!obj)
				return null;
			if (obj is Rectangle)
				return (obj as Rectangle).clone();
			if (obj is Stage)
			{
				var stageRect:Rectangle = new Rectangle(0,0,(obj as Stage).stageWidth,(obj as Stage).stageHeight);//目标为舞台则取舞台矩形
				if (space)
					return localRectToContent(stageRect,obj as DisplayObject,space);
				else
					return stageRect;
			}
			if (obj is DisplayObject)
			{
				if (!space&&(obj as DisplayObject).parent)
					space = (obj as DisplayObject).parent;
				else  return new Rectangle((obj as DisplayObject).x,(obj as DisplayObject).y,(obj as DisplayObject).width,(obj as DisplayObject).height)
				
				if (obj.width == 0 || obj.height == 0)//长框为0则只变换坐标
				{
					var p:Point = localToContent(new Point(),obj,space);
					return new Rectangle(p.x,p.y,0,0);
				}
				
				if ((obj as DisplayObject).scrollRect)//scrollRect有时候不会立即确认属性
					return localRectToContent((obj as DisplayObject).scrollRect,obj,space)
				else
					return obj.getRect(space);
			}
			
			return null;
		}
		/**
		 * 转换矩形坐标到某个显示对象
		 * 
		 * @param rect	矩形 需要转换矩形
		 * @param source	源
		 * @param target	目标
		 * @return 
		 * 
		 */		
		public static function localRectToContent(rect:Rectangle,source:DisplayObject,target:DisplayObject):Rectangle
		{
			if (source == target)
				return rect;
			
			var topLeft:Point = localToContent(rect.topLeft,source,target);
			var bottomRight:Point = localToContent(rect.bottomRight,source,target);
			return new Rectangle(topLeft.x,topLeft.y,bottomRight.x - topLeft.x,bottomRight.y - topLeft.y);
		}
		/**
		 * 把某显示对象坐标转换为某个显示对象坐标
		 * 
		 * @param pos	坐标 需要转换坐标
		 * @param source	源 需要转换目标原,如果没有target，那默认转换坐标就是舞台坐标
		 * @param target	目标 如果没有source,那么pos就是舞台坐标转换成target本地坐标
		 * @return 
		 * 
		 */		
		public static function localToContent(pos:Point,source:DisplayObject=null,target:DisplayObject=null):Point
		{
			if (target && source)
				return target.globalToLocal(source.localToGlobal(pos));
			else if (source)
				return source.localToGlobal(pos);
			else if (target)
				return target.globalToLocal(pos);
			return null;
		}
	}

}