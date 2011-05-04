package com.ixiyou.FMS
{
	import com.ixiyou.FMS.FMSBase;
	
	/**
	 * FMS客户端接口
	 * @author spe
	 */
	public interface IFMSClient 
	{	
		function set fmsBase(value:FMSBase):void
		function get fmsBase():FMSBase
		function close():void/*{
			if (_fms) {
				trace('fmsClient断开')
				_fms.nc.close()
			}
		}
		*/
		function fmsCall(obj:Object):void /*{
			if (obj == null && obj.type == null) return
			trace(obj.type)
			dispatchEvent(new FmsCallEvent(obj.type,obj.data))
		}
		*/
	}
	
	
}