package com.ixiyou.speUI.core
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * 组件接口定义基本 API 集 ，都是spe组件必须实现的API
	 * */
	 
	public interface ISpeComponent extends ISize
	{
		/**初始化*/
		function initialize():void
		/**边界*/
		function get borderMetrics():EdgeMetrics
		/**父级边界布局*/
		function get pLayout():LayoutMode
		/**设置大小*/
		//function setSize(w:Number, h:Number):void
		/**组件大小更新*/
		//function upSize():void
		/**组件大小重设，一般在组件被新的容器装载、组件边界发生变化时候执行大小重设由组件自行计算重设的大小*/
		//function ResetSize():void
		/**设置高度*/
		//function set height(value:Number):void 
		//function get height():Number
		/**设置宽度*/
		//function set width(value:Number):void
		//function get width():Number
		/**布局使用设置X Y坐标*/
		function layoutLocation(_x:Number, _y:Number):void
		/** 设置组件的X Y坐标*/
		function setLocation(_x:Number, _y:Number):void
		/**设置X坐标*/
		function set x(value:Number):void
		function get x():Number
		/**设置Y坐标*/
		function set y(value:Number):void
		function get y():Number
		/**组件的父级容器*/
		function get owner():DisplayObjectContainer
		/**摧毁这物件*/
		function destory():void
		
	}
}