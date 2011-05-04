package com.ixiyou.utils.text 
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.MovieClip
	import flash.events.FocusEvent;
	import flash.utils.Dictionary;
	/**
	 * 文本常用处理器
	 * @author spe email:md9yue@qq.com
	 */
	public class TextUtil
	{
		
		/**
		 * 设置可输入字符可输入字符串
		 * @param	text
		 * @param	restrict "A-Z a-z 0-9"输入英文 空格 数字，"^a-z"不能输入小写英文字符
		 */
		public static function setTxtInData(text:TextField,restrict:String="A-Z a-z 0-9"):void {
			text.restrict=restrict
		}
		/**
		 * 默认输入背景字典
		 */
		private static var textInPutBgDic:Dictionary = new Dictionary()
	
		/**
		 * 添加文本背景动画
		 * @param	text
		 * @param	movie 背景动画
		 * @param	move 是否移动时候也有效果
		 */
		public static function addTextMovieBg(text:TextField, movie:MovieClip,move:Boolean=false):void {
			if (textInPutBgDic[text] == null) {
				textInPutBgDic[text]={text:text,movie:movie,move:move,focus:false}
			}else {
				textInPutBgDic[text].text = text
				textInPutBgDic[text].movie = movie
				textInPutBgDic[text].move = move
				textInPutBgDic[text].focus=false
			}
			text.type = 'input'
			text.addEventListener(FocusEvent.FOCUS_IN, inPutFocusIn)
			text.addEventListener(FocusEvent.FOCUS_OUT, inPutFocusOut)
			text.addEventListener(MouseEvent.MOUSE_OVER, inPutFocusOVER)
			text.addEventListener(MouseEvent.MOUSE_OUT,inPutFocusOUT)
		}
		
		static private function inPutFocusOUT(e:MouseEvent):void 
		{
			var text:TextField = e.target as TextField
			var movie:MovieClip
			var move:Boolean
			if (textInPutBgDic[text] != null) {
				movie = textInPutBgDic[text].movie as MovieClip
				move = textInPutBgDic[text].move
				if (move) {
					if (movie) {
						if (textInPutBgDic[text].focus) movie.gotoAndStop(2)
						else movie.gotoAndStop(1)
					}else {
						removeTextMovieBg(text)
					}
				}
				
			}
		}
		
		static private function inPutFocusOVER(e:MouseEvent):void 
		{
			var text:TextField = e.target as TextField
			var movie:MovieClip
			var move:Boolean
			if (textInPutBgDic[text] != null) {
				movie = textInPutBgDic[text].movie as MovieClip
				move = textInPutBgDic[text].move
				if (move) {
					if (movie) {
						movie.gotoAndStop(2)

					}else {
						removeTextMovieBg(text)
					}
				}
				
			}
		}
		/**
		*删除文本背景动画
		*/
		public static function removeTextMovieBg(text:TextField):void {
			if (textInPutBgDic[text] != null) {
				textInPutBgDic[text]=null
			}
			text.removeEventListener(FocusEvent.FOCUS_IN, inPutFocusIn)
			text.removeEventListener(FocusEvent.FOCUS_OUT, inPutFocusOut)
			text.removeEventListener(MouseEvent.MOUSE_OVER, inPutFocusOVER)
			text.removeEventListener(MouseEvent.MOUSE_OUT,inPutFocusOUT)
		}
		static private function inPutFocusOut(e:FocusEvent):void 
		{
			var text:TextField = e.target as TextField
			var movie:MovieClip
			if (textInPutBgDic[text] != null) {
				movie = textInPutBgDic[text].movie as MovieClip
				textInPutBgDic[text].focus=false
				 if (movie) {
					 movie.gotoAndStop(1)
				}else {
					removeTextMovieBg(text)
				}
			}
		}
		
		static private function inPutFocusIn(e:FocusEvent):void 
		{
			var text:TextField = e.target as TextField
			var movie:MovieClip
			if (textInPutBgDic[text] != null) {
				movie = textInPutBgDic[text].movie as MovieClip
				textInPutBgDic[text].focus=true
				 if (movie) {
					 movie.gotoAndStop(2)
				}else {
					removeTextMovieBg(text)
				}
			}
		}
		
		
		/**
		 * 默认输入字典
		 */
		private static var defaultInfoDic:Dictionary = new Dictionary()
		/**
		 * 默认输入字符
		 * @param	text
		 * @return
		 */
		public static function getDefaultInfo(text:TextField):String {
			if (defaultInfoDic[text] == null) {
				return null
			}else {
				return defaultInfoDic[text].value
			}
		}
		/**
		 * 是否输入
		 * @param	text
		 * @return
		 */
		public static function getDefaultBool(text:TextField):Boolean {
			if (text.text == '' || text.text == getDefaultInfo(text)) {
				return false
			}else {
				return true
			}
		}
		/**
		 * 设置默认输入
		 * @param	text
		 * @param	value
		 */
		public static function addDefaultInfo(text:TextField,value:String,password:Boolean=false):void {
			if (defaultInfoDic[text] == null) {
				defaultInfoDic[text]={text:text,value:value,password:password}
			}else {
				defaultInfoDic[text].value=value
			}
			text.type = 'input'
			text.text=value
			text.addEventListener(FocusEvent.FOCUS_IN, defaultFocusIn)
			text.addEventListener(FocusEvent.FOCUS_OUT,defaultFocusOut)
		}
		
		static private function defaultFocusOut(e:FocusEvent):void 
		{
			var text:TextField= e.target as TextField
			if (defaultInfoDic[text] != null) {
				if (text.text == defaultInfoDic[text].value || text.text == '') {
					text.text = defaultInfoDic[text].value
					text.displayAsPassword=false
				}
				else {
					if(defaultInfoDic[text].password)text.displayAsPassword=true
				}
			}else {
				removeDefaultInfo(text)
			}
		}
		static private function  defaultFocusIn(e:FocusEvent):void 
		{
			var text:TextField= e.target as TextField
			if (defaultInfoDic[text] != null) {
				if (text.text == defaultInfoDic[text].value || text.text == '') {
					if (defaultInfoDic[text].password) text.displayAsPassword = true
					else text.displayAsPassword = false
					text.text=''
				}
			}else {
				removeDefaultInfo(text)
			}
		}
		/**
		 * 删除默认文本输入
		 * @param	text
		 */
		public static function removeDefaultInfo(text:TextField):void {
			if (defaultInfoDic[text] != null) {
				text.removeEventListener(FocusEvent.FOCUS_IN, defaultFocusIn)
				text.removeEventListener(FocusEvent.FOCUS_OUT, defaultFocusOut)
				defaultInfoDic[text]=null
			}
		}
	}

}