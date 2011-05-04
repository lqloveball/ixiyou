package com.ixiyou.geom
{
	
	/**
	* 多页，翻页控制器 翻页效果
	* @author spe qq:175716009
	*/
	import flash.events.EventDispatcher
	import flash.events.Event
	//页面更新
	[Event(name = "upData", type = "flash.events.Event")]
	//设置所有页面数
	[Event(name = "upTotal", type = "flash.events.Event")]
	//设置页面显示数
	[Event(name="Number", type="flash.events.Event")]
	public class PageList extends EventDispatcher
	{
		//The total number of pages
		private var _totalPages:uint=0
		//The number of page
		private var _numPage:uint
		//All of the data page
		private var _data:Array
		//The current page number
		private var _nowPage:uint
		//The current page Data
		private var _nowPageData:Array
		//更新前页面数据
		public var oldPageData:Array
		/**
		 * 是否循环
		 */
		public var revolveBool:Boolean=true
		//更新目前所在页码
		public static var UPPAGEDATA:String = "upData"
		//总数据
		public static var TOTALPAGES:String = "upTotal"
		//设置每页页码
		public static var NUMPAGE:String = 'Number';
		
		/**构造函数
		 * 
		 * @param _Data:数据
		 * @param _numPage：一页多少条记录
		 * @param _nowPage：目前属在页码
		 * @return 
		*/
		public function PageList(_data:Array=null,_numPage:uint=1,_nowPage:uint=0) 
		{
			if (_data) data = _data
			else data=[]
			numPage = _numPage
			nowPage=_nowPage
		}
		/**
		 * The current page Data(目前的页面数据)
		 * @param 
		 * @return 
		*/
		public function get nowPageData():Array {
			return _nowPageData;
		}
		/**
		 * 前一页(翻页)
		 * @param 
		 * @return 
		*/
		public function previous():void {
			if (nowPage > 1) nowPage -= 1
			if (nowPage == 0 && revolveBool)nowPage=this.totalPages - 1
			else nowPage=0
		}
		/**下一页
		 * 
		 * @param 
		 * @return 
		*/
		public function next():void {
			if (nowPage <this.totalPages-1) nowPage += 1
			else if (nowPage == this.totalPages - 1 && revolveBool)nowPage=0
			else nowPage=this.totalPages-1
		}
		/**
		 * The current page number(目前所在页码)
		 * @param 
		 * @return 
		*/
		public function set nowPage(value:uint):void {
			if(_nowPage==value)return
			if (data) {
				//计算页面但时候页码超过，就取最后一页
				//trace(value+"/"+_totalPages)
				if (value < _totalPages) { _nowPage = value }
				else _nowPage=_totalPages-1
				
				if (data.length < 2) {
					if(_nowPageData)oldPageData=_nowPageData
					_nowPageData=data
				}
				else {
					var Arr:Array = new Array()
					var Length:uint
					if (numPage * (nowPage + 1)<=data.length)Length= numPage * (nowPage + 1)
					else Length=data.length
					for (var i:uint= numPage * nowPage; i <Length ; i++ ) {
						Arr.push(data[i])
					}
					if(_nowPageData)oldPageData=_nowPageData
					_nowPageData=Arr
				}
				this.dispatchEvent(new Event(PageList.UPPAGEDATA))
			}
		}		
		public function get nowPage():uint { return _nowPage; }
		/**
		 * The number of page(每页的数)
		 * @param 
		 * @return 
		*/
		public function set numPage(value:uint):void 
		{
			_numPage = value
			_totalPages = totalPages
			this.dispatchEvent(new Event(PageList.NUMPAGE))
			_nowPage=999999999
			nowPage=0
		}
		public function get numPage():uint { return _numPage; }
		
		/**
		 * All of the data page(总数据)
		 * @param 
		 * @return 
		*/
		public function set data(value:Array):void 
		{
			_data = value
			_totalPages = totalPages
			this.dispatchEvent(new Event(PageList.TOTALPAGES))
			_nowPage=999999999
			nowPage=0
		}
		public function get data():Array { return _data; }
		/**
		 * The total number of pages(总页面数)
		 * @param 
		 * @return 0-n 0为没数据
		*/
		public function get totalPages():uint { 
			if (data) {
				if (data.length > 0) {
				//多页
				if (data.length > numPage) { 
					var temp:Number = data.length / numPage
					if (temp > temp >> 0)_totalPages = temp + 1
					else _totalPages=temp
				}
				//单页
				else {
					_totalPages=1
				}
				}
				else {
					_totalPages=0
				}
			}else {
				_totalPages=0
			}
			return _totalPages; 
		}
	}
	
}