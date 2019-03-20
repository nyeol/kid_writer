
package editor
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	import model.PageData;
	
	
	public class EditListItem extends Sprite
	{
		
		//---------------------------------------------------------------------
		//  
		//  Class ( Constants, Variables, Properties, Methods)
		//  
		//---------------------------------------------------------------------
		public static const WIDTH:int = 761;
		private static var CANVAS_WIDTH:int = 761 - 16*2;
		
		//---------------------------------------------------------------------
		//  
		//  Variables ( Constants, public, internal, private )
		//  
		//---------------------------------------------------------------------
		private const _bg:Bitmap = new Assets.bg_edit as Bitmap;
		
		private var pageTf:TextField = new TextField;
		
		private var _index:int = -1;
		
		private var _canvasContainer:Sprite = new Sprite;
		private var _canvas:CanvasView;
		
		/**
		 * Constructor
		 */
		public function EditListItem()
		{
			if(stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedStage);
		}
		

		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addChild(_bg);
			addChild(_canvasContainer);
			addChild(pageTf);
			
//			_canvasContainer
			pageTf.x = pageTf.y = 30;
			
			_canvasContainer.x = 16;
			_canvasContainer.y = 13;
//			_canvasContainer.alpha = .5;
		}
		
		private function onRemovedStage(e:Event):void
		{
			clear();
		}
		
		//---------------------------------------------------------------------
		//  
		//  Properties ( first Override )
		//  
		//---------------------------------------------------------------------
		public function get index():int
		{
			return _index;
		}
		
		//---------------------------------------------------------------------
		//  
		//  Methods ( first Override )
		//  
		//---------------------------------------------------------------------
		
		public function clear():void
		{
			_index = -1;
			if(_canvas)
			{
				_canvasContainer.removeChild(_canvas);
				_canvas = null;
			}
		}
		
		public function update(index:int=-1, pageData:PageData=null):void
		{
			clear();
			
			pageTf.text = '' + index;
			_index = index;
			
			if(pageData && pageData.image)
			{
				_canvas = new CanvasView(pageData.image, new BitmapData(1,1,false,pageData.bgColor));
				_canvas.width = CANVAS_WIDTH;
				_canvas.scaleY = _canvas.scaleX;
				
				_canvasContainer.addChild(_canvas);
			}
		}

	}
}
