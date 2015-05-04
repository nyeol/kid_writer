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
//  File name : Drawer.as
//  Author: 최진열(choi.jinyeol@nhn.com)
//  First created: Apr 28, 2015, 최진열(choi.jinyeol@nhn.com)
//  Last revised: Apr 28, 2015, 최진열(choi.jinyeol@nhn.com)
//  Version: v.1.0
//
////////////////////////////////////////////////////////////////////////////////


package editor
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	/**
	 * 
	 * @author 최진열(choi.jinyeol@nhn.com)
	 */
	public class Drawer extends Sprite
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
		private var _canvas:CanvasView;
		private var _drawTarget:Sprite = new Sprite;
		
		private var _btnOpen:Sprite;
		
		private var _tools:Sprite;
		private var _btnPen:Sprite = new Sprite;
		private var _btnEraser:Sprite = new Sprite;
		private var _btnUndo:Sprite = new Sprite;
		
		
		private var _isPen:Boolean;
		
		private static const ERASER_MASK:Bitmap = new Assets.eraser_mask as Bitmap;
		private var _eraserMask:BitmapData; 
		
		private var _cachedDatas:Vector.<BitmapData>;
		private static var _cacheMaxCount:int = 5;
		
		/**
		 * Constructor
		 */
		public function Drawer()
		{
			_eraserMask = new BitmapData(ERASER_MASK.width, ERASER_MASK.height, true, 0x0);
			_eraserMask.draw(ERASER_MASK);

			
			if(stage)
				onAddToStage();
			else
				this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
		}
		
		private function onAddToStage(e:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			open();
		}
		
		public function init(canvas:CanvasView):void
		{
			_canvas = canvas;
			_cachedDatas = new Vector.<BitmapData>();
		}
		
		public function enable():void
		{
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		public function disable():void
		{
			_canvas.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function open():void
		{
			setupButtons(true);
			enable();
		}
		
		public function close():void
		{
			setupButtons(false);
			disable();
		}
		
		private function setupButtons(isOpen:Boolean):void
		{
			if(isOpen)
			{
				if(!_tools)
				{
					_tools = new Sprite;
					_tools.addChild(new Assets.bg_tool_big as Bitmap);
					_tools.x = stage.stageWidth - _tools.width;
					_tools.y = 10;
					addChild(_tools);

					// - undo
					_btnUndo.addChild(new Assets.bt_undo as Bitmap);
					_btnUndo.addEventListener(MouseEvent.CLICK, function(e:Event):void{
						if (_cachedDatas.length > 0) 
						{
							_canvas.canvasData = _cachedDatas.pop();
							_checkUndoable();
						}

					});
					_btnUndo.x = 10;
					_btnUndo.y = 10;
					_tools.addChild(_btnUndo);
					
					
					// - pen
					_btnPen.addChild(new Assets.bt_pencil as Bitmap);
					_btnPen.addEventListener(MouseEvent.CLICK, function(e:Event):void{
						setupPenMode(true);
					});
					_btnPen.x = 10;
					_btnPen.y = 100;
					_tools.addChild(_btnPen);
					
					// - eraser
					_btnEraser.addChild(new Assets.bt_eraser as Bitmap);
					_btnEraser.addEventListener(MouseEvent.CLICK, function(e:Event):void{
						setupPenMode(false);
					});
					
					_btnEraser.x = 10;
					_btnEraser.y = 200;
					_btnEraser.alpha = .3;
					_tools.addChild(_btnEraser);
				}
				
				_tools.visible = true;
				setupPenMode(true);
				
			} else {
				if(_tools)
					_tools.visible = false;
				
				if(!_btnOpen)
				{
					_btnOpen = new Sprite;
					_btnOpen.addChild(new Assets.bg_tool_small as Bitmap);
					var pen:Bitmap = new Assets.bt_pencil as Bitmap;
					pen.x = 10;
					pen.y = 10;
					_btnOpen.addChild(pen);
					
					_btnOpen.x = stage.stageWidth - 200;
					_btnOpen.y = 0;
					addChild(_btnOpen);
					
					_btnOpen.addEventListener(MouseEvent.CLICK, function(e:Event):void
					{
						open();
					});
				}
				_btnOpen.visible = true;
				
			}
		}
		
		
		private function setupPenMode(isPen:Boolean=true):void
		{
			_isPen = isPen;
			
			if(_isPen)
			{
				_btnPen.alpha = 1;
				_btnEraser.alpha = .5;
			}
			else
			{
				_btnPen.alpha = .5;
				_btnEraser.alpha = 1;
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

		private function isIn(x:Number, y:Number):Boolean
		{
			if(x < 0 || y < 0 || x > _canvas.width || y > _canvas.height)
				return false;
			return true;
		}
		
		private var _pastPoint:Point = new Point;
		
		private function onMouseDown(e:MouseEvent):void
		{
//			if(isIn(e.localX, e.localY))
			{
				_canvas.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				
				_pastPoint.x = e.localX;
				_pastPoint.y = e.localY;
				
				if (_isPen) _resetDrawSp(_pastPoint);
				_cacheData();
			}
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			var x:Number;
			var y:Number;
			
			x = e.localX;
			y = e.localY;
			
			if (_isPen) {
				_drawTarget.graphics.lineTo(x, y);
				_canvas.canvasData.draw(_drawTarget);
				
				_pastPoint.x = x;
				_pastPoint.y = y;
				_resetDrawSp(_pastPoint);
				
			} else {
				var sx:Number = x - _eraserMask.width / 2;
				var sy:Number = y - _eraserMask.height / 2;
				
				var m:BitmapData = new BitmapData(_eraserMask.width, _eraserMask.height, true, 0x0);
				
				m.copyPixels(_canvas.canvasData, new Rectangle(sx, sy, _eraserMask.width, _eraserMask.height),
					new Point(),
					_eraserMask, new Point(), true);
				
				_canvas.canvasData.copyPixels(m, m.rect, new Point(sx, sy));
			}			
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		//////////////////////////////////////////////////////////////////// 
		
		private function _resetCanvasData():void
		{
			_canvas.canvasData = new BitmapData(CanvasView.W, CanvasView.H, true, 0x0);
		}
		
		private function _resetDrawSp(point:Point):void
		{
			_drawTarget.graphics.clear();
			_drawTarget.graphics.lineStyle(4, 0x0);
			_drawTarget.graphics.moveTo(point.x, point.y);
		}
		
		private function _cacheData():void
		{
			_cachedDatas.push(_canvas.canvasData.clone());
			if (_cachedDatas.length > _cacheMaxCount) _cachedDatas.shift();
			_checkUndoable();
		}
		private function _checkUndoable():void
		{
			_btnUndo.alpha = _cachedDatas.length > 0 ? 1 : .3;
		}

	}
}