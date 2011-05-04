package  
{
	import flash.events.*;
    import flash.utils.*;
	/**
	 * 事件发送管理者
	 * @author spe email:md9yue@@q.com
	 */
	public class MEventManager
	{
		static public var turnels:Dictionary=new Dictionary();
		public function MEventManager() 
		{
			
		}
		static public  function removeInstance(value:String):EventDispatcher
        {
			var temp:EventDispatcher=turnels[value]
            turnels[value] = null;
            return temp;
        }

        static public  function getInstance(value:String):EventDispatcher
        {
            if (!turnels[value])
            {
                turnels[value] = new EventDispatcher();
            }// end if
            return turnels[value];
        }
		
	}

}