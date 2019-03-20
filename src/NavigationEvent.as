

package
{
	import flash.events.Event;
	
	public class NavigationEvent extends Event
	{
		public static const CREATE:String = 'create';
		public static const SHOW:String = 'show';
		public static const EDIT:String = 'edit';
		public static const BACK:String = 'back';

		public var bookIndex:int;
		public var pageIndex:int;
		public var editType:String;
		
		/**
		 * Constructor
		 */
		public function NavigationEvent(type:String, bookIndex:int=-1, pageIndex:int=-1,extra:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.bookIndex = bookIndex;
			this.pageIndex = pageIndex;
			
			if(type == EDIT && extra)
			{
				this.editType = String(extra);
			}
			
		}
		
		override public function clone():Event
		{
			return new NavigationEvent(this.type, this.bookIndex, this.pageIndex, this.editType, this.bubbles, this.cancelable);
		}
		
		
	}
}