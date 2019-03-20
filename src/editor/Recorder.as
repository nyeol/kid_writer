

package editor
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SampleDataEvent;
	import flash.media.Microphone;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	
	
	public class Recorder extends Sprite
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
		private var _btnOpen:Sprite;
		
		private var _tools:Sprite;
		private var _btnSpeaker:Sprite = new Sprite;
		private var _btnDelete:Sprite = new Sprite;
		private var _btnMicrophone:Sprite = new Sprite;
		
		private var _mic:Microphone;
		private var _sound:Sound;
		private var _recordData:ByteArray;
		
		/**
		 * Constructor
		 */
		public function Recorder()
		{
			_sound = new Sound;
			_mic = new Microphone;
//			Microphone.isSupported
			
			_mic.setSilenceLevel(0);
			_mic.gain = 100;
			_mic.rate = 44;

		}
		
		public function init(recordData:ByteArray):void
		{
			_recordData = recordData;
		}
		
		public function enable():void
		{
			
		}
		
		public function disable():void
		{
			
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
					
					// - microphone
					_btnMicrophone.addChild(new Assets.bt_microphone as Bitmap);
					_btnMicrophone.addEventListener(MouseEvent.CLICK, function(e:Event):void{
						
					});
					_btnMicrophone.x = 10;
					_btnMicrophone.y = 10;
					_tools.addChild(_btnMicrophone);
					
					
					// - sound
					_btnSpeaker.addChild(new Assets.btn_sound as Bitmap);
					_btnSpeaker.addEventListener(MouseEvent.CLICK, function(e:Event):void{
						
					});
					_btnSpeaker.x = 10;
					_btnSpeaker.y = 100;
					_tools.addChild(_btnSpeaker);
					
					// - delete
					_btnDelete.addChild(new Assets.bt_delete as Bitmap);
					_btnDelete.addEventListener(MouseEvent.CLICK, function(e:Event):void{
						
					});
					
					_btnDelete.x = 10;
					_btnDelete.y = 200;
					_btnDelete.alpha = .3;
					_tools.addChild(_btnDelete);
				} 
				else 
				{
					addChild(_tools);
				}
				
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
					
					var microphone:Bitmap = new Assets.bt_microphone as Bitmap;
					microphone.x = 10;
					microphone.y = 10;
					_btnOpen.addChild(microphone);
					
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
		
		//---------------------------------------------------------------------
		//  
		//  Methods ( first Override )
		//  
		//---------------------------------------------------------------------
		
		/*
		public function startRecord():void
		{
			recMode = true;
			mic.addEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
		}
		
		public function stopRecord():void
		{
			recMode = false;
			
			mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
			soundBytes.position = 0;
			soundO.length=0;
			soundO.writeBytes(soundBytes);
			soundO.position = 0;
			soundBytes.length=0;    
		}
		
		private function micSampleDataHandler(event:SampleDataEvent):void
		{
			while (event.data.bytesAvailable)
			{
				var sample:Number = event.data.readFloat();
				soundBytes.writeFloat(sample);
			}
		}
		
		
		private var callback:Function;
		public function playSound(cb:Function):void
		{   
			callback = cb;
			playMode = true;
			
			
			sound.addEventListener(SampleDataEvent.SAMPLE_DATA, playbackSampleHandler);
			ch=sound.play();
			ch.addEventListener(Event.SOUND_COMPLETE,onSC);
		}
		
		public function stopSound():void
		{   
			playMode = false;
			
			sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, playbackSampleHandler);
			ch.stop();
			ch.removeEventListener(Event.SOUND_COMPLETE,onSC);
			
			if(callback)
			{
				callback();
				callback = null;
			}
		}
		
		private function onSC(evt:Event):void
		{
			trace("SOUND_COMPLETE")
			stopSound();
			soundO.position=0;
		}
		
		private function playbackSampleHandler(event:SampleDataEvent):void
		{
			for (var i:int = 0; i < 8192; i++)
			{
				if (soundO.bytesAvailable < 4)
				{
					break
				}
				var sample:Number = soundO.readFloat();
				event.data.writeFloat(sample);
				event.data.writeFloat(sample);
				
				
			}
			if (soundO.bytesAvailable < 4&&soundO.position!==0)
			{
				
			}
		}
		*/
	}
}