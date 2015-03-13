package  
{
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getTimer;	

	/**
	 * @author mrdoob
	 */
	[SWF(width="1024",height="768",frameRate="60",backgroundColor="#000000")]
	public class Main extends Sprite 
	{
		[Embed(source="../assets/plasma.pbj", mimeType="application/octet-stream")]
		private var PlasmaShader:Class;
		
		private var shader : Shader;
				
		public function Main()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.LOW;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
			
		private function onAddedToStage( e : Event ) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
			
			shader = new Shader( new PlasmaShader() );
			
			//addChild( new Stats() );
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame( e : Event ) : void
		{			
			graphics.clear();
			
			
			shader.data.center.value = [ Math.sin(getTimer() * .0002) * 300 + (stage.stageWidth >> 1), Math.cos(getTimer() * .0001) * 300 + (stage.stageHeight >> 1) ];
			shader.data.wave.value = [ Math.sin(getTimer() * .0001) * .06 + 0.01, Math.cos(getTimer() * .00005) * .05 ];
			shader.data.offset.value = [ Math.sin(getTimer() * .0004) * 200, Math.cos(getTimer() * .0003) * 200 ];
			shader.data.color_offset.value = [ Math.sin(getTimer() * .0002) * 2, Math.sin(getTimer() * .00009) * 2, Math.cos(getTimer() * .00005) * 2 ];
			shader.data.distort.value = [ Math.sin(getTimer() * .00008) * .05 ];
				
			graphics.beginShaderFill(shader);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		}
	}
}
