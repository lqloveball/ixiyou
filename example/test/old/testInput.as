package  
{
	
	/**
	 * ...
	 * @author spe
	 */
	import flash.display.Sprite
	import com.ixiyou.speUI.controls.MTextInput
	public class testInput extends Sprite
	{
		
		public function testInput() 
		{
			var txt:MTextInput = new MTextInput({width:100,height:20,x:100,y:100})
			addChild(txt)
			txt.displayAsPassword=true
			txt.text='ddddd'
		}
		
	}
	
}