
package common
{
	import flash.display.Sprite;
	
	import model.BookData;
	
	
	public class BookView extends Sprite
	{
		
		//---------------------------------------------------------------------
		//  
		//  Variables ( Constants, public, internal, private )
		//  
		//---------------------------------------------------------------------
		
		private var _bookData:BookData;
		private var _bookIndex:int;
		private var _pageIndex:int;
		
		/**
		 * Constructor
		 */
		public function BookView()
		{
		}
		
		
		
		public function get bookData():BookData
		{
			return _bookData;
		}
		public function get bookIndex():int
		{
			return _bookIndex;
		}
		public function get pageIndex():int
		{
			return _pageIndex;
		}
		
		public function setup(bookData:BookData, index:int, pageIndex:int=0):void
		{
			_bookData = bookData;
			_bookIndex = index;
			_pageIndex = pageIndex;
		}
		
	}
}