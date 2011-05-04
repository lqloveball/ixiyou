package com.ixiyou.speUI.containers 
{
	
	/**
	 * 纵向布局容器
	 * @author 
	 */
	import com.ixiyou.speUI.core.*
	import flash.display.DisplayObject
	import flash.display.Shape;
	public class VBox extends VContainer
	{
		
		public function VBox(config:*=null) 
		{
			super(config)
			fixSize=true
		}
		override public function upSize():void {
			_boxMask.width = width
			_boxMask.height = height
			//trace(width)
			var nextY:Number = 0
			var child:DisplayObject 
			var component:ISpeComponent 
			var thisX:Number
			var i:int 
			for (i = 0; i < numChildren; i++)
			{	
				child = getChildAt(i);
				if (this.nLayout.horizontalAlign == LayoutMode.CENTER) thisX = (this.width - child.width) / 2
				else if (this.nLayout.horizontalAlign == LayoutMode.RIGHT) thisX = this.width - child.width
				else thisX = 0
				if (child is SpeComponent) {
					component = child as SpeComponent
					
					if (SpeComponent(child).autoSize) SpeComponent(child).setSize(this.width, SpeComponent(child).height)
					else if (SpeComponent(child).pWidthBool) {
						SpeComponent(child).setSize(this.width * SpeComponent(child).percentWidth, SpeComponent(child).height)
						if (this.nLayout.horizontalAlign == LayoutMode.CENTER) thisX = (this.width - child.width) / 2
						else if (this.nLayout.horizontalAlign == LayoutMode.RIGHT) thisX = this.width - child.width
						else thisX = 0
					}
					component.layoutLocation(thisX, nextY)
					nextY += component.height + verticalGap
					
				}else {
					child.y = nextY
					child.x = thisX
					nextY += child.height + verticalGap
				}
			}
		}
		/** 
		 * 计算布局高度只是计算box需要的高度和宽度
		 * */
		override public function layout_neiSize():void{
			var maxH:Number = 0;
			var maxW:Number = 0;
			var child:DisplayObject 
			var component:ISpeComponent 
			var SpeArr:Array = new Array()
			var i:int 
			for (i= 0; i < numChildren; i++)
			{		
				child = getChildAt(i);
				if (child is ISpeComponent) {
					component = child as ISpeComponent
					 maxW = Math.max(component.x+component.width,maxW)
					maxH += component.height
				}else {
					maxW = Math.max(child.x+child.width,maxW)
					//if (child.width> maxW)maxW = child.width;
					maxH += child.height;
				}
			}
			if (parent&&parent is ILayoutContainer && this.autoSize) {
				maxW = parent.width
			}
			maxH += this.verticalGap * (numChildren - 1)
			//trace(maxW)
			_box.setSize(maxW, maxH)
			_box.graphics.clear()
			_box.graphics.beginFill(0x0,0)
			_box.graphics.drawRect(0,0,maxW,maxH)
		}
		
	}
	
}