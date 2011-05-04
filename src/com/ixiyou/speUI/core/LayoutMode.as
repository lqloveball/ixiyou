package com.ixiyou.speUI.core
{
	/**
	 * 布局对其方式对象
	 * 
	 * 
	 * */
	import flash.display.DisplayObject
	import flash.events.Event;
	import flash.events.EventDispatcher
	import com.ixiyou.utils.StringUtil
	public class LayoutMode extends EventDispatcher
	{
		public static const TOP:String = "T";//居顶对齐
		public static const LEFT:String = "L";//居左对齐
		public static const RIGHT:String = "R";//居右对齐
		public static const BOTTOM:String = "B";//居下对齐
		
		public static const BOTTOM_LEFT:String = "BL";//居下左对齐
		public static const BOTTOM_RIGHT:String = "BR";//居下右对齐
		
		public static const TOP_LEFT :String = "TL";//居顶左对齐
		public static const TOP_RIGHT :String = "TR";//居顶右对齐
		
		public static const TOP_CENTER :String = "TC";//居顶中间对齐
		public static const BOTTOM_CENTER :String = "BC";//居下中间对齐
		
		public static const LEFT_MIDDLE:String = "LM";//左对齐，垂直位置局中
		public static const RIGHT_MIDDLE:String = "RM";//右对齐，垂直位置局中
		
		public static const MIDDLE_CENTER:String = "MC";//垂直横向都居中

		public static const MIDDLE:String = "M";//垂直居中
		public static const CENTER:String = "C";//横向居中
		
		public static const ABSOLUTE:String = "absolute";//绝对位置对齐
		
		//内部对齐方式改变
		public static const UPMODE:String = "upMode";
		//父级布局方式改变
		public static const UPLAYOUT:String = "upLayout";
		//对齐方法
		private var _align:String = LayoutMode.ABSOLUTE
		//布局方式
		private var _layout:String=LayoutMode.ABSOLUTE
		/**构造函数*/
		public function LayoutMode(align:String=LayoutMode.ABSOLUTE,layout:String=LayoutMode.ABSOLUTE) {
			this.align = align
			this.layout=layout
		}
		/**布局对齐方式*/
		public function set align(value:String):void 
		{
			if (_align == value) return
			_align = value	
			this.dispatchEvent(new Event(LayoutMode.UPMODE))
		}
		public function get align():String { return _align; }
		public function set layout(value:String):void 
		{
			//检测是否已经包含对齐方式
			if (StringUtil.Contains(_layout, value)) return
			//添加的对齐方式符合标准
			if (value == LayoutMode.ABSOLUTE ||
			value == LayoutMode.BOTTOM||
			value == LayoutMode.TOP||
			value == LayoutMode.MIDDLE||
			value == LayoutMode.LEFT||
			value == LayoutMode.RIGHT||
			value == LayoutMode.CENTER
			) {
				if (value == LayoutMode.ABSOLUTE) {
					_layout = value
				}else {
					if(_layout== LayoutMode.ABSOLUTE)_layout=""
					var arr:Array = _layout.split(",")
					if(arr.length==1&&_layout=="")_layout=value
					else {
						arr.push(value)
						var i:uint
						var arr2:Array=new Array()
						if (value == LayoutMode.BOTTOM || value == LayoutMode.TOP) {
							for ( i= 0; i < arr.length; i++ )if(arr[i]!=LayoutMode.MIDDLE)arr2.push(arr[i])
						}
						if (value == LayoutMode.MIDDLE ) {
							for ( i= 0; i < arr.length; i++ )if(arr[i]!= LayoutMode.BOTTOM||arr[i]!= LayoutMode.TOP)arr2.push(arr[i])
						}
						if (value == LayoutMode.LEFT || value == LayoutMode.RIGHT) {
							for (i= 0; i < arr.length; i++ )if(arr[i]!=LayoutMode.CENTER)arr2.push(arr[i])
						}
						if (value == LayoutMode.CENTER ) {
							for (i = 0; i < arr.length; i++ )if(arr[i]!= LayoutMode.LEFT||arr[i]!= LayoutMode.RIGHT)arr2.push(arr[i])
						}
						_layout = arr2.join(",")
					}
				}
				this.dispatchEvent(new Event(LayoutMode.UPLAYOUT))
			}
		}
		public function get layout():String { return _layout; }
		/**
		 * 纵向对齐方式
		 */
		public function get verticalAlign():String {
			if (align == "T" || align == "TL" || align == "TR" || align == "TC") return LayoutMode.TOP
			if (align == "B" || align == "BL" || align == "BR" || align == "BC") return LayoutMode.BOTTOM
			if (align == "M" || align == "MC" || align == "RM" || align == "LM") return LayoutMode.MIDDLE
			return "FALSE"
		}
		/**
		 * 横向对齐方式
		 */
		public function get horizontalAlign():String {
			if (align == "L" || align == "BL" || align == "TL" || align == "LM") return LayoutMode.LEFT
			if (align == "R" || align == "TR" || align == "BR" || align == "RM") return LayoutMode.RIGHT
			if (align == "C" || align == "MC" || align == "TC" || align == "BC") return LayoutMode.CENTER
			return "FALSE"
		}
	}
}