////////////////////////////////////////////////////////////////////////////////
//
//  NHN Corp
//  Copyright NHN Corp.
//  All Rights Reserved.
//
//  이 문서는 NHN(주)의 지적 자산이므로 NHN(주)의 승인 없이 이 문서를	다른 용도로
//  임의 변경하여 사용할 수 없습니다. NHN(주)는 이 문서에 수록된 정보의 완전성과
//  정확성을 검증하기 위해 노력하였으나, 발생할 수 있는 내용상의 오류나 누락에
//  대해서는 책임지지 않습니다. 따라서 이 문서의 사용이나 사용결과에 따른 책임은
//  전적으로 사용자에게 있으며, NHN(주)는 이에 대해 명시적 혹은 묵시적으로 어떠한
//  보증도하지 않습니다. NHN(주)는 이 문서의 내용을 예고 없이 변경할 수 있습니다.
//
//  File name : Home.as
//  Author: 최진열(choi.jinyeol@nhn.com)
//  First created: Apr 28, 2015, 최진열(choi.jinyeol@nhn.com)
//  Last revised: Apr 28, 2015, 최진열(choi.jinyeol@nhn.com)
//  Version: v.1.0
//
////////////////////////////////////////////////////////////////////////////////


package home
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	/**
	 * 
	 * @author 최진열(choi.jinyeol@nhn.com)
	 */
	public class Home extends Sprite
	{
		
		//---------------------------------------------------------------------
		//  
		//  Class ( Constants, Variables, Properties, Methods)
		//  
		//---------------------------------------------------------------------
		
		//---------------------------------------------------------------------
		//  
		//  Variables ( Constants, public, internal, private )
		//  
		//---------------------------------------------------------------------
		
		private var btnCreate:Sprite;
		
		/**
		 * Constructor
		 */
		public function Home()
		{
			if(stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			setupButton();
		}
		
		//---------------------------------------------------------------------
		//  
		//  Properties ( first Override )
		//  
		//---------------------------------------------------------------------
		
		//---------------------------------------------------------------------
		//  
		//  Methods ( first Override )
		//  
		//---------------------------------------------------------------------
		private function setupButton():void
		{
			btnCreate = new Sprite;
			btnCreate.addChild(new Assets.btn_create as Bitmap);
			
			btnCreate.x = stage.stageWidth - btnCreate.width - 40;
			btnCreate.y = stage.stageHeight - btnCreate.height - 40;
			addChild(btnCreate);
			
			btnCreate.addEventListener(MouseEvent.CLICK, createHandler);
				
		}
		
		private function createHandler(e:Event):void
		{
			dispatchEvent(new NavigationEvent(NavigationEvent.CREATE));
		}
		
		
	}
}