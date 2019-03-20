

package home
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
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
		
		private var bookList:BookList;
		private var btnCreate:Sprite;
		
		/**
		 * Constructor
		 */
		public function Home()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			if(stage)
				init();
		}
		
		private function onAddedToStage(e:Event):void
		{
			if(!btnCreate)
				init();
			
			showList();
		}
		private function onRemovedFromStage(e:Event):void
		{
			removeList();
		}
		
		private function init(e:Event=null):void
		{
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
			
			btnCreate.x = KidWriter.SCREEN_WIDTH - btnCreate.width - 40;
			btnCreate.y = KidWriter.SCREEN_HEIGHT - btnCreate.height - 40;
			addChild(btnCreate);
			
			btnCreate.addEventListener(MouseEvent.CLICK, createHandler);
			
		}
		
		private function createHandler(e:Event):void
		{
			dispatchEvent(new NavigationEvent(NavigationEvent.CREATE));
		}
		
		
		private function onClickBook(e:NavigationEvent):void
		{
			dispatchEvent(e);
		}
		
		public function showList():void
		{
			bookList = new BookList;
			addChild(bookList);
			
			bookList.addEventListener(NavigationEvent.SHOW, onClickBook);

		}
		
		public function removeList():void
		{
			bookList.removeEventListener(NavigationEvent.SHOW, onClickBook);
			
			removeChild(bookList);
			bookList = null;
		}
	}
}