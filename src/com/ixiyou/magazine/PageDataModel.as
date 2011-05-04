package com.ixiyou.magazine 
{

	/**
	 * 杂志数据处理
	 * Object类型
	 * 	+width:uint 杂志宽
	 * 	+height:uint  杂志高
	 * 	+pages:Array 杂志页面数据
	 *    obj:Object 记录每个单独页面数据
	 * 		+id:String 页面的ID
	 * 		+src:String 页面的加载地址,或者页面数据（如加载的数据或者直接的现实对象，考虑到比如FLASH内部生产的显示对象）
	 *		+type:String 页面的数据形式
	 *  +other:其他配置数据，可以考虑做声音等等
	 * 
	 * 这个类主要负责把对应的数据处理成MagaPageFlip可用的数据形式，比如传输进的XML处理成对应的obj数据形式，或者自己添加一些数据处理方法
	 * @author spe
	 */
	public class PageDataModel
	{
		/**
		 * 数据处理
		 * <?xml version="1.0" encoding="utf-8" ?>
			<data>
				<info name="杂志一期" width="500" height="400"/>
				<pages>
					<page src="img/0-1.png" type="png"/>
					<page src="img/2-3.png" type="png"/>
					<page src="img/4-5.png" type="png"/>
					<page src="img/6-7.swf" type="swf"/>
					<page src="img/8-9.png" type="png"/>
				</pages>
			</data>
		 */
		public static function dataProcessing(value:XML):Object {
			var data:Object = new Object()
			data.width = value.info.@width
			data.height = value.info.@height
			data.name = value.info.@name
			var arr:Array = new Array()
			var obj:Object
			for (var i:uint = 0; i < value.pages.page.length(); i++) {
				obj = new Object()
				if (value.pages.page[i].@src) obj.src = String(value.pages.page[i].@src);
				else obj.src = '';
				if (value.pages.page[i].@type) obj.type = String(value.pages.page[i].@type);
				else obj.type = '';
				if (value.pages.page[i].@id) obj.id = String(value.pages.page[i].@id);
				else obj.id = i;
				if (value.pages.page[i].@reserve)	String(obj.reserve = value.pages.page[i].@reserve);
				else obj.reserve = '';
				if (value.pages.page[i].@sound) obj.sound = String(value.pages.page[i].@sound);
				else obj.sound = '';
				obj.index=i
				//trace(obj.id,obj.src,obj.type,obj.reserve,obj.sound)
				arr.push(obj);
			}
			data.pages = arr;
			return data
		}
		
	}

}