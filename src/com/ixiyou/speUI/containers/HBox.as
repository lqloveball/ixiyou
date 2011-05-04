package com.ixiyou.speUI.containers 
{
	
	/**
	 * 纵向布局容器
	 * @author ...
	 */
	import com.ixiyou.speUI.core.*
	import flash.display.DisplayObject
	import flash.display.Shape;
	public class HBox extends HContainer
	{
		protected var _mask:Shape=new Shape()
		public function HBox(config:*=null) 
		{
			
			super(config)
			fixSize=true
			if (width <= 0) this.width = 100
			if (height <= 0) this.height =100
		}
		override public function upSize():void {
			//super.upSize()
			_boxMask.width = width
			_boxMask.height = height
			var nextX:Number=0
			var child:DisplayObject 
			var component:ISpeComponent 
			var thisY:Number
			var i:int 
			//trace("----"+nLayout.align)
			for (i = 0; i < numChildren; i++)
			{	
				child = getChildAt(i);
				 
				if (this.nLayout.verticalAlign == LayoutMode.MIDDLE) thisY = (this.height - child.height) / 2
				else if (this.nLayout.verticalAlign == LayoutMode.BOTTOM) thisY = this.height - child.height
				else thisY = 0
				//trace(thisX)
				if (child is SpeComponent) {
					component = child as SpeComponent
					
					if (SpeComponent(child).autoSize) SpeComponent(child).setSize(SpeComponent(child).width, this.height)
					else if (SpeComponent(child).pHidthBool) {
						SpeComponent(child).setSize(SpeComponent(child).width,this.height * SpeComponent(child).percentHeight)
						if (this.nLayout.verticalAlign == LayoutMode.MIDDLE) thisY = (this.height - child.height) / 2
						else if (this.nLayout.verticalAlign == LayoutMode.BOTTOM) thisY = this.height - child.height
						else thisY = 0
					}
					component.layoutLocation(nextX, thisY)
					nextX += component.width + horizontalGap
					
				}else {
					child.x = nextX
					child.y=thisY
					nextX += child.width + horizontalGap
					
				}
			}
		}
		/** 计算布局高度*/
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
					if (component.height > maxH) maxH = component.height
					maxW += component.width
				}else {
					if (child.height> maxH)maxH = child.height;
					maxW += child.width;
				}
			}
			maxW += this.horizontalGap * (numChildren - 1)
			_box.setSize(maxW, maxH)
		}
	}
	
}