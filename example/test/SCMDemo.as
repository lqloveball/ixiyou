package
{
	import flash.display.*;
	import flash.events.*
	import flash.external.ExternalInterface
	import com.ixiyou.speUI.controls.*
	import com.ixiyou.managers.AlertManager

	/**
	 * 单片机 测试
	 * @author spe email:md9yue@qq.com
	 */
	public class SCMDemo extends Sprite
	{
		private var input1:MTextInput
		private var input2:MTextInput
		private var input3:MTextInput
		private var arlt:AlertWindow=new AlertWindow({label: '错误', info: '没有可以call交互的shell'})

		public function SCMDemo()
		{

			var label:MLabel=new MLabel({label: '方法名:', x: 10, y: 10, width: 50})
			addChild(label)
			input1=new MTextInput({toolTip: '输入方法名', x: 60, y: 10, width: 200})
			addChild(input1)
			label=new MLabel({label: '参 数:', x: 10, y: 40, width: 50})
			addChild(label)
			input2=new MTextInput({toolTip: '输入参数', x: 60, y: 40, width: 400})
			addChild(input2)
			var btn:MButton
			btn=new MButton({label: '提交', x: 10, y: 70})
			addChild(btn)
			btn.addEventListener(MouseEvent.CLICK, fun)
			input3=new MTextInput({toolTip: '调用FLASH的方法命', x: 10, y: 100, width: 200})
			addChild(input3)
			btn=new MButton({label: '提交被调方法名', x: 215, y: 100, width: 100})
			addChild(btn)
			btn.addEventListener(MouseEvent.CLICK, addFun)
		}

		private function addFun(e:MouseEvent):void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback(input3.label, callFun)
				var temp:AlertWindow=new AlertWindow({label: '调用FLASH 方法', info: '提交的被叫方法名成功:' + input3.label})
				AlertManager.getInstance(stage).push(temp)
			}
			else
			{
				AlertManager.getInstance(stage).push(arlt)
			}
		}

		private function callFun(value:String):void
		{
			var temp:AlertWindow=new AlertWindow({label: '调用FLASH 方法', info: value})
			AlertManager.getInstance(stage).push(temp)
		}

		private function fun(e:MouseEvent):void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.call(input1.label, input2.label)
			}
			else
			{
				AlertManager.getInstance(stage).push(arlt)
			}
		}

	}

}

