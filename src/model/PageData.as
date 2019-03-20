
package model
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	

	public class PageData
	{
		public var id:int;
		public var bgColor:uint = 0xffffff;
		private var _image:BitmapData;
		private var _sound:ByteArray;
		
		public function PageData(id:int=0)
		{
			this.id = id;
		}
		
		public function get sound():ByteArray
		{
			return _sound;
		}

		public function set sound(value:ByteArray):void
		{
			_sound = value;
		}

		public function get image():BitmapData
		{
			return _image;
		}

		public function set image(value:BitmapData):void
		{
			_image = value;
		}

	}
}