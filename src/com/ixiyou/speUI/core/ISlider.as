package com.ixiyou.speUI.core 
{
	
	/**
	 * ...
	 * @author ...
	 */
	public interface ISlider 
	{
		
		/**
		 * 指定在轨道上单击是否会移动滑块。
		 */
		function set allowTrackClick(value:Boolean):void 
		function get allowTrackClick():Boolean
		/**
		 * 滑块上允许的最大值。
		 */
		function set maximum(value:Number):void
		function get maximum():Number
		/**
		 * 滑块控件上允许的最小值。
		 */
		function set minimum(value:Number):void
		function get minimum():Number
		/**
		 * 包含滑块的位置，并且此值介于 minimum 属性和 maximum 属性之间。
		 */
		function set value(value:Number):void
		function get value():Number
		/**
		 * 指定是否为滑块启用实时拖动。
		 */
		function set liveDragging(value:Boolean):void
		function get liveDragging():Boolean
		
	}
	
}