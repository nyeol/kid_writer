

package editor
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	
	import common.BookView;
	
	import model.BooksManager;
	
	import org.libspark.betweenas3.BetweenAS3;
	
	public class EditorMain extends BookView
	{
		
		//---------------------------------------------------------------------
		//  
		//  Class ( Constants, Variables, Properties, Methods)
		//  
		//---------------------------------------------------------------------
		private const MODE_LIST:int = 1;
		private const MODE_EDIT:int = 2;
		//---------------------------------------------------------------------
		//  
		//  Variables ( Constants, public, internal, private )
		//  
		//---------------------------------------------------------------------
		private const _bg:Bitmap = new Bitmap(new BitmapData(1, 1, false, 0x73D2FF));
		
		private var btnBack:Sprite;
		private var _mode:int;
		
		private var _list:EditList;
		private var _editor:PageEditor;
		
		
		/**
		 * Constructor
		 */
		public function EditorMain()
		{
//			if(stage)
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
			
		}
		
		private function init():void
		{
			if(this.numChildren == 0)
			{
				addChild(_bg);
				_bg.width = KidWriter.SCREEN_WIDTH;
				_bg.height = KidWriter.SCREEN_HEIGHT;
				
				setupButton();
			}

		}
		
		public function showEdit():void
		{
			changeMode(MODE_EDIT);
		}
		
		public function showList():void
		{
			BetweenAS3.tween(_bg, {alpha:1}, {alpha:0}, .4).play();
			changeMode(MODE_LIST);
		}
		
		private function changeMode(to:int, index:int=0, editType:String=null):void
		{
			if(_mode != to)
			{
				switch(to)
				{
					case MODE_LIST:
					{
						btnBack.visible = true;
						
						if(!_list)
						{
							_list = new EditList;
							_list.addEventListener(NavigationEvent.EDIT, onEdit);
						}
						_list.setup(bookData, bookIndex, pageIndex);
						addChild(_list);

						if(_editor && _editor.parent == this)
						{
							removeChild(_editor);
						}
						
						break;
					}
						
					case MODE_EDIT:
					{
						btnBack.visible = false;
						if(_list && _list.parent == this)
						{
							removeChild(_list);
						}
						
						if(!_editor)
						{
							_editor = new PageEditor;
							_editor.addEventListener(NavigationEvent.BACK, onCompleteEdit);
						}
						_editor.setup(bookData.pages[index], editType);
						addChild(_editor);
						
						break;
					}
				}
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
//			
			btnBack.addEventListener(MouseEvent.CLICK, onClose);
		}
		

		private function onEdit(e:NavigationEvent):void
		{
			changeMode(MODE_EDIT, e.pageIndex, e.editType);
		}
		
		private function onCompleteEdit(e:NavigationEvent):void
		{
			BooksManager.instance.saveBook(bookData);
			BooksManager.instance.saveBookList();
			
			changeMode(MODE_LIST);
		}
		
		private function onClose(e:Event):void
		{
			dispatchEvent(new NavigationEvent(NavigationEvent.BACK));
		}
		
		
	}
}