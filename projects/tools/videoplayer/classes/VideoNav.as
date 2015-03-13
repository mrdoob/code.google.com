package
{
	
	import flash.display.Sprite;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.hires.controllers.VideoController;
	
	
	public class VideoNav extends Sprite
	{
		private var video		:VideoController;
		
		// Graphics
		private var bg			:Sprite;
		private var track		:Sprite;
		private var buffer		:Sprite;
		private var progress	:Sprite;
		
		private var mtr			:Matrix;
		
		
		public function VideoNav()
		{
			
			buttonMode = true;
			addEventListener( MouseEvent.CLICK, onClick );
			
			bg = new Sprite();
			bg.graphics.beginFill(0x161616, 1);
			bg.graphics.drawRect(0, 0, 5, 5);
			bg.graphics.endFill();
			addChild(bg);
			
			track = new Sprite();
			track.y = 7;
			track.graphics.beginFill(0x000000, 1);
			track.graphics.drawRect(0, 0, 5, 5);
			track.graphics.endFill();
			addChild(track);
			
			mtr = new Matrix();
			mtr.createGradientBox(10, 10, Math.PI*.5);
			
			buffer = new Sprite();
			buffer.y = 7;
			buffer.graphics.beginGradientFill(GradientType.LINEAR, [0x282828, 0x343434], [1, 1], [0, 255], mtr);
			buffer.graphics.drawRect(0, 0, 5, 5);
			buffer.graphics.endFill();
			addChild(buffer);
			
			progress = new Sprite();
			progress.y = 7;
			addChild(progress);
			
		}
		
		public function updateSize()
		{
			bg.width = stage.stageWidth;
			bg.height = 19;
			
			track.width = stage.stageWidth;			
		}
		
		public function connectToVideo( v:VideoController )
		{
			video = v;
			addEventListener( Event.ENTER_FRAME, loop );
		}
		
		public function loop( e:Event )
		{
			buffer.width = video.getPercentLoaded() * stage.stageWidth;
			updateProgressBar( video.getPercentPlayed() );
		}
		
		public function updateProgressBar( percent:Number )
		{
			var xPos:Number = percent * stage.stageWidth;
			
			progress.graphics.clear();
			progress.graphics.beginFill(0xFFFFFF, 1);
			progress.graphics.moveTo(0, 0);
			progress.graphics.lineTo(xPos, 0);
			progress.graphics.lineTo(xPos+2, 2.5);
			progress.graphics.lineTo(xPos, 5);
			progress.graphics.lineTo(0, 5);
			progress.graphics.lineTo(0, 0);
			progress.graphics.endFill();
		}
		
		public function onClick( e:Event = null )
		{
			video.play( mouseX / bg.width );
		}
	}
}