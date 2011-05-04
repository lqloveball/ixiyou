package com.ixiyou.speUI.core 
{
	import com.ixiyou.speUI.core.SpeComponent;
	import flash.display.DisplayObject
	import flash.display.Shape;
	import flash.display.Sprite
	import flash.display.DisplayObjectContainer
	import flash.events.Event
	/**
	 * 基础容器 只有遮罩
	 * @author spe
	 */
	public class ContainerBase extends SpeComponent
	{
		protected var _box:SpeComponent
		protected var _boxMask:Shape
		public function ContainerBase(config:*=null) 
		{
			_boxMask=new Shape()
			_boxMask.graphics.beginFill(0x0,.2)
			_boxMask.graphics.drawRect(0, 0, 1, 1)
			_box = new SpeComponent()
			_box.autoSize=true
			oldAddChild(_box)
			oldAddChild(_boxMask)
			_box.mask = _boxMask
			super(config)
		}
		public function oldAddChild(child:DisplayObject):void {
			super.addChild(child)
		}
		public function oldiRemoveChild(child:DisplayObject):void {
			super.removeChild(child)
		}
		/**重写添加显示对象方法*/
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			return addChildAt(child, numChildren);
		}
		/**重写添加显示对象到层方法*/
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			//try {
		   if (child.parent && child.parent.parent && child.parent.parent is IContainer) {
				var formerParent:DisplayObjectContainer = child.parent.parent;
				formerParent.removeChild(child);
			}
			if (index > numChildren) index = numChildren
			_box.addChildAt(child, index);
			return child;
		}
		
		/**重写删除显示对象方法*/
		override public function removeChild(child:DisplayObject):DisplayObject {
			return removeChildAt(getChildIndex(child));
		}
		/**
		 * 重写删除指定层显示对象方法
		 * @param	index 删除什么位置的对象
		 * @return 删除的对象
		 */
		override public function removeChildAt(index:int):DisplayObject 
		{
			return  _box.removeChildAt(index);
		}
		/**
		 *重写是否包含,获取等
		*/
		override public function contains(child:DisplayObject):Boolean {return _box.contains(child)}
		override public function getChildIndex(child:DisplayObject):int { return _box.getChildIndex(child) }
		override public function setChildIndex(child:DisplayObject, index:int):void{_box.setChildIndex(child,index) }
		override public function getChildAt(index:int):DisplayObject { return _box.getChildAt(index) }
		override public function getChildByName(name:String):DisplayObject{return _box.getChildByName(name)}
		override public function swapChildrenAt(index1:int, index2:int):void{_box.swapChildrenAt(index1,index2)}
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void{_box.swapChildren(child1,child2)}
		override public function get numChildren():int { return _box.numChildren }
		//---
		/**
		 *重写是否包含,获取等
		*/
		public function oldContains(child:DisplayObject):Boolean {return super.contains(child)}
		public function oldGetChildIndex(child:DisplayObject):int { return super.getChildIndex(child) }
		public function oldSetChildIndex(child:DisplayObject, index:int):void{super.setChildIndex(child,index) }
		public function oldGetChildAt(index:int):DisplayObject { return super.getChildAt(index) }
		public function oldGetChildByName(name:String):DisplayObject{return super.getChildByName(name)}
		public function oldSwapChildrenAt(index1:int, index2:int):void{super.swapChildrenAt(index1,index2)}
		public function oldSwapChildren(child1:DisplayObject, child2:DisplayObject):void{super.swapChildren(child1,child2)}
		public function oldGetnumChildren():int { return super.numChildren }
		/**
		 * 内部盒子
		 */
		public function get box():SpeComponent { return _box; }
		/**重写组件大小更新*/
		override public function upSize():void {
			_boxMask.width = width
			_boxMask.height = height
			_box.width = width
			_box.height = height
		
			//trace("w[" + width + "]  h[" + height + "]" )
			//显示测试使用
			/*
			this.graphics.clear()
			this.graphics.beginFill(Math.random()*0xffffff)
			this.graphics.drawRect(-2,-2,this.width+4,this.height+4)
			*/
		}
	}

}