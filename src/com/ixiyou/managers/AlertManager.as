package  com.ixiyou.managers
{
	
	
	/**
	* 不是很完美的警告框组件
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	import com.ixiyou.utils.display.MFilters;
	import com.ixiyou.speUI.collections.BgShape;
	//import com.ixiyou.speUI.core.MSprite
	import com.ixiyou.speUI.collections.MSprite
	import flash.display.*;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	public class AlertManager extends EventDispatcher
	{
		private static var instance : AlertManager;
		//场景字典
		private static var stageDic:Dictionary=new Dictionary()
		/**
		 * 返回这个类的实例，做为静态方法返回实例。这样保证这个实例是唯一
		 * @param 
		 * @return 
		*/
		public static function getInstance(value:Stage = null) : AlertManager {
			/**
			 * 默认方式
			 */
			if (value == null) {
				if (instance == null)
				instance = new AlertManager();
				return instance;
			}else {
				//从字典里获取
				if (stageDic[value] != null) return stageDic[value] as AlertManager
				else {
					//字典里没有，创建一个
					var temp:AlertManager = new AlertManager();
					temp.stage=value
					stageDic[value] =temp
					return temp
				}
			}
			
		}
		//场景舞台
		private var _stage:DisplayObjectContainer
		private var objList:Array
		private var _container:MSprite
		private var _bg:uint = 0x0
		private var _alpha:Number=.2
		//事件对象列表
		private var objects:Dictionary;
		private var filtersArr:Array=new Array()
		/**
		 * 构造函数
		 */
		public function AlertManager() {
			objects=new Dictionary()
			objList = new Array()
			_container = new MSprite()
			//_bg.alpha = .2
			//_bg.visible=false
			MSprite(_container).autoSize = true
			_container.addEventListener(Event.RESIZE, function():void {computShow()})
			//_container.addChild(_bg)
			_container.addEventListener(Event.ADDED, ADDED)
			_container.addEventListener(Event.REMOVED,REMOVED)
		}
		public function setBgAlpha(value:Number):void {
			_alpha = value
			computShow()
		}
		/**
		 * 有新对象需要展现
		 * @param	e
		 */
		private function ADDED(e:Event):void {
			if (e.target == _container) return
			if (stage == null) return
			var obj:DisplayObject = DisplayObject(e.target)
			/**
			 * 添加警告对象
			 * @param	obj 警告对象
			 * @param	bgBool 是否使用背景
			 * @param	bg 背景色、或位图
			 * @param	filterBool 是否使用滤镜
			 */
			var temp:Object = objects[obj];
			if (temp == null) return
			stage.addChild(_container)
			//if (temp.bgBool)_bg.visible = true;
			//if (temp.bg != null)_bg.bg = temp.bg;
			_bg = temp.bg;
			computShow()
		}
		/**
		 * 有对象被剔除
		 * @param	e
		 */
		private function REMOVED(e:Event):void {
			
			if (e.target == _container) return
			if (stage == null) return
			if (objects[e.target] == null) return
			var obj:DisplayObject = DisplayObject(e.target)
			/**
			 * 添加警告对象
			 * @param	obj 警告对象
			 * @param	bgBool 是否使用背景
			 * @param	bg 背景色、或位图
			 * @param	filterBool 是否使用滤镜
			 */
			computShow(obj)
			removeObjForArr(objList,obj)
		}
		/**
		 * 设置场景
		 */
		public function set stage(value:DisplayObjectContainer ):void 
		{
			//字典已经存在的一个场景
			if(stageDic[value]!=null)return
			if (stage) return
			_stage = value
			stageDic[value]=this
		}
		public function get stage():DisplayObjectContainer {
			return _stage
		}
		/**
		 * 计算是否需要展示
		 */
		private function computShow(value:DisplayObject=null):void {
			if(stage==null) return
			var temp:Object
			var num:uint = _container.numChildren;
			var i:int 
			var d:DisplayObject
			//是否有背景
			var bgBool:Boolean = false
			for (i= 0; i <num; i++) 
			{
				d = _container.getChildAt(i)
				temp = objects[d];
				if (temp.bgBool) {
					bgBool = true;
					break;
				}
				
			}
			if (bgBool) {
				_container.graphics.clear()
				_container.graphics.beginFill(_bg,_alpha)
				_container.graphics.drawRect(-stage.stage.stageWidth,-stage.stage.stageHeight,stage.stage.stageWidth*2,stage.stage.stageHeight*2)
			}
			else {
				_container.graphics.clear()
				_container.graphics.beginFill(0x0, 0)
				_container.graphics.drawRect(-stage.stage.stageWidth,-stage.stage.stageHeight,stage.stage.stageWidth*2,stage.stage.stageHeight*2)
			}
			//模糊
			var filterBool:Boolean = false
			for (i = 0; i <num; i++) 
			{
				d=_container.getChildAt(i)
				temp = objects[d];
				if (temp.filterBool) {
					filterBool = true;
					break;
				}
			}
			if (filterBool) setFilters()
			else clearFilters()
			//是否需要显示
			//trace(num,_container.numChildren)
			if ((num == 0 || (value&&num==1&&_container.contains(value)))
			&&stage.contains(_container)) {
				stage.removeChild(_container)
				clearFilters()
			}
		}	
		/**
		* 设置模糊滤镜
		* @author 
		*/
		private function setFilters():void {
			if (!stage) return;
				var num:uint = stage.numChildren
				var temp:DisplayObject
				var i:uint
				
				for (i= 0; i < filtersArr.length; i++) 
				{
					temp = filtersArr[i] as DisplayObject
					if (temp != _container) {
						temp.filters=[]
					}
				}
				for (i= 0; i < num; i++) 
				{
					temp = stage.getChildAt(i)
					if (temp != _container) {
						temp.filters = [MFilters.getBlurFilter()]
						filtersArr.push(temp)
					}
				}
		}
		/**
		 * 清除模糊滤镜
		 */
		private function clearFilters():void {
			if (!stage) return;
				var num:uint = stage.numChildren
				var temp:DisplayObject
				var i:uint 
				for (i= 0; i < filtersArr.length; i++) 
				{
					temp = filtersArr[i] as DisplayObject
					temp.filters=[]
				}
				/*
				for (i= 0; i < num; i++) 
				{
					temp = stage.getChildAt(i)
					if (temp != _container) {
						temp.filters=[]
					}
				}
				*/
		}
		/**
		 * 添加警告对象
		 * @param	obj 警告对象
		 * @param	bgBool 是否使用背景
		 * @param	filterBool 是否使用滤镜
		 * @param	bg 背景色、或位图
		 */
		public function push(obj:DisplayObject, bgBool:Boolean = false, filterBool:Boolean = false, bg:*= null,alpha:Number=.2):void {
			if (!stage) return
			_alpha=alpha
			if (!_container.contains(obj)) {
				var temp:Object = { obj:obj, bgBool:bgBool, bg:bg, filterBool:filterBool }
				objList.push(temp)
				objects[obj] = temp
				//trace('add',objects[obj],obj)
				_container.addChild(obj)
				if (stage)stage.addChild(_container)
			}
		}
		/**
		* 删除对象
		* @author 
		*/
		public function remove(obj:DisplayObject):void {
			if(!stage)return
			if(_container.contains(obj))_container.removeChild(obj)
		}
		/**
		 * 清空所有
		 */
		public function clear():void {
			var arr:Array = new Array()
			var d:DisplayObject
			var i:int
			for ( i= 0; i <_container.numChildren; i++) 
			{
				d=_container.getChildAt(i)
				arr.push(d)
			}
			for ( i= 0; i <arr.length; i++) 
			{
				d=arr[i]
				if(_container.contains(d))_container.removeChild(d)
			}	
		}
		/**
		* 检查是否在显示列表中
		* @author 
		*/
		public function inspectInList(obj:DisplayObject):Boolean {
			if(objList.length<1)return false
			for (var i:uint = 0; i < objList.length; i++) {
				if(obj==objects[i])return true
			}
			return false
		}
		
		/**
		 * 删除数组中制定对象
		 * @param	arr
		 * @param	obj
		 */
		private function removeObjForArr(arr:Array, obj:Object):void {
			objects[obj] = null
			for (var i:int = 0; i < arr.length; i++) 
			{
				if (obj == arr[i]) {
					arr.splice(i, 1);
					break; 
				}
			}
		}
		/**
		 * 是否存在对象
		 * @param	arr
		 * @param	obj
		 * @return
		 */
		private function ObjONArr(arr:Array, obj:Object):Boolean {
			var bool:Boolean=false
			for (var i:int = 0; i < arr.length; i++) 
			{
				if (obj == arr[i]) {
					bool=true
					break; 
				}
			}
			return bool
		}
	}
	
}