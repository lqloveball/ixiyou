package com.ixiyou.speUI.controls.listClasses 
{
	
	/**
	 * 列表的项 ，IListBase类型使用的项表现
	 * @author spe
	 */
	import com.ixiyou.speUI.collections.SMovieClipBase;
	import com.ixiyou.speUI.core.IListIteam
	import com.ixiyou.speUI.collections.MSprite
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite
	import flash.geom.Rectangle;
	import flash.text.TextField;
	public class ListIteamDefault extends MSprite implements IListIteam
	{
		//显示用的标题
		protected var _label:TextField
		protected var _labelRect:Rectangle=new Rectangle()
		//数据
		protected var _data:Object
		//展现属性
		protected var _showProperty:String = "label"
		//是否选择
		protected var _select:Boolean = false
		//皮肤
		protected var _skin:*
		protected  var tmepLabel:TextField
		//
		protected var _stateBox:SMovieClipBase=new SMovieClipBase()
		public function ListIteamDefault(config:*=null) 
		{
			this.mouseChildren = false
			tmepLabel= new TextField()
			//不自动换行
			tmepLabel.wordWrap = false
			//默认不可选
			tmepLabel.selectable = false
			tmepLabel.x =tmepLabel.y = 0
			//addChild(_label)
			label=tmepLabel
			addChild(_stateBox)
			this.percentWidth = 1
			//this.height=20
			super(config)
			if (config != null) {
				if(config.skin!=null)skin=config.skin
				if(config.data!=null)data=config.data
				if(config.showProperty!=null)showProperty=config.showProperty
			}
		}
		
		/**设置组件皮肤*/
		public function get skin():*{ return _skin; }
		public function set skin(value:*):void {
			if (value is Sprite) {
					try {
						if (Sprite(value).getChildByName('_select0') ) {
							_skin = value;
							if (_skin) {
								_height =Sprite(_skin).height
							}
							_stateBox.replaceLabel('_select0', Sprite(_skin).getChildByName('_select0'))
							if (Sprite(_skin).getChildByName('_select1'))_stateBox.replaceLabel('_select1', Sprite(_skin).getChildByName('_select1'))
							else _stateBox.replaceLabel('_select1', Sprite(_skin).getChildByName('_select0'))
							if (Sprite(_skin).getChildByName('_label') && Sprite(_skin).getChildByName('_label') is TextField) {
								if(label&&contains(label))removeChild(label)
								label = Sprite(_skin).getChildByName('_label') as TextField
								//addChild(label)
								_labelRect.width = Sprite(_skin).width - Sprite(_skin).getChildByName('_label').width-Sprite(_skin).getChildByName('_label').x
								_labelRect.height = Sprite(_skin).height - Sprite(_skin).getChildByName('_label').height-Sprite(_skin).getChildByName('_label').y
							}else {
								_labelRect.width =_labelRect.height =0
								label.y=label.x=0
							}
							upSize()
						}else {
							_skin=null
						}
					}catch (e:TypeError) {
						trace(e)
						skin=null
					}
			}else if (value == null) {
				skin = null
			}
		}
		/**
		 * 更新数据
		 * @param	value 数据源
		 * @param	inBeing 现有的属性才更新
		 */
		public function upData(value:Object,inBeing:Boolean=true):void {
			if (!data) return
			var key:*
			if (!inBeing) {
				for (key in value) data[key] = value[key];
			}else {
				for (key in value) {
					if(data.hasOwnProperty(key)) data[key] = value[key];
				}
			}
			draw()
		}
		/**
		 * 设置选取
		 */
		public function set select(value:Boolean):void {
			if (_select == value) return
			_select = value
			drawSelected()
		}
		public function get select():Boolean { return _select; }
		
		/**
		 * 作为label显示的字段
		 */
		public function set showProperty(value:String):void {
			if (_showProperty == value) return
			_showProperty=value
			draw()
		}
		public function get showProperty():String{return _showProperty}
		/**
		 * 数据
		 */
		public function set data(value:Object):void {
			if (_data == value) return
			_data = value
			draw()
		}
		public function get data():Object{return _data}
		
		/**
		 * 文本
		 */
		public function set label(value:TextField):void 
		{
			if(_label==value)return
			if(_label&&this.contains(_label))removeChild(_label)
			_label = value;
			if(data!=null)_label.text = String(data[showProperty])
		}
		/**
		 * 文本
		 */
		public function get label():TextField { return _label; }
		/**根据目前数据和样式绘制*/
		public function draw():void {
			if (data != null) {
				if (data[showProperty] != null) {
					label.text = String(data[showProperty])
				}
				else label.text=""
			}else {
				label.text = ""
			}
			if (label) {
				label.width =this.width-_labelRect.width- label.x
				label.height = this.height - _labelRect.height - label.y
				if(!this.contains(label))addChild(label)
			}
			drawSelected()
		}
		/**
		 * 设置选取情况的绘制
		 */
		protected function drawSelected():void {
			if (skin) {
				if (select) _stateBox.gotoAndStop('_select1')
				else _stateBox.gotoAndStop('_select0')
				return 
			}
			if (select) {
				this.graphics.clear()
				this.graphics.beginFill(0xdfeeff)
				this.graphics.drawRect(0, 0, this.width, this.height)
				this.graphics.beginFill(0x90c3fe)
				this.graphics.drawRect(0,  this.height-1, this.width, 1)
			}else {
				this.graphics.clear()
				this.graphics.beginFill(0xffffff)
				this.graphics.drawRect(0, 0, this.width, this.height)
				this.graphics.beginFill(0x90c3fe)
				this.graphics.drawRect(0,  this.height-1, this.width, 1)
			}
		}
		/**
		 * 帧跳转
		 * @param	value
		 */
		protected function goto(value:uint):void {
			if (!skin||!(skin is MovieClip)) return
			var movie:MovieClip=skin as MovieClip
			var temp:DisplayObject
			movie.gotoAndStop(value)
			
			if(movie.numChildren<1)return
			temp = movie.getChildAt(0)
			//trace(temp,movie.getChildAt(0),movie.numChildren)
			if(!temp)temp=movie
			temp.width = width
			temp.height = height
		}
		/**
		 * 调整时候处理大小问题
		 * @param	value
		 */
		override public function upSize():void {
			//trace(height)
			_stateBox.setAllMovieSize(width,height)
			draw()
		}
		/**事件摧毁*/
		override public function destory():void {
			super.destory()
		}
	}
	
}