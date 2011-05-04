package  
{
	import com.ixiyou.events.SelectEvent;
	import flash.events.Event
	import com.ixiyou.speUI.controls.MButtonBase;
	import com.ixiyou.speUI.controls.MCheckButton;
	import flash.display.Sprite;
	import com.ixiyou.managers.CheckManager
	/**
	 * 按钮集管理
	 * @author spe
	 */
	public class CheckManagerDemo extends Sprite
	{
		private var buttonEr:CheckManager=new CheckManager(true)
		public function CheckManagerDemo() 
		{
			var box:Sprite
			box= new Sprite()
			addChild(box)
			var i:int 
			var btnBase:MCheckButton
			for (i = 0; i < 5; i++) 
			{
				btnBase = new MCheckButton( { x:50 * i, width:45,label:'btn'+i} )
				box.addChild(btnBase)
				buttonEr.push(btnBase)
			}
			//btnBase.addEventListener(Event.SELECT,function():void{trace('----------')})
		}
		
	}

}