package com.ixiyou.speUI.core 
{
	
	/**
	 * 继承容器组件接口
	 * 允许内部自组件靠组件边界值进行布局容器
	 * 要重写layoutChilds()，只对有边界布局的组件进行布局
	 * @author ...
	 */
	public interface ILayoutContainer extends IContainer
	{
		//对某个组件进行布局
		function setChildLocation(Child:SpeComponent):void
	}
	
}