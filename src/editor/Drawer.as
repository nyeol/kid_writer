

package editor
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
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
					_tools.x = KidWriter.SCREEN_WIDTH - _tools.width;
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
				else 
				{
					addChild(_tools);
				}
				setupPenMode(true);
				
				if(_btnOpen && _btnOpen.parent)
					removeChild(_btnOpen);
				
			} else {
				
				if(!_btnOpen)
				{
					_btnOpen = new Sprite;
					_btnOpen.addChild(new Assets.bg_tool_small as Bitmap);
					_btnOpen.x = KidWriter.SCREEN_WIDTH - _btnOpen.width;
					_btnOpen.y = 10;
					addChild(_btnOpen);
					
					var pen:Bitmap = new Assets.bt_pencil as Bitmap;
					pen.x = 10;
					pen.y = 10;
					_btnOpen.addChild(pen);
					
					_btnOpen.addEventListener(MouseEvent.CLICK, function(e:Event):void
					{
						dispatchEvent(new Event(Event.OPEN));
					});
				} 
				else 
				{
					addChild(_btnOpen);
				}

				if(_tools && _tools.parent)
					removeChild(_tools);
				
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
		
		private var curPath:LinePath;
		
		private function onMouseDown(e:MouseEvent):void
		{
//			if(isIn(e.localX, e.localY))
			{
				_canvas.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				
				curPath = new LinePath(e.localX, e.localY);
				
				_cacheData();
			}
			
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			var x:Number = e.localX;
			var y:Number = e.localY;
			
			if (_isPen) {
				
				_draw(_drawTarget.graphics, x, y);
				_canvas.canvasData.draw(_drawTarget);
				
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
			if (_isPen) 
			{
				_drawEnd(_drawTarget.graphics, e.localX, e.localY, .8);
				_canvas.canvasData.draw(_drawTarget);
			}			
			
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		//////////////////////////////////////////////////////////////////// 
		
		private function _resetCanvasData():void
		{
			_canvas.canvasData = new BitmapData(CanvasView.W, CanvasView.H, true, 0x0);
		}
		
		private var lineColor:uint = 0x444444;
		private var lineAlpha:Number = .4;
		
		private function _draw(dg:Graphics, x:Number, y:Number, smoothFacter:Number = .4):void
		{
			var cx:Number = curPath.x + (x - curPath.x) * smoothFacter;
			var cy:Number = curPath.y + (y - curPath.y) * smoothFacter;
			
			var path:LinePath = new LinePath(cx, cy, curPath);
			
			dg.clear();
			dg.beginFill(lineColor, lineAlpha);
			
			dg.moveTo(path.path[0].x, path.path[0].y);
			dg.lineTo(path.path[1].x, path.path[1].y);
			dg.lineTo(path.path[2].x, path.path[2].y);
			dg.lineTo(path.path[3].x, path.path[3].y);
			
			dg.endFill();
			curPath = path;
		}
		
		private function _drawEnd(dg:Graphics, x:Number, y:Number, smoothFacter:Number = .4):void
		{
			var cx:Number = curPath.x + (x - curPath.x) * smoothFacter;
			var cy:Number = curPath.y + (y - curPath.y) * smoothFacter;
			
			var path:LinePath = new LinePath(cx, cy, curPath);
			
			dg.clear();
			dg.beginFill(lineColor, lineAlpha);
			
			dg.moveTo(path.path[0].x, path.path[0].y);
			dg.cubicCurveTo(
				path.path[1].x, path.path[1].y, 
				path.path[2].x, path.path[2].y,
				path.path[3].x, path.path[3].y
			);
			
			dg.endFill();
			curPath = path;
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


import flash.geom.Point;

class LinePath extends Point
{
	public var angle:Number;
	public var thickness:Number;
	
	public var path:Vector.<Point> = new Vector.<Point>(4);
	
	public function LinePath(x:Number, y:Number, pastLinePoint:LinePath=null)
	{
		super(x, y);
		
		if(pastLinePoint)
		{
			thickness = 1 + Point.distance(pastLinePoint, this) * .6;
			angle = Math.atan2( y - pastLinePoint.y, x - pastLinePoint.x);
			
			var th:Number = thickness / 2;
			var leftPoint:Point = Point.polar(th, angle + Math.PI/2);
			leftPoint.x += x;
			leftPoint.y += y;
			
			var rightPoint:Point = Point.polar(th, angle - Math.PI/2);
			rightPoint.x += x;
			rightPoint.y += y;
			
			path[0] = pastLinePoint.path[1].clone();
			path[3] = pastLinePoint.path[2].clone();
			
			path[1] = leftPoint;
			path[2] = rightPoint;
		}
		else
		{
			path[0] = this.clone();
			path[3] = this.clone();
			path[1] = this.clone();
			path[2] = this.clone();
		}
		
	}
	
}