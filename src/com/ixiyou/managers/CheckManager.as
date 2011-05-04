package com.ixiyou.managers 
{
	
	/**
	 * 单选复选按钮组
	 * flash 中快速使用
		import com.ixiyou.managers.CheckManager;
		import com.ixiyou.speUI.mcontrols.MovieToCheck2;
		import com.ixiyou.events.SelectEvent;
		var btner:CheckManager=new CheckManager(false);
		var btnArr:Array=[btn1,btn2,btn3]
		var arr:Array=new Array()
		for (var i:int = 0; i < btnArr.length; i++) {
			var item:MovieToCheck2 = new MovieToCheck2( btnArr[i],true,true);
			item.data=(i+1)
			arr.push(item);
		}
		btner.dataArr = arr;
		item=arr[0]
		item.select=true
		btner.addEventListener(SelectEvent.UPSELECT,upSelect);
		function upSelect(e:SelectEvent):void {
			var btn:MovieToCheck2 = btner.selected as MovieToCheck2
			MovieClip(root).gotoAndStop(btn.data)
		}
	 * @author spe
	 */
	import flash.events.*
	import flash.display.InteractiveObject;
	import com.ixiyou.speUI.core.Iselect;
	import com.ixiyou.events.SelectEvent;
	import com.ixiyou.events.DataSpeEvent
	import com.ixiyou.utils.ArrayUtil;
	//选择更新
	[Event(name="upSelect", type="com.ixiyou.events.SelectEvent")]
	//选择
	[Event(name="Select", type="com.ixiyou.events.SelectEvent")]
	//取消选择
	[Event(name="ReSelect", type="com.ixiyou.events.SelectEvent")]
	public class CheckManager extends EventDispatcher
	{
		//按钮数据集
		private var _dataArr:Array
		//是否复选
		private var _iterance:Boolean = true
		//当前复选
		private var _selectedArr:Array
		//当前选择
		private var _selected:Iselect
		/**
		 * 构造函数
		 * @param	_iterance 是否复选
		 * @param	arr 按钮组
		 */
		public function CheckManager(_iterance:Boolean=false,arr:Array=null) 
		{
			iterance = _iterance;
			if (arr == null ) dataArr = new Array()
			else dataArr=arr
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
				if(value[i] is Iselect)push(Iselect(value[i]))
			}
			dispatchEvent(new DataSpeEvent(DataSpeEvent.ADDALL))
		}
		public function get dataArr():Array { return _dataArr; }
		
		
		/**
		 * 添加对象
		 * @param obj
		 * @param msg
		 * 
		 */		
		public function push(value:Iselect):void {
			if (value is InteractiveObject) {
				var temp:InteractiveObject = value as InteractiveObject
				if(ArrayUtil.inArr(dataArr,value))return
				dataArr.push(temp)
				temp.addEventListener(SelectEvent.SELECT, SELECT)
				temp.addEventListener(SelectEvent.RESELECT,RESELECT)
				temp.addEventListener(SelectEvent.UPSELECT, UPSELECT)
				dispatchEvent(new DataSpeEvent(DataSpeEvent.ADD))
			}
		}
		/**
		 * 删除对象
		 * @param	value
		 */
		public function remove(value:Iselect):void {
			if (dataArr) {
				for (var i:uint = 0; i < dataArr.length; i++) {
					if (value == dataArr[i]) {
						this.dataArr.splice(i,1);
						dispatchEvent(new DataSpeEvent(DataSpeEvent.REMOVE))
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
		/**
		 * 清除所有
		 */
		public function clear():void {
			if (dataArr) {
				var value:Iselect
				for (var i:int = dataArr.length-1; i >=0; i--) {
					if (dataArr[i] is Iselect) {
						value = Iselect( dataArr[i])
						if(value is Iselect)remove(Iselect(value))
					}
				}
				dispatchEvent(new DataSpeEvent(DataSpeEvent.REMOVEALL))
			}
		}
		private function UPSELECT(e:SelectEvent):void {
			
		}
		/**
		 * 删除选择
		 * @param	e
		 */
		private function RESELECT(e:SelectEvent):void {
			var value:*= e.target
			if (value is InteractiveObject) {
				var arr:Array=new Array()
				//复选
				var i:int 
				if (iterance) {
					for (i= 0; i < dataArr.length; i++) 
					{
						if (dataArr[i] is Iselect) {
							if(Iselect(dataArr[i]).select)arr.push(dataArr[i])
						}
					}
					_selectedArr = arr
					dispatchEvent(new SelectEvent(SelectEvent.RESELECT))
					dispatchEvent(new SelectEvent(SelectEvent.UPSELECT))
				}
				else {
					//单选
					//if (_selected == value)return
					//trace('ddd')
				}
				
			}
		}
		/**
		 * 有新选择
		 * @param	e
		 */
		private function SELECT(e:SelectEvent):void {
			var value:*= e.target
			//trace(e)
			if (value is InteractiveObject) {
				var arr:Array=new Array()
				//复选
				var i:int 
				if (iterance) {
					for (i= 0; i < dataArr.length; i++) 
					{
						if (dataArr[i] is Iselect) {
							if(Iselect(dataArr[i]).select)arr.push(dataArr[i])
						}
					}
					_selectedArr = arr
					dispatchEvent(new SelectEvent(SelectEvent.UPSELECT,arr))
					//dispatchEvent(new SelectEvent(SelectEvent.DATAUPSELECT,arr))
				}else {
					//单选
					if (_selected && Iselect(_selected).select) {
						Iselect(_selected).selectLock=false
						Iselect(_selected).select=false
					}
					if (Iselect(value).selectLock==false)Iselect(value).selectLock=true
					arr.push(value)
					_selected=value
					_selectedArr = arr
					dispatchEvent(new SelectEvent(SelectEvent.UPSELECT,value))
					//dispatchEvent(new SelectEvent(SelectEvent.DATAUPSELECT,value))
				}
				dispatchEvent(new Event(Event.SELECT))
				
			}
		}
		/**
		 * 是否复选
		 */
		public function set iterance(value:Boolean):void 
		{
			if (_iterance == value) return;
			_iterance = value;
			var i:int
			if(dataArr==null)return
			if (!_iterance) {
				//单选
				for (i = 0; i < dataArr.length; i++) {
					if (i == 0) {
						Iselect(dataArr[i]).selectLock=false
						Iselect(dataArr[i]).select = true
					}
					else if (dataArr[i] is Iselect&&Iselect(dataArr[i]).select) {	
						Iselect(dataArr[i]).selectLock=false
						Iselect(dataArr[i]).select = false
					}
					
				}
			}else {
				//复选
				for (i = 0; i < dataArr.length; i++) {
					Iselect(dataArr[i]).selectLock=false
				}
			}
			
		}
		public function get iterance():Boolean { return _iterance; }
		/**
		 * 当前选择对象数组
		 */
		public function get selectedArr():Array { return _selectedArr; }
		/**
		 * 当前选择的对象
		 */
		public function get selected():Iselect { return _selected; }
	}
	
}