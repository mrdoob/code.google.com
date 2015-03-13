package 
{
	import flash.text.TextFieldAutoSize;	
	import flash.text.TextFormat;	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.ByteArray;	

	/**
	 * @author mrdoob
	 */
	[SWF(width = "1024", height = "768", backgroundColor = "#000000", frameRate = "30")]

	public class Main extends Sprite 
	{
		private var h : int = 60;
		private var distortX : Number = 1.17;
		
		private var message : TextField;
		
		private var container : Sprite;

		private var line : Sprite;
		private var linesB : Array;
		private var linesBD : Array;		

		private var fft : ByteArray;
		private var fftBD : BitmapData;

		private var filter : Array;
		
		private var count : int = -1;

		
		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		public function init(e : Event) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.quality = StageQuality.HIGH;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			var sound : Sound = new Sound(new URLRequest("01. Joy Division - Disorder.mp3"));
			sound.play();	

			container = new Sprite();
			addChild(container);
			
			linesB = new Array();
			linesBD = new Array();
			
			for (var i : int = 0; i < 100; i++)
			{
				linesBD[i] = new BitmapData(300, h + 1, true, 0x00000000);
				linesB[i] = new Bitmap(linesBD[i]);
				linesB[i].y = (i * 4) - h;
				container.addChild(linesB[i]); 
			}
			
			line = new Sprite();
			
			fft = new ByteArray();
			fftBD = new BitmapData(256, 3, false, 0x000000);
			
			filter = new Array();

			for (i = 0; i < 256; i++)
				filter[i] = Math.pow( 1 - (Math.abs(i-128) / 128) , 4)  * 2;
			
			message = new TextField();
			message.defaultTextFormat = new TextFormat("sans",10,0xffffff);
			message.text = "wops! I can't access the audio, maybe you have a tab open with another flash playing?";
			message.autoSize = TextFieldAutoSize.LEFT;
			message.mouseEnabled = false;
			message.selectable = false;
			message.visible = false;			
			addChild(message);
			
			onStageResize();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(e : Event) : void
		{
			// .. Audio?

			if (SoundMixer.areSoundsInaccessible())
			{
				message.visible = true;
				return;
			}
			else
			{
				message.visible = false;
			}

			SoundMixer.computeSpectrum(fft, true, 4);
			
			fftBD.scroll(0, -1);
			
			for (var i : int = 0; i < 256; i++)
			{
				fft.position = 512 - (i * 4);
				fftBD.setPixel(i, 2, fft.readFloat() * filter[i] * 0xff + (Math.random() * 0x10) );
			}
			
			fftBD.applyFilter(fftBD, fftBD.rect, new Point(), new BlurFilter(16, 16));
			
			drawLine();
			
			// .. Spread
			
			for (i = 0; i < 99; i++)
				linesB[i].bitmapData = linesB[i+1].bitmapData;

			// .. Copy graphic to BitmapData

			count ++;
			count %= 100;

			linesBD[count].fillRect(linesBD[99].rect, 0x00000000);
			linesBD[count].draw(line);
			
			linesB[99].bitmapData = linesBD[count];			
		}
		
		private function drawLine() : void
		{
			line.graphics.clear();

			// .. Draw Bg
			
			line.graphics.beginFill( 0x000000 );
			line.graphics.moveTo(0, h - ((fftBD.getPixel(i, 2) / 0xff)  * h));
			
			for (var i : int = 0; i < 256; i ++)
				line.graphics.lineTo(i * distortX, h - ((fftBD.getPixel(i, 2) / 0xff)  * h));
			
			line.graphics.lineTo(256 * distortX, h + 1);
			line.graphics.lineTo(0, h + 1);
			line.graphics.endFill();
			
			// .. Draw Line
			
			line.graphics.lineStyle( 0, 0xC0C0C0 );
			line.graphics.moveTo(Math.random() * distortX, h - .5 - ((fftBD.getPixel(0, 2) / 0xff)  * h));
			
			for (i = 1; i < 256; i ++)
				line.graphics.lineTo((i + Math.random()) * distortX, h - .5 - ((fftBD.getPixel(i, 2) / 0xff)  * h));
			
			line.graphics.lineStyle();
		}
		
		public function onStageResize( e : Event = null ) : void
		{
			container.x = (stage.stageWidth >> 1) - 150;
			container.y = (stage.stageHeight >> 1) - 200;
			
			message.x = (stage.stageWidth >> 1) - (message.width >> 1);
			message.y = (stage.stageHeight >> 1);
		}		
	}
}