package com.ixiyou.net 
{

	/**
	 * 获取默认的HTML页面上的参数
	 * @author spe
	 */
	import flash.display.Sprite
	public class DefaultHtmlObj
	{
		//默认数据
		private var _data:Object
		//文档类
		private var _root:Sprite
		public function DefaultHtmlObj(root:Sprite=null) 
		{
			if(root)this.root=root
		}
		/**
		 * 设置文档类
		 */
		public function set root(value:Sprite):void 
		{
			if (_root == value) return
			_root = value
			_data=_root.loaderInfo.parameters
		}
		public function get root():Sprite { return _root; }
		/**
		 * 默认数据
		 */
		public function get data():Object { return _data; }
	}

}