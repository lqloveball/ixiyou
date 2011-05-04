package com.ixiyou.pv3d.show.objects
{
	
	/**
	 * 3D图片加载对象组件
	 * 带链接，带标题，带加载方法等等
	 * @author spe
	 */
	
	import flash.events.*;
	import flash.text.TextField;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import com.ixiyou.events.ResizeEvent;
	import flash.text.TextFormat;
	
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.events.InteractiveScene3DEvent
	
	public class PicLoadObj extends DisplayObject3D
	{
		
		//显示加载对象的面
		private var _picBox:Plane
		//显示字符的面
		private var _textBox:Plane
		//组件宽
		private var _w:uint=100
		//组件高
		private var _h:uint=100
		//组件展示数据
		private var _data:Object=null
		//组件加载对象背景颜色
		private var _picBgColor:uint = 0xd0d0d0;
		private var _picBgColor2:uint=0xB3B3B3
		//组件字符颜色
		private var _textBgColor:uint = 0x9e9e9e;
		//
		private var _textColor:uint=0xffffff
		//加载贴图
		private var _picMaterial:MovieMaterial
		//绘制对象
		private var _picSptrie:Sprite = new Sprite();
		//标题文件的贴图
		private var _textMaterial:MovieMaterial
		//标题绘制对象
		private var _textSptrie:Sprite = new Sprite();
		//标题
		private var _textTitle:TextField 
		//加载图片对象
		private var _loader:Loader = new Loader()
		//加载进度文字
		private var _loaderText:TextField
		//事件类型
		//数据开始加载
		public static var DATASTARTLOAD:String = 'dataStartLoad';
		//数据加载完成
		public static var DATALOADEND:String = 'dataLoadend';
		//设置数据完成
		public static var SETDATA:String = 'setData';
		public static var ONCLICK:String = 'onClick';
		/**
		 * 构造函数
		 * @param	_w
		 * @param	_h
		 * @param	_date
		 */
		public function PicLoadObj(_w:uint=100, _h:uint=100,_data:Object=null) 
		{
			this.
			//初始化数据
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
            _loader.contentLoaderInfo.addEventListener(Event.OPEN, openHandler);
            _loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            _loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            _loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			//
			this._w = _w
			this._h=_h
			initObj();
			//setSize(_w, _h);
			if (_data != null) this.data = _data
			this.alpha
		}
		/**
		 * 初始化这个对象内容
		 */
		public function initObj():void {
			//初始材质
			
			//
			_textTitle = new TextField();
			_textTitle.defaultTextFormat=new TextFormat('Arial,宋体',14,_textColor)
			//_textTitle.textColor = _textColor;
			_textTitle.text = 'Lable';
			_textSptrie.addChild(_textTitle);
			//文本材质
			_textMaterial = new MovieMaterial(_textSptrie);
			_textMaterial.animated = true;
			_textMaterial.smooth = true;
			_textMaterial.interactive=true
			//图片材质
			_loaderText = new TextField();
			_loaderText.defaultTextFormat = new TextFormat('Arial,宋体', 14, _textColor)
			_loaderText.autoSize='center'
			_loaderText.text = 'loading';
			_loaderText.width = this.width
			_loaderText.height = _loaderText.textHeight+2
			_loaderText.y=(this.height-(_loaderText.height+2))/2
			_picSptrie.addChild(_loaderText)
			_picSptrie.addChild(_loader)
			_picMaterial = new MovieMaterial(_picSptrie);
			_picMaterial.animated = true;
			_picMaterial.smooth = true;
			_picMaterial.interactive=true
			//初始对象
			_picBox = new Plane(_picMaterial, width, height);
			_picBox.y = 15
			addChild(_picBox)
			_textBox = new Plane(_textMaterial, width, 30)
			_textBox.y = -(height + 30) / 2+15
			addChild(_textBox);
			
			//更新材质大小
			upTextMaterialSize();
			upPicMaterialSize();
			//点击
			_textBox.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, onClick);
			_picBox.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, onClick);
		}
		private function onClick(e:InteractiveScene3DEvent):void {
			dispatchEvent(new Event(PicLoadObj.ONCLICK))
		}
		/**
		 * 加载完成
		 * @param	e
		 */
		private function completeHandler(e:Event):void {
			upPicMaterial()
			dispatchEvent(new Event(PicLoadObj.DATALOADEND))
		}
		/**
		 * 开始加载
		 * @param	e
		 */
		private function openHandler(e:Event):void {
			//trace('开始加载')
			dispatchEvent(new Event(PicLoadObj.DATASTARTLOAD))
		}
		/**
		 * 加载中
		 * @param	e
		 */
		private function progressHandler(e:ProgressEvent):void { 
			//trace('加载...')
			_loaderText.text=String((e.bytesLoaded/e.bytesTotal)*100>>0)+'%'
			_picSptrie.graphics.clear();
			_picSptrie.graphics.beginFill(_picBgColor);
			_picSptrie.graphics.drawRect(0, 0, width, height);
			_picSptrie.graphics.beginFill(_picBgColor2);
			_picSptrie.graphics.drawRect(0, height, width, -height*(e.bytesLoaded/e.bytesTotal));
			dispatchEvent(e)
		}
		//加载的其他监听
		private function securityErrorHandler(e:SecurityErrorEvent):void { }
		private function httpStatusHandler(e:HTTPStatusEvent):void { }
		private function ioErrorHandler(e:IOErrorEvent):void { }
		//加载图片
		public function loadImg(value:String):void {
			_loader.load(new URLRequest(value))
			
		}
		/**
		 * 设置数据
		 */
		public function set data(value:Object):void 
		{
			if (_data == value) return;
			_data=value
			lable = _data.lable
			loadImg(_data.image)
			dispatchEvent(new Event(PicLoadObj.SETDATA))
		}
		public function get data():Object { return _data; }
		/**
		 * 设置标题
		 */
		public function set lable(value:String):void {
			_textTitle.text = value;
			upTextMaterial();
		}
		public function get lable():String { return _textTitle.text; }
		
		/**
		 * 更新图片材质大小
		 */
		private function upPicMaterialSize():void {
			_picSptrie.graphics.clear();
			_picSptrie.graphics.beginFill(_picBgColor);
			_picSptrie.graphics.drawRect(0, 0, width, height);
			upPicMaterial();
		}
		/**
		 * 更新图片材质
		 */
		private function upPicMaterial():void {
			if (_picMaterial.bitmap)_picMaterial.bitmap.dispose();
			_picMaterial.bitmap = new BitmapData(width, height);
			_picMaterial.bitmap.draw(_picSptrie);
		}
		/**
		 * 更新文本材质大小
		 */
		private function upTextMaterialSize():void {
			
			_textSptrie.graphics.clear();
			_textSptrie.graphics.beginFill(_textBgColor);
			_textSptrie.graphics.drawRect(0, 0, width, 30);
			_textTitle.width = width;
			_textTitle.height = _textTitle.textHeight + 2;
			_textTitle.y = (30 - _textTitle.textHeight - 2) / 2;
			upTextMaterial();
		}
		/**
		 * 更新文本材质
		 */
		private function upTextMaterial():void {
			if (_textMaterial.bitmap)_textMaterial.bitmap.dispose();
			_textMaterial.bitmap = new BitmapData(width, 30);
			_textMaterial.bitmap.draw(_textSptrie);
		}
		/**
		 * 组件宽度
		 */
	    public function set width(value:uint):void 
		{
			if (_w == value) return;
			setSize(value, _h);
		}
		public function get width():uint { return _w; }
		/**
		 * 组件高度
		 */
		public function set height(value:uint):void 
		{	
			if (_h == value) return
			setSize(_w,value)
		}
		public function get height():uint { return _h; }
		/**设置大小*/
		public function setSize(w:Number, h:Number):void {
			if (w != _w|| h != _h) {
				var event:ResizeEvent = new ResizeEvent(ResizeEvent.RESIZE);
				event.oldHeight = _h;
				event.oldWidth = _w;
				if (w != _w) {
					var wevent:ResizeEvent = new ResizeEvent(ResizeEvent.WRESIZE);
					event.oldWidth = _w;
					_w = w;
					dispatchEvent(wevent);
				} 
				if (h != _h) {
					var hevent:ResizeEvent = new ResizeEvent(ResizeEvent.HRESIZE);
					hevent.oldHeight = _h;
					_h = h;
					dispatchEvent(hevent);
				} 
				upSize();
				dispatchEvent(event);
				dispatchEvent(new Event(Event.RESIZE));
				//大小变化事件
			}
		}
		public function upSize():void {
			upTextMaterialSize();
			upPicMaterialSize();
		}
	}
	
}