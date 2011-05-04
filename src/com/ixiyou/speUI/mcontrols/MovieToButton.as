package com.ixiyou.speUI.mcontrols 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 快速设置按钮
	 * 这个类可以是一个静态方法也可以是构建出来的
	 * @author spe email:md9yue@qq.com
	 */
	public class MovieToButton extends Sprite
	{
		private var _skin:MovieClip
		public function MovieToButton(value:MovieClip,formerly:Boolean=false,parentBool:Boolean=false) 
		{
			_skin = MovieToButton.add(value)
			if (formerly) {
				this.x = _skin.x
				this.y = _skin.y
				
			}
			if (_skin.parent && parentBool) {
				_skin.parent.addChild(this)
				this.name=_skin.name
			}
			_skin.x = 0
			_skin.y=0
			addChild(_skin)
		}
		/**
		 * 破坏所有索引，垃圾回收
		 */
		public function destory():void {
			remove(_skin)
		}
	
		/**
		 * 对一个按钮进行转换添加事件
		 * @param	value
		 * @param	md_Click
		 * @return
		 */
		public static function add(value:MovieClip,md_Click:Function=null):MovieClip
		{
			/**
			 * 帧标签说明
			 * default //正常状态
			 * movieIn //鼠标滑进
			 * on //鼠标滑进鼠标悬停上，动画也会在这帧停止
			 * movieOut //鼠标滑出
			 * toDefault //滑出动画最后回到正常状态
			 * down //鼠标按钮下时候，可以选择做按下动画，并补上回到默认的动画
			 * up //鼠标放开动画
			 */
			value.buttonMode = true
			value.mouseChildren = false
			value.mouseEnabled = true
			//做移开后 是否是点击后滑开判断
			value.md_mouuseDown=false
			if(md_Click!=null)value.md_Click=md_Click
			value.addEventListener(MouseEvent.MOUSE_OVER,mouseOver)
			value.addEventListener(MouseEvent.MOUSE_OUT, mouseOut)
			value.addEventListener(MouseEvent.CLICK, mouseClick)
			value.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			value.addEventListener(MouseEvent.MOUSE_UP,mouseUp)
			return value
		}
		
		static private function mouseUp(e:MouseEvent):void 
		{
			var btn:MovieClip = e.target as MovieClip
			btn.gotoAndPlay('up')
			btn.md_mouuseDown=false
		}
		/**
		 * 按下
		 * @param	e
		 */
		static private function mouseDown(e:MouseEvent):void 
		{
			var btn:MovieClip = e.target as MovieClip
			btn.gotoAndPlay('down')
			btn.md_mouuseDown=true
		}
		/**
		 * 点击
		 * @param	e
		 */
		static private function mouseClick(e:MouseEvent):void 
		{
			var btn:MovieClip=e.target as MovieClip
			if (btn.md_Click != null) btn.md_Click()
			
		}
		/**
		 * 移动开
		 * @param	e
		 */
		static private function mouseOut(e:MouseEvent):void 
		{
			var btn:MovieClip = e.target as MovieClip

			if (btn.md_mouuseDown) btn.gotoAndPlay('up')
			else btn.gotoAndPlay('movieOut')
			btn.md_mouuseDown=false
		}
		/**
		 * 移动进来
		 * @param	e
		 */
		static private function mouseOver(e:MouseEvent):void 
		{
			var btn:MovieClip = e.target as MovieClip
			btn.gotoAndPlay('movieIn')
			btn.md_mouuseDown=false
			
		}
		/**
		 * 对一个按钮进行
		 * @param	value
		 * @return
		 */
		public static function remove(value:MovieClip):MovieClip
		{
			value.buttonMode = true
			value.mouseChildren = false
			value.mouseEnabled = true
			if (value.md_Click != null) value.md_Click = null
			value.removeEventListener(MouseEvent.MOUSE_OVER,mouseOver)
			value.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut)
			value.removeEventListener(MouseEvent.CLICK, mouseClick)
			value.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			value.removeEventListener(MouseEvent.MOUSE_UP, mouseUp)
			
			
			return value
		}
	}

}