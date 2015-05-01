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
//  File name : Editor.as
//  Author: 최진열(choi.jinyeol@nhn.com)
//  First created: Apr 28, 2015, 최진열(choi.jinyeol@nhn.com)
//  Last revised: Apr 28, 2015, 최진열(choi.jinyeol@nhn.com)
//  Version: v.1.0
//
////////////////////////////////////////////////////////////////////////////////


package editor
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.libspark.betweenas3.BetweenAS3;
	
	
	/**
	 * 
	 * @author 최진열(choi.jinyeol@nhn.com)
	 */
	public class Editor extends Sprite
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
		private const _bg:Bitmap = new Bitmap(new BitmapData(1, 1, false, 0x73D2FF));
		
		private var btnBack:Sprite;
		
		
		private var _list:EditorPageList;
		
		
		/**
		 * Constructor
		 */
		public function Editor()
		{
			if(stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addChild(_bg);
			_bg.width = stage.stageWidth;
			_bg.height = stage.stageHeight;
			
			BetweenAS3.tween(_bg, {alpha:1}, {alpha:0}, .4).play();
			
			setupButton();
			
			_list = new EditorPageList;
			addChild(_list);
			
			_list.enable();
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
			btnBack = new Sprite;
			btnBack.addChild(new Assets.btn_close as Bitmap);
			
			btnBack.x = 6;
			btnBack.y = 6;
			addChild(btnBack);
//			
			btnBack.addEventListener(MouseEvent.CLICK, onClose);
			
		}
		

		
		private function onClose(e:Event):void
		{
			dispatchEvent(new NavigationEvent(NavigationEvent.BACK));
		}
		
	}
}