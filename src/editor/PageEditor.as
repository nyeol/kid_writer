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
//  File name : PageEditor.as
//  Author: 최진열(choi.jinyeol@nhn.com)
//  First created: May 4, 2015, 최진열(choi.jinyeol@nhn.com)
//  Last revised: May 4, 2015, 최진열(choi.jinyeol@nhn.com)
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
	
	import model.PageData;
	
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.core.easing.BackEaseIn;
	import org.libspark.betweenas3.easing.Back;
	
	
	/**
	 * 
	 * @author 최진열(choi.jinyeol@nhn.com)
	 */
	public class PageEditor extends Sprite
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
		private const _bg:Bitmap = new Bitmap(new BitmapData(1, 1, false, 0x738BFF));

		private var _pageContaer:Sprite = new Sprite;
		private const _pageBg:Bitmap = new Assets.bg_edit as Bitmap;
		
		private var _canvas:CanvasView;
		
		private var _mode:String;
		
		private var btnOk:Sprite;
		private var _drawer:Drawer;
		
		
		private var _pageData:PageData;
		
		/**
		 * Constructor
		 */
		public function PageEditor()
		{
			if(stage)
				onAddToStage();
			else
				addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addChild(_bg);
			_bg.width = stage.stageWidth;
			_bg.height = stage.stageHeight;
			
			_pageBg.scaleX = _pageBg.scaleY = 1.26;
			_pageBg.x = -8;
			_pageBg.y = -5;
			_pageContaer.addChild(_pageBg);
			
			var canvas:BitmapData = new BitmapData(CanvasView.W, CanvasView.H, true, 0x0);
			_canvas = new CanvasView(canvas, new BitmapData(1,1,false, 0xffffff));
			_canvas.x = 12;
			_canvas.y = 11;
			
			_pageContaer.addChild(_canvas);
			addChild(_pageContaer);
			
			show();
			setupButton();
			changeMode();
		}
		
		public function init(pageData:PageData):void
		{
			_pageData = pageData;
		}
			
		
		
		public function show():void
		{
			BetweenAS3.tween(_bg, {alpha:1}, {alpha:0}, .4).play();
			
			BetweenAS3.tween(_pageContaer, 
				{x:0, y:0, scaleX:1, scaleY:1}, 
				{x:EditList.startX * 1.26, y:EditList.startY * 1.26, scaleX:.74, scaleY:.74},
				.4, Back.easeOut).play();
			
			
			if(!_drawer)
			{
				_drawer = new Drawer;
				_drawer.init(_canvas);
				addChild(_drawer);
			} else {
				_drawer.init(_canvas);
				_drawer.open();
			}
			
		}
		
		private function changeMode(to:String=null):void
		{
			if(!to)
				to = EditType.DRAW;
			
			if(_mode != to)
			{
				switch(to)
				{
					case EditType.DRAW:
					{
						
						break;
					}
						
					case EditType.RECORD:
					{
						break;
					}
				}
				
				_mode = to;
			}
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
			if(!btnOk)
			{
				btnOk = new Sprite;
				btnOk.addChild(new Assets.bt_ok as Bitmap);
				btnOk.x = stage.stageWidth - btnOk.width - 15;
				btnOk.y = stage.stageHeight - btnOk.height - 10;
				addChild(btnOk);
				btnOk.addEventListener(MouseEvent.CLICK, onClose);
			}			
		}
		
		
		private function onClose(e:Event):void
		{
			
			
			
			dispatchEvent(new NavigationEvent(NavigationEvent.BACK));
		}


	}
}