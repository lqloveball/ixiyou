package com.ixiyou.speUI.core 
{
	
	/**
	 * 列表组件内部展现的样式
	 * @author spe
	 */
	public interface IListIteam extends IDestory
	{
		/**
		 * 设置选取
		 */
		function set select(value:Boolean):void
		function get select():Boolean
		/**
		 * 作为表现的属性
		 */
		function set showProperty(value:String):void
		function get showProperty():String
		/**
		 * 数据
		 */
		function set data(value:Object):void
		function get data():Object
		/**
		 * 更新数据
		 * @param	value 数据源
		 * @param	inBeing 现有的属性才更新
		 */
		function upData(value:Object,inBeing:Boolean=true):void/* {
			if (!data) return
			var key:*
			if (!inBeing) {
				for (key in value) data[key] = value[key];
			}else {
				for (key in value) {
					if(data.hasOwnProperty(key)) data[key] = value[key];
				}
			}
		}
		*/
		/**根据目前数据和样式绘制*/
		function draw():void
		/**设置组件皮肤*/
		function get skin():*
		function set skin(value:*):void
	}
	
}