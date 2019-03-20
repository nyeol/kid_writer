
package viewer
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	
	import editor.CanvasView;
	
	import model.PageData;
	
	
	public class ViewerPage extends Sprite
	{
		
		//---------------------------------------------------------------------
		//  
		//  Class ( Constants, Variables, Properties, Methods)
		//  
		//---------------------------------------------------------------------
		private static var CANVAS_WIDTH:int = 875;

		//---------------------------------------------------------------------
		//  
		//  Variables ( Constants, public, internal, private )
		//  
		//---------------------------------------------------------------------
		private var _canvas:CanvasView;
		
		/**
		 * Constructor
		 */
		public function ViewerPage()
		{
			super();
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
		public function clear():void
		{
			if(_canvas)
			{
				removeChild(_canvas);
				_canvas = null;
			}
		}

		public function update(pageData:PageData=null):void
		{
			clear();
			
			if(pageData && pageData.image)
			{
				_canvas = new CanvasView(pageData.image, new BitmapData(1,1,false,pageData.bgColor));
				_canvas.width = CANVAS_WIDTH;
				_canvas.scaleY = _canvas.scaleX;
				
				_canvas.blendMode = BlendMode.MULTIPLY;
				
				addChild(_canvas);
			}
		}

		
	}
}