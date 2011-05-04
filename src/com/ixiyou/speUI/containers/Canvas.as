package com.ixiyou.speUI.containers 
{
	
	/**
	 * Canvas 布局容器基类
	 * 定义一个矩形区域，您可以在其中放置子容器和控件
	 * @author ...
	 */
	import flash.display.DisplayObject
	import flash.display.DisplayObjectContainer
	import flash.display.Sprite;
	import flash.events.Event
	import com.ixiyou.utils.StringUtil;
	import com.ixiyou.events.LocationEvent
	import com.ixiyou.events.ResizeEvent
	import com.ixiyou.speUI.core.*
	public class Canvas extends Container implements ILayoutContainer
	{
		public function Canvas(config:*=null) 
		{
			super(config)
		}
		/**执行对内部元素布局*/
		override public function layoutChilds():void {
			var child:DisplayObject 
			var i:int
			for ( i= 0; i < numChildren; i++){	
				child = getChildAt(i);
				if (child is SpeComponent)setChildLocation(SpeComponent(child))
			}
		}
		/**重写添加显示对象到层方法*/
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			if (child)
			{
				if (child.parent && child.parent.parent && child.parent.parent is IContainer) {
					var formerParent:DisplayObjectContainer = child.parent.parent;
					formerParent.removeChild(child);
				}
				if (index>numChildren)index=numChildren
				_box.addChildAt(child, index);
				child.addEventListener(Event.RESIZE,childResize)
				if (child is SpeComponent) SpeComponent(child).addEventListener(SpeComponent.AUTO_SIZE, childAutoSize)
				if(child is SpeComponent)SpeComponent(child).addEventListener(LayoutMode.UPLAYOUT,childLayout)
				if(child is SpeComponent)SpeComponent(child).addEventListener(EdgeMetrics.UPEDGEMETRICS,childEdgeMetrics)
				if(child is SpeComponent)setChildLocation(SpeComponent(child))
			}
			return child;
		}
		/**
		 * 重写删除指定层显示对象方法
		 * @param	index 删除什么位置的对象
		 * @return 删除的对象
		 */
		override public function removeChildAt(index:int):DisplayObject 
		{
			var child:DisplayObject = _box.removeChildAt(index);
			if (child is SpeComponent) SpeComponent(child).removeEventListener(SpeComponent.AUTO_SIZE, childAutoSize)
			if(child is SpeComponent)SpeComponent(child).removeEventListener(LayoutMode.UPLAYOUT,childLayout)
			if(child is SpeComponent)SpeComponent(child).removeEventListener(EdgeMetrics.UPEDGEMETRICS,childEdgeMetrics)
			child.removeEventListener(Event.RESIZE, childResize)
			layoutChilds()
			return child
		}
		//子对象布局方式改变时候
		protected function childLayout(e:Event):void {
			try{
				var child:SpeComponent=e.target as SpeComponent
				if (this.contains(child)) {
					//做处理
					setChildLocation(child)
				}
				else {
					//trace("非子级删除")
					child.removeEventListener(LayoutMode.UPLAYOUT, childLayout)
				}
			}catch(e:ArgumentError){
				trace(e.toString()+" 错误：组件子级，事件对象不是显示对象类型")
			}
		}
		/**组件大小更新*/
		override public function upSize():void {
			super.upSize()
			layoutChilds()
			//测试使用
			/*
			this.graphics.clear()
			this.graphics.beginFill(0x0,.3)
			this.graphics.drawRect(0,0,this.width,this.height)
			*/
		}
		
		//子对象边界发生变化时候
		protected function childEdgeMetrics(e:Event):void {
			try{
				var child:SpeComponent=e.target as SpeComponent
				if (this.contains(child)) {
					//做处理
					setChildLocation(child)
				}
				else {
					//trace("非子级删除")
					child.removeEventListener(EdgeMetrics.UPEDGEMETRICS, childEdgeMetrics)
				}
			}catch(e:ArgumentError){
				trace(e.toString()+" 错误：组件子级，事件对象不是显示对象类型")
			}
		}
		//子对象自动适应时候
		override protected function childAutoSize(e:Event):void {
			try{
				var child:SpeComponent=e.target as SpeComponent
				if (this.contains(child)) {
					//做处理
					setChildLocation(child)
				}
				else {
					//trace("非子级删除")
					child.removeEventListener(SpeComponent.AUTO_SIZE, childAutoSize)
				}
			}catch(e:ArgumentError){
				trace(e.toString()+" 错误：组件子级，事件对象不是显示对象类型")
			}
		}
		//子对象大小变化
		override protected function childResize(e:Event):void {
			try {
				//trace('childResize')
				var child:DisplayObject=e.target as DisplayObject
				if (this.contains(child)) {
					if (child is SpeComponent)setChildLocation(SpeComponent(child))
				}
				else {
					//trace("非子级删除")
					child.removeEventListener(Event.RESIZE, childResize)
				}
			}catch(e:ArgumentError){
				trace(e.toString()+" 错误：组件子级，事件对象不是显示对象类型")
			}
		}
		
		public function setChildLocation(child:SpeComponent):void {
			var _w:uint
			var _h:uint
			if (child.autoSize) {
				//trace('setChildLocation',this.width - child.borderMetrics.width,this.height - child.borderMetrics.height)
				child.layoutLocation(child.borderMetrics.left, child.borderMetrics.top)
				child.layoutSetSize(this.width - child.borderMetrics.width, this.height - child.borderMetrics.height)
				//trace('c:',child.width,child.height)
			}else {
				//绝对位置对齐
				if (StringUtil.Contains(child.pLayout.layout, LayoutMode.ABSOLUTE)) return
				if (StringUtil.Contains(child.pLayout.layout, LayoutMode.BOTTOM) &&
					StringUtil.Contains(child.pLayout.layout, LayoutMode.TOP) &&
					StringUtil.Contains(child.pLayout.layout, LayoutMode.LEFT) &&
					StringUtil.Contains(child.pLayout.layout, LayoutMode.RIGHT) 
				) {
					//4边布局
					_w = width - child.borderMetrics.width
					_h = height - child.borderMetrics.height
					child.layoutSetSize(_w,_h)
					child.layoutLocation(child.borderMetrics.left, child.borderMetrics.top)
					
				}
				else if (child.pLayout.layout==LayoutMode.TOP){
					//靠顶部对齐
					//if(child.percentWidthBool==true&&child.percentWidth<=1)_w=child.percentWidth*width
					//if (child.percentHeightBool == true&&child.percentHeight<=1)_h=child.percentHeight*(height-child.borderMetrics.top)
					//if((child.percentWidthBool==true&&child.percentWidth<=1)||(child.percentHeightBool == true&&child.percentHeight<=1))child.layoutSetSize(_w,_h)
					child.layoutLocation(child.x, child.borderMetrics.top)
				}
				
				else if (child.pLayout.layout==LayoutMode.BOTTOM) {
					//靠底部对齐
					//if(child.percentWidthBool==true&&child.percentWidth<=1)_w=child.percentWidth*width
					//if (child.percentHeightBool == true&&child.percentHeight<=1)_h=child.percentHeight*(height-child.borderMetrics.bottom)
					//if((child.percentWidthBool==true&&child.percentWidth<=1)||(child.percentHeightBool == true&&child.percentHeight<=1))child.layoutSetSize(_w,_h)
					child.layoutLocation(child.x, this.height-child.borderMetrics.bottom-child.height)
				}
				else if (child.pLayout.layout==LayoutMode.LEFT) {
					//靠左对齐
					//if(child.percentWidthBool==true&&child.percentWidth<=1)_w=child.percentWidth*width-child.borderMetrics.width
					//if (child.percentHeightBool == true&&child.percentHeight<=1)_h=child.percentHeight*height
					//if((child.percentWidthBool==true&&child.percentWidth<=1)||(child.percentHeightBool == true&&child.percentHeight<=1))child.layoutSetSize(_w,_h)
					child.layoutLocation(child.borderMetrics.left, child.y)
				}
				else if (child.pLayout.layout==LayoutMode.RIGHT) {
					//右边对齐
					child.layoutLocation(this.width-child.borderMetrics.right-child.width, child.y)
				}
				else if (child.pLayout.layout==LayoutMode.MIDDLE) {
					//纵中边对齐
					child.layoutLocation(child.x, (this.height-child.height)/2)
				}
				else if (child.pLayout.layout==LayoutMode.CENTER) {
					//横中边对齐
					child.layoutLocation((this.width-child.width)/2,child.y)
				}
				else if (StringUtil.Contains(child.pLayout.layout, LayoutMode.BOTTOM) &&
					StringUtil.Contains(child.pLayout.layout, LayoutMode.TOP) &&
					child.pLayout.layout.split(",").length==2
				) {
					//上下边布局
					child.layoutLocation(child.x, child.borderMetrics.top)
					child.layoutSetSize(child.width,this.height-child.borderMetrics.height)
				}
				else if (StringUtil.Contains(child.pLayout.layout, LayoutMode.RIGHT) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.LEFT) &&
				child.pLayout.layout.split(",").length==2
				) {
					//左右边布局
					child.layoutLocation(child.borderMetrics.left,child.y)
					child.layoutSetSize(width-child.borderMetrics.width,child.height)
				}
				else if (StringUtil.Contains(child.pLayout.layout, LayoutMode.LEFT) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.TOP) &&
				child.pLayout.layout.split(",").length==2
				) {
					//上左边布局
					child.layoutLocation(child.borderMetrics.left, child.borderMetrics.top)
					child.layoutSetSize(child.width,child.height)
				}
				else if (StringUtil.Contains(child.pLayout.layout, LayoutMode.RIGHT) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.TOP) &&
				child.pLayout.layout.split(",").length==2
				) {
					//上右边布局
					child.layoutLocation(this.width-child.borderMetrics.right-child.width, child.borderMetrics.top)
					child.layoutSetSize(child.width,child.height)
				}
				else if (StringUtil.Contains(child.pLayout.layout, LayoutMode.RIGHT) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.BOTTOM) &&
				child.pLayout.layout.split(",").length==2
				) {
					//下右边布局
					child.layoutLocation(this.width-child.borderMetrics.right-child.width,height-child.height-child.borderMetrics.bottom)
					child.layoutSetSize(child.width,child.height)
				}
				else if (StringUtil.Contains(child.pLayout.layout, LayoutMode.LEFT) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.BOTTOM) &&
				child.pLayout.layout.split(",").length==2
				) {
					//下左边布局
					child.layoutLocation(child.borderMetrics.left,height-child.height-child.borderMetrics.bottom)
					child.layoutSetSize(child.width,child.height)
				}
				else if (StringUtil.Contains(child.pLayout.layout, LayoutMode.LEFT) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.MIDDLE) &&
				child.pLayout.layout.split(",").length==2
				) {
					//左中边布局
					child.layoutLocation(child.borderMetrics.left,(height-child.height)/2)
					child.layoutSetSize(child.width,child.height)
				}
				else if (StringUtil.Contains(child.pLayout.layout, LayoutMode.LEFT) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.MIDDLE) &&
				child.pLayout.layout.split(",").length==2
				) {
					//右中边布局
					child.layoutLocation(this.width-child.borderMetrics.right-child.width,(height-child.height)/2)
					child.layoutSetSize(child.width,child.height)
				}
				else if (StringUtil.Contains(child.pLayout.layout, LayoutMode.TOP) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.CENTER) &&
				child.pLayout.layout.split(",").length==2
				) {
					//上中边布局
					child.layoutLocation((width-child.width)/2,child.y)
					child.layoutSetSize(child.width,child.height)
				}
				else if (StringUtil.Contains(child.pLayout.layout, LayoutMode.BOTTOM) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.CENTER) &&
				child.pLayout.layout.split(",").length==2
				) {
					//下中边布局
					child.layoutLocation((width-child.width)/2,height-child.height-child.borderMetrics.bottom)
					child.layoutSetSize(child.width,child.height)
				}
				else if (StringUtil.Contains(child.pLayout.layout, LayoutMode.MIDDLE) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.CENTER) &&
				child.pLayout.layout.split(",").length==2
				) {
					//中中边布局
					child.layoutLocation((width-child.width)/2,(height-child.height)/2)
					child.layoutSetSize(child.width,child.height)
				}
				else if (StringUtil.Contains(child.pLayout.layout, LayoutMode.BOTTOM) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.TOP) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.LEFT)
				) {
					//上下左边布局
					child.layoutLocation(child.borderMetrics.left, child.borderMetrics.top)
					child.layoutSetSize(child.width,this.height-child.borderMetrics.height)
				}
				else if (StringUtil.Contains(child.pLayout.layout, LayoutMode.BOTTOM) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.TOP) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.RIGHT)
				) {
					//上下右边布局
					child.layoutLocation(this.width-child.borderMetrics.right-child.width, child.borderMetrics.top)
					child.layoutSetSize(child.width,this.height-child.borderMetrics.height)
				}
				else if (StringUtil.Contains(child.pLayout.layout, LayoutMode.BOTTOM) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.TOP) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.CENTER)
				) {
					//上下中边布局
					child.layoutLocation((width-child.width)/2, child.borderMetrics.top)
					child.layoutSetSize(child.width,this.height-child.borderMetrics.height)
				}
				else if (StringUtil.Contains(child.pLayout.layout, LayoutMode.MIDDLE) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.LEFT) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.RIGHT)
				) {
					//左右中边布局
					child.layoutLocation(child.borderMetrics.left, (height-child.height)/2)
					child.layoutSetSize(width-child.borderMetrics.width,child.height)
				}
				else if (StringUtil.Contains(child.pLayout.layout, LayoutMode.TOP) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.LEFT) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.RIGHT)
				) {
					//左右上边布局
					child.layoutLocation(child.borderMetrics.left,child.borderMetrics.top)
					child.layoutSetSize(width-child.borderMetrics.width,child.height)
				}
				else if (StringUtil.Contains(child.pLayout.layout, LayoutMode.BOTTOM) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.LEFT) &&
				StringUtil.Contains(child.pLayout.layout, LayoutMode.RIGHT)
				) {
					//左右下边布局
					child.layoutLocation(child.borderMetrics.left,height-child.borderMetrics.height-child.height)
					child.layoutSetSize(width-child.borderMetrics.width,child.height)
				}
			}
		}
		
		/**
		 * 破坏所有索引，垃圾回收
		 */
		override public function destory():void {
			super.destory()
			var child:DisplayObject 
			for (var i:int = 0; i < numChildren; i++) 
			{
				child= getChildAt(i)
				if (child is SpeComponent) SpeComponent(child).removeEventListener(SpeComponent.AUTO_SIZE, childAutoSize)
				if(child is SpeComponent)SpeComponent(child).removeEventListener(LayoutMode.UPLAYOUT,childLayout)
				if(child is SpeComponent)SpeComponent(child).removeEventListener(EdgeMetrics.UPEDGEMETRICS,childEdgeMetrics)
				child.removeEventListener(Event.RESIZE, childResize)
			}
		}
	}
	
}