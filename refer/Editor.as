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
//  File name : Editor.as
//  Author: 최진열(choi.jinyeol@nhn.com)
//  First created: Apr 17, 2015, 최진열(choi.jinyeol@nhn.com)
//  Last revised: Apr 17, 2015, 최진열(choi.jinyeol@nhn.com)
//  Version: v.1.0
//
////////////////////////////////////////////////////////////////////////////////


package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	/**
	 * 
	 * @author 최진열(choi.jinyeol@nhn.com)
	 */
	public class Editor extends Sprite
	{

		
		private var BTM_CANVAS_BG:Bitmap = new kid_writer.NOTE_CANVAS_BG as Bitmap;
		
		private var BTM_BUTTON_BACK:Bitmap = new kid_writer.NOTE_BUTTON_BACK() as Bitmap;
		private var BTM_BUTTON_CLEAR:Bitmap = new kid_writer.NOTE_BUTTON_CLEAR() as Bitmap;
		private var BTM_BUTTON_ERASER:Bitmap = new kid_writer.NOTE_BUTTON_ERASER() as Bitmap;
		private var BTM_BUTTON_PEN:Bitmap = new kid_writer.NOTE_BUTTON_PEN() as Bitmap;
		private var BTM_BUTTON_UNDO:Bitmap = new kid_writer.NOTE_BUTTON_UNDO() as Bitmap;
		private var BTM_ERASER_MASK:Bitmap = new kid_writer.NOTE_ERASER_MASK() as Bitmap;
		
		private var CANVAS_POINT:Point = new Point();
		private static var BUTTONS_Y:int = 10;
		
		private var _cachedDatas:Vector.<BitmapData> = new Vector.<BitmapData>();
		private static var _cacheMaxCount:int = 5;
		
		private var _drawSp:Sprite = new Sprite();
		
		private var _canvasSp:Sprite = new Sprite();
		private var _canvas:Bitmap =  new Bitmap();
		private var _canvasData:BitmapData;
		
		private var _bg:Sprite = new Sprite();
		private var _btnBack:Sprite = new Sprite();
		private var _btnPen:Sprite = new Sprite();
		private var _btnEraser:Sprite = new Sprite();
		private var _btnClear:Sprite = new Sprite();
		private var _btnUndo:Sprite = new Sprite();
		private var _btnMove:Sprite = new Sprite();
		private var _btnZoomOut:Sprite = new Sprite();
		private var _btnZoomIn:Sprite = new Sprite();
		
		private var _eraserMask:BitmapData;
		
		private var _isPen:Boolean = true;
		private var _pastPoint:Point = new Point();
		
		private var _text:TextField = new TextField;
		private var _textFormat:TextFormat = new TextFormat;
		
		
		/**
		 * Constructor
		 */
		public function Editor()
		{
			if(stage)
				init();
			else
				this.addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// canvas
			addChild(_canvasSp);
			BTM_CANVAS_BG.smoothing = true;
			_canvasSp.addChild(BTM_CANVAS_BG);
			
			_canvasSp.x = (stage.stageWidth - _canvasSp.width)/2;
			_canvasSp.y = 80;
			
			_resetCanvasData();
			_canvas = new Bitmap(_canvasData);
			_canvas.x = CANVAS_POINT.x;
			_canvas.y = CANVAS_POINT.y;
			
			_canvasSp.addChild(_canvas);
			
			_drawSp.x = _canvas.x;
			_drawSp.y = _canvas.y;

			
			// - back
			_btnBack.addChild(BTM_BUTTON_BACK);
			_btnBack.addEventListener(MouseEvent.CLICK, _onClickBack);
			_btnBack.x = 13;
			_btnBack.y = BUTTONS_Y;
			addChild(_btnBack);
			
			
			
			// - clear
			_btnClear.addChild(BTM_BUTTON_CLEAR);
			_btnClear.addEventListener(MouseEvent.CLICK, _onClickClear);
			_btnClear.x = 112;
			_btnClear.y = BUTTONS_Y;
			addChild(_btnClear);
			
			// - undo
			_btnUndo.addChild(BTM_BUTTON_UNDO);
			_btnUndo.addEventListener(MouseEvent.CLICK, _onClickUndo);
			_btnUndo.x = 214;
			_btnUndo.y = BUTTONS_Y;
			addChild(_btnUndo);
			
			
			// - pen
			_btnPen.addChild(BTM_BUTTON_PEN);
			_btnPen.addEventListener(MouseEvent.CLICK, _onClickPen);
			_btnPen.x = 617;
			_btnPen.y = BUTTONS_Y;
			addChild(_btnPen);
			
			// - eraser
			_btnEraser.addChild(BTM_BUTTON_ERASER);
			_btnEraser.addEventListener(MouseEvent.CLICK, _onClickEraser);
			_btnEraser.x = 704;
			_btnEraser.y = BUTTONS_Y;
			_btnEraser.alpha = .3;
			addChild(_btnEraser);
			
			
			_textFormat.size = 20;
			_text.defaultTextFormat = _textFormat;
//			_text.text = '안녕 안녕';
			_text.x = 150; 
			_text.y = 150; 
			_text.autoSize = TextFieldAutoSize.LEFT;
			addChild(_text);
			
			_checkUndoable();
			
			_eraserMask = new BitmapData(BTM_ERASER_MASK.width, BTM_ERASER_MASK.height, true, 0x0);
			_eraserMask.draw(BTM_ERASER_MASK);
			
//			_canvasSp.doubleClickEnabled = true;
			
			
			this.visible = false;
			
//			show();
			
		}
		
		
		public function setText(str:String):void
		{
			_text.text = str;
		}
		
		public function show():void 
		{
			this.visible = true;
			_canvasSp.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		}
		
		public function hide():void 
		{
			this.visible = false;
			_canvasSp.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			_canvasSp.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			_canvasSp.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		}
		
		private function _onClickBack(e:MouseEvent):void 
		{
			
		}
		
		private function _onClickPen(e:MouseEvent):void 
		{
			_isPen = true;
			
			_btnPen.alpha = 1;
			_btnMove.alpha = .3;
			_btnEraser.alpha = .3;
		}
		
		private function _onClickEraser(e:MouseEvent):void 
		{
			_isPen = false;
			
			_btnPen.alpha = .3;
			_btnMove.alpha = .3;
			_btnEraser.alpha = 1;
		}
		
		private function _onClickClear(e:MouseEvent):void 
		{
			_resetCanvasData();
		}
		
		private function _onClickUndo(e:MouseEvent):void
		{
			if (_cachedDatas.length > 0) 
			{
				_canvasData = _cachedDatas.pop();
				_canvas.bitmapData = _canvasData;
				_checkUndoable();
			}
		}
		
		//////////////////////////////////////////////////////////////////// 
		
		private function _onMouseDown(e:MouseEvent):void
		{
			_canvasSp.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			_canvasSp.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			
			_pastPoint.x = _canvasSp.mouseX;
			_pastPoint.y = _canvasSp.mouseY;
			
			if (_isPen) _resetDrawSp(_pastPoint);
			_cacheData();
			
		}
		
		private function _onMouseMove(e:MouseEvent):void
		{
			var x:Number;
			var y:Number;
			
			x = _canvasSp.mouseX;
			y = _canvasSp.mouseY;
			
			if (_isPen) {
				_drawSp.graphics.lineTo(x, y);
				_canvasData.draw(_drawSp);
				
				_pastPoint.x = x;
				_pastPoint.y = y;
				_resetDrawSp(_pastPoint);
				
			} else {
				var sx:Number = x - _eraserMask.width / 2;
				var sy:Number = y - _eraserMask.height / 2;
				
				var m:BitmapData = new BitmapData(_eraserMask.width, _eraserMask.height, true, 0x0);
				
				m.copyPixels(_canvasData, new Rectangle(sx, sy, _eraserMask.width, _eraserMask.height),
					new Point(),
					_eraserMask, new Point(), true);
				
				_canvasData.copyPixels(m, m.rect, new Point(sx, sy));
			}
		}
		
		private function _onMouseUp(e:MouseEvent):void
		{
			_canvasSp.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			_canvasSp.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		}
		
		//////////////////////////////////////////////////////////////////// 
		
		private function _resetCanvasData():void
		{
			_canvasData = new BitmapData(stage.width - CANVAS_POINT.x, stage.height - CANVAS_POINT.y, true, 0x0);
			_canvas.bitmapData = _canvasData;
		}
		
		private function _resetDrawSp(point:Point):void
		{
			_drawSp.graphics.clear();
			_drawSp.graphics.lineStyle(4, 0x0);
			_drawSp.graphics.moveTo(point.x, point.y);
		}
		
		private function _cacheData():void
		{
			_cachedDatas.push(_canvasData.clone());
			if (_cachedDatas.length > _cacheMaxCount) _cachedDatas.shift();
			_checkUndoable();
		}
		private function _checkUndoable():void
		{
			_btnUndo.alpha = _cachedDatas.length > 0 ? 1 : .3;
		}
		
		
		
	}
}