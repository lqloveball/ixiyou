package  
{
	import flash.display.*;
	/**
	 * ...
	 * @author spe
	 */
	//[Frame(factoryClass="RootLoaderBase",label='start')]
	public class Main extends Sprite
	{
		[Embed(source='../../../lib/test/pic/ScrollBarTest.png')]
		private var img:Class
		public function Main() 
		{
			init();
		}
		public function init():void
		{
			var asset:Bitmap = new img();
			addChild(asset);
		}

	}

}