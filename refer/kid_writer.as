

package
{
	import com.inoel.ane.speech.Speech;
	import com.inoel.ane.speech.speechToTextEvent;
	import com.junkbyte.console.Cc;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	
	[SWF(frameRate="60", width="1024", height="600", backgroundColor="#009955")]
	public class kid_writer extends Sprite
	{
		[Embed(source = "../asset/note_canvas_bg.png")]
		public static var NOTE_CANVAS_BG:Class;
		[Embed(source = "../asset/btn_note_back.png")]
		public static var NOTE_BUTTON_BACK:Class;
		[Embed(source = "../asset/btn_note_clear.png")]
		public static var NOTE_BUTTON_CLEAR:Class;
		[Embed(source = "../asset/note_eraser.png")]
		public static var NOTE_BUTTON_ERASER:Class;
		[Embed(source = "../asset/note_eraser_mask.png")]
		public static var NOTE_ERASER_MASK:Class;
		[Embed(source = "../asset/note_pen.png")]
		public static var NOTE_BUTTON_PEN:Class;
		[Embed(source = "../asset/btn_note_undo.png")]
		public static var NOTE_BUTTON_UNDO:Class;
		[Embed(source = "../asset/kid_writer.png")]
		public static var BG_TEST:Class;

		
		private var noteContainer:Sprite;
		private var editers:Array=[];
		private var curIndex:int;
		private var tf:TextField;
		
		private var bg:Bitmap = new BG_TEST as Bitmap;
		
		private var prev:TextField = new TextField;
		private var next:TextField = new TextField;
		
		private var rec:TextField = new TextField;
		private var play:TextField = new TextField;
		
		private var rec2:TextField = new TextField;
		
		private var recoder:Recoder = new Recoder;
		
		/**
		 * Constructor
		 */
		public function kid_writer()
		{
//			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);

//			Cc.startOnStage(stage);
			Cc.width = stage.stageWidth;
			Cc.height = stage.stageHeight * .7;
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			tf = new TextField;
			tf.width = 50;
			tf.height = 40;
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.x = stage.stageWidth/2;
			tf.y = stage.stageHeight - 40;
			addChild(tf);
			
			
			noteContainer = new Sprite;
			addChild(noteContainer);
			
			var cnt:int = 1;
			for (var i:int = 0; i < cnt; i++) 
			{
				var editer:Editor = new Editor();
//				editer.scaleX = editer.scaleY = .5;
//				editer.x = i%2 * 400; 
//				editer.y = int(i/2) * 534; 
				
				editers[i] = editer;
				noteContainer.addChild(editer);
			}
			
			editers[curIndex].show();
			
			prev.y = tf.y;
			prev.text = '<';
			prev.width = prev.height = 80;
			prev.background = true;
			prev.backgroundColor = 0x0000ff;
			addChild(prev);
			
			prev.addEventListener(MouseEvent.CLICK, function(e:Event):void{
				if(curIndex > 0)
				{
					editers[curIndex].hide();
					noteContainer.removeChild(editers[curIndex]);
					
					noteContainer.addChild(editers[--curIndex]);
					editers[curIndex].show();
					updatePage();
				}
			});
			
			next.x = stage.stageWidth - 80;
			next.y = tf.y;
			next.text = '>';
			next.width = next.height = 80;
			next.background = true;
			next.backgroundColor = 0x0000ff;
			addChild(next);
			
			next.addEventListener(MouseEvent.CLICK, function(e:Event):void
			{
				editers[curIndex].hide();
				noteContainer.removeChild(editers[curIndex]);
				
				if(++curIndex >= editers.length)
				{
					editers[curIndex] = new Editor();
				}
				
				noteContainer.addChild(editers[curIndex]);
				editers[curIndex].show();
				
				updatePage();

			});
			
			updatePage();
			
			
			rec2.x = prev.x + prev.width + 20;
			rec2.y = tf.y + 100;
			rec2.text = 'REC by activity';
			rec2.width = rec2.height = 80;
			rec2.background = true;
			rec2.backgroundColor = 0xff00ff;
			addChild(rec2);
			
			var speech:Speech = new Speech("Please speak something !");
			speech.addEventListener(speechToTextEvent.VOICE_RECOGNIZED, function(e:speechToTextEvent):void{
				editers[curIndex].setText(e.data);
			});
			
			rec2.addEventListener(MouseEvent.CLICK, function(e:Event):void
			{
				if(!recoder.playMode && !recoder.recMode)
				{
					speech.listen();
				}
			});
			
			
			rec.x = prev.x + prev.width + 20;
			rec.y = tf.y;
			rec.text = 'REC';
			rec.width = rec.height = 80;
			rec.background = true;
			rec.backgroundColor = 0xff00ff;
			addChild(rec);
			
			
			rec.addEventListener(MouseEvent.CLICK, function(e:Event):void
			{
				if(!recoder.playMode)
				{
					if(recoder.recMode){
						rec.text = 'REC';
						recoder.stopRecord();
						
						startTime = getTimer();
						
						editers[curIndex].setText('시작~');
						
						recoder.getFlac(reqRecognize);
						
						editers[curIndex].setText('시작~~~~');
						
					}
					else
					{
						rec.text = 'REC-ing';
						recoder.startRecord();
					}
				}
				
			});
			
			play.x = next.x - next.width - 20;
			play.y = tf.y;
			play.text = 'PLAY';
			play.width = play.height = 80;
			play.background = true;
			play.backgroundColor = 0xff00ff;
			addChild(play);
			
			play.addEventListener(MouseEvent.CLICK, function(e:Event):void
			{
				if(!recoder.recMode)
				{
					if(recoder.playMode)
					{
						play.text = 'PLAY';
						recoder.stopSound();
					}
					else
					{
						play.text = 'PLAY-ing';
						recoder.playSound(function():void{
							play.text = 'PLAY';
						});
					}
				}					
			});
			
			
			addChild(bg);
			
		}
		
		private var startTime:uint;
		
		
		private function updatePage():void
		{
			tf.text = (curIndex + 1) + "/" + editers.length;
		}
		
		private function deactivate(e:Event):void 
		{
			// auto-close
//			NativeApplication.nativeApplication.exit();
		}
		
		
		
		private function reqRecognize(flacData:ByteArray):void
		{
			Cc.debug('reqRecognize :', flacData.length);
			
			
			var PATH:String = "https://www.google.com/speech-api/v2/recognize?output=json&lang=ko-kr&key=AIzaSyCY437q0FiBowypusB6x4usPw0Ek-p1ffA";
			var urlRequest:URLRequest = new URLRequest(PATH);
			var urlLoader:URLLoader = new URLLoader();
			urlRequest.contentType = "audio/x-flac; rate=44100";
//			urlRequest.contentType = "audio/x-flac; rate=44000";
			//urlRequest.contentType = "audio/l16; rate=16000";
			urlRequest.data = flacData;
			urlRequest.method = URLRequestMethod.POST;
			urlLoader.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				var loader:URLLoader = URLLoader(e.target);
				Cc.debug('loader.data', loader.data);
				
				var s:Array = loader.data.split('\n');
				
				Cc.debug('loader.data >>>', objToString(s));
				
				
				if(loader.data && s.length > 1)
				{
					var data:Object = JSON.parse(s[1]);
					
					
					Cc.debug('is data.result ---', data.result);
					Cc.debug('data', objToString(data));
					
					var script:String = '';
					if(data && data.result && data.result.length > 0)
					{
						var info:Object = data.result[data.result_index];
						
//						var count:int = info.alternative.length;
//						for (var i:int = 0; i < count; i++) 
//						{
//							Cc.debug('info.alternative[',i,']', objToString(info.alternative[i]));
//							script += '\n' + info.alternative[i].transcript;
//						}
						
						script = info.alternative[0].transcript;
					}
					

					script += "\n" + 'time gap : ' + (getTimer() - startTime);
					
					editers[curIndex].setText(script);
				} else {
					editers[curIndex].setText('없다');
				}
			});
			urlLoader.addEventListener(ErrorEvent.ERROR, function(e:ErrorEvent):void
			{
				editers[curIndex].setText(e);
			});
			urlLoader.load(urlRequest);
		}
		
		public static function objToString(obj:Object):String
		{
			var str:String;
			if(obj)
				str = JSON.stringify(obj);
			return str;
		}

	}
}