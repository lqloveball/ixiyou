package com.ixiyou.geom
{
	/**
	 * Dimension 类封装单个对象中组件的宽度和高度
	 * @author wersling
	 */	
	public class Dimension 
	{
		private var _width:Number;
		private var _height:Number;
		public function Dimension(w:Number = 0,h:Number = 0){
			width = w;
			height = h;
		}
		public function clone():Dimension{
			return new Dimension(_width,_height);
		}
		public function get width():Number{
			return _width;
		}
		
		public function set width(value:Number):void{
			_width = value;
		}
		public function get height():Number{
			return _height;
		}
		
		public function set height(value:Number):void{
			_height = value;
		}
		
		public function toString():String{
			return "(w="+_width+" , h="+_height+")";
		}
	}
}