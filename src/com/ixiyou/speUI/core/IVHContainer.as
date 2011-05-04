package com.ixiyou.speUI.core 
{
	
	/**
	 * 横纵向排列容器 接口
	 * @author ...
	 */
	public interface IVHContainer 
	{
		//内部大小计算
		function layout_neiSize():void
		//是否锁定宽或高的大小
		function get fixSize():Boolean
	}
	
}