package com.ixiyou.data 
{

	/**
	 * Collection 层次结构 中的根接口. 
	 * Collection 表示一组对象，这些对象也称为 collection 的元素。一些 collection 允许有重复的元素，而另一些则不允许。一些 collection 是有序的，而另一些则是无序的。JDK 不提供此接口的任何直接 实现：它提供更具体的子接口（如 Set 和 List）实现。此接口通常用来传递 collection，并在需要最大普遍性的地方操作这些 collection。 
	 * 包 (bag) 或多集合 (multiset)（可能包含重复元素的无序 collection）应该直接实现此接口。 
	 * 所有通用的 Collection 实现类（通常通过它的一个子接口间接实现 Collection）应该提供两个“标准”构造方法：一个是 void（无参数）构造方法，用于创建空 collection；另一个是带有 Collection 类型单参数的构造方法，用于创建一个具有与其参数相同元素新的 collection。实际上，后者允许用户复制任何 collection，以生成所需实现类型的一个等效 collection。尽管无法强制执行此约定（因为接口不能包含构造方法），但是 Java 平台库中所有通用的 Collection 实现都遵从它。 
	 * 此接口中包含的“破坏性”方法，是指可修改其所操作的 collection 的那些方法，如果此 collection 不支持该操作，则指定这些方法抛出 UnsupportedOperationException。如果是这样，那么在调用对该 collection 无效时，这些方法可能，但并不一定抛出 UnsupportedOperationException。例如，如果要添加的 collection 为空且不可修改，则对该 collection 调用 addAll(Collection) 方法时，可能但并不一定抛出异常。 
	 * 一些 collection 实现对它们可能包含的元素有所限制。例如，某些实现禁止 null 元素，某些实现则对元素的类型有限制。试图添加不合格的元素将抛出一个未经检查的异常，通常是 NullPointerException 或 ClassCastException。试图查询是否存在不合格的元素可能抛出一个异常，或者只是简单地返回 false；某些实现将表现出前一种行为，而某些实现则表现后一种。较为常见的是，试图对某个不合格的元素执行操作且该操作的完成不会导致将不合格的元素插入 collection 中，将可能抛出一个异常，也可能操作成功，这取决于实现本身。这样的异常在此接口的规范中标记为“可选”。 
	 * 此接口是 Java Collections Framework 的成员。 
	 * Collections Framework 接口中的很多方法是根据 equals 方法定义的。例如，contains(Object o) 方法的规范声明：“当且仅当此 collection 包含至少一个满足 (o==null ? e==null :o.equals(e)) 的元素 e 时，才返回 true。”不 应将此规范理解为它暗指调用具有非空参数 o 的 Collection.contains 方法会导致为任意的 e 元素调用 o.equals(e) 方法。可随意对各种实现执行优化，只要避免调用 equals 即可，例如，通过首先比较两个元素的哈希代码。（Object.hashCode() 规范保证哈希代码不相等的两个对象不会相等）。较为常见的是，各种 Collections Framework 接口的实现可随意利用基础 Object 方法的指定行为，而不管实现程序认为它是否合适。 
 	 * @author Sean
	 * 
	 */	
	public interface ICollection extends Iterable
	{
		/**
		 * 确保此 collection 包含指定的元素（可选操作）. 
		 * 如果此 collection 由于此方法的调用而发生改变，则返回 true。
		 * （如果此 collection 不允许有重复元素，并且已经包含了指定的元素，则返回 false。）
		 * 支持此操作的 collection 可以限制哪些元素能添加到此 collection 中来。需要特别指出的是，
		 * 一些 collection 拒绝添加 null 元素，其他一些 collection 将对可以添加的元素类型强加限制。
		 * Collection 类应该在其文档中清楚地指定能添加哪些元素方面的所有限制。
		 * 
		 * 如果 collection 由于某些原因（已经包含该元素的原因除外）拒绝添加特定的元素，
		 * 那么它必须抛出一个异常（而不是返回 false）。这确保了在此调用返回后，collection 总是包含指定的元素。
		 * @param o - 要添加的元素（如果存在）。 
		 * @return uint 返回数组长度
		 * @roseuid 4380659E0203
		 */
		function add(o:Object) : uint;
		
		/**
		 * 从此 collection 中移除指定元素的单个实例，如果存在的话（可选操作）. 
		 * 更正式地说，如果此 collection 包含一个或多个满足 (o==null ? e==null : o.equals(e)) 的元素 e，则移除这样的元素。
		 * 如果此 collection 包含指定的元素（或者此 collection 由于此方法的调用而发生改变），则返回 true。
		 * @param o - 要从此 collection 中移除的元素（如果存在）。
		 * @return uint 返回删除元素位置，如果元素不存在则返回-1
		 * @roseuid 438066170000
		 */
		function remove(o:Object) : uint;
		
		/**
		 * 如果此 collection 包含指定 collection 中的所有元素，则返回 true.
		 * @param c - 将检查是否包含在此 collection 中的 collection。
		 * @return Boolean
		 * @roseuid 4380666F00EA
		 */
		function containsAll(c:ICollection) : Boolean;
		
		/**
		 * 将指定 collection 中的所有元素都添加到此 collection 中（可选操作）. 
		 * 如果在进行此操作的同时修改指定的 collection，那么此操作行为是不明确的。
		 * （这意味着如果指定的 collection 是此 collection，并且此 collection 为非空，那么此调用的行为是不明确的。）
		 * @param c - 要插入到此 collection 的元素。
		 * @return uint 返回新数组长度
		 * @roseuid 438066A603B9
		 */
		function addAll(c:ICollection) : uint;
		
		/**
		 * 移除此 collection 中那些也包含在指定 collection 中的所有元素（可选操作）. 
		 * 此调用返回后，collection 中将不包含任何与指定 collection 相同的元素。
		 * @param c - 要从此 collection 移除的元素。
		 * @return Boolean 如果此 collection 由于此方法的调用而发生改变，则返回 true
		 * @roseuid 438066CE034B
		 */
		function removeAll(c:ICollection) : Boolean;
		
		/**
		 * 仅保留此 collection 中那些也包含在指定 collection 的元素（可选操作）. 
		 * 换句话说，
		 * 移除此 collection 中未包含在指定 collection 中的所有元素。
		 * @param c - 保留在此 collection 中的元素。
		 * @return Boolean 如果此 collection 由于此方法的调用而发生改变，则返回 true
		 * @roseuid 438066F50167
		 */
		function retainAll(c:ICollection) : Boolean;
		
		/**
		 * 移除此 collection 中的所有元素（可选操作）. 
		 * 此方法返回后，除非抛出一个异常，否则 collection 将为空。
		 * @return void
		 * @roseuid 4380671F008C
		 */
		function clear() : void;
		
		/**
		 * 比较此 collection 与指定对象是否相等. 
		 * 当 Collection 接口没有对 Object.equals 的常规协定添加任何约定时，
		 * “直接”实现该 Collection 接口（换句话说，创建一个 Collection，但它不是 Set 或 List 的类）的程序员
		 * 选择重写 Object.equals 方法时必须小心。没必要这样做，最简单的方案是依靠 Object 的实现，然而实现者可
		 * 能希望实现“值比较”，而不是默认的“引用比较”。（List 和 Set 接口要求进行这样的值比较。）
		 * 
		 * Object.equals 方法的常规协定声称相等必须是对称的
		 * （换句话说，当且仅当存在 b.equals(a) 时，才存在 a.equals(b)）。List.equals 和 Set.equals 的协定声
		 * 称列表只能与列表相等，set 只能与 set 相等。因此，对于一个既不实现 List 又不实现 Set 接口的 collection 类，
		 * 当将此 collection 与任何列表或 set 进行比较时，常规的 equals 方法必须返回 false。（按照相同的逻辑，不可能
		 * 编写一个同时正确实现 Set 和 List 接口的类。）
		 * @param o - 要与此 collection 进行相等性比较的对象。
		 * @return Boolean
		 * @roseuid 438067720242
		 */
		function equals(o:Object) : Boolean;
		
		/**
		 * 如果此 collection 不包含元素，则返回 true. 
		 * @return Boolean
		 * @roseuid 43806BD40196
		 */
		function isEmpty() : Boolean;
		
		/**
		 * 如果此 collection 包含指定的元素，则返回 true. 
		 * 更正式地说，当且仅当此 collection 至少包含一个满足 (o==null ? e==null : o.equals(e)) 的元素 e 时才返回 true。
		 * @param o - 测试在此 collection 中是否存在的元素。
		 * @return Boolean
		 * @roseuid 43806BE60128
		 */
		function contains(o:Object) : Boolean;
		
		/**
		 * 返回指定的元素，这个方法不知道是不是需要提供. 
		 * @param i - 元素编号
		 * @return Object 一个元素
		 * @roseuid 43806BE60128
		 */
		function getItemAt(i:int):Object;
		
		/**
		 * 返回此 collection 中的元素数. 
		 * @return Number
		 * @roseuid 4382ED1D03C8
		 */
		function size() :int;
		
		/**
		 * 返回包含此 collection 中所有元素的数组. 
		 * @return Array
		 * @roseuid 4382ED9C02ED
		 */
		function toArray() : Array;
		}
}