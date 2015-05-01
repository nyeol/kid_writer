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
//  File name : EditorThumb.as
//  Author: 최진열(choi.jinyeol@nhn.com)
//  First created: Apr 28, 2015, 최진열(choi.jinyeol@nhn.com)
//  Last revised: Apr 28, 2015, 최진열(choi.jinyeol@nhn.com)
//  Version: v.1.0
//
////////////////////////////////////////////////////////////////////////////////


package editor
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.ModuleEvent;
	
	import org.libspark.betweenas3.BetweenAS3;
	
	
	/**
	 * 
	 * @author 최진열(choi.jinyeol@nhn.com)
	 */
	public class EditorPageList extends Sprite
	{
		
		//---------------------------------------------------------------------
		//  
		//  Class ( Constants, Variables, Properties, Methods)
		//  
		//---------------------------------------------------------------------
		private static const pageGap:int = 40;
		private static const startX:int = 130;
		
		//---------------------------------------------------------------------
		//  
		//  Variables ( Constants, public, internal, private )
		//  
		//---------------------------------------------------------------------
		
		private var _pageContainer:Sprite = new Sprite;
		private var _pages:Vector.<EditorPage> = new Vector.<EditorPage>(3);
		
		private var _curIndex:int;
		private var _totalCount:int = 2;
		
		private var _btnAdd:Sprite = new Sprite;
		private var _btnDelete:Sprite = new Sprite;
		private var _btnPlay:Sprite = new Sprite;
		private var _btnRecord:Sprite = new Sprite;
		private var _btnDraw:Sprite = new Sprite;

		
		/**
		 * Constructor
		 */
		public function EditorPageList()
		{
			if(stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			var count:int = _pages.length;
			for (var i:int = 0; i < count; i++) 
			{
				var page:EditorPage = createPage();
				_pages[i] = page
				_pageContainer.addChild(page);
			}
			_pageContainer.x = stage.stageWidth;
			_pageContainer.y = 50;
			addChild(_pageContainer);
			
			
			_btnAdd.addChild(new Assets.add as Bitmap);
			_btnAdd.x = stage.stageWidth - 70;
			_btnAdd.y = _pageContainer.height / 2 + _pageContainer.y - _btnAdd.height/2;
			addChild(_btnAdd);
			
			_btnAdd.addEventListener(MouseEvent.CLICK, function(e:Event):void{
				_totalCount++;
				next();
			});
			
			
			_btnDelete.addChild(new Assets.bt_delete as Bitmap);
			_btnDelete.x = startX + 30;
			_btnDelete.y = 8;
			addChild(_btnDelete);
			
			_btnDelete.addEventListener(MouseEvent.CLICK, function(e:Event):void{
				_totalCount--;
				prev();
			});
			
			setButtonVisible();
			move();
		}
		
		//---------------------------------------------------------------------
		//  
		//  Properties ( first Override )
		//  
		//---------------------------------------------------------------------
		public function get curIndex():int
		{
			return _curIndex;
		}

		//---------------------------------------------------------------------
		//  
		//  Methods ( first Override )
		//  
		//---------------------------------------------------------------------
		
		public function setup(totalPage:int):void
		{
			_totalCount = totalPage;
		}
		
		public function enable():void
		{
			addEvents();
		}
		
		public function disable():void
		{
			removeEvents()
		}
		
		private function addEvents():void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
		}
		private function removeEvents():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private var _draging:Boolean;
		private var _downX:Number;
		private var _pastX:Number;
		private function onMouseDown(e:MouseEvent):void
		{
			if(e.target != _btnAdd && isIn(e.stageY))
			{
				_draging = true;
				_downX = _pastX = e.stageX;
				hideButtons();
				
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			var curX:Number = e.stageX;
			_pageContainer.x += curX - _pastX;
			_pastX = curX;
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			if(_downX > _pastX)
				next();
			else if(_downX < _pastX)
				prev();
			else
				setButtonVisible();
			
			_draging = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		
		private function isIn(y:Number):Boolean
		{
			if(y <_pageContainer.y || y > _pageContainer.y + _pageContainer.height)
				return false;
			return true;
		}
		
		public function next():void
		{
			if(_curIndex < _totalCount-1)
			{
				_curIndex++;
				_pages.push(_pages.shift());
			}
			move();
		}
		
		public function prev():void
		{
			if(_curIndex > 0)
			{
				_curIndex--;
				_pages.unshift(_pages.pop());
			}
			move();
		}
		
		private function move():void
		{
			setButtonVisible();
			display();
			
			var target:Number = startX -((pageGap + EditorPage.WIDTH) * _curIndex);
			BetweenAS3.tween(_pageContainer, {x:target}, null, .2).play();
		}
		
		private function createPage(isCover:Boolean=false):EditorPage
		{
			var page:EditorPage = new EditorPage;
			
			return page;
		}
		
		private function display():void
		{
			var count:int = _pages.length;
			for (var i:int = 0; i < count; i++) 
			{
				var page:EditorPage = _pages[i];
				var index:int = _curIndex + (i-1);
				
				if(index < 0)
				{
					page.visible = false;
				}
				else 
				{
					page.visible = true;
					
					if(index > _totalCount-1)
					{
						page.alpha = .2;
					} else {
						page.alpha = 1;
					}
					
					if( index != page.index)
					{
						page.update(index);
						page.x = (index) * (pageGap + EditorPage.WIDTH);
					}
				}
				
			}
		}
		
		
		
		private function setButtonVisible():void
		{
			if(_curIndex == 0 || _totalCount < 3)
			{
				_btnDelete.visible = false;
			} else {
				_btnDelete.visible = true;
			}
			
			
			if(_curIndex == _totalCount-1)
			{
				_btnAdd.visible = true;
				BetweenAS3.tween(_btnAdd, {alpha:.4}, {alpha:0}, .4).play();
			}
			else
			{
				_btnAdd.visible = false;
			}
			
			
		}

		private function hideButtons():void
		{
//			_btnDelete.visible = false;
			_btnAdd.visible = false;
		}
		
	}
}