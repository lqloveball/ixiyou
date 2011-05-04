package  
{
	import com.ixiyou.speUI.containers.MAccordion;
	import flash.display.Sprite;
	
	/**
	 * 导航器容器
	 * @author spe
	 */
	public class MAccordionDemo extends Sprite
	{
		private var accordin:MAccordion=new MAccordion({x:20,y:20})
		public function MAccordionDemo() 
		{
			addChild(accordin)
			var test0:Sprite = new Sprite()
			test0.graphics.beginFill(0xffff00)
			test0.graphics.drawRect(0, 0, 100, 100)
			var test1:Sprite = new Sprite()
			test1.graphics.beginFill(0x0000ff)
			test1.graphics.drawRect(0, 0, 100, 100)
			var test2:Sprite = new Sprite()
			test2.graphics.beginFill(0xff0000)
			test2.graphics.drawRect(0,0,100,100)
			accordin.add('label1',test0)
			accordin.add('label2',test1)
			accordin.add('label3', test2)
			var test3:Sprite = new Sprite()
			test3.graphics.beginFill(0xff00ff)
			test3.graphics.drawRect(0,0,100,100)
			accordin.addAt('label4', test3, 1)
			accordin.remove('label4')
		}
		
	}

}