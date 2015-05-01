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
//  File name : Recoder.as
//  Author: 최진열(choi.jinyeol@nhn.com)
//  First created: Apr 20, 2015, 최진열(choi.jinyeol@nhn.com)
//  Last revised: Apr 20, 2015, 최진열(choi.jinyeol@nhn.com)
//  Version: v.1.0
//
////////////////////////////////////////////////////////////////////////////////


package
{
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.events.StatusEvent;
	import flash.media.Microphone;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import cmodule.flac.CLibInit;
	
	/**
	 * 
	 * @author 최진열(choi.jinyeol@nhn.com)
	 */
	public class Recoder
	{
		
		private var ch:SoundChannel;
		//ByteArray in which the recorded sound data is stored
		private var soundBytes:ByteArray = new ByteArray();
		//ByteArray from which the recorded sound data is played
		private var soundO:ByteArray = new ByteArray();
		//Sound object which plays the recorded sound...
		private var sound:Sound= new Sound();
		
		//Gets your default microphone
		private var mic:Microphone = Microphone.getMicrophone();
		//To check whether the application is recording the sound or not
		public var recMode:Boolean=false;
		//To check whether the application is playing the sound or not
		public var playMode:Boolean=false;
		/**
		 * Constructor
		 */
		public function Recoder()
		{
			
			trace(Microphone.isSupported);
			
			//Sets the minimum input level that should be considered sound
			mic.setSilenceLevel(0);
			//The amount by which the microphone boosts the signal.
			mic.gain = 100;
			//The rate at which the microphone is capturing sound, in kHz.
			mic.rate = 44;
			
//			mic.setUseEchoSuppression(true);
//			mic.setLoopBack(true);
			
			mic.addEventListener(ActivityEvent.ACTIVITY, this.onMicActivity); 
			mic.addEventListener(StatusEvent.STATUS, this.onMicStatus); 
			
		}
		
		
		private function onMicActivity(event:ActivityEvent):void 
		{ 
			trace("activating=" + event.activating + ", activityLevel=" + mic.activityLevel); 
		} 
		
		private function onMicStatus(event:StatusEvent):void 
		{ 
			trace("status: level=" + event.level + ", code=" + event.code); 
		}
		
		
		//function called when start Record button is clicked
		public function startRecord():void
		{
			recMode = true;
			mic.addEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
		}
		//function called when stop Record button is clicked
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
		
		
		
		
		public function getFlac(callback:Function):void
		{
			var flacCodec:Object;
			flacCodec = (new cmodule.flac.CLibInit).init();
			soundO.position = 0;
			var rawData: ByteArray = new ByteArray();
			var flacData : ByteArray = new ByteArray();
			rawData = convert32to16(soundO);
			flacData.endian = Endian.LITTLE_ENDIAN;
			
			flacCodec.encode(function(e:*):void{
				trace('complete');
				callback(flacData); 
			}, 
				function(progress:int):void{ trace('progress', progress); }, 
				rawData, 
				flacData, 
				rawData.length, 
				30); 
		}
		
		
		private static const FLOAT_MAX_VALUE:Number = 1.0;
		private static const SHORT_MAX_VALUE:int = 0x7fff;
		
		/**
		 * Converts an (raw) audio stream from 32-bit (signed, floating point)
		 * to 16-bit (signed integer).
		 *
		 * @param source The audio stream to convert.
		 */
		private function convert32to16(source:ByteArray):ByteArray {
			trace("BitrateConvertor.convert32to16(source)", source.length);
			
			var result:ByteArray = new ByteArray();
			result.endian = Endian.LITTLE_ENDIAN;
			
			while( source.bytesAvailable ) {
				var sample:Number = source.readFloat() * SHORT_MAX_VALUE;
				
				// Make sure we don't overflow.
				if (sample < -SHORT_MAX_VALUE) sample = -SHORT_MAX_VALUE;
				else if (sample > SHORT_MAX_VALUE) sample = SHORT_MAX_VALUE;
				
				result.writeShort(sample);
			}
			
			trace(" - result.length:", result.length);
			result.position = 0;
			return result;
		}
	}
}