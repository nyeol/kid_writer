
package viewer
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import common.BookView;
	
	import model.BookData;
	import model.BooksManager;
	
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Circ;
	import org.libspark.betweenas3.easing.Cubic;
	import org.libspark.betweenas3.events.TweenEvent;
	import org.libspark.betweenas3.tweens.IObjectTween;
	import org.libspark.betweenas3.tweens.ITweenGroup;
	
	

	public class Viewer extends BookView
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
		private var _bg:Bitmap;
		private var btnBack:Sprite;
		private var btnEdit:Sprite;
		
		private var page:ViewerPage;
		private var _curIndex:int;
		
		private var trOpen:IObjectTween;
		private var trNext:ITweenGroup;
		
		/**
		 * Constructor
		 */
		public function Viewer()
		{
			if(stage)
				init();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			init();
			
		}
		
		private function onRemovedToStage(e:Event):void
		{
			stage.removeEventListener(MouseEvent.CLICK, onClickStage);
		}
		
		
		private function onClickStage(e:MouseEvent):void
		{
			if(e.stageY > _bg.y)
			{
				if(e.stageX > stage.stageWidth/2)
					next();
				else
					prev();
			}
		}
		
		private function init():void
		{
			if(this.numChildren == 0)
			{
				_bg = new Assets.bg_view as Bitmap;
				addChild(_bg);
				_bg.x = 45;
				_bg.y = 10;
				
				setupButton();
				
				page = new ViewerPage;
				page.x = _bg.x + 30;
				page.y = _bg.y + 10;
				addChild(page);
			}
			
			_curIndex = 0;
			page.visible = false;
			
			if(!trOpen)
			{
				trOpen = BetweenAS3.tween(_bg, 
					{alpha:1, scaleX:1, scaleY:1, x:45, y:10 }, 
					{alpha:0, scaleX:.4, scaleY:.8, x:360, y:50},
					.4, Cubic.easeOut);
				trOpen.addEventListener(TweenEvent.COMPLETE, function(e:Event):void
				{
					show();
				});
			}
			trOpen.play();
		}
		
		
		private function startShow():void
		{
			if(!trNext)
			{
				trNext = BetweenAS3.serial(
					BetweenAS3.tween(_bg, 
						{alpha:1, scaleX:.95, scaleY:1, x:60, y:10 }, 
						null,
						.1),
					BetweenAS3.func(show),
					BetweenAS3.parallel(
						BetweenAS3.tween(page, {alpha:1}, {alpha:0}, .4),
						BetweenAS3.tween(_bg, 
							{alpha:1, scaleX:1, scaleY:1, x:45, y:10 }, 
							null,
							.1)
						)
					);
			}
			
			if(trNext.isPlaying)
			{
				trNext.stop();
				setTimeout(function():void
				{
					trNext.gotoAndPlay(0);
				}, 1);
			}
			else 
			{
				trNext.play();
			}

			page.visible = false;
			stage.removeEventListener(MouseEvent.CLICK, onClickStage);
		}

		private function addEvent():void
		{
			stage.addEventListener(MouseEvent.CLICK, onClickStage);
		}
		
		private function show():void
		{
			page.update(bookData.pages[_curIndex]);
			page.visible = true;
			
			addEvent();
		}
		
		private function next():void
		{
			if(_curIndex < bookData.count-1)
			{
				_curIndex++;
				startShow();
			}
		}
		
		private function prev():void
		{
			if(_curIndex > 0)
			{
				_curIndex--;
				startShow();
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
			btnBack = new Sprite;
			btnBack.addChild(new Assets.btn_close as Bitmap);
			
			btnBack.x = 6;
			btnBack.y = 6;
			addChild(btnBack);
			btnBack.addEventListener(MouseEvent.CLICK, onClose);
			
			
			btnEdit = new Sprite;
			btnEdit.addChild(new Assets.btn_edit as Bitmap);
			
			btnEdit.x = KidWriter.SCREEN_WIDTH - btnEdit.width - 6;
			btnEdit.y = 6;
			addChild(btnEdit);
			btnEdit.addEventListener(MouseEvent.CLICK, onEdit);
			
		}

		private function onEdit(e:Event):void
		{
			dispatchEvent(new NavigationEvent(NavigationEvent.EDIT, bookIndex, _curIndex));
		}
		
		private function onClose(e:Event):void
		{
			dispatchEvent(new NavigationEvent(NavigationEvent.BACK));
		}
		
		
	}
}