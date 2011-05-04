package com.ixiyou.speUI.controls 
{
	/**
	 * MTreeBase的扩展，所有节点都是MTree类型
	 * 可能TreeManager进行管理
	 * 添加子节点使用 add,addAt方法
	 * 删除子节点使用 remove,removeAt方法
	 * @author magic
	 */
	
	import com.ixiyou.speUI.controls.MTreeBase;
	import com.ixiyou.speUI.controls.skins.CheckButtonSkin;
	import com.ixiyou.speUI.core.ISkinComponent;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class MTree extends MTreeBase implements ISkinComponent
	{
		private static var _defaultSkin:Class=CheckButtonSkin;
		private var _items:Array;
		protected var _parentTree:MTree;
		protected var _rootTree:MTree;
		protected var _label:String;
		protected var _headBtn:MCheckButton;
		public var data:Object;
		public function MTree(config:*=null) {
			_items = new Array();
			_rootTree = this;
			if (config == null) config = new Object();
			if (config.skin == null) config.skin = new _defaultSkin();
			config.head = _headBtn = new MCheckButton( { skin:config.skin } );
			delete config.skin;
			if (config.data != null) {
				data = config.data;
			}
			super(config);
			if (config.label) {
				label = config.label;
			}
		}
		
		/**
		 * 添加一个节点
		 * @param	mt
		 */
		public function add(mt:MTree):void { 
			_box.addChild(mt);
			_items.push(mt);
			mt._rootTree = _rootTree;
			mt._parentTree = this;
		}
		
		/**
		 * 轻型添加
		 * @param	mt
		 */
		public function addSimple(mt:MTree):void {
			_box.box.addChild(mt);
			_items.push(mt);
			mt._rootTree = _rootTree;
			mt._parentTree = this;
		}
		
		/**
		 * 轻型添加到指定位置
		 * @param	mt
		 * @param	index
		 */
		public function addSimpleAt(mt:MTree, index:uint):void {
			_box.box.addChildAt(mt, index);
			_items.splice(index, 0, mt);
			mt._rootTree = _rootTree;
			mt._parentTree = this;
		}
		
		/**
		 * 在指定位置添加一个节点
		 * @param	mt
		 * @param	index
		 */
		public function addAt(mt:MTree,index:uint):void{
			_items.splice(index, 0, mt);
			_box.addChildAt(mt, index);
			mt._rootTree = _rootTree;
			mt._parentTree = this;
		}
		
		/**清除所有子节点*/
		public function clear():void {
			var len:int = _items.length;
			_items = new Array();
			for (var i:int = 0; i < len; i++) {
				_box.removeChildAt(i);
			}
		}
		
		/**
		 * 获取指定位置的节点
		 * @param	index
		 * @return
		 */
		public function getTreeAt(index:uint):MTree{return _items[index];}
		
		/**
		 * 获取节点所在位置
		 * @param	mt
		 * @return
		 */
		public function getTreeIndex(mt:MTree):int {return _items.indexOf(mt);	}
		
		/**
		 * 移出一个节点
		 * @param	mt
		 */
		public function remove(mt:MTree):void { 
			mt._rootTree = mt;
			mt._parentTree = null;
			_box.removeChild(mt as DisplayObject);
			_items.splice(_items.indexOf(mt), 1);
		}
		/**
		 * 移出指定位置的节点
		 * @param	index
		 * @return
		 */
		public function removeAt(index:uint):MTree{
			_items.splice(index, 1);
			var mt:MTree = _box.removeChildAt(index) as MTree;
			mt._parentTree = null;
			mt._rootTree = mt;
			return mt;
		}
		
		/**父级节点*/
		public function get parentTree():MTree { return _parentTree; }
		
		/**根节点*/
		public function get rootTree():MTree { return _rootTree; }
		
		/**是否为末尾节点*/
		public function get isEnd():Boolean {return _items.length == 0;	}
		
		/**
		 * 推荐使用修改skin属性的方式修改head
		 */
		override public function get head():InteractiveObject { return _head; }
		
		/**子级节点*/
		public function get items():Array { return _items; }
		
		/**皮肤*/
		public function get skin():*{ return _headBtn.skin;	}
		public function set skin(value:*):void { _headBtn.skin = value; }
		
		/**设置label*/
		public function get label():String { return _headBtn.label; }
		public function set label(value:String):void { _headBtn.label = value; }
		
		/**MTree的默认皮肤*/
		static public function get defaultSkin():Class { return _defaultSkin; }
		static public function set defaultSkin(value:Class):void { _defaultSkin = value;	}
		
		/**
		 * 根据现有数据创建MTree实例
		 * @param	value	
		 * @return
		 */
		static public function createTreeBy(value:Object=null):MTree {
			if (value == null) return new MTree();
			var mt:MTree = new MTree(value);
			if (value.items is Array) {
				var len:int = value.items.length;
				for (var i:int = 0; i <len; i++) {
					mt.add(createTreeBy(value.items[i]));
				}
			}
			return mt;
		}
	}
}