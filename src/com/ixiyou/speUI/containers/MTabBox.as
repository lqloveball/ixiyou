package com.ixiyou.speUI.containers 
{
	
	
	/**
	 * 实现滑门，显示区域使用的遮罩
	 * @author spe
	 */
	import com.ixiyou.speUI.containers.OneBox;
	import flash.display.DisplayObject
	public class MTabBox extends OneBox
	{
		//talList列表
		protected var _tabList:Array=new Array()
		public function MTabBox(config:*=null) 
		{
			super(config)
		}
		/**
		 * 标签列表
		 */
		public function get tabList():Array { return _tabList; }
		/**
		 * 添加制定对象
		 * @param	name tab名
		 * @param	children 显示对象
		 * @param	nowShow 是否马上显示
		 * @return
		 */
		public function push(name:String, children:DisplayObject,nowShow:Boolean=false):uint {
			if (_tabList[name] == undefined) {
				//if (nameContains(name)) remove(name)
				_tabList[name] = children
			}
			else return _tabList.length
			_tabList.push(name)
			if (nowShow) addChild(children)
			
			return _tabList.length
		}
		/**
		 * 删除指定名的显示对象
		 * @param	name
		 */
		public function remove(name:String):uint {
			if (_tabList[name] != undefined) {
				var temp:DisplayObject=_tabList[name]
				removeObjForArr(_tabList, name)
				_tabList[name] = undefined
				if(this.contains(temp))removeChild(temp)
			}
			return _tabList.length
		}
		/**
		 * 设置显示对象
		 * @param	name
		 */
		public function showTab(name:String):void {
			if (nameInList(name)&&_tabList[name]!=undefined) addChild(_tabList[name])
		}
		/**
		 * 获取指定对象名的对象
		 * @param	name
		 * @return
		 */
		public function getTab(name:String):DisplayObject {
			if (nameInList(name) && _tabList[name] != undefined) return _tabList[name] as DisplayObject
			else return null
		}
		/**
		 * 是否有对应的名字对象存在列表中
		 * @param	arr
		 * @param	obj
		 * @return
		 */
		public function nameInList(name:String):Boolean {
			for (var i:int = 0; i < _tabList.length; i++) 
			{
				if (name == _tabList[i])return true
			}
			return false
		}
		/**
		 * 清除所有的tab
		 */
		public function clearTab():void {
			var num:int=_tabList.length
			for (var i:int = 0; i < num; i++) 
			{
				remove(_tabList[0])
			}
		}
		/**
		 * 是目前显示
		 * @param	name
		 * @return
		 */
		public function setNameBool(name:String):Boolean {
			if (nameInList(name) && _tabList[name] != undefined) {
				var temp:DisplayObject = _tabList[name]
				if (contains(temp)) return true
				else return false
			}else return false
		}
		/**
		 * 删除数组中制定对象
		 * @param	arr
		 * @param	obj
		 */
		private function removeObjForArr(arr:Array, name:String):Boolean {
			for (var i:int = 0; i < arr.length; i++) 
			{
				if (name == arr[i]) {
					arr.splice(i, 1);
					return true
				}
			}
			return false
		}
	}

}