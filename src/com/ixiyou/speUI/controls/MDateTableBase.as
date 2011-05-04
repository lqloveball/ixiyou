package  com.ixiyou.speUI.controls
{
	
	
	/**
	 * 日期显示基本表格
	 * @author magic
	 */
	import com.ixiyou.events.SelectEvent;
	import com.ixiyou.managers.CheckManager;
	import com.ixiyou.speUI.controls.MCheckButton;
	import com.ixiyou.speUI.core.SpeComponent;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	 
	[Event(name = "upSelect", type = "com.ixiyou.events.SelectEvent")]
	 
	public class MDateTableBase extends SpeComponent
	{
		protected var _date:Date;
		protected var _year:int;
		protected var _month:int;
		protected var _day:int;
		protected var _box:Sprite;
		protected var _selectMaster:CheckManager
		protected var _dateCells:Array;
		
		protected var _cellFromat:CellFromat;
		protected var _dic:Dictionary;
		
		public function MDateTableBase(config:*=null) 
		{
			super(config);
			_dic = new Dictionary(true);
			_cellFromat = new CellFromat();
			_selectMaster = new CheckManager();
			_selectMaster.addEventListener(SelectEvent.UPSELECT, onSelect);
			_box = new Sprite();
			addChild(_box);
			if (config != null){
				if (config.date != null) {
					date = config.date;
				}else {
					date = new Date(config.year as Number, config.month as Number, config.day as Number);
				}
				if (config.iterance != null) {
					_selectMaster.iterance = config.iterance;
				}
			}else {
				date = new Date();
			}
			
		}
		
		/**
		 * 刷新显示
		 */
		public function upDate():void {
			clear();
			var dayCount:int = getDaysOfMonth(_date);
			var index:int = getFirstDayOfMonth(_date);
			var end:int = index + dayCount;
			_dateCells = new Array();
			for ( var i:int = 1; index < end; index++, i++) {
				var mcb:MCheckButton = new MCheckButton( { label:i } )
				_dic[_year + String(_month) + i] = mcb;
				mcb.data = new Date(_year, _month, i);
				mcb.setSize(_cellFromat.width, _cellFromat.height);
				_selectMaster.push(mcb);
				mcb.x = int((index % 7) * _cellFromat.distanceX+_cellFromat._initX);
				mcb.y = int(int(index / 7) * _cellFromat.distanceY+_cellFromat._initY);
				_box.addChild(mcb);
				_dateCells.push(mcb);
				mcb.initialize();
			}
		}
		
		public function setCellSize(w:Number, h:Number):void {
			_cellFromat.width = w;
			_cellFromat.height = h;
		}
		
		/**
		 * 选择一个日期
		 * @param	date
		 * @return
		 */
		public function select(date:Date):Boolean {
			var mcb:MCheckButton = _dic[date.getFullYear() + String(date.getMonth()) + date.getDate()] as MCheckButton;
			if (mcb != null) {
				mcb.select = true;
				return true;
			}
			return false;
		}
		/**
		 * 更新大小
		 */
		override public function upSize():void 
		{
			_cellFromat.distanceX = _width / 7;
			_cellFromat.distanceY = _height / 6;
			_cellFromat._initX = (_cellFromat.distanceX - _cellFromat.width)*0.5;
			_cellFromat._initY = (_cellFromat.distanceY - _cellFromat.height)*0.5;
			upDate();
		}
		
		/**
		 * 获取Date实例中所在月的天数
		 * @param	date
		 */
		public static function getDaysOfMonth(date:Date):int {
			return new Date(date.getFullYear(), date.getMonth() + 1, 0).getDate();
		}
		
		/**
		 * date实例所在月的第一天为星期几
		 * @param	date
		 * @return
		 */
		public static function getFirstDayOfMonth(date:Date):int {
			return (new Date(date.getFullYear(), date.getMonth(), 1)).getDay();
		}
		/**
		 * 对应的date实例
		 */
		public function get date():Date { return _date; }
		public function set date(value:Date):void {
			_date = value;
			_year = _date.getFullYear();
			_month = _date.getMonth();
			_day = _date.getDate();
			upDate();
		}
		/**
		 * 年
		 */
		public function get year():int { return _year; }
		public function set year(value:int):void {
			if (_year == value) return;
			_date.fullYear = value;
			date = _date;
		}
		/**
		 * 月
		 */
		public function get month():int { return _month; }
		public function set month(value:int):void {
			if (_month == value) return;
			_date.month = value;
			date = _date;
		}
		/**
		 * 日
		 */
		public function get day():int { return _day; }
		public function set day(value:int):void {
			if (_day == value) return;
			_day = value;
			_date.date = _day;
		}
		
		/**
		 * 是否可复选
		 */
		public function get iterance():Boolean { return _selectMaster.iterance }
		public function set iterance(value:Boolean):void {
			_selectMaster.iterance = value;
		}
		
		/**
		 * 日期选择控制器
		 */
		public function get selectMaster():CheckManager { return _selectMaster; }
		/**
		 * 当前显示的所有日期按钮
		 */
		public function get dateCells():Array { return _dateCells; }
		
		/**
		 * 清空
		 */
		protected function clear():void {
			for (var i:int = _box.numChildren - 1; i >= 0; i--) {
				var mcb:MCheckButton = _box.removeChildAt(i) as MCheckButton;
				_selectMaster.remove(mcb);
				var date:Date = mcb.data as Date;
				delete _dic[date.getFullYear() + String(date.getMonth()) + date.getDate];
			}
			_dateCells = null;
		}
		
		/**
		 * 选择日期
		 * @param	se
		 */
		protected function onSelect(se:SelectEvent):void {
			if (!hasEventListener(SelectEvent.UPSELECT)) return;
			if (_selectMaster.iterance) {
				var temp:Array = _selectMaster.selectedArr;
				for (var i:int = temp.length - 1; i >= 0; i--) {
					temp[i] = temp[i].data;
				}
				dispatchEvent(new SelectEvent(SelectEvent.UPSELECT, temp));
			}else {
				dispatchEvent(new SelectEvent(SelectEvent.UPSELECT, MCheckButton(_selectMaster.selected).data));
			}
		}
	}
}

class CellFromat {
	public var width:Number=50;
	public var height:Number=20;
	public var distanceX:Number=3;
	public var distanceY:Number=2;
	public var _initX:Number=0;
	public var _initY:Number=0;
}