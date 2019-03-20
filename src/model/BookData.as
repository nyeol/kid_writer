

package model
{
	public class BookData
	{
		public var uid:String;
		public var pages:Vector.<PageData>;
		
		/**
		 * Constructor
		 */
		public function BookData(uid:String, pages:Vector.<PageData>=null)
		{
			this.uid = uid;
			
			if(pages)
			{
				this.pages = pages;				
			} 
			else 
			{
				this.pages = new Vector.<PageData>(2);
				var count:int = this.pages.length;
				for (var i:int = 0; i < count; i++) 
				{
					this.pages[i] = new PageData(i);
				}
				
			}
		}
		
		public function get count():int
		{
			return pages.length;
		}
		
		public function addPage(at:int):PageData
		{
			var page:PageData = new PageData();
			pages.splice(at, 0, page);
			return page;
		}
		
		public function removePage(at:int):void
		{
			pages.splice(at, 1);
		}
		
	}
}