package com.ixiyou.managers 
{
	import flash.display.*;
	import flash.events.*;
	import com.ixiyou.events.SelectEvent;
	import com.ixiyou.utils.ArrayUtil;
	import com.ixiyou.speUI.mcontrols.MovieToCheckButton
	/**
	 *  MovieClip 转换来的按钮做单选按钮的管理
	 * @author spe email:md9yue@qq.com
	 */
	
	 //添加按钮
	[Event(name = "addAll", type = "flash.events.Event")]
	[Event(name = "removeAll", type = "flash.events.Event")]
	//选择更新
	[Event(name="upSelect", type="com.ixiyou.events.SelectEvent")]
	public class MovieToCheckButtonManagers extends EventDispatcher
	{
		
		//按钮数据集
		private var _dataArr:Array
		//当前选择
		private var _selected:MovieClip
		public var seletFun:Function
		public function MovieToCheckButtonManagers(arr:Array=null,seletFun:Function=null) 
		{
			if (arr == null ) dataArr = new Array()
			else dataArr = arr
			this.seletFun=seletFun
		}
		/**
		 * 设置按钮组
		 */
		public function set dataArr(value:Array):void 
		{
			if (_dataArr == value) return;	
			var i:int
			clear()
			_dataArr = new Array()
			for ( i= 0; i < value.length; i++) 
			{
				if(value[i] is MovieClip)push(MovieClip(value[i]))
			}
			dispatchEvent(new Event('addAll'))
		}
		public function get dataArr():Array { return _dataArr; }
		/**
		 * 当前选择的按钮
		 */
		public function get selected():MovieClip { return _selected; }
		/**
		 * 清除所有
		 */
		public function clear():void {
			if (dataArr) {
				var value:MovieClip
				for (var i:int = dataArr.length-1; i >=0; i--) {
					if (dataArr[i] is MovieClip) {
						value = MovieClip( dataArr[i])
						if(value is MovieClip)remove(MovieClip(value))
					}
				}
				dispatchEvent(new Event('removeAll'))
			
			}
		}
		/**
		 * 添加对象
		 * @param obj
		 * @param msg
		 * 
		 */		
		public function push(value:MovieClip):void {
			if (value is InteractiveObject) {
				var temp:InteractiveObject = value as InteractiveObject
				if(ArrayUtil.inArr(dataArr,value))return
				dataArr.push(temp)
				temp.addEventListener(SelectEvent.SELECT, SELECT)
				temp.addEventListener(SelectEvent.RESELECT,RESELECT)
				temp.addEventListener(SelectEvent.UPSELECT, UPSELECT)
				dispatchEvent(new Event('add'))
			}
		}
		/**
		 * 删除对象
		 * @param	value
		 */
		public function remove(value:MovieClip):void {
			if (dataArr) {
				for (var i:uint = 0; i < dataArr.length; i++) {
					if (value == dataArr[i]) {
						this.dataArr.splice(i,1);
						dispatchEvent(new Event('remove'))
						break; 
					}
				}
				if (value is InteractiveObject) {
					InteractiveObject(value).removeEventListener(SelectEvent.SELECT, SELECT)
					InteractiveObject(value).removeEventListener(SelectEvent.RESELECT, RESELECT)
					InteractiveObject(value).removeEventListener(SelectEvent.UPSELECT, UPSELECT)
				}
			}
			
		}
		private function UPSELECT(e:SelectEvent):void {
			var btn:MovieClip = e.target as MovieClip
			//trace('UPSELECT',selected,btn)
			if (selected == btn) return
			if (selected) {
				MovieToCheckButton.selectLockFun(selected, false)
				MovieToCheckButton.selectFun(selected, false)
				MovieToCheckButton.selectLockFun(selected, true)
			}
			MovieToCheckButton.selectLockFun(btn, false)
			MovieToCheckButton.selectFun(btn, true)
			MovieToCheckButton.selectLockFun(btn, true)
			_selected = btn
			dispatchEvent(new SelectEvent(SelectEvent.UPSELECT, selected))
			if(seletFun!=null)seletFun()
		}
		/**
		 * 删除选择
		 * @param	e
		 */
		private function RESELECT(e:SelectEvent):void {
		
		}
		/**
		 * 有新选择
		 * @param	e
		 */
		private function SELECT(e:SelectEvent):void {
			
			
		}
	}

}