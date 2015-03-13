package  
{
	import flash.events.TimerEvent;	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;	

	/**
	 * @author mrdoob
	 */
	public class LaughingManIcon extends Sprite 
	{
		[Embed(source="assets/laughing_man_bg.svg")]
		[Bindable]
		private var bgAsset : Class;

		[Embed(source="assets/laughing_man_text.svg")]
		[Bindable]
		private var textAsset : Class;

		[Embed(source="assets/laughing_man_face.svg")]
		[Bindable]
		private var faceAsset : Class;

		protected var bg : Sprite;
		protected var text : Sprite;
		protected var face : Sprite;

		protected var timer : Timer;

		public function LaughingManIcon()
		{
			bg = new bgAsset();
			text = new textAsset();
			face = new faceAsset();
			
			var offsetX : Number = 159;
			var offsetY : Number = 159;

			bg.x -= offsetX;
			bg.y -= offsetY;
			
			face.x -= offsetX;
			face.y -= offsetY;			
			
			addChild(bg);
			addChild(text);
			addChild(face);
			
			timer = new Timer(1000, 0);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function show() : void
		{
			timer.stop();
			visible = true;
		}

		public function hide() : void
		{
			timer.start();
		}

		private function onTimer(e:TimerEvent) : void
		{
			timer.stop();
			visible = false;
		}

		private function onEnterFrame( e : Event ) : void
		{
			text.rotation -= 2;
		}
	}
}
