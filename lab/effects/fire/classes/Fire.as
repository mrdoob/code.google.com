package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Fire extends Sprite
	{
		private var effect_width	:Number = stage.stageWidth;
		private var effect_height	:Number = stage.stageHeight;
		
		private var loadingMC		:Sprite;
		private var loadingBD		:BitmapData;
		private var perlin			:BitmapData;
		private var perlinBD		:Bitmap;
		private var perlin_temp		:BitmapData;		
		private var scroll_speed	:Number = 2;
		
		private var mouseIsDown		:Boolean = false;
		
		private var tuto_status		:Number = 0;
		
		public function Fire() 
		{			
			loadingBD = new BitmapData(effect_width, effect_height, false, 0);
			addChild(new Bitmap(loadingBD));
			
			perlin = new BitmapData(effect_width, effect_height, false, 0);
			perlin.perlinNoise(20, 40, 10, 0, true, true, 7, true);
			perlinBD = new Bitmap(perlin);
			perlinBD.visible = false;
			addChild(perlinBD);
			
			perlin_temp = new BitmapData(effect_width, 2, false, 0);
			
			loadingMC = new Sprite();
			loadingMC.buttonMode = true;
			loadingMC.doubleClickEnabled = true;
			loadingMC.graphics.beginFill(0xFF0000, 0);
			loadingMC.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			loadingMC.graphics.endFill();
			loadingMC.graphics.lineStyle(5, 0xFFFFFF);
			loadingMC.graphics.moveTo(20, 330);
			loadingMC.graphics.lineTo(330, 330);
			loadingMC.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			loadingMC.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			loadingMC.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			addChild(loadingMC);			
			
			var tf:TextField = new TextField();
			tf.mouseEnabled = false;
			tf.selectable = false;
			tf.defaultTextFormat = new TextFormat("Arial");
			tf.width = stage.stageWidth;
			tf.textColor = 0xFFFFFF;
			tf.text = "Click to draw\nDouble Click to see the steps";
			addChild(tf);
			
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function onDoubleClick(e:MouseEvent):void 
		{
			switch(tuto_status)
			{
				case 0:
					tuto_status = 1;
					perlinBD.visible = false;
				break;
				case 1:
					tuto_status = 2;
					perlinBD.visible = true;
					perlinBD.blendMode = BlendMode.NORMAL;
				break;
				case 2:
					tuto_status = 0;
					perlinBD.blendMode = BlendMode.OVERLAY;
				break;
			}
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			mouseIsDown = true;
			loadingMC.graphics.moveTo(mouseX, mouseY);
		}		
		
		private function onMouseUp(e:MouseEvent):void 
		{
			mouseIsDown = false;			
		}
		
		private function loop(e:Event):void 
		{
			if (mouseIsDown)
				loadingMC.graphics.lineTo(mouseX, mouseY);

			loadingBD.draw(loadingMC);
			loadingBD.applyFilter(loadingBD, loadingBD.rect, new Point(), new BlurFilter(2, 2, 1));
			loadingBD.colorTransform(loadingBD.rect, new ColorTransform(1, 1, .5, 1, -5, -20, -20));
			loadingBD.scroll(0, -1);
			
			perlin_temp.copyPixels(perlin, new Rectangle(0, 0, effect_width, scroll_speed), new Point());
			perlin.scroll(0, -scroll_speed);
			perlin.copyPixels(perlin_temp, perlin_temp.rect, new Point(0, effect_height - scroll_speed));
		}
	}
}