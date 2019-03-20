

package editor
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class CanvasView extends Sprite
	{
		public static const W:Number = 919;
		public static const H:Number = 581;
		
		public var bg:Bitmap;
		public var canvas:Bitmap;
		
		/**
		 * Constructor
		 */
		public function CanvasView(canvasData:BitmapData, bgData:BitmapData)
		{
			bg = new Bitmap(bgData);
			canvas = new Bitmap(canvasData);
			canvas.smoothing = true;
			
			bg.width = canvas.width;
			bg.height = canvas.height;
			
			addChild(bg);
			addChild(canvas);
		}
		
		public function get canvasData():BitmapData
		{
			return canvas.bitmapData;
		}
		public function set canvasData(data:BitmapData):void
		{
			canvas.bitmapData = data;
		}
		
		
	}
}