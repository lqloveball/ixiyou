package  
{
	import com.ixiyou.events.SelectEvent;
	import com.ixiyou.speUI.collections.MSprite;
	import com.ixiyou.speUI.controls.MButton;
	import com.ixiyou.speUI.controls.MCheckButton;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import caurina.transitions.Tweener
	
	/**
	 * 下拉滑块 组件
	 * @author spe
	 */
	public class dropDownPanel extends MSprite
	{
		private var _skin:Sprite
		//用一个选区按钮来做头部
		private var headBtn:MCheckButton
		private var bottomBg:DisplayObject
		private var text:TextField
		private var textBg:DisplayObject
		private var _info:String
		private var textBox:Sprite
		private var textMask:Shape
		private var textRect:Rectangle = new Rectangle()
		private var _allTextHeight:Number
		public function dropDownPanel(skin:Sprite) 
		{
			textMask = new Shape()
			textMask.graphics.beginFill(0)
			textMask.graphics.drawRect(0, 0, 10, 10)
			addChild(textMask)
			textBox = new Sprite()
			addChild(textBox)
			textBox.mask=textMask
			this.skin=skin
		}
		/**
		 * 设置皮肤
		 */
		public function get skin():Sprite { return _skin; }
		public function set skin(value:Sprite):void 
		{
			if (_skin == value) return;
			_skin = value;
			if(_skin)
			var _w:Number;
			var _h:Number;
			var headSKin:DisplayObject = _skin.getChildByName('_headSkin') as Sprite;
			var _bg:DisplayObject = _skin.getChildByName('_bg') as Sprite;
			var _text:TextField = _skin.getChildByName('_text') as TextField;
			var _textBg:DisplayObject = _skin.getChildByName('_textBg') as Sprite;
			textRect.x = _text.x
			textRect.y = _text.y - _textBg.y
			textRect.height = _textBg.height - _text.height-textRect.y
			//textRect.width=(_textBg.x+_textBg.width)-(_text.x+_text.width)
			_w = headSKin.width;
			_h = headSKin.height;
			//如果没有头按钮就创建一个
			if (!headBtn) {
				headBtn = new MCheckButton( { parent:this, skin:headSKin } )
				headBtn.addEventListener(SelectEvent.UPSELECT,headFun)
			}
			else headBtn.skin = headSKin
			headBtn.setSize(_w, _h)
			//如果不在显示列表
			if (!contains(headBtn)) addChild(headBtn)
			//背景也可以称为底部
			if(bottomBg&&contains(bottomBg))removeChild(bottomBg)
			bottomBg = _bg
			bottomBg.x = 0
			//bottomBg.y=textBox.y+textBox.height
			//bottomBg.alpha=.5
			addChild(bottomBg)
			//text背景
			if(textBg&&textBox.contains(textBg))textBox.removeChild(textBg)
			textBg = _textBg
			textBg.y=textBg.x = 0
			textMask.y=textBox.y = headBtn.y + headBtn.height
			textMask.width=textBg.width
			textBox.addChild(textBg)
			//text
			if(text&&textBox.contains(text))textBox.removeChild(text)
			text = _text
			text.x = textRect.x
			text.y=textRect.y
			textBox.addChild(text)
			if (info) info = info
			else info = 'test\ntest\ntest'
			this._width=textMask.width
			
		}
		
		/**
		 * 内容
		 */
		public function get info():String { return _info; }
		
		public function set info(value:String):void 
		{
			_info = value;
			//trace(1,_info)
			if (text) {
				text.height=0
				text.text = _info
				var _h:Number
				if (text.maxScrollV > 1)_h=text.textHeight+text.textHeight/(text.maxScrollV-1)
				else _h = text.textHeight
				if(_info=='')_h=0
				text.height = _h
				if (_h != 0)_allTextHeight = textBg.height = text.y + textRect.height + text.height
				else _allTextHeight=0
				if (headBtn.select) {
					textMask.height = _allTextHeight
					bottomBg.y = textMask.y + textMask.height
					Tweener.addTween(textMask, { time:.3, height:_allTextHeight, onUpdate:function():void {
						bottomBg.y=textMask.y+textMask.height
						}
					})
				}
				else {
					textMask.height = 0
					bottomBg.y=textMask.y+textMask.height
				}
			}
		}
		/**
		 * 区块高度
		 */
		public function get allTextHeight():Number { return _allTextHeight; }
		/**
		 * 头部点击
		 * @param	e
		 */
		private function headFun(e:SelectEvent):void 
		{
			//trace(headBtn.select)
			if (headBtn.select) {
				Tweener.addTween(textMask, { time:.3, height:_allTextHeight, onUpdate:function():void {
					bottomBg.y=textMask.y+textMask.height
					}
				})
			}else {
				Tweener.addTween(textMask, { time:.3, height:0, onUpdate:function():void {
					bottomBg.y=textMask.y+textMask.height
					}
				})
			}
		}
		/**
		 * 开启关闭开关
		 * @param	value
		 */
		public function selectShow(value:Boolean):void {
			if(headBtn.select!=value)headBtn.select=value
		}
	}

}