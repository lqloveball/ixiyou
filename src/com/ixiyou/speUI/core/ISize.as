package com.ixiyou.speUI.core 
{
	
	/**
	 * 组件大小和重绘制接口
	 * @author spe
	 */
	public interface ISize 
	{
		/**设置大小*/
		function setSize(w:Number, h:Number):void
		/**组件大小更新*/
		function upSize():void
		/**组件大小重设，一般在组件被新的容器装载、组件边界发生变化时候执行大小重设由组件自行计算重设的大小*/
		function ResetSize():void
		/**设置高度*/
		function set height(value:Number):void 
		function get height():Number
		/**设置宽度*/
		function set width(value:Number):void
		function get width():Number
	}
	
}