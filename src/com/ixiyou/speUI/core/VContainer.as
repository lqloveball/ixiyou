package com.ixiyou.speUI.core 
{
	
	/**
	 * V容器基类
	 * 继承于容器基类
	 * @author ...
	 */
	import flash.display.DisplayObject
	import flash.display.DisplayObjectContainer
	import flash.events.Event
	import com.ixiyou.events.LocationEvent
	import com.ixiyou.events.ResizeEvent
	public class VContainer extends Container implements IVHContainer
	{
		//是否固定宽度
		protected var _fixSize:Boolean=false		
		public function VContainer(config:*=null) 
		{
			super(config)
			_box.autoSize = false
			//if (width <= 0) this.width = 100
			//if (height <= 0) this.height =100
		}
		/**
		 * 是否锁定宽或高的大小
		 */
		public function set fixSize(value:Boolean):void {
			if (_fixSize == value) return
			_fixSize=value
		}
		public function get fixSize():Boolean{return _fixSize}
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
				if (value == LayoutMode.BOTTOM_CENTER)value = LayoutMode.TOP_CENTER	
				if (value == LayoutMode.BOTTOM_LEFT) value = LayoutMode.TOP_LEFT
				if (value == LayoutMode.BOTTOM_RIGHT)value = LayoutMode.TOP_RIGHT
				if (value == LayoutMode.MIDDLE_CENTER)value = LayoutMode.TOP_CENTER	
				if (value == LayoutMode.RIGHT_MIDDLE)value = LayoutMode.TOP_RIGHT
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
					maxW = Math.max(component.x+component.width,maxW)
					maxH += component.height
				}else {
					maxW = Math.max(child.x+child.width,maxW)
					maxH += child.height;
				}
			}
			if (parent&&parent is ILayoutContainer && this.autoSize) {
				maxW = parent.width
			}
			if(numChildren!=0)maxH += this.verticalGap * (numChildren - 1)
			if (fixSize)setSize(width, maxH)
			else setSize(maxW, maxH)
		}
		
		//子对象自动适应时候
		override protected function childAutoSize(e:Event):void {
			try{
				var child:SpeComponent=e.target as SpeComponent
				if (this.contains(child)) {
					if (SpeComponent(child).autoSize)SpeComponent(child).setSize(width,SpeComponent(child).height)
				}
				else {
					child.removeEventListener(SpeComponent.AUTO_SIZE, childAutoSize)
				}
			}catch(e:ArgumentError){
				trace(child.toString()+" 错误：组件子级，事件对象不是显示对象类型")
			}
		}
	}
}