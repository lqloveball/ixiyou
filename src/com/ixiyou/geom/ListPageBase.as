package com.ixiyou.geom 
{
	import flash.display.*;
	import flash.net.*
	import flash.text.*
	import flash.events.*
	/**
	 * 翻页工具条的 页面模版
	 * 
	 * 翻页工具条 设置 
	 * @author spe
	 */
	public class ListPageBase extends Sprite 
	{
		protected var sx:Number = -391
		protected var sy:Number = -169
		//<page search="" pagenum="12" allnum="100" ></page>
		//列表搜索出来关键字
		protected var search:String = ''
		//当前页码
		protected var pagenum:uint = 1
		//总页码
		protected var allnum:uint = 1
		//每组多少页码
		protected var shownum:uint = 7
		//当前组
		protected var nowGrounp:uint
		//总的组
		protected var allGrounp:uint
		public function ListPageBase() 
		{
			
		}
		/**
		 * 
		 * 初始化页码数据 工具条
		 * @param	shownum1 显示多少页码
		 * @param	pagenum1 当前页码
		 * @param	allnum1 总页码
		 * @param	search1 搜索关键字
		 */
		public function initPageInfo(shownum1:Number=7,pagenum1:Number=1,allnum1:Number=1,search1:String=''):void {
			search =search1
			pagenum =pagenum1
			allnum = allnum1
			if (pagenum < 1) pagenum = 1
			if (allnum < 1) allnum=1
			if (pagenum > allnum) pagenum = allnum
			//最多七个页码
			shownum=shownum1
			//在第几组
			nowGrounp = Math.ceil( pagenum / shownum )
			//总组
			allGrounp = Math.ceil(allnum / shownum)
			initPageNumShow()
		}
		/**
		 * 处理页码显示表现
		 */
		public function initPageNumShow():void {
			var i:int
			//开始页码
			var startPage:uint = (nowGrounp-1) * shownum+1
			//结束页码
			var endPage:uint = nowGrounp * shownum
			if(endPage>allnum)endPage=allnum
			trace('每页显示:', shownum, '当前页码:' + pagenum + "/" + allnum, '当前页码组:' + nowGrounp, '开始页码:', startPage, '结束页码:', endPage)
			/*
			var btn:MovieClip
			for (i = 0; i < 7; i++ ) {
				btn = MovieClip(this['pagenum' + i])
				var num:uint=startPage + i
				btn.id = num
				btn.text.text = num
				// 这里做区当前页码
				if (num== pagenum) TextField(btn.text).textColor = 0xFB1542
				else TextField(btn.text).textColor =0xcccccc
				
				// 超出页码不显示
				if ( num> endPage) {
					btn.visible=false
				}else {
					btn.visible=true
				}
			}
			*/
		}
		/**
		 * 向后翻页
		 */
		public function nFun():void 
		{
			if ((nowGrounp + 1) <=allGrounp ) {
				nowGrounp += 1
				initPageNumShow()
			}
		}
		/**
		 * 向前翻页
		 */
		public function pFun():void 
		{
			if ((nowGrounp - 1) >0 ) {
				nowGrounp -= 1
				initPageNumShow()
			}
		}
		
	}

}