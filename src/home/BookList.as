
package home
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import model.BookData;
	import model.BooksManager;
	
	
	public class BookList extends Sprite
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
		
		private var bookCovers:Vector.<Cover>;
		
		/**
		 * Constructor
		 */
		public function BookList()
		{
			addBook();
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
		
		public function addBook():void
		{
			bookCovers = new Vector.<Cover>;
			
			var count:int = BooksManager.instance.bookCount;
			for (var i:int = 0; i < count; i++) 
			{
				var cover:Cover = new Cover(BooksManager.instance.getBookByIndex(i));
				cover.index = i;
				cover.x = cover.width * i + 30;
				cover.y = 30;
				addChild(cover);
				cover.addEventListener(MouseEvent.CLICK, onClick);
				
				bookCovers.push(cover);
			}
			
		}
		
		private function onClick(e:MouseEvent):void
		{
//			var book:BookData = Cover(e.target).book;
			dispatchEvent(new NavigationEvent(NavigationEvent.SHOW, Cover(e.target).index));
		}
	}
}
import flash.display.Bitmap;
import flash.display.Sprite;

import model.BookData;

class Cover extends Sprite
{
	public var index:uint;
	public var book:BookData;
	
	public function Cover(book:BookData)
	{
		var bg:Bitmap = new Assets.bg_main_book() as Bitmap;
		addChild(bg);
		
		this.book = book;
		var img:Bitmap = new Bitmap(book.pages[0].image);
		img.width = bg.width;
		img.height = bg.height;
		addChild(img);
	}
}