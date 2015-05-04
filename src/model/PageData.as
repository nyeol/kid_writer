////////////////////////////////////////////////////////////////////////////////
//
//  NHN Corp
//  Copyright NHN Corp.
//  All Rights Reserved.
//
//  이 문서는 NHN(주)의 지적 자산이므로 NHN(주)의 승인 없이 이 문서를	다른 용도로
//  임의 변경하여 사용할 수 없습니다. NHN(주)는 이 문서에 수록된 정보의 완전성과
//  정확성을 검증하기 위해 노력하였으나, 발생할 수 있는 내용상의 오류나 누락에
//  대해서는 책임지지 않습니다. 따라서 이 문서의 사용이나 사용결과에 따른 책임은
//  전적으로 사용자에게 있으며, NHN(주)는 이에 대해 명시적 혹은 묵시적으로 어떠한
//  보증도하지 않습니다. NHN(주)는 이 문서의 내용을 예고 없이 변경할 수 있습니다.
//
//  File name : PageData.as
//  Author: 최진열(choi.jinyeol@nhn.com)
//  First created: Apr 28, 2015, 최진열(choi.jinyeol@nhn.com)
//  Last revised: Apr 28, 2015, 최진열(choi.jinyeol@nhn.com)
//  Version: v.1.0
//
////////////////////////////////////////////////////////////////////////////////


package model
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author 최진열(choi.jinyeol@nhn.com)
	 */
	public class PageData
	{
		public var id:int;
		public var bgColor:uint;
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