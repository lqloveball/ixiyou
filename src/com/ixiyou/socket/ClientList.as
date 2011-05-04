package com.ixiyou.socket 
{
	import flash.events.*;
	import flash.utils.*;
	import flash.net.*
	
	/**
	 * 客户端列表对象
	 * @author spe email:md9yue@@q.com
	 */
	public class ClientList extends EventDispatcher 
	{
		private var _dic:Dictionary = new Dictionary()
		private var _listArr:Array = new Array()
		private var _addAll:int=0
		public function ClientList() 
		{
			
		}
		/**
		 * 通过socket 获取客户端
		 * @param	socket
		 * @return
		 */
		public function getClientBySocket(socket:Socket):Client {
			if(!dic)return null
			else return dic[socket]
		}
		
		/**
		 * 添加用户
		 * @param	client
		 * @return 添加成功
		 */
		public function add(socket:Socket):Client {
			if (dic[socket] == null) {
				_addAll+=1
				var client:Client=new Client(socket,addAll)
				dic[socket] = client
				_listArr.push(client)
				dispatchEvent(new Event('addUser'))
				return client
				
			}else {
				return null
			}
		}
		/**
		 * 删除用户
		 * @param	client
		 * @return 
		 */
		public function remove(socket:Socket):Client {
			if (dic[socket]) {
				var client:Client = dic[socket]
				dic[socket] = null
				var index:int;
				index = _listArr.indexOf(client);
				if (index != -1) {
					_listArr.splice(index, 1);	
				}
				dispatchEvent(new Event('removeUser'))
				return client
			}
			else { 
				return null
			}
		}
		/**
		 * 清空所有用户
		 */
		public function clear():void {
			_dic = new Dictionary()
			_listArr=new Array()
		}
		/**
		 * 用户列表字典
		 */
		public function get dic():Dictionary { return _dic;}
		/**
		 * 用户列表数组 副本
		 */
		public function get list():Array {
			if (_listArr) return _listArr.concat() 
			else return null
		}
		/**
		 * 用户socket列表数组 副本
		 */
		public function get socketlist():Array {
			if (_listArr) {
				var arr:Array =new Array()
				for (var i:int = 0; i < _listArr.length; i++) 
				{
					var item:Client = _listArr.list[i] as Client;
					arr.push(item.socket)
				}
				return arr
			}
			else return null
		}
		/**
		 * 一共创建过多少个客户端
		 */
		public function get addAll():int { return _addAll; }
		/**
		 * 用户列表长度
		 */
		public function get length():int{return _listArr.length}
	}

}