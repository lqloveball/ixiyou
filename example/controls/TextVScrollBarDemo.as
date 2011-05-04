package  
{
	/**
	 * 文本纵向滚动条
	 * @author spe
	 */
	import flash.display.*
	import flash.events.*
	import flash.text.*
	import com.ixiyou.speUI.controls.MTextVScrollBar
	public class TextVScrollBarDemo extends Sprite
	{
		
		public function TextVScrollBarDemo() 
		{
			var sl:MTextVScrollBar = new MTextVScrollBar({x:100,height:100})
			addChild(sl)
			var text:TextField = new TextField()
			text.type = TextFieldType.INPUT
			text.multiline=true
			text.text = '\n1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n20-----\n1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n20-----'
			addChild(text)
			sl.content=text
		}
		
	}

}