package  
{
	import com.ixiyou.speUI.collections.TabBox;
	import com.ixiyou.speUI.controls.MCheckButtonByMovie6;
	import com.ixiyou.speUI.controls.MToggleButtonBar;
	import com.ixiyou.speUI.controls.skins.DefaultButtonBar;
	import com.ixiyou.speUI.controls.skins.TailButtonBar;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 导航选项卡
	 * @author spe
	 */
	public class MToggleButtonBarDemo extends Sprite
	{
		private var buttonBar:MToggleButtonBar
		private var tabBox:TabBox=new TabBox()
		public function MToggleButtonBarDemo() 
		{
			addChild(tabBox)
			tabBox.y=50
			var data:Array=new Array()
			for (var i:int = 0; i < 5; i++) 
			{
				var child:Sprite = new Sprite()
				child.graphics.beginFill(Math.random()*0xffffff)
				child.graphics.drawRect(0,0,100,100)
				var obj:Object = {label:'label_' + i, num:i ,child:child}
				data.push(obj)
				tabBox.addTab('label_' + i,child)
			}
			buttonBar = new MToggleButtonBar({defaultIndex:0,data:data})
			addChild(buttonBar)
			buttonBar.addEventListener(Event.SELECT, function():void { tabBox.gotoAndStop(buttonBar.currentIndex) } )
			trace(buttonBar.width)
			buttonBar.addAt( { label:'label_' + 22, num:22 }, 0)
			trace(buttonBar.width)
			//buttonBar.removeByProperty('label','label_0')
			//buttonBar.removeAt(-1)
			//buttonBar.removeAt(0)
			//buttonBar.removeAt(0)
			//buttonBar.removeAt(0)
			//buttonBar.removeAt(0)
			//var btn:MCheckButtonByMovie6 = new MCheckButtonByMovie6( {y:100, skin:new DefaultButtonBar() } )
			//btn.skin=new TailButtonBar()
			//addChild(btn)
			
		}
		
	}

}