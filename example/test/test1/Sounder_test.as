package  
{
	import com.ixiyou.speUI.controls.MButton;
	import flash.display.Sprite;
	import com.ixiyou.media.Sounder
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.*
	import flash.text.TextField;
	/**
	 * ...
	 * @author spe
	 */
	public class Sounder_test extends Sprite
	{
		[Embed(source='../../../lib/test/Music/testMusic.mp3')]
		private var soundClass:Class
		private var sounder:Sounder = new Sounder()
		private var sound:Sound
		public function Sounder_test() 
		{
			sound = new soundClass() as Sound
			//sounder.sound = sound
			
			//sounder.url='http://nahuo8.820.8008202191.com/images/227313941.mp3'
			var btn:MButton 
			btn= new MButton( { x:0, y:0, width:50, height:25, label:'mp3_1' } )
			addChild(btn)
			btn.addEventListener(MouseEvent.CLICK,function():void{sounder.sound=sound})
			btn = new MButton( { x:60, y:0, width:50, height:25, label:'mp3_2' } )
			btn.addEventListener(MouseEvent.CLICK,function():void{sounder.url='http://nahuo8.820.8008202191.com/images/227313941.mp3'})
			addChild(btn)
			btn= new MButton( { x:120, y:0, width:50, height:25, label:'播放' } )
			addChild(btn)
			btn.addEventListener(MouseEvent.CLICK,function():void{sounder.play()})
			btn= new MButton( { x:180, y:0, width:50, height:25, label:'暂停' } )
			addChild(btn)
			btn.addEventListener(MouseEvent.CLICK,function():void{sounder.pause()})
			btn= new MButton( { x:240, y:0, width:50, height:25, label:'停止' } )
			addChild(btn)
			btn.addEventListener(MouseEvent.CLICK,function():void{sounder.stop()})
			btn= new MButton( { x:300, y:0, width:50, height:25, label:'Y/N' } )
			addChild(btn)
			btn.addEventListener(MouseEvent.CLICK, function():void { sounder.togglePause() } )
			var text:TextField = new TextField()
			addChild(text)
			text.width = 300
			text.height=300
			text.x = 360
			addEventListener(Event.ENTER_FRAME, function():void {
				var str:String = '\r\n'
				str += '  加载进度:' +(sounder.bytesLoaded/1000>>0) +'/'+ (sounder.bytesTotal/1000>>0)+'='+ (sounder.bytesLoaded / sounder.bytesTotal * 100>>0)
				str+='\r\n播放时间:'+(sounder.time/1000>>0) +'/'+ (sounder.duration/1000>>0)+'='+ (sounder.time / sounder.duration * 100>>0)
				text.text=str
				})
		}
		
	}

}