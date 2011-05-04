package  
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author spe QQ:175716009
	 */
	public class xmltest extends Sprite
	{
		
		public function xmltest() 
		{
			var data:XML =
			<data>
			<bottle id='1'>
				<name><![CDATA[姓名]]></name>
				<cityCountry><![CDATA[国家城市]]></cityCountry>
				<inspiration><![CDATA[启示]]></inspiration>
				<rating><![CDATA[投票数量]]></ rating >
				<photo><![CDATA[图片地址]]></photo>
			</bottle>
			</data>
			trace(data.bottle[0])
			trace('-------------------------------')
			data.bottle[0].rating = 1
			trace(data.bottle[0])
		}
		
	}

}