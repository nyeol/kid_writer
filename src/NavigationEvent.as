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
//  File name : NavigationEvent.as
//  Author: 최진열(choi.jinyeol@nhn.com)
//  First created: Apr 30, 2015, 최진열(choi.jinyeol@nhn.com)
//  Last revised: Apr 30, 2015, 최진열(choi.jinyeol@nhn.com)
//  Version: v.1.0
//
////////////////////////////////////////////////////////////////////////////////


package
{
	import flash.events.Event;
	
	
	/**
	 * 
	 * @author 최진열(choi.jinyeol@nhn.com)
	 */
	public class NavigationEvent extends Event
	{
		public static const CREATE:String = 'create';
		public static const SHOW:String = 'show';
		public static const EDIT:String = 'edit';
		public static const BACK:String = 'back';

		public var targetIndex:int;
		public var editType:String;
		
		/**
		 * Constructor
		 */
		public function NavigationEvent(type:String, targetBookId:int=-1, extra:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.targetIndex = targetBookId;
			
			if(type == EDIT && extra)
			{
				this.editType = String(extra);
			}
			
		}
		
	}
}