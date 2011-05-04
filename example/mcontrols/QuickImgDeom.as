package  
{
	import com.ixiyou.speUI.mcontrols.QuickImg;
	import flash.display.Loader;
	import flash.display.Sprite;
	/**
	 * 快速加载图片
	 * @author spe email:md9yue@qq.com
	 */
	public class QuickImgDeom extends Sprite
	{
		
		public function QuickImgDeom() 
		{
			var img:QuickImg = new QuickImg('http://www.baidu.com/img/baidu_logo.gif',function(value:*=null):void{trace(value.url,' loaded')})
			addChild(img)
		}
		
	}

}