package com.ixiyou.speUI.core 
{
	
	/**
	 * H容器基类
	 * 继承于容器基类
	 * @author ...
	 */
	import flash.display.DisplayObject
	import flash.display.DisplayObjectContainer
	import flash.events.Event
	import com.ixiyou.events.LocationEvent
	import com.ixiyou.events.ResizeEvent
	public class HContainer extends Container implements IVHContainer
	{
		//是否固定宽度
		protected var _fixSize:Boolean=false	
		public function HContainer(config:*=null) 
		{
			super(config)
			_box.autoSize=false
		}
		/**设置容器对齐方式*/
		override public function setLayout(value:String):void {
			//设置允许的内部对其方式
			if (value == LayoutMode.BOTTOM_CENTER ||
			value == LayoutMode.BOTTOM_LEFT ||
			value == LayoutMode.BOTTOM_RIGHT ||
			value == LayoutMode.LEFT_MIDDLE ||
			value == LayoutMode.TOP_RIGHT ||
			value == LayoutMode.TOP_CENTER ||
			value == LayoutMode.TOP_LEFT ||
			value == LayoutMode.MIDDLE_CENTER ||
			value == LayoutMode.RIGHT_MIDDLE) {
				if (value == LayoutMode.MIDDLE_CENTER) value = LayoutMode.LEFT_MIDDLE
				if (value == LayoutMode.TOP_CENTER) value = LayoutMode.TOP_LEFT
				if (value == LayoutMode.TOP_RIGHT) value = LayoutMode.TOP_LEFT
				if (value == LayoutMode.RIGHT_MIDDLE) value = LayoutMode.LEFT_MIDDLE
				if (value == LayoutMode.BOTTOM_RIGHT) value = LayoutMode.BOTTOM_LEFT
				if (value == LayoutMode.BOTTOM_CENTER)value = LayoutMode.BOTTOM_LEFT 
				nLayout.align = value
				
			}else {
				value = LayoutMode.TOP_LEFT	
				nLayout.align = value
				
			}
			layoutChilds()
		}
		/**
		 * 组件重绘制
		 */
		override public function upSize():void {
			super.upSize()
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
		/**执行对内部元素布局*/
		override public function layoutChilds():void {
			//trace(nLayout.align)
			layout_neiSize()
			upSize()
		}
		/** 计算布局高度*/
		public function layout_neiSize():void{
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
			if (fixSize)setSize(maxW,height)
			else setSize(maxW, maxH)
		}
		/**
		 * 是否锁定宽或高的大小
		 */
		public function set fixSize(value:Boolean):void {
			if (_fixSize == value) return
			_fixSize=value
		}
		public function get fixSize():Boolean{return _fixSize}
		//子对象自动适应时候
		override protected function childAutoSize(e:Event):void {
			try{
				var child:SpeComponent=e.target as SpeComponent
				if (this.contains(child)) {
					if (SpeComponent(child).autoSize)SpeComponent(child).setSize(SpeComponent(child).width,this.height)
				}
				else {
					//trace("非子级删除")
					child.removeEventListener(SpeComponent.AUTO_SIZE, childAutoSize)
				}
			}catch(e:ArgumentError){
				trace(e.toString()+" 错误：组件子级，事件对象不是显示对象类型")
			}
		}
	}
	
}