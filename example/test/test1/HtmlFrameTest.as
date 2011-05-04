package  
{
	
	
	/**
	 * ...
	 * @author ...
	 */
	import com.ixiyou.events.DataEvent;
	import flash.display.Sprite;
	import com.ixiyou.geom.HtmlFrame
	import flash.text.TextField;
	public class HtmlFrameTest extends Sprite
	{
		private var html:HtmlFrame
		public var text:TextField = new TextField()
		public var str:String=''
		public function HtmlFrameTest() 
		{
			
			addChild(text)
			text.width = 500
			text.height = 500
			
			html = new HtmlFrame('FlashID','http://baidu.com')
			html.addEventListener(HtmlFrame.ERROR, error)
			html.addEventListener(HtmlFrame.FOUNDEND, foudend)
			html.addEventListener(HtmlFrame.GETSHOW, getShow)
			html.addEventListener(HtmlFrame.FOUNDSTART, foudStart)
			html.text=text
			html.found()
		}
		private function getShow(e:DataEvent):void {
			if (e.data) str+='\r\n' + String(e.data)
			text.text=str
		}
		private function foudStart(e:DataEvent):void {
			if (e.data) str+='\r\n' + String(e.data)
			text.text=str
		
		}
		private function error(e:DataEvent):void {
			if (e.data) str+='\r\n错误>>' + String(e.data)
			text.text=str
		
		}
		private function foudend(e:DataEvent):void {
			if (e.data) str+='\r\n' + String(e.data)
			text.text = str+'\r\n-------------------------------'
			html.getShow()
		}
	
	
	}

}