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
//  File name : KidWriter.as
//  Author: 최진열(choi.jinyeol@nhn.com)
//  First created: Apr 28, 2015, 최진열(choi.jinyeol@nhn.com)
//  Last revised: Apr 28, 2015, 최진열(choi.jinyeol@nhn.com)
//  Version: v.1.0
//
////////////////////////////////////////////////////////////////////////////////


package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import editor.Editor;
	
	import home.Home;
	
	
	/**
	 * 
	 * @author 최진열(choi.jinyeol@nhn.com)
	 */
	[SWF(frameRate="60", width="1024", height="600", backgroundColor="#FFE566")]
	public class KidWriter extends Sprite
	{
		
		//---------------------------------------------------------------------
		//  
		//  Class ( Constants, Variables, Properties, Methods)
		//  
		//---------------------------------------------------------------------
		
		//---------------------------------------------------------------------
		//  
		//  Variables ( Constants, public, internal, private )
		//  
		//---------------------------------------------------------------------
		
		private var _curSceneName:String;
		private var _curScene:Sprite;
		
		private var _home:Home;
		private var _editor:Editor;
		
		
		/**
		 * Constructor
		 */
		public function KidWriter()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			
			
			init();
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
		private function init():void
		{
			chageScene(Scene.HOME);
			
		}
			
		private function chageScene(to:String):void
		{
			if(_curSceneName != to)
			{
				if(_curScene)
					removeChild(_curScene);
				
				switch(to)
				{
					case Scene.HOME:
					{
						_curScene = createHome();
						break;
					}
					case Scene.EDIT_LIST:
					{
						_curScene = createEditor();
						break;
					}
						
				}
				
				addChild(_curScene);
				_curSceneName = to;
			}
		}
			
		
		private function createHome():Home
		{
			if(!_home)
			{
				_home = new Home;
				_home.addEventListener(NavigationEvent.CREATE, onStartCreate);
			}
			return _home;
		}
		private function createEditor():Editor
		{
			if(!_editor)
			{
				_editor = new Editor;
				_editor.addEventListener(NavigationEvent.BACK, onBack);
			}
			return _editor;
		}
		
		
		private function startCreateBook():void
		{
			chageScene(Scene.EDIT_LIST);
		}
		
		//---------------------------------------------------------------------
		//  
		//  Handlers ( first Override )
		//  
		//---------------------------------------------------------------------
		
		private function onStartCreate(e:NavigationEvent):void
		{
			trace('create');
			startCreateBook();
		}
		
		private function onBack(e:NavigationEvent):void
		{
			trace('back');
			chageScene(Scene.HOME);
		}
		
	}
}