package com.ixiyou.speUI.core 
{
	
	/**
	 * 选择，复选，单选 锁定选择
	 * @author spe
	 */
	public interface Iselect 
	{
		function set selectLock(value:Boolean):void 
		function get selectLock():Boolean 
		function set select(value:Boolean):void 
		function get select():Boolean 
	}
	
}