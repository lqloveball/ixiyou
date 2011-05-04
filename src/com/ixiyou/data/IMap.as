package com.ixiyou.data 
{
	/**
	 * 将键映射到值的对象。一个映射不能包含重复的键；每个键最多只能映射一个值. 
	 * @author Sean
	 * @version 1.0
	 * @since Flex2,Flash9
	 */	
	public interface IMap
	{
		/**
		 * 返回此映射中映射到指定键的值. 
		 * 如果此映射中没有该键的映射关系，则返回 null. 
		 * @param key
		 * @return 此映射中映射到指定值的键，如果此映射不包含该键的映射关系，则返回 null. 
		 */		
		function getValue(key:Object):Object;
		
		/**
		 * 如果此映射未包含键-值映射关系，则返回 true. 
		 * @return 如果此映射未包含键-值映射关系，则返回 true. 
		 * 
		 */		
		function isEmpty():Boolean;
		
		/**
		 * 如果此映射包含指定键的映射关系，则返回 true. 
		 * @param key 测试在此映射中是否存在的键. 
		 * @return 如果此映射包含指定键的映射关系，则返回 true. 
		 * 
		 */		
		function containsKey(key:Object):Boolean;
		
		/**
		 * 如果此映射为指定值映射一个或多个键，则返回 true. 
		 * @param value  测试在该映射中是否存在的值. 
		 * @return 如果该映射将一个或多个键映射到指定值，则返回 true. 
		 * 
		 */		
		function containsValue(value:Object):Boolean;
		
		/**
		 * 将指定的值与此映射中的指定键相关联.
		 * @param key 与指定值相关联的键. 
		 * @param value 与指定键相关联的值. 
		 * @return 以前与指定键相关联的值，如果没有该键的映射关系，则返回 null. 如果该实现支持 null 值，则返回 null 也可表明此映射以前将 null 与指定键相关联. 
		 * 
		 */		
		function put(key:Object,value:Object):Object;
		
		/**
		 * 如果存在此键的映射关系，则将其从映射中移除.
		 * @param key 键
		 * @return 以前与指定键相关联的值，如果没有该键的映射关系，则返回 null. 
		 * 
		 */		
		function remove(key:Object):Object;
		
		/**
		 * 返回此映射中包含的值的数组. 
		 * @return  此映射中包含的值的数组
		 * 
		 */		
		function values():Array;
		
		/**
		 * 返回此映射中的键-值映射关系数. 
		 * @return 此映射中的键-值映射关系数. 
		 * 
		 */		
		function size():uint;
		
	}
}