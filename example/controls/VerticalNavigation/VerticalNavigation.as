package  
{
	
	import com.ixiyou.speUI.containers.VBox;
	import com.ixiyou.speUI.controls.MVScrollBar;
	import com.ixiyou.speUI.core.VContainer;
	import com.ixiyou.speUI.core.SpeComponent;
	import flash.display.Shape
	/**
	 * 纵向导航
	 * @author spe
	 */
	
	public class VerticalNavigation extends SpeComponent
	{
		private var box:VContainer
		private var boxMask:Shape = new Shape()
		private var sl:MVScrollBar = new MVScrollBar()
		public function VerticalNavigation(config:*=null) 
		{
			
			//创建导航容器 这里使用 纵向排布容器
			box = new VContainer()
			box.verticalGap = 1
			addChild(box)
			boxMask.graphics.beginFill(0x0)
			boxMask.graphics.drawRect(0, 0, 100, 100)
			addChild(boxMask)
			box.mask=boxMask
			
			//导航使用的滚动条
			sl = new MVScrollBar({x:100})
			addChild(sl)
			sl.content = box
			//创建导航项
			for (var i:int = 0; i < 30; i++) 
			{
				var temp:navIteam=new navIteam({label:'nav'+i,toolTip:'toolTip'+i})
				box.addChild(temp)
			}
			sl.upSlider()
			//设置组件高度为父级的百分百
			this.percentHeight = 1
			
		}
		override public function upSize():void {
			boxMask.height = height
			sl.height=height
		}
	}
}
//内部导航项
import com.ixiyou.speUI.core.SpeComponent;
import flash.display.Shape;
import flash.events.MouseEvent;
import flash.text.TextField;
import caurina.transitions.Tweener
class navIteam extends SpeComponent {
	private var text:TextField = new TextField()
	private var bg:Shape=new Shape()
	public function navIteam(config:*):void {
		bg.graphics.beginFill(0xff8400)
		bg.graphics.drawRect(0, 0, 10, 10)
		addChild(bg)
		super(config)
		width = 100
		height = 20
		if(config.label!=null)text.text=config.label
		addChild(text)
		this.mouseChildren = false
		addEventListener(MouseEvent.MOUSE_OVER, mouseOver)
		addEventListener(MouseEvent.MOUSE_OUT,mouseOut)
	}
	private function mouseOver(e:MouseEvent):void {
		Tweener.addTween(this, { time:.5, height:50 } )
		Tweener.addTween(bg, { time:.5, alpha:.5 } )
		
	}
	private function mouseOut(e:MouseEvent):void {
		Tweener.addTween(this, { time:.2, height:20 } )
		Tweener.addTween(bg, { time:.2, alpha:1 } )
	}
	override public function upSize():void {
		super
		bg.width = width
		bg.height=height
	}

}