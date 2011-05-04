﻿package com.ixiyou.speUI.mcontrols 
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import com.ixiyou.speUI.mcontrols.MovieToComboBox;
	import com.ixiyou.events.DataSpeEvent;
	/**
	 * ...
	 * @author $(DefaultUser)
	 */
	public class CityComboBox extends Sprite 
	{
		public static var provinceArr:Array = [
		'上海',
		'安徽',
		'北京',
		'重庆',
		'福建',
		'甘肃',
		'广东',
		'广西',
		'贵州',
		'海南',
		'河北',
		'黑龙江',
		'河南',
		'香港',
		'湖北',
		'湖南',
		'江苏',
		'江西',
		'吉林',
		'辽宁',
		'澳门',
		'内蒙古',
		'宁夏',
		'青海',
		'山东',
		'山西',
		'陕西',
		'四川',
		'台湾',
		'天津',
		'新疆',
		'西藏',
		'云南',
		'浙江'];
		/**
		 * 省份列表
		 * @return
		 */
		public function getProvinces():Array {
			return CityComboBox.provinceArr.concat()
		}
		/**
		 * 城市列表
		 * @param	province 省份
		 * @return
		 */
		public function getCity(province:String=''):Array {
			var cityOptions:Array
			switch (province) {
			case "" :
				 cityOptions = new Array("", "");
				break;
			case "安徽" :
				 cityOptions = new Array(
				"合肥", "合肥",
				"安庆", "安庆",
				"蚌埠", "蚌埠",
				"亳州", "亳州",
				"巢湖", "巢湖",
				"滁州", "滁州",
				"阜阳", "阜阳",
				"贵池", "贵池",
				"淮北", "淮北",
				"淮化", "淮化",
				"淮南", "淮南", 
				"黄山", "黄山",
				"九华山", "九华山", 
				"六安", "六安",
				"马鞍山", "马鞍山",
				"宿州", "宿州",
				"铜陵", "铜陵",
				"屯溪", "屯溪",
				"芜湖", "芜湖",
				"宣城", "宣城");
				 break;
			case "北京" :
				 cityOptions = new Array( 
				"北京", "北京",
				"东城", "西城",
				"崇文", "宣武",
				"朝阳", "丰台",
				"石景山", "海淀",
				"门头沟", "房山",
				"通州", "顺义",
				"昌平", "大兴",
				"平谷", "怀柔",
				"密云","延庆");
				break;
			case "重庆" :
				 cityOptions = new Array( 
				"重庆", "重庆",
				"万州", "涪陵",
				"渝中", "大渡口",
				"江北", "沙坪坝",
				"九龙坡", "南岸",
				"北碚", "万盛",
				"双挢", "渝北",
				"巴南", "黔江",
				"长寿", "綦江",
				"潼南", "铜梁",
				"大足", "荣昌",
				"壁山", "梁平",
				"城口", "丰都",
				"垫江", "武隆",
				"忠县", "开县",
				"云阳", "奉节",
				"巫山", "巫溪",
				"石柱", "秀山",
				"酉阳", "彭水",
				"江津", "合川",
				"永川","南川");
				break;
			case "福建" :
				 cityOptions = new Array( 
				"福州", "福州",
				"福安", "福安",
				"龙岩", "龙岩",
				"南平", "南平",
				"宁德", "宁德",
				"莆田", "莆田",
				"泉州", "泉州",
				"三明", "三明",
				"邵武", "邵武",
				"石狮", "石狮",
				"永安", "永安",
				"武夷山", "武夷山",
				"厦门", "厦门",
				"漳州", "漳州");
				 break;
			case "甘肃" :
				 cityOptions = new Array( 
				"兰州", "兰州",
				"白银", "白银",
				"定西", "定西",
				"敦煌", "敦煌",
				"甘南", "甘南",
				"金昌", "金昌",
				"酒泉", "酒泉",
				"临夏", "临夏",
				"平凉", "平凉",
				"天水", "天水",
				"武都", "武都", 
				"西峰", "西峰", 
				"张掖", "张掖");
				break;
			case "广东" :
				 cityOptions = new Array( 
				"广州", "广州",
				"潮阳", "潮阳",
				"潮州", "潮州",
				"澄海", "澄海",
				"东莞", "东莞",
				"佛山", "佛山",
				"河源", "河源",
				"惠州", "惠州",
				"江门", "江门",
				"揭阳", "揭阳",
				"开平", "开平",
				"茂名", "茂名",
				"梅州", "梅州",
				"清远", "清远",
				"汕头", "汕头",
				"汕尾", "汕尾",
				"韶关", "韶关",
				"深圳", "深圳",
				"顺德", "顺德",
				"阳江", "阳江",
				"阳江", "阳江",
				"英德", "英德",
				"云浮", "云浮",
				"增城", "增城",
				"湛江", "湛江",
				"肇庆", "肇庆", 
				"中山", "中山", 
				"珠海", "珠海");
				break;
			case "广西" :
				 cityOptions = new Array( 
				"南宁", "南宁",
				"百色", "百色",
				"北海", "北海",
				"桂林", "桂林",
				"防城港", "防城港",
				"河池", "河池",
				"柳州", "柳州",
				"钦州", "钦州", 
				"梧州", "梧州", 
				"玉林", "玉林");
				break;
			case "贵州" :
				 cityOptions = new Array( 
				"贵阳", "贵阳",
				"安顺", "安顺",
				"毕节", "毕节",
				"都匀", "都匀",
				"凯里", "凯里",
				"六盘水", "六盘水",
				"铜仁", "铜仁",
				"兴义", "兴义", 
				"玉屏", "玉屏", 
				"遵义", "遵义");
				break;
			case "海南" :
				 cityOptions = new Array( 
				"海口", "海口",
				"儋县", "儋县",
				"陵水", "陵水",
				"琼海", "琼海",
				"三亚", "三亚", 
				"通什", "通什", 
				"万宁", "万宁");
				break;
			case "河北" :
				 cityOptions = new Array( 
				"石家庄", "石家庄",
				"保定", "保定",
				"北戴河", "北戴河",
				"沧州", "沧州",
				"承德", "承德",
				"丰润", "丰润",
				"邯郸", "邯郸",
				"衡水", "衡水",
				"廊坊", "廊坊",
				"南戴河", "南戴河",
				"秦皇岛", "秦皇岛",
				"唐山", "唐山",
				"新城", "新城",
				"邢台", "邢台", 
				"张家口", "张家口");
				break;
			case "黑龙江" :
				 cityOptions = new Array( 
				"哈尔滨", "哈尔滨",
				"北安", "北安",
				"大庆", "大庆",
				"大兴安岭", "大兴安岭",
				"鹤岗", "鹤岗",
				"黑河", "黑河",
				"佳木斯", "佳木斯",
				"鸡西", "鸡西",
				"牡丹江", "牡丹江",
				"齐齐哈尔", "齐齐哈尔",
				"七台河", "七台河",
				"双鸭山", "双鸭山",
				"绥化", "绥化",
				"伊春", "伊春");
				break;
			case "河南" :
				 cityOptions = new Array( 
				"郑州", "郑州",
				"安阳", "安阳",
				"鹤壁", "鹤壁",
				"潢川", "潢川",
				"焦作", "焦作",
				"开封", "开封",
				"漯河", "漯河",
				"洛阳", "洛阳",
				"南阳", "南阳",
				"平顶山", "平顶山",
				"濮阳", "濮阳",
				"三门峡", "三门峡",
				"商丘", "商丘",
				"新乡", "新乡",
				"信阳", "信阳",
				"许昌", "许昌",
				"周口", "周口", 
				"驻马店", "驻马店");
				break;
			case "香港" :
				 cityOptions = new Array( 
				"香港", "香港", 
				"九龙", "九龙");
				break;
			case "湖北" : 
				 cityOptions = new Array( 
				"武汉", "武汉",
				"恩施", "恩施",
				"鄂州", "鄂州",
				"黄岗", "黄岗",
				"黄石", "黄石",
				"荆门", "荆门",
				"荆州", "荆州",
				"潜江", "潜江",
				"十堰", "十堰",
				"随州", "随州",
				"武穴", "武穴",
				"仙桃", "仙桃",
				"咸宁", "咸宁",
				"襄阳", "襄阳",
				"襄樊", "襄樊",
				"孝感", "孝感",
				"宜昌", "宜昌");
				break;
			case "湖南" :
				 cityOptions = new Array( 
				"长沙", "长沙",
				"常德", "常德",
				"郴州", "郴州",
				"衡阳", "衡阳",
				"怀化", "怀化",
				"吉首", "吉首",
				"娄底", "娄底",
				"邵阳", "邵阳",
				"湘潭", "湘潭",
				"益阳", "益阳",
				"岳阳", "岳阳",
				"永州", "永州",
				"张家界", "张家界",
				"株洲", "株洲");
				break;
			case "江苏" :
				 cityOptions = new Array( 
				"南京", "南京",
				"常熟", "常熟",
				"常州", "常州",
				"海门", "海门",
				"淮安", "淮安",
				"江都", "江都",
				"江阴", "江阴",
				"昆山", "昆山",
				"连云港", "连云港",
				"南通", "南通",
				"启东", "启东",
				"沭阳", "沭阳",
				"苏州", "苏州",
				"太仓", "太仓",
				"泰州", "泰州",
				"同里", "同里",
				"无锡", "无锡",
				"徐州", "徐州",
				"盐城", "盐城",
				"扬州", "扬州",
				"宜兴", "宜兴",
				"仪征", "仪征",
				"张家港", "张家港", 
				"镇江", "镇江", 
				"周庄", "周庄");
				break;
			case "江西" :
				 cityOptions = new Array(
				"南昌", "南昌",
				"抚州", "抚州",
				"赣州", "赣州",
				"吉安", "吉安",
				"景德镇", "景德镇",
				"井冈山", "井冈山",
				"九江", "九江",
				"庐山", "庐山",
				"萍乡", "萍乡",
				"上饶", "上饶",
				"新余", "新余", 
				"宜春", "宜春", 
				"鹰潭", "鹰潭");
				break;
			case "吉林" :
				 cityOptions = new Array( 
				"长春", "长春",
				"白城", "白城",
				"白山", "白山",
				"珲春", "珲春",
				"辽源", "辽源",
				"梅河", "梅河",
				"吉林", "吉林",
				"四平", "四平",
				"松原", "松原",
				"通化", "通化",
				"延吉", "延吉");
				break;
			case "辽宁" :
				 cityOptions = new Array( 
				"沈阳", "沈阳",
				"鞍山", "鞍山",
				"本溪", "本溪",
				"朝阳", "朝阳",
				"大连", "大连",
				"丹东", "丹东",
				"抚顺", "抚顺",
				"阜新", "阜新",
				"葫芦岛", "葫芦岛",
				"锦州", "锦州",
				"辽阳", "辽阳",
				"盘锦", "盘锦",
				"铁岭", "铁岭",
				"营口", "营口");
				break;
			case "澳门" :
				 cityOptions = new Array( 
				"澳门", "澳门");
				break;
			case "内蒙古" :
				 cityOptions = new Array( 
				"呼和浩特", "呼和浩特",
				"阿拉善盟", "阿拉善盟",
				"包头", "包头",
				"赤峰", "赤峰",
				"东胜", "东胜",
				"海拉尔", "海拉尔",
				"集宁", "集宁",
				"临河", "临河",
				"通辽", "通辽",
				"乌海", "乌海",
				"乌兰浩特", "乌兰浩特", 
				"锡林浩特", "锡林浩特");
				break;
			case "宁夏" :
				 cityOptions = new Array( 
				"银川", "银川",
				"固源", "固源", 
			   "石嘴山", "石嘴山", 
				"吴忠", "吴忠");
				break;
			case "青海" :
				 cityOptions = new Array(
				"西宁", "西宁",
				"德令哈", "德令哈",
				"格尔木", "格尔木",
				"共和", "共和",
				"海东", "海东",
				"海晏", "海晏",
				"玛沁", "玛沁",
				"同仁", "同仁", 
				"玉树", "玉树");
				break;
			case "山东" :
				 cityOptions = new Array( 
				"济南", "济南",
				"滨州", "滨州",
				"兖州", "兖州",
				"德州", "德州",
				"东营", "东营",
				"荷泽", "荷泽",
				"济宁", "济宁",
				"莱芜", "莱芜",
				"聊城", "聊城",
				"临沂", "临沂",
				"蓬莱", "蓬莱",
				"青岛", "青岛",
				"曲阜", "曲阜",
				"日照", "日照",
				"泰安", "泰安",
				"潍坊", "潍坊",
				"威海", "威海",
				"烟台", "烟台",
				"枣庄", "枣庄",
				"淄博", "淄博");
				break;
			case "上海" :
				 cityOptions = new Array( 
				"上海", "上海", 
				"崇明", "崇明", 
				"朱家角", "朱家角");
				break;
			case "山西" :
				 cityOptions = new Array( 
				"太原","太原",
				"长治", "长治",
				"大同", "大同",
				"候马", "候马",
				"晋城", "晋城",
				"离石", "离石",
				"临汾", "临汾",
				"宁武", "宁武",
				"朔州", "朔州",
				"忻州", "忻州",
				"阳泉", "阳泉", 
				"榆次", "榆次", 
				"运城", "运城");
				break;
			case "陕西" :
				 cityOptions = new Array( 
				"西安", "西安",
				"安康", "安康",
				"宝鸡", "宝鸡",
				"汉中", "汉中",
				"渭南", "渭南",
				"商州", "商州",
				"绥德", "绥德",
				"铜川", "铜川",
				"咸阳", "咸阳",
				"延安", "延安",
				"榆林", "榆林");
				break;
			case "四川" :
				 cityOptions = new Array( 
				"成都", "成都",
				"巴中", "巴中",
			   "达安", "达安",
				"德阳", "德阳",
				"都江堰", "都江堰",
				"峨眉山", "峨眉山",
				"涪陵", "涪陵",
				"广安", "广安",
				"广元", "广元",
				"九寨沟", "九寨沟",
				"康定", "康定",
				"乐山", "乐山",
				"泸州", "泸州",
				"马尔康", "马尔康",
				"绵阳", "绵阳",
				"南充", "南充",
				"内江", "内江",
				"攀枝花", "攀枝花",
				"遂宁", "遂宁",
				"汶川", "汶川",
				"西昌", "西昌",
				"雅安", "雅安",
				"宜宾", "宜宾", 
				"自贡", "自贡");
				break;
			case "台湾" :
				 cityOptions = new Array( 
				"台北", "台北",
				"基隆", "基隆", 
				"台南", "台南", 
				"台中", "台中");
				break;
			case "天津" :
				 cityOptions = new Array( 
				"天津", "天津");
				break;
			case "新疆" :
				 cityOptions = new Array( 
				"乌鲁木齐", "乌鲁木齐",
				"阿克苏", "阿克苏",
				"阿勒泰", "阿勒泰",
				"阿图什", "阿图什",
				"博乐", "博乐",
				"昌吉", "昌吉",
				"东山", "东山",
				"哈密", "哈密",
				"和田", "和田",
				"喀什", "喀什",
				"克拉玛依", "克拉玛依",
				"库车", "库车",
				"库尔勒", "库尔勒",
				"奎屯", "奎屯",
				"石河子", "石河子",
				"塔城", "塔城",
				"吐鲁番", "吐鲁番", 
				"伊宁", "伊宁");
				break;
			case "西藏" :
				 cityOptions = new Array( 
				"拉萨", "拉萨",
				"阿里", "阿里",
				"昌都", "昌都",
				"林芝", "林芝",
				"那曲", "那曲", 
				"日喀则", "日喀则", 
				"山南", "山南");
				break;
			case "云南" :
				 cityOptions = new Array( 
				"昆明", "昆明",
				"大理", "大理",
				"保山", "保山",
				"楚雄", "楚雄",
				"大理", "大理",
				"东川", "东川",
				"个旧", "个旧",
				"景洪", "景洪",
				"开远", "开远",
				"临沧", "临沧",
				"丽江", "丽江",
				"六库", "六库",
				"潞西", "潞西",
				"曲靖", "曲靖",
				"思茅", "思茅",
				"文山", "文山",
				"西双版纳", "西双版纳",
				"玉溪", "玉溪", 
				"中甸", "中甸", 
				"昭通", "昭通");
				break;
			case "浙江" :
				 cityOptions = new Array( 
				"杭州", "杭州",
				"安吉", "安吉",
				"慈溪", "慈溪",
				"定海", "定海",
				"奉化", "奉化",
				"海盐", "海盐",
				"黄岩", "黄岩",
				"湖州", "湖州",
				"嘉兴", "嘉兴",
				"金华", "金华",
				"临安", "临安",
				"临海", "临海",
				"丽水", "丽水",
				"宁波", "宁波",
				"瓯海", "瓯海",
				"平湖", "平湖",
				"千岛湖", "千岛湖",
				"衢州", "衢州",
				"瑞安", "瑞安",
				"绍兴", "绍兴",
				"嵊州", "嵊州",
				"台州", "台州",
				"温岭", "温岭",
				"温州", "温州");
				break; 
			 default:
				 cityOptions = new Array("", "");
			}
			return cityOptions
		}
		private var provinceBox:MovieToComboBox
		private var cityBox:MovieToComboBox
		private var _province:String=''
		private var _city:String = ''
		private var skin:*
		/**
		 * 构造函数
		 */
		public function CityComboBox(skin:Sprite,formerly:Boolean=false,parentBool:Boolean=false)
		{
			var tempParent:DisplayObjectContainer
			
			if (formerly) {
				this.x = skin.x
				this.y = skin.y
			}
			if (skin.parent&& parentBool) {
				tempParent=skin.parent
				this.name=skin.name
			}
			this.skin = skin
			skin.x=skin.y=0
			addChild(skin)
			if(tempParent)tempParent.addChild(this)
			
			cityBox = new MovieToComboBox(skin.getChildByName('box2') as Sprite, { data:null }, true, true)
			cityBox.addEventListener('upData',cityUpData)
			provinceBox = new MovieToComboBox(skin.getChildByName('box1') as Sprite, { data:null}, true, true)
			provinceBox.addEventListener('upData', provinceUpData)
			provinceBox.data=getProvinces()
			//trace(province,city)
		}
		
		private function cityUpData(e:DataSpeEvent):void 
		{
			_city = cityBox.seletData.label
			trace(province,city)
		}
		private function provinceUpData(e:DataSpeEvent):void 
		{
			_province = provinceBox.seletData.label
			var cityArr:Array=getCity(province)
			var arr:Array = new Array()
			var i:int 
			var item:Object
			if (province == '北京' || province == '重庆') {
				for(i = 0; i < cityArr.length; i++) 
				{
					item =cityArr[i];
					if (i > 0) arr.push(item)
				}
			}else {
				for (i = 0; i < cityArr.length; i++) 
				{
					item = cityArr[i];
					if(i%2==0)arr.push(item)
				}
			}
			cityBox.data=arr
		}
		
		public function get province():String { return _province; }
		
		public function get city():String { return _city; }
	}

}