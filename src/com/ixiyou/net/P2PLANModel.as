package com.ixiyou.net
{
	import flash.events.*;
	import flash.net.*
	import com.ixiyou.events.DataSpeEvent
	import com.ixiyou.utils.ObjectUtil
	/**
	 * P2P技术 (目前在局域网测试)
	 * @author spe email:md9yue@@q.com
	 */
	public class P2PLANModel extends EventDispatcher
	{
		private var _groupSpecifier:GroupSpecifier
		private var _nc:NetConnection
		private var _group:NetGroup;
		private var _groupName:String
		private var _groupAddress:String
		public function P2PLANModel()
		{
			//setGroupSpecifier()
		}
		/**
		 * 关闭连接
		 */
		public function close():void {
			if(group)group.close()
		}
		/**
		 *  发送数据
		 * @param	value
		 */
		public function post(value:Object):void {
			if(group)group.post(value)
		}
		/**
		 * 连接
		 */
		public function connect(name:String='mdP2P',address:String='225.225.0.1:30303',value:String='rtmfp:'):void {
			if (nc) nc.removeEventListener(NetStatusEvent.NET_STATUS, netStatus);
			if (group) {
				group.close()
				group.removeEventListener(NetStatusEvent.NET_STATUS, netStatus);
			}
			setGroupSpecifier(name, address);
			_nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
			nc.connect(value);
		}

		/**
		 * 连接事件
		 * @param	event
		 */
		private function netStatus(e:NetStatusEvent):void {
			var info:Object = e.info
			trace(info.code)
			switch(info.code){
					case "NetConnection.Connect.Success":
						//DebugOutput.add('NetConnection.Connect.Success')
						connectGroup();
					break;
					case "NetGroup.Connect.Failed":
						DebugOutput.add('NetGroup 连接尝试失败。info.group 属性指示哪些 NetGroup 已失败。')
					break;
					case "NetGroup.Connect.Rejected":
						DebugOutput.add('NetGroup 没有使用函数的权限。info.group 属性指示哪些 NetGroup 被拒绝。')
					break;
					case "NetGroup.Connect.Success":
						DebugOutput.add('连接组成功>>'+ObjectUtil.ObjtoString(info.group))
						//DebugOutput.add('NetGroup 已构建成功并有权使用函数。info.group 属性指示哪些 NetGroup 已成功。')
					break;
					case "NetGroup.LocalCoverage.Notify":
						DebugOutput.add('此节点负责的组地址空间的一部分发生更改时发送。')
					break;
					case "NetGroup.Neighbor.Connect":
						var nncStr:String = '有邻居连接上\n'
						nncStr=nncStr+'用户数：'+group.neighborCount +'\n'
						nncStr = nncStr + 'peerID:' + info.peerID + '\n' + 'neighbor:' + info.neighbor + '\n'
						group.post('用户数:'+group.neighborCount)
						DebugOutput.add(nncStr)
					break;
					case "NetGroup.Neighbor.Disconnect":
						var nncStr1:String = '有邻居断开\n'
						nncStr1=nncStr1+'用户数：'+group.neighborCount +'\n'
						nncStr1=nncStr1+'peerID:'+info.peerID+'\n'+'neighbor:'+info.neighbor+'\n'
						DebugOutput.add(nncStr1)

					break;
					case "NetGroup.Posting.Notify":
						//DebugOutput.add('当收到新的 Group Posting 时发送。info.message:Object 属性是消息。info.messageID:String 属性是消息的 messageID。')
						//DebugOutput.add( 'Group Posting>> '+e.info.messageID+':'+e.info.message)
						DebugOutput.add( 'Group Posting>> ' + e.info.message)
						dispatchEvent(new DataSpeEvent('Posting',info.message))
					break;
					case "NetGroup.Replication.Fetch.Failed":
						DebugOutput.add('NetGroup.Replication.Fetch.Failed')
					break;
					case "NetGroup.Replication.Fetch.Result":
						DebugOutput.add('NetGroup.Replication.Fetch.Result')
					break;
					case "NetGroup.Replication.Fetch.SendNotify":
						DebugOutput.add('当 Object Replication 系统即将向邻域发送对象请求时发送。info.index:Number 属性是请求的对象的索引。')
					break;
					case "NetGroup.Replication.Request":
						DebugOutput.add('NetGroup.Replication.Request')
					break;
					case "NetGroup.SendTo.Notify":
						DebugOutput.add('NetGroup.SendTo.Notify')
					break;
			}
			info=null
		}

		/**
		 * 进行P2P组连接
		 */
		private function connectGroup():void
		{
			DebugOutput.add('进行组连接>>',groupSpecifier.groupspecWithAuthorizations())
			if(group)group.removeEventListener(NetStatusEvent.NET_STATUS,netStatus);
			_group = new NetGroup(nc,groupSpecifier.groupspecWithAuthorizations());
			group.addEventListener(NetStatusEvent.NET_STATUS,netStatus);
		}
		/**
		 * 设置P2P组 信息规格
		 * @param	name p2p组名
		 * @param	address
		 */
		public function setGroupSpecifier(name:String='mdP2P',address:String="225.225.0.1:30303"):void
		{
			_groupName = name
			_groupAddress=address
			_groupSpecifier = new GroupSpecifier(name)
			_groupSpecifier.postingEnabled = true;
			_groupSpecifier.ipMulticastMemberUpdatesEnabled = true;
			_groupSpecifier.serverChannelEnabled=true
			_groupSpecifier.addIPMulticastAddress(address);
		}
		/**
		 * 组信息 GroupSpecifier对象
		 */
		public function get groupSpecifier():GroupSpecifier { return _groupSpecifier; }
		/**
		 * 连接对象
		 */
		public function get nc():NetConnection { return _nc; }
		/**
		 * 组
		 */
		public function get group():NetGroup { return _group; }
		/**
		 * 组名
		 */
		public function get groupName():String { return _groupName; }
		/**
		 * 组地址
		 */
		public function get groupAddress():String { return _groupAddress; }
	}

}