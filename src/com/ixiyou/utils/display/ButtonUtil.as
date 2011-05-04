package com.ixiyou.utils.display 
{
	import flash.display.*
	import flash.events.*

	/**
	 * 按钮处理
	 * @author spe
	 */
	public class ButtonUtil 
	{
		/**
		 * 设置无鼠标事件
		 * @param	btn
		 */
		public static function setNoMouse(btn:MovieClip):void {
			btn.gotoAndStop(1)
			btn.mouseChildren = false;
			btn.mouseEnabled = false;
		}
		/**
		 * 设置按钮
		 * @param	btn
		 */
		public static function setButton(btn:MovieClip):void {
			btn.gotoAndStop(1)
			btn.mouseChildren = false;
			btn.buttonMode = true;
			btn.addEventListener(MouseEvent.MOUSE_OVER, buttonOver)
			btn.addEventListener(MouseEvent.MOUSE_OUT, buttonOut)	
		}
		
		static private function buttonOut(e:MouseEvent):void 
		{
			var btn:MovieClip = e.target as MovieClip
			MovieUtils.movieFrame(btn,'off')
		}
		
		static private function buttonOver(e:MouseEvent):void 
		{
			var btn:MovieClip=e.target as MovieClip
			MovieUtils.movieFrame(btn,'on')
		}
		
		/**
		 * 设置按钮
		 * @param	btn
		 */
		public static function setSelectButton(btn:MovieClip):void {
			btn.gotoAndStop(1)
			btn.mouseChildren = false;
			btn.buttonMode = true;
			btn.select=false
			btn.addEventListener(MouseEvent.MOUSE_OVER, selectButtonOver)
			btn.addEventListener(MouseEvent.MOUSE_OUT, selectButtonOut)	
			btn.addEventListener(MouseEvent.CLICK,selectButtonClick)
		}
		static private function selectButtonClick(e:MouseEvent):void 
		{
			var btn:MovieClip = e.target as MovieClip
			if (btn.select) btn.select = false
			else btn.select = true
			if (btn.select)btn.gotoAndStop('on')
			else btn.gotoAndStop('off')
			btn.dispatchEvent(new Event('upSelect'))
		}
		/**
		 * 有 off on select
		 * @param	arr
		 */
		public static function setSelectButtonArr2(arr:Array,select:Number=0):void {
			for (var i:int = 0; i < arr.length; i++) 
			{
				var item:MovieClip = arr[i] as MovieClip;
				item.selectButtonArr = arr
				item.selectButtonType='select'
				ButtonUtil.setSelectButton(item)
				item.removeEventListener(MouseEvent.CLICK,selectButtonClick)
				item.addEventListener(MouseEvent.CLICK, selectButtonFun2)
				
			}
			item = arr[select]
			setSelecItem2(item)
		}
		/**
		 * 设置单选项2
		 * @param	btn
		 */
		public static function setSelecItem2(btn:MovieClip):void {
			var arr:Array = btn.selectButtonArr
			//trace(arr.length)
			for (var i:int = 0; i < arr.length; i++) 
			{
				var item:MovieClip = arr[i];
				//trace(i,item == btn)
				if (item == btn) {
					if (!item.select) {
						btn.dispatchEvent(new Event('upSelect'))
					}
					item.select=true
					item.gotoAndStop('select')
				}else {
					item.select=false
					MovieUtils.movieFrame(item,'off')
				}
			}
		}
		static private function selectButtonFun2(e:MouseEvent):void 
		{
			var btn:MovieClip = e.target as MovieClip
			setSelecItem2(btn)
		}
		/**
		 * 只有 off on 
		 * @param	arr
		 */
		public static function setSelectButtonArr(arr:Array,select:Number=0):void {
			for (var i:int = 0; i < arr.length; i++) 
			{
				var item:MovieClip = arr[i] as MovieClip;
				item.selectButtonArr = arr
				ButtonUtil.setSelectButton(item)
				item.removeEventListener(MouseEvent.CLICK,selectButtonClick)
				item.addEventListener(MouseEvent.CLICK, selectButtonFun)
				//if (i == select) {
					//item.select=true
					//MovieUtils.movieFrame(item,'on')
				//}
				setSelecItem(arr[select])
			}
		}
		/**
		 * 设置单选项2
		 * @param	btn
		 */
		public static function setSelecItem(btn:MovieClip):void {
			var arr:Array = btn.selectButtonArr
			//trace(arr.length)
			for (var i:int = 0; i < arr.length; i++) {
				var item:MovieClip = arr[i];
				if (item == btn) {
					if (!item.select) {
						btn.dispatchEvent(new Event('upSelect'))
					}
					//trace()
					item.select=true
					MovieUtils.movieFrame(item, 'on')
				}else {
					item.select=false
					MovieUtils.movieFrame(item,'off')
				}
			}
		}
		static private function selectButtonFun(e:MouseEvent):void 
		{
			var btn:MovieClip = e.target as MovieClip
			var arr:Array = btn.selectButtonArr
			setSelecItem(btn)
			return
			//trace(arr.length)
			for (var i:int = 0; i < arr.length; i++) 
			{
				var item:MovieClip = arr[i];
				if (item == btn) {
					item.select=true
					MovieUtils.movieFrame(item, 'on')
					//btn.dispatchEvent(new Event('upSelect'))
				}else {
					item.select=false
					MovieUtils.movieFrame(item,'off')
				}
			}
		}
		/**
		 * 有 off on   off1 on1
		 * @param	arr
		 */
		public static function setSelectButtonArr3(arr:Array, select:Number = 0):void {
			//var arr2:Array=arr.concat()
			for (var i:int = 0; i < arr.length; i++) 
			{
				var item:MovieClip = arr[i] as MovieClip;
				item.selectButtonArr = arr
				item.selectButtonType='select2'
				ButtonUtil.setSelectButton(item)
				item.removeEventListener(MouseEvent.CLICK,selectButtonClick)
				item.addEventListener(MouseEvent.CLICK, selectButtonFun3)
				
			}
			item = arr[select]
			setSelecItem3(item)
			
		}
		/**
		 * 设置单选项3
		 * @param	btn
		 */
		public static function setSelecItem3(btn:MovieClip):void {
			var arr:Array = btn.selectButtonArr
			//trace('-----', arr.length)
			for (var i:int = 0; i < arr.length; i++) 
			{
				var item:MovieClip = arr[i];
				if (item == btn) {
					//trace('true---'+item.num,item.select)
					if (item.select) {
						//item.gotoAndStop('on')
						MovieUtils.movieFrame(item,'on')
					}else {
						item.gotoAndStop('off')
						item.gotoAndStop('on')
						MovieUtils.movieFrame(item, 'on')
						btn.dispatchEvent(new Event('upSelect'))
					}
					item.select = true
				}else{

					if (item.select != false) {
						item.gotoAndStop('on')
						MovieUtils.movieFrame(item, 'off' )
					}else {
						if (item.currentFrameLabel == 'on1') MovieUtils.movieFrame(item, 'off1')
						else item.gotoAndStop('off1')	
					}
					item.select = false
				}
			}
		}
		static private function selectButtonFun3(e:MouseEvent):void 
		{
			var btn:MovieClip = e.target as MovieClip
			setSelecItem3(btn)
		}
		
		
		static private function selectButtonOut(e:MouseEvent):void 
		{
			var btn:MovieClip = e.target as MovieClip
			if (btn.selectButtonType && btn.selectButtonType == 'select') {
				if (btn.select)btn.gotoAndStop('select')
				else MovieUtils.movieFrame(btn,'off')
			}else if (btn.selectButtonType && btn.selectButtonType == 'select2') {
				if (btn.select) {
					MovieUtils.movieFrame(btn,'on')
				}
				else {
					btn.gotoAndStop('on1')
					MovieUtils.movieFrame(btn,'off1')
				}
			}else {
				if (btn.select)btn.gotoAndStop('on')
				else MovieUtils.movieFrame(btn,'off')
			}
			
		}
		
		static private function selectButtonOver(e:MouseEvent):void 
		{
			var btn:MovieClip = e.target as MovieClip
			if (btn.selectButtonType && btn.selectButtonType == 'select') {
				if (btn.select) {
					MovieUtils.movieFrame(btn,'on')
				}
				else {
					MovieUtils.movieFrame(btn,'on')
				}
			}else if (btn.selectButtonType && btn.selectButtonType == 'select2') {
				if (btn.select) {
					//btn.gotoAndStop('off')
					MovieUtils.movieFrame(btn,'on')
				}
				else {
					btn.gotoAndStop('off1')
					MovieUtils.movieFrame(btn,'on1')
				}
			}else {
				if (btn.select)btn.gotoAndStop('on')
				else MovieUtils.movieFrame(btn,'on')
			}
		}
	}

}