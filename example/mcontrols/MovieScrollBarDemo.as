package  
{
	import com.ixiyou.speUI.mcontrols.MovieToTextVScrollBar;
	import flash.display.*;
	import flash.events.*
	import com.ixiyou.speUI.mcontrols.MovieToVScrollBar
	import flash.text.TextField;
	import lib.VScrollBarSkin;
	/**
	 * 直接滚动条测试
	 * @author spe email:md9yue@@q.com
	 */
	public class MovieScrollBarDemo extends Sprite
	{
		[Embed(source='../../lib/test/pic/ScrollBarTest.png')]
		private var img:Class
		private var bmp:Bitmap
		private var _mask:Shape
		private var text:TextField=new TextField()
		public function MovieScrollBarDemo() 
		{
			_mask = new Shape()
			_mask.graphics.beginFill(0)
			_mask.graphics.drawRect(0, 0, 100, 200)
			_mask.x = 100
			_mask.y = 100
			
			bmp = new img() as Bitmap
			var box:Sprite = new Sprite()
			box.addChild(bmp)
			addChild(box)
			box.mask = _mask
			box.x = 100
			box.y=100
			var sl:MovieToVScrollBar
			sl = new MovieToVScrollBar( new VScrollBarSkin(), { hideBool:true, x:200, y:100, coordinateBool:false } )
			sl.hideType=MovieToVScrollBar.HITAll
			addChild(sl)
			sl.content = box
			sl.setSize(100, 100)
			
			addChild(text)
			text.text='ActionScript 3.0 语言Adobe Flex 2 Language Reference和组件参考概述Adobe Flex 2 Language Reference《ActionScript 3.0 语言和组件参考》是 Flash® Player 应用程序编程接口 (API) 的参考手册。 Adobe Flex 2 Language Reference《ActionScript 3.0 语言和组件参考》提供 ActionScript 语言中所支持元素的语法和用法信息。其中包括以下部分：•语言元素，如全局变量、运算符、语句、关键字、指令和特殊类型•包按字母顺序排列的类元素条目•包含所有条目的索引•附录，比较 ActionScript 2.0 与 ActionScript 3.0 的某些关键语言和 API 的改动•有关错误和警告的附录（带注释）可通过作为创作工具的一部分的“帮助”面板以及 LiveDocs 等多种途径获得本参考。应结合其它指导性媒体来使用本参考，例如《ActionScript 3.0 编程》指南，以及 Adobe 网站上的资源（如 ActionScript 主题中心）。'
			var temp:MovieClip = new VScrollBarSkin()
			temp.x = 10
			temp.y = 10
			var slt:MovieToTextVScrollBar=new MovieToTextVScrollBar(temp, { hideBool:true, coordinateBool:false },true,true )
			addChild(slt);
			text.wordWrap=true
			slt.content = text
			
			text.x=100
			//slt.x=400
		}
		
	}

}