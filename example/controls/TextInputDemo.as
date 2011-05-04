package 
{
	
	/**
	 * ...
	 * @author spe
	 */
	import flash.display.Sprite
	import com.ixiyou.speUI.controls.MTextInput
	public class TextInputDemo extends Sprite
	{
		
		public function TextInputDemo() 
		{
			var txt:MTextInput = new MTextInput({width:100,height:20,x:100,y:100})
			addChild(txt)
			txt.text = 'ddddd'
			txt.displayAsPassword = false
			txt.setToolTip('请输入你要输入的文字')
			txt.height=25
			//txt.setSize(200,200)
		}
		
	}
	
}