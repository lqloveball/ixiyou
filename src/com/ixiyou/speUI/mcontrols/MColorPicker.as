package com.ixiyou.speUI.mcontrols 
{
	import flash.display.Bitmap
	import flash.display.BitmapData
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.*;
	import flash.events.*;
	import flash.text.TextField;
	import com.ixiyou.speUI.core.ISkinComponent
	import com.ixiyou.speUI.collections.MSprite
	import com.ixiyou.speUI.collections.Skins.MColorPickerSkin;
	[Event(name = 'selectedColor', type = "flash.events.Event")]
	[Event(name = 'movieColor', type = "flash.events.Event")]
	/**
	 * 选色器
	 * 20列乘12行
	 * 
	 * @author spe
	 */
	public class MColorPicker extends MSprite implements ISkinComponent
	{
		//颜色数组
		protected var colorArr:Array = [0, 0, 0, 13056, 26112, 39168, 52224, 65280, 3342336, 3355392, 3368448, 3381504, 3394560, 3407616, 6684672, 6697728, 6710784, 6723840, 6736896, 6749952, 3355443, 0, 51, 13107, 26163, 39219, 52275, 65331, 3342387, 3355443, 3368499, 3381555, 3394611, 3407667, 6684723, 6697779, 6710835, 6723891, 6736947, 6750003, 6710886, 0, 102, 13158, 26214, 39270, 52326, 65382, 3342438, 3355494, 3368550, 3381606, 3394662, 3407718, 6684774, 6697830, 6710886, 6723942, 6736998, 6750054, 10066329, 0, 153, 13209, 26265, 39321, 52377, 65433, 3342489, 3355545, 3368601, 3381657, 3394713, 3407769, 6684825, 6697881, 6710937, 6723993, 6737049, 6750105, 13421772, 0, 204, 13260, 26316, 39372, 52428, 65484, 3342540, 3355596, 3368652, 3381708, 3394764, 3407820, 6684876, 6697932, 6710988, 6724044, 6737100, 6750156, 16777215, 0, 255, 13311, 26367, 39423, 52479, 65535, 3342591, 3355647, 3368703, 3381759, 3394815, 3407871, 6684927, 6697983, 6711039, 6724095, 6737151, 6750207, 16711680, 0, 10027008, 10040064, 10053120, 10066176, 10079232, 10092288, 13369344, 13382400, 13395456, 13408512, 13421568, 13434624, 16711680, 16724736, 16737792, 16750848, 16763904, 16776960, 65280, 0, 10027059, 10040115, 10053171, 10066227, 10079283, 10092339, 13369395, 13382451, 13395507, 13408563, 13421619, 13434675, 16711731, 16724787, 16737843, 16750899, 16763955, 16777011, 255, 0, 10027110, 10040166, 10053222, 10066278, 10079334, 10092390, 13369446, 13382502, 13395558, 13408614, 13421670, 13434726, 16711782, 16724838, 16737894, 16750950, 16764006, 16777062, 16776960, 0, 10027161, 10040217, 10053273, 10066329, 10079385, 10092441, 13369497, 13382553, 13395609, 13408665, 13421721, 13434777, 16711833, 16724889, 16737945, 16751001, 16764057, 16777113, 65535, 0, 10027212, 10040268, 10053324, 10066380, 10079436, 10092492, 13369548, 13382604, 13395660, 13408716, 13421772, 13434828, 16711884, 16724940, 16737996, 16751052, 16764108, 16777164, 16711935, 0, 10027263, 10040319, 10053375, 10066431, 10079487, 10092543, 13369599, 13382655, 13395711, 13408767, 13421823, 13434879, 16711935, 16724991, 16738047, 16751103, 16764159, 16777215];
		protected var colorArrBmp:Bitmap=new Bitmap()
		protected var colorBmpData:BitmapData
		protected var colorGrid:Sprite = new Sprite()
		protected var movieGrid:Shape = new Shape()
		protected var _colorGridWH:uint 
		protected var showColor:DisplayObject
		protected var showBox:MovieClip
		protected var swatchPanel:Sprite
		protected var swatchPanelBg:DisplayObject
		protected var swatchColor:DisplayObject
		protected var swatchPanelLabel:TextField
		protected var swatchRect:Rectangle = new Rectangle()
		protected var colorT:ColorTransform=new ColorTransform()
		protected var _selectedColor:uint = 0x0
		protected var _listDirection:uint;
		private var _downBool:Boolean=false;
		private var _skin:*;
		
		
		public function MColorPicker(config:*=null) 
		{
			/*
			 * 测试
			var spr:Sprite = new Sprite()
			addChild(spr)
			for (var i:uint = 0; i <colorArr.length; i++) 
			{
				spr.graphics.lineStyle(.1,0)
				spr.graphics.beginFill(colorArr[i])
				spr.graphics.drawRect((i % 20 )*11,(i / 20 >> 0) * 11,11,11)
			}
			*/
			colorGridWH=11
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			super(config)
			if (config) {
				if (config.colorGridWH != null) colorGridWH = config.colorGridWH
				if (config.selectedColor != null) selectedColor = config.selectedColor
				if (config.color!=null) selectedColor = config.color
				if (config.skin != null) skin = config.skin
			}
			if (!skin) skin = null
			
		}
		/**设置组件皮肤*/
		public function get skin():*{return _skin}
		public function set skin(value:*):void {
			if (value is Sprite) {
				if(_skin&&contains(_skin as Sprite))removeChild(_skin as Sprite)
				_skin = value;
				var _skinS:Sprite = _skin
				addChild(_skin as Sprite)
				//_skinS.mouseEnabled = false
				//_skinS.mouseChildren=false
				try {
					//close()
					if(swatchPanel&&swatchPanel.parent)swatchPanel.parent.removeChild(swatchPanel)
					swatchPanel = _skinS.getChildByName('swatchPanel') as Sprite
					if (swatchPanel.parent) swatchPanel.parent.removeChild(swatchPanel)
					showBox = _skinS.getChildByName('showBox') as MovieClip
					_width = showBox.width
					_height = showBox.height
					colorT.color=color
					showColor=_skinS.getChildByName('showColor')
					showColor.transform.colorTransform = colorT
					swatchColor = swatchPanel.getChildByName('swatchColor') 
					swatchColor.transform.colorTransform = colorT
					if (swatchPanelLabel) swatchPanelLabel.removeEventListener(Event.CHANGE, colorChange)
					
					swatchPanelLabel = swatchPanel.getChildByName('swatchPanelLabel') as TextField
					swatchPanelLabel.addEventListener(Event.CHANGE, colorChange)
					swatchPanelLabel.text = color.toString(16)
					swatchPanelBg = swatchPanel.getChildByName('swatchPanelBg')
					var tmep:DisplayObject= swatchPanel.getChildByName('swatchRect')
					movieGrid.x=colorGrid.x=colorArrBmp.x=swatchRect.x = tmep.x
					movieGrid.y=colorGrid.y=colorArrBmp.y=swatchRect.y = tmep.y
					swatchRect.width = swatchPanelBg.width-tmep.width-tmep.x
					swatchRect.height = swatchPanelBg.height - tmep.height - tmep.y
					swatchPanel.addChild(colorArrBmp)
					swatchPanel.addChild(colorGrid)
					swatchPanel.addChild(movieGrid)
					colorGrid.addEventListener(MouseEvent.MOUSE_MOVE, colorMovie)
					colorGrid.addEventListener(MouseEvent.MOUSE_DOWN,colorDown)
					upSize()
				}catch (e:TypeError) {
					trace(e)
					skin=new MColorPickerSkin()
				}
			}else if (value == null){skin=new MColorPickerSkin()}
		}
		/**
		 * 文本改变
		 * @param	e
		 */
		private function colorChange(e:Event):void 
		{
			var _color:uint = uint('0x'+swatchPanelLabel.text)
			colorT.color = _color
			dispatchEvent(new Event('movieColor'))
			swatchColor.transform.colorTransform = colorT
		}
		/**
		 * 取色移动按下
		 * @param	e
		 */
		private function colorDown(e:MouseEvent):void 
		{
			//trace('dd')
			var _color:uint = colorBmpData.getPixel(colorGrid.mouseX, colorGrid.mouseY)
			colorT.color = _color
			swatchPanelLabel.text = _color.toString(16)
			swatchColor.transform.colorTransform = colorT
			movieGrid.x = ((colorGrid.mouseX / colorGridWH) >> 0)*colorGridWH + colorArrBmp.x
			movieGrid.y = ((colorGrid.mouseY / colorGridWH) >> 0) * colorGridWH + colorArrBmp.y
			color = _color
			close()
		}
		/**
		 * 取色移动动画
		 * @param	e
		 */
		private function colorMovie(e:MouseEvent):void 
		{
			//trace(colorGrid.mouseX, colorGrid.mouseY)
			var _color:uint = colorBmpData.getPixel(colorGrid.mouseX, colorGrid.mouseY)
			colorT.color = _color
			if (swatchPanelLabel.text != _color.toString(16)) {
				//trace('movieColor')
				dispatchEvent(new Event('movieColor'))
			}
			swatchPanelLabel.text = _color.toString(16)
			swatchColor.transform.colorTransform = colorT
			movieGrid.x = ((colorGrid.mouseX / colorGridWH) >> 0)*colorGridWH + colorArrBmp.x
			movieGrid.y = ((colorGrid.mouseY / colorGridWH) >> 0) * colorGridWH + colorArrBmp.y
			
		}
		
		/**
		 * 隐藏下拉 swatchPanel 对象
		 * @param	trigger
		 */
		public function  close(e:Event = null):void {
			if (swatchPanel&&swatchPanel.parent)swatchPanel.parent.removeChild(swatchPanel)
			_downBool=false
			goto(1)
			if(stage)stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
		}
		/**
		 * 显示下拉 swatchPanel 对象，该对象显示可供用户选择的颜色。
		 */
		public function open():void {
			listDirection=listDirection
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			_downBool = true
			goto(2)
			if (swatchRect&&skin) {
				movieGrid.x=swatchRect.x 
				movieGrid.y = swatchRect.y 
				//var _color:uint = colorBmpData.getPixel(colorGrid.mouseX, colorGrid.mouseY)
				colorT.color = color
				swatchPanelLabel.text = color.toString(16)
				swatchColor.transform.colorTransform = colorT
				//movieGrid.x = ((colorGrid.mouseX / colorGridWH) >> 0)*colorGridWH + colorArrBmp.x
				//movieGrid.y=((colorGrid.mouseY/colorGridWH)>>0)*colorGridWH+colorArrBmp.y
			}
			
		}
		protected function mouseDown(e:MouseEvent):void {
			if (!_downBool) {
				open()
				e.stopPropagation()
				return
			}else {
				//trace(e.target )
				if (e.target == this||this.contains(e.target as DisplayObject) ) {
					close()
					e.stopPropagation()
					return
				}
				if (e.target == swatchPanel||swatchPanel.contains(DisplayObject( e.target))||this.contains(DisplayObject( e.target))) return
				close()
				e.stopPropagation()
			}
			
		}
		private function goto(value:uint):void {
			if (showBox&&(value==1||value==2)) {
				showBox.gotoAndStop(value)
			}
		}
		/**
		 * 设置列表出现方位 九宫格
		 */
		public function set listDirection(value:uint):void 
		{
			_listDirection=value
			if (swatchPanel) {
				if (stage) {
					if (_listDirection == 1 || _listDirection == 2 || _listDirection == 3 ) {
						swatchPanel.x = this.localToGlobal(new Point()).x
						swatchPanel.y = this.localToGlobal(new Point()).y - swatchPanel.height
					}
					else if (_listDirection == 4) {
						swatchPanel.x = this.localToGlobal(new Point()).x-width
						swatchPanel.y = this.localToGlobal(new Point()).y
					}else if (_listDirection == 6) {
						swatchPanel.x = this.localToGlobal(new Point()).x+width
						swatchPanel.y = this.localToGlobal(new Point()).y
					}
					else  {
						swatchPanel.x = this.localToGlobal(new Point()).x
						swatchPanel.y = this.localToGlobal(new Point()).y + height
					}
					stage.addChild(swatchPanel)
				}
			}
		}
		public function get listDirection():uint { return _listDirection; }
		/**
		 * 设置格子大小
		 */
		public function get colorGridWH():uint { return _colorGridWH; }
		
		public function set colorGridWH(value:uint):void 
		{
			if(_colorGridWH == value)return ;
			if (colorBmpData) colorBmpData.dispose()
			_colorGridWH=value
			colorBmpData = new BitmapData(20 * _colorGridWH, 12 * _colorGridWH)
			colorArrBmp.bitmapData = colorBmpData
			colorGrid.graphics.clear()
			movieGrid.graphics.clear()
			movieGrid.graphics.lineStyle(.1, 0xffffff)
			movieGrid.graphics.drawRect(0,0,value,value)
			for (var i:uint = 0; i <colorArr.length; i++) 
			{
				colorBmpData.copyPixels(new BitmapData(value, value, false, colorArr[i]), new Rectangle(0, 0, value, value),
					new Point((i % 20 )*value,(i / 20 >> 0) * value)
				)
				colorGrid.graphics.lineStyle(.1,0)
				colorGrid.graphics.beginFill(0,0)
				colorGrid.graphics.drawRect((i % 20 )*value,(i / 20 >> 0) * value,value,value)
			}
			upSize()
		}
		/**
		 *  选择的颜色
		 */
		public function get selectedColor():uint { return _selectedColor; }
		
		public function set selectedColor(value:uint):void 
		{
			if (_selectedColor == value) return;
			_selectedColor=value
			colorT.color=color
			showColor.transform.colorTransform = colorT
			dispatchEvent(new Event('selectedColor'))
		}
		/**
		 *  选择的颜色 与selectedColor 相同
		 */
		public function set color(value:uint):void {
			selectedColor = value
			
		}
		public function get color():uint { return selectedColor; }
		/**
		 * 更新组件大小
		 */
		override public function upSize():void {
			if (swatchPanelBg) {
				swatchPanelBg.width =colorArrBmp.width+swatchRect.x+swatchRect.width
				swatchPanelBg.height=colorArrBmp.height+swatchRect.y+swatchRect.height
			}
		}	
		/**
		 * @inheritDoc
		 */
		override public function destory():void {
			super.destory()
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			if(stage)stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
		}
	}

}