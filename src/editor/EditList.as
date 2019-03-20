

package editor
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import common.BookView;
	
	import model.BookData;
	
	import org.libspark.betweenas3.BetweenAS3;
	
	
	public class EditList extends BookView
	{
		
		//---------------------------------------------------------------------
		//  
		//  Class ( Constants, Variables, Properties, Methods)
		//  
		//---------------------------------------------------------------------
		private static const pageGap:int = 40;
		public static const startX:int = 130;
		public static const startY:int = 50;
		
		//---------------------------------------------------------------------
		//  
		//  Variables ( Constants, public, internal, private )
		//  
		//---------------------------------------------------------------------
		
		private var _pageContainer:Sprite;
		private var _pages:Vector.<EditListItem> = new Vector.<EditListItem>(3);
		
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
		public function EditList()
		{
			if(stage)
				onAddedToStage();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedToStage);
		}
		
		private function onAddedToStage(e:Event=null):void
		{
			init();
			
			move();
			addEvents();
		}
		
		private function onRemovedToStage(e:Event=null):void
		{
			removeEvents();
		}
		
		
		private function init():void
		{
			if(!_pageContainer)
			{
				_pageContainer = new Sprite;
				
				var count:int = _pages.length;
				for (var i:int = 0; i < count; i++) 
				{
					var page:EditListItem = createPage();
					_pages[i] = page
					_pageContainer.addChild(page);
				}
				_pageContainer.x = KidWriter.SCREEN_WIDTH;
				_pageContainer.y = startY;
				addChild(_pageContainer);
				
				
				_btnAdd.addChild(new Assets.add as Bitmap);
				_btnAdd.x = KidWriter.SCREEN_WIDTH - 70;
				_btnAdd.y = _pageContainer.height / 2 + _pageContainer.y - _btnAdd.height/2;
				addChild(_btnAdd);
				
				_btnAdd.addEventListener(MouseEvent.CLICK, function(e:Event):void
				{
					bookData.addPage(_curIndex + 1);
					_totalCount = bookData.count;
					next();
				});
				
				
				_btnDelete.addChild(new Assets.bt_delete as Bitmap);
				_btnDelete.x = startX + 30;
				_btnDelete.y = 8;
				addChild(_btnDelete);
				
				_btnDelete.addEventListener(MouseEvent.CLICK, function(e:Event):void
				{
					bookData.removePage(_curIndex);
					_totalCount = bookData.count;
					
					prev();
				});
				
				setButtonVisible();
				
				
				var bottmY:int = _pageContainer.y + _pageContainer.height;
				
				_btnPlay.addChild(new Assets.btn_play as Bitmap);
				_btnPlay.x = KidWriter.SCREEN_WIDTH/2 - _btnPlay.width/2;
				_btnPlay.y = bottmY;
				addChild(_btnPlay);
				
				_btnPlay.addEventListener(MouseEvent.CLICK, function(e:Event):void{
					
				});
				
				_btnRecord.addChild(new Assets.bt_microphone as Bitmap);
				_btnRecord.x = _btnPlay.x - 200;
				_btnRecord.y = bottmY;
				
				_btnRecord.height = _btnPlay.height;
				_btnRecord.scaleX = _btnRecord.scaleY;
				
				addChild(_btnRecord);
				
				_btnRecord.addEventListener(MouseEvent.CLICK, function(e:Event):void{
					dispatchEvent(new NavigationEvent(NavigationEvent.EDIT, bookIndex, curIndex, EditType.RECORD));
				});
				
				_btnDraw.addChild(new Assets.bt_pencil as Bitmap);
				_btnDraw.x = _btnPlay.x + 200;
				_btnDraw.y = bottmY;
				
				_btnDraw.height = _btnPlay.height;
				_btnDraw.scaleX = _btnDraw.scaleY;
				
				addChild(_btnDraw);
				
				_btnDraw.addEventListener(MouseEvent.CLICK, function(e:Event):void{
					dispatchEvent(new NavigationEvent(NavigationEvent.EDIT, bookIndex, curIndex, EditType.DRAW));
				});
			} 
			else
			{
				_pageContainer.x = KidWriter.SCREEN_WIDTH;
			}
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
		
		public override function setup(book:BookData, index:int, pageIndex:int=0):void
		{
			super.setup(book, index, pageIndex);
			
			_totalCount = book.count;
			_curIndex = pageIndex;
			
			trace('_curIndex', _curIndex);
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
				_pages.unshift(_pages.shift());
			}
			move();
		}
		
		private function move():void
		{
			setButtonVisible();
			display();
			
			var target:Number = startX -((pageGap + EditListItem.WIDTH) * _curIndex);
			BetweenAS3.tween(_pageContainer, {x:target}, null, .2).play();
		}
		
		private function createPage(isCover:Boolean=false):EditListItem
		{
			var page:EditListItem = new EditListItem;
			
			return page;
		}
		
		private function display():void
		{
			var count:int = _pages.length;
			for (var i:int = 0; i < count; i++) 
			{
				var page:EditListItem = _pages[i];
				var index:int = _curIndex + (i-1);
				
				if(index < 0)
				{
					page.visible = false;
				}
				else 
				{
					page.visible = true;
					
					if( index != page.index)
					{
						if(index > _totalCount-1)
						{
							page.alpha = .2;
							page.update();
						} else {
							page.alpha = 1;
							page.update(index, bookData.pages[index]);
						}
						page.x = (index) * (pageGap + EditListItem.WIDTH);
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
			_btnAdd.visible = false;
		}
		
	}
}