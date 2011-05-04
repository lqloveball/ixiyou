package com.ixiyou.data 
{
	/**
	 * 对集合进行迭代的迭代器. 
	 * @author Sean
	 * 
	 */	
	public interface Iterator
	{
		/**
		 * 如果仍有元素可以迭代，则返回 true. 
		 * @return Boolean
		 * @roseuid 438064890290
		 */
		function hasNext() : Boolean;
		
		/**
		 * 返回迭代的下一个元素. 重复调用此方法直到 hasNext() 方法返回 false，这将精确地一次性返回迭代器指向的集合中的所有元素. 
		 * @return Object
		 * @roseuid 438064AD03A9
		 */
		function next() : Object;
		
		/**
		 * 从迭代器指向的集合中移除迭代器返回的最后一个元素（可选操作）. 
		 * 每次调用 next 只能调用一次此方法. 如果进行迭代时用调用此方法之外的其他方式修改了该迭代器所指向的集合，则迭代器的行为是不明确的. 
		 * @return Void
		 * @roseuid 438064CF0177
		 */
		function remove() : void;
	}
}