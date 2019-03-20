
package editor
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import model.PageData;
	
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Back;
	
	
	public class PageEditor extends Sprite
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
		private const _bg:Bitmap = new Bitmap(new BitmapData(1, 1, false, 0x738BFF));

		private var _pageContaer:Sprite = new Sprite;
		private const _pageBg:Bitmap = new Assets.bg_edit as Bitmap;
		
		private var _canvas:CanvasView;
		
		private var _mode:String;
		
		private var btnOk:Sprite;
		private var _drawer:Drawer;
		private var _recorder:Recorder;
		
		
		private var _pageData:PageData;
		
		/**
		 * Constructor
		 */
		public function PageEditor()
		{
			if(stage)
				onAddToStage();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedToStage);
		}
		
		private function onAddToStage(e:Event=null):void
		{
			init();
			setupButton();
			show();
		}
		
		private function onRemovedToStage(e:Event=null):void
		{
			removeCanvas();
		}

		
		private function init():void
		{
			if(this.numChildren==0)
			{
				addChild(_bg);
				_bg.width = KidWriter.SCREEN_WIDTH;
				_bg.height = KidWriter.SCREEN_HEIGHT;
				
				_pageBg.scaleX = _pageBg.scaleY = 1.26;
				_pageBg.x = -8;
				_pageBg.y = -5;
				_pageContaer.addChild(_pageBg);
				
				addChild(_pageContaer);
			}
			
			
			var canvas:BitmapData;
			var bgColor:uint;
			
			if(_pageData && _pageData.image)
			{
				canvas = _pageData.image;
				bgColor = _pageData.bgColor;
			}
			else 
			{
				canvas = new BitmapData(CanvasView.W, CanvasView.H, true, 0x0);
				bgColor = 0xffffff;
			}
			_canvas = new CanvasView(canvas, new BitmapData(1,1,false, bgColor));
			_canvas.x = 12;
			_canvas.y = 11;
			_pageContaer.addChild(_canvas);
			
			
			if(!_drawer)
			{
				_drawer = new Drawer;
				_drawer.addEventListener(Event.OPEN, function(e:Event):void{
					changeMode(EditType.DRAW);
				});
				addChild(_drawer);
				
				_recorder = new Recorder;
				_recorder.addEventListener(Event.OPEN, function(e:Event):void{
					changeMode(EditType.RECORD);
				});
				addChild(_recorder);
			}
			_drawer.init(_canvas);
			
		}
		
		private function removeCanvas():void
		{
			_pageContaer.removeChild(_canvas);
			_canvas = null;
		}
		
		public function setup(pageData:PageData, editType:String):void
		{
			_pageData = pageData;
			_mode = editType ? editType : EditType.DRAW;
		}
			
		
		private function show():void
		{
			BetweenAS3.tween(_bg, {alpha:1}, {alpha:0}, .4).play();
			
			BetweenAS3.tween(_pageContaer, 
				{x:0, y:0, scaleX:1, scaleY:1}, 
				{x:EditList.startX * 1.26, y:EditList.startY * 1.26, scaleX:.74, scaleY:.74},
				.4, Back.easeOut).play();
		
			
			changeMode(_mode, true);
		}
		
		private function changeMode(to:String, isFirst:Boolean=false):void
		{
			if(isFirst || _mode != to)
			{
				switch(to)
				{
					case EditType.DRAW:
					{
						_drawer.open();
						_recorder.close();
						
						_recorder.y = _drawer.height + 10;
						
						break;
					}
						
					case EditType.RECORD:
					{
						_drawer.close();
						_recorder.open();
						
						_recorder.y = _drawer.height + 10;
						
						break;
					}
				}
				
				_mode = to;
			}
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
		private function setupButton():void
		{
			if(!btnOk)
			{
				btnOk = new Sprite;
				btnOk.addChild(new Assets.bt_ok as Bitmap);
				btnOk.x = KidWriter.SCREEN_WIDTH - btnOk.width - 15;
				btnOk.y = KidWriter.SCREEN_HEIGHT - btnOk.height - 10;
				addChild(btnOk);
				btnOk.addEventListener(MouseEvent.CLICK, onClose);
			}			
		}
		
		private function onClose(e:Event):void
		{
			_pageData.image = _canvas.canvasData;
			
			dispatchEvent(new NavigationEvent(NavigationEvent.BACK));
		}

		
		
	}
}