package com.ixiyou.geom 
{
	/**
	 * 画廊列表 前后作品相接的 
	 * @author spe email:md9yue@qq.com
	 */
	import flash.events.Event;
	import flash.events.EventDispatcher;
	[Event(name = "upData", type = "flash.events.Event")]
	[Event(name = "upTotal", type = "flash.events.Event")]
	public class GalleryList extends EventDispatcher
	{

		//The number of page
		private var _showNum:uint
		//All of the data page
		private var _data:Array
		//
		private var _selectObj:Object
		//The current page number
		private var _selectNum:uint
		//The current page Data
		private var _nowObjData:Array
		//更新前页面数据
		private var _oldObjData:Array
		//转动方向
		public var directionBool:Boolean=true
		public function GalleryList(_data:Array=null,_showNum:uint=1,_selectNum:uint=0) 
		{
			if (_data) data = _data
			else data=[]
			showNum = _showNum
			selectNum=_selectNum
		}
		/**
		 * 前一页(翻页)
		 * @param 
		 * @return 
		*/
		public function previous():void {
			if (selectNum >= 1) selectNum -= 1
			else selectNum=length-1
		}
		/**下一页
		 * 
		 * @param 
		 * @return 
		*/
		public function next():void {
			if (selectNum < length - 1) selectNum += 1
			else selectNum=0
	
		}
		/**
		 * 显示个数
		 */
		public function get showNum():uint { return _showNum; }
		
		public function set showNum(value:uint):void 
		{
			if(_showNum == value||!data)return
			_showNum = value;
			value=selectNum
			_selectNum=999999999
			selectNum=value
		}
		/**
		 * 数据
		 */
		public function get data():Array { return _data; }
		
		public function set data(value:Array):void 
		{
			if(_data==value)return
			_data = value;
			this.dispatchEvent(new Event('upTotal'))
			_selectNum = 9999999999
			selectNum = 0
			
		}
		
		/**
		 * 位置选择
		 */
		public function get selectNum():uint { return _selectNum; }
		
		public function set selectNum(value:uint):void 
		{
			if (value < 0) value = 0
			if (value >= data.length)value=0
			if (_selectNum == value || !data) return
			//if (_selectNum < value) directionBool = true
			//else directionBool=false
			//方向
			var onum:uint = value + showNum
			if (onum >length) {
				//trace(value,':会超出长度')
				//onum = onum - length-1
				if (_selectNum<showNum) {
					directionBool = false
				}
				else {
					if (value > _selectNum) directionBool = true
					else directionBool = false
				}
			}else {
				//trace(value, ':不会超出长度')
				onum = _selectNum + showNum
				if (value < showNum&&onum>=length) {
					//trace('不会超出长度1')
					directionBool = true
				}else {
					//trace(_selectNum,value,'不会超出长度2')
					if (value > _selectNum) directionBool = true
					else directionBool = false
					//&&onum>length
				}
			}
			//trace(_selectNum,value)
			//方向 end
			_selectNum = value;
			
			if (data) {
				if (data.length < 2) {
					if(_nowObjData)_oldObjData=_nowObjData
					_nowObjData = data
					_selectObj=data[0]
				}
				else {
					var arr:Array = new Array()
					var num:uint = 0
					//trace('-------------',showNum)
					for (var i:uint = 0; i < showNum ; i++ ) {
						num = _selectNum + i;
						if(num>length-1)num=num-length
						//trace(num)
						if(i==0)_selectObj=data[num]
						arr.push(data[num])
					}
					if (_nowObjData)_oldObjData = _nowObjData
					else _oldObjData=[]
					_nowObjData = arr
					//trace(_nowObjData)
				}
				//if()
				dispatchEvent(new Event('upData'))
			}
			
		}
		/**
		 * 选择对象
		 */
		public function get selectObj():Object { return _selectObj; }
		
		public function set selectObj(value:Object):void 
		{
			for (var i:int = 0; i < data.length; i++) 
			{
				if (value == data[i]) {
					selectNum=i
					return
				}
			}
		}
		
		/**
		 * 当前显示数据
		 */
		public function get nowObjData():Array { return _nowObjData; }
		/**
		 * 之前数据
		 */
		public function get oldObjData():Array { return _oldObjData; }
		/**
		 * 画面数
		 */
		public function get length():uint { 
			if(!data)_data=[]
			return data.length;
		}
		
		
	}

}