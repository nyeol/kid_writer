

package
{
	import flash.desktop.NativeApplication;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import editor.EditorMain;
	
	import home.Home;
	
	import model.BookData;
	import model.BooksManager;
	
	import viewer.Viewer;
	
	
	[SWF(frameRate="60", width="1024", height="600", backgroundColor="#FFE566")]
	public class KidWriter extends Sprite
	{
		
		//---------------------------------------------------------------------
		//  
		//  Class ( Constants, Variables, Properties, Methods)
		//  
		//---------------------------------------------------------------------
		public static var SCREEN_WIDTH:Number;
		public static var SCREEN_HEIGHT:Number;
		//---------------------------------------------------------------------
		//  
		//  Variables ( Constants, public, internal, private )
		//  
		//---------------------------------------------------------------------
		
		private var _curSceneName:String;
		private var _curScene:Sprite;
		
		private var _home:Home;
		private var _editor:EditorMain;
		private var _viewer:Viewer;
		
		
		/**
		 * Constructor
		 */
		public function KidWriter()
		{
			super();
//			stage.scaleMode = StageScaleMode.NO_SCALE;
//			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true)
			
//			var minBound:Number = Math.min( Screen.mainScreen.visibleBounds.width, Screen.mainScreen.visibleBounds.height );  
//			var maxBound:Number = Math.max( Screen.mainScreen.visibleBounds.width, Screen.mainScreen.visibleBounds.height );
//			if (stage.fullScreenWidth > stage.fullScreenHeight) {  
//				// Landscape  
//				SCREEN_WIDTH = Math.min( stage.fullScreenWidth, maxBound );
//				SCREEN_HEIGHT = Math.min( stage.fullScreenHeight, minBound );
//			}else{
//				// Portrait  
//				SCREEN_WIDTH = Math.min( stage.fullScreenWidth, minBound );  
//				SCREEN_HEIGHT = Math.min( stage.fullScreenHeight, maxBound );  
//			}
			
//			SCREEN_WIDTH = stage.fullScreenWidth;
//			SCREEN_HEIGHT = stage.fullScreenHeight;
			SCREEN_WIDTH = stage.stageWidth;
			SCREEN_HEIGHT = stage.stageHeight;
			
//			trace('screen size W :', stage.fullScreenWidth, stage.stageWidth);
//			trace('screen size H :', stage.fullScreenHeight, stage.stageHeight);
			
			
			init();
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
		private function init():void
		{
			chageScene(Scene.HOME);
		}
			
		private function chageScene(to:String, bookIndex:int=0, pageIndex:int=0):void
		{
			if(_curSceneName != to)
			{
				if(_curScene)
					removeChild(_curScene);
				
				switch(to)
				{
					case Scene.HOME:
					{
						_curScene = createHome();
						break;
					}
					case Scene.EDIT:
					{
						_curScene = createEditor(bookIndex, pageIndex);
						EditorMain(_curScene).showEdit();
						break;
					}
					case Scene.EDIT_LIST:
					{
						_curScene = createEditor(bookIndex, pageIndex);
						EditorMain(_curScene).showList();
						break;
					}
					case Scene.VIEWER:
					{
						_curScene = createViewer(bookIndex, pageIndex);
						break;
					}
				}
				
				addChild(_curScene);
				_curSceneName = to;
			}
		}
			
		
		private function createHome():Home
		{
			if(!_home)
			{
				_home = new Home;
				_home.addEventListener(NavigationEvent.CREATE, onStartCreate);
				_home.addEventListener(NavigationEvent.SHOW, onShow);
				
				BooksManager.instance.loadBookList();
			}
			trace('bookCount',BooksManager.instance.bookCount);
			return _home;
		}
		
		private function createEditor(bookIndex:int, pageIndex:int):EditorMain
		{
			if(!_editor)
			{
				_editor = new EditorMain;
				_editor.addEventListener(NavigationEvent.BACK, onBack);
			}
			
			_editor.setup(BooksManager.instance.getBookByIndex(bookIndex), bookIndex, pageIndex);
			return _editor;
		}
		
		private function createViewer(bookIndex:int, pageIndex:int):Viewer
		{
			if(!_viewer)
			{
				_viewer = new Viewer;
				_viewer.addEventListener(NavigationEvent.BACK, onBack);
				_viewer.addEventListener(NavigationEvent.EDIT, onEdit);
			}
			
			_viewer.setup(BooksManager.instance.getBookByIndex(bookIndex), bookIndex, pageIndex);
			return _viewer;
		}
		
		
		
		
		
		private function startCreateBook():void
		{
			var book:BookData = BooksManager.instance.makeNewBook();
			BooksManager.instance.addBook(book);
			
			chageScene(Scene.EDIT_LIST, BooksManager.instance.bookCount-1);
		}
		
		
		private function exit():void 
		{
			NativeApplication.nativeApplication.exit();
		}

		//---------------------------------------------------------------------
		//  
		//  Handlers ( first Override )
		//  
		//---------------------------------------------------------------------
		
		private function onStartCreate(e:NavigationEvent):void
		{
			trace('create');
			startCreateBook();
		}
		
		private function onEdit(e:NavigationEvent):void
		{
			trace('edit', e.bookIndex);
//			chageScene(Scene.EDIT, e.bookIndex, e.pageIndex);
			chageScene(Scene.EDIT_LIST, e.bookIndex, e.pageIndex);
		}
		
		private function onShow(e:NavigationEvent):void
		{
			trace('show', e.bookIndex);
			chageScene(Scene.VIEWER, e.bookIndex, e.pageIndex);
		}
		
		private function onBack(e:NavigationEvent):void
		{
			trace('back');
			chageScene(Scene.HOME);
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			if( event.keyCode == Keyboard.BACK )
			{
				event.preventDefault();
				event.stopImmediatePropagation();
				trace('back key pressed');
				
				if(_curSceneName == Scene.HOME)
					exit();
				
			}
		}
		
	}
}