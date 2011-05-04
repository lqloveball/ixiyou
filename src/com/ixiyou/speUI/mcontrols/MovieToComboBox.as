package com.ixiyou.speUI.mcontrols 
{
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import com.ixiyou.events.DataSpeEvent;
	import com.ixiyou.speUI.mcontrols.MovieToTextVScrollBar
	import com.ixiyou.utils.display.ButtonUtil
	import com.ixiyou.utils.display.MovieUtils
	import caurina.transitions.Tweener
	import flash.utils.Dictionary;
	/**
	 * 下拉框滚动
	 * @author $(DefaultUser)
	 */
	public class MovieToComboBox extends Sprite 
	{
		private var _data:Array;
			//皮肤
		protected var _skin:*
		
		protected var selectBox:MovieClip
		protected var selectText:TextField
		
		protected var sl:MovieToTextVScrollBar
		protected var infoBox:Sprite
		protected var infoText:TextField
		
		private var dataDic:Dictionary
		private var _seletData:Object
		/**
		 * 
		 * @param	skin
		 * @param	config
		 * @param	formerly
		 * @param	parentBool
		 */
		public function MovieToComboBox(skin:Sprite,config:*=null,formerly:Boolean=false,parentBool:Boolean=false) 
		{
			var tempParent:DisplayObjectContainer
			
			if (formerly) {
				this.x = skin.x
				this.y = skin.y
			}
			if (skin.parent&& parentBool) {
				tempParent=skin.parent
				this.name=skin.name
			}
			if (skin) this.skin = skin
			if(tempParent)tempParent.addChild(this)
			if (config) {
				if (config.data != null && config.data is Array) {
					data=config.data as Array
				}
			}
		}
		
		public function get skin():* { return _skin; }
		
		public function set skin(value:*):void 
		{
			//_skin = value;
			if (value is Sprite) {
				try {
					//trace('skin------------')
					if (_skin && this.contains(_skin)) removeChild(_skin)
					_skin = value;
					var skin1:Sprite=Sprite(_skin)
					addChild(skin1)
					skin1.x = skin1.y = 0
					
					selectBox = Sprite(_skin).getChildByName('_selectBox') as MovieClip
					ButtonUtil.setSelectButton(selectBox)
					selectText = selectBox.getChildByName('text') as TextField
					selectText.text = ''
					
					selectBox.addEventListener('upSelect', selectBoxUpSelect)
					
					
					infoBox = Sprite(_skin).getChildByName('box') as Sprite
					infoText = infoBox.getChildByName('text') as TextField
					infoText.addEventListener(TextEvent.LINK,textLink)
					infoText.text = ''
					infoText.condenseWhite = true
					infoText.selectable=false
					sl=new MovieToTextVScrollBar(infoBox.getChildByName('_scrollBar') as Sprite,{},true,true)
					sl.hideBool = true
					sl.content = infoText
					skin.removeChild(infoBox)
				}
				catch (e:TypeError) {
					trace('MovieToComboBox skin error:',e)
				}
			}
		}
		
		
		
		
		
		public function get data():Array { return _data; }
		
		public function set data(value:Array):void 
		{
			if (!value) return
			_seletData=null
			var test:Object=value[0]
			if (test is String) {
				var arr:Array = new Array()
				for (var i:int = 0; i < value.length; i++) 
				{
					var item:Object = {}
					item.label = value[i];
					arr.push(item)
				}
				_data=arr
			}else {
				_data = value;
			}
			upInfoBox()
			upSelet(0)
		}
		
		
		
		public function upInfoBox():void 
		{
			if (!data) return;
			dataDic=new Dictionary()
			var str:String=''
			for (var i:int = 0; i < data.length; i++) 
			{
				var item:Object= data[i];
				dataDic[i] = item
				str += '<u><a href=\"event:' +i+'\">'+item.label+'</a></u><br>'
			}
			infoText.htmlText =str
		}
		private function textLink(e:TextEvent):void 
		{
			upSelet(uint(e.text))
		}
		public function upSelet(value:uint):void {
			if (dataDic && dataDic[value]) {
				var obj:Object = dataDic[value]
				hitInfo()
				selectText.text = obj.label
				_seletData=obj
				dispatchEvent(new DataSpeEvent('upData', obj))
				
			}
		}
		public function get seletData():Object { return _seletData; }
		
		private function selectBoxUpSelect(e:Event):void 
		{
			var btn:MovieClip = e.target as MovieClip
			//trace(btn.select)
			if (btn.select) {
				showInfo()
			}else {
				hitInfo()
			}
		}
		public function showInfo():void {
			if (!infoBox) return;
			if (stage) {
				stage.addEventListener(MouseEvent.MOUSE_DOWN,stageHitDown)
			}
			infoBox.alpha=0
			Sprite(skin).addChild(infoBox)
			Tweener.addTween(infoBox, { time:.5, alpha:1 } )
			MovieUtils.movieFrame(selectBox, 'on')
			selectBox.select=true
		}
		
		private function stageHitDown(e:MouseEvent):void 
		{
			var temp:DisplayObject = e.target as DisplayObject
			if(!infoBox.contains(temp))hitInfo()
		}
		public function hitInfo():void {
			if (!infoBox) return
			if (stage) {
				stage.removeEventListener(MouseEvent.MOUSE_DOWN,stageHitDown)
			}
			Tweener.addTween(infoBox, { time:.5, alpha:0 , onComplete:function():void {
				if(this.parent)this.parent.removeChild(this)
			}} )
			//if (infoBox.parent) infoBox.parent.removeChild(infoBox)
			MovieUtils.movieFrame(selectBox, 'off')
			selectBox.select=false
		}
		
	}
}