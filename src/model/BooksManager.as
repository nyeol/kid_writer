

package model
{
	import com.laiyonghao.Uuid;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import editor.CanvasView;
	
	public class BooksManager
	{
		
		//---------------------------------------------------------------------
		//  
		//  Class ( Constants, Variables, Properties, Methods)
		//  
		//---------------------------------------------------------------------
		private static var _instance:BooksManager;
		public static function get instance():BooksManager
		{
			if (!Boolean(_instance)) 
				_instance = new BooksManager;
			return _instance;
		}
		//---------------------------------------------------------------------
		//  
		//  Variables ( Constants, public, internal, private )
		//  
		//---------------------------------------------------------------------
		
		private var _books:Vector.<BookData> = new Vector.<BookData>;
		private var _needSaveList:Boolean;
		
		/**
		 * Constructor
		 */
		public function BooksManager()
		{
		}
		
		public function get bookCount():int
		{
			return _books.length;
		}
		
		public function getBookByIndex(index:int):BookData
		{
			return _books[index];
		}

		public function searchIndex(book:BookData):int
		{
			return _books.indexOf(book);
		}
		
		public function addBook(book:BookData):void
		{
			_books.push(book);
			
			_needSaveList = true;
		}

		
		public function makeNewBook():BookData
		{
			var book:BookData = new BookData(new Uuid().toString());
			return book;
		}
		
		
		private const booklistfile:String = 'kidWriterBookList.db';
		private const bookfileprefix:String = 'books/kidWriterBook_';
		
		public function loadBookList():void
		{
			trace("BooksManager.loadBookList > " );
			
			_books = new Vector.<BookData>;
			
			var inData:Object = readFileIntoByteArray(booklistfile);
			var bookList:BookListDB = new BookListDB;
			setIn(inData, bookList);
			
			if(bookList.bookDataPath)
			{
				var count:int = bookList.bookDataPath.length;
				for (var i:int = 0; i < count; i++) 
				{
					if(bookList.bookDataPath[i])
					{
						var bookRaw:Object = readFileIntoByteArray(bookfileprefix + bookList.bookDataPath[i] + '.db');
						if(bookRaw)
						{
							var pagesRaw:Array = bookRaw['pages'];
							var pagesCount:int = pagesRaw.length;
							var pages:Vector.<PageData> = new Vector.<PageData>;
							for (var j:int = 0; j < pagesCount; j++) 
							{
								var page:PageData = new PageData;
								page.image = new BitmapData(CanvasView.W, CanvasView.H, true, 0);
								setIn(pagesRaw[j], page);
								
								pages.push(page);
							}
							
							var book:BookData = new BookData(bookRaw['uid'], pages);
							_books.push(book);
						}
					}
				}
			}
		}
		
		private function setIn(from:Object, to:Object):void
		{
			for (var prop:String in from)
			{
				if(prop == 'image' && from[prop])
				{
					from[prop].uncompress();
					to[prop].setPixels(to[prop].rect, from[prop]);
				} else {
					to[prop] = from[prop];
				}
			}
		}
		
		private function readFileIntoByteArray(fileName:String):Object 
		{ 
			var bytes:ByteArray = new ByteArray;
			var inFile:File = File.applicationStorageDirectory;//desktopDirectory; 
			inFile = inFile.resolvePath(fileName);  // name of file to read 
			var inStream:FileStream = new FileStream(); 
			
			try
			{
				inStream.open(inFile, FileMode.READ);
				inStream.readBytes(bytes); 
				inStream.close(); 
				
				bytes.position = 0;
				bytes.uncompress();
				bytes.position = 0;
				return bytes.readObject();
			} 
			catch(error:Error) 
			{
				trace(error);
			}
			return null;
		}
		
		
		public function saveBookList():void
		{
			if(_needSaveList)
			{
				var data:BookListDB = new BookListDB;
				var count:int = _books.length;
				
				for (var i:int = 0; i < count; i++) 
				{
					data.bookDataPath.push(_books[i].uid);
				}
				writeBytesToFile(booklistfile, data);
			}
			_needSaveList = false;
		}
		
		public function saveAllBooks():void
		{
			for each (var book:BookData in _books) 
			{
				saveBook(book);
			}
		}
		
		public function saveBook(book:BookData):void
		{
			var bookdb:BookDB = new BookDB;
			bookdb.uid = book.uid;
			
			var count:int = book.count;
			for (var i:int = 0; i < count; i++) 
			{
				var page:PageData = book.pages[i];
				var pagedb:PageDB = new PageDB;
				pagedb.bgColor = page.bgColor;
				if(page.image)
				{
					pagedb.image = page.image.getPixels(page.image.rect);
					pagedb.image.compress();
				}				
				bookdb.pages.push(pagedb);
			}
			
			writeBytesToFile(bookfileprefix + book.uid + '.db', bookdb);
		}
		
		private function writeBytesToFile(fileName:String, data:Object):void 
		{ 
			var bytes:ByteArray = new ByteArray;
			bytes.writeObject(data);
			bytes.compress();
			
			var outFile:File = File.applicationStorageDirectory;//desktopDirectory;
			outFile = outFile.resolvePath(fileName);  // name of file to write 
			var outStream:FileStream = new FileStream(); 
			outStream.open(outFile, FileMode.WRITE); 
			outStream.writeBytes(bytes, 0, bytes.length); 
			outStream.close(); 
		} 
		
	}
}

import flash.utils.ByteArray;

class BookListDB
{
	public var bookDataPath:Array = [];
}

class PageDB
{
	public var bgColor:uint;
	public var image:ByteArray;
}

class BookDB
{
	public var uid:String;
	public var pages:Array=[];
}
