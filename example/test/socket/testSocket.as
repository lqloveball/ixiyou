package  
{
	import flash.display.Sprite;
	import com.ixiyou.socket.BaseSocket
	/**
	 * ...
	 * @author spe
	 */
	public class testSocket extends Sprite
	{
		
		public function testSocket() 
		{
			var so:BaseSocket = new BaseSocket('http://127.0.0.1',80)
			so.connect()
		}
		
	}

}