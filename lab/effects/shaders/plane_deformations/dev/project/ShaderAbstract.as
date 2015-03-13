package  
{
	import flash.display.Loader;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.ShaderFilter;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;	

	/**
	 * @author mrdoob
	 */
	public class ShaderAbstract extends Sprite
	{
		private var imagePath : String;
		private var shaderPath : String;

		private var imageLoader : Loader;
		private var shaderLoader : URLLoader;

		private var shader : Shader;
		private var shaderFilter : ShaderFilter;

		private var offsetU : Number = 0;
		private var offsetV : Number = 0;
		private var easeX : Number = 0;
		private var easeY : Number = 0;

		public function ShaderAbstract(image : String, shader : String) : void
		{
			imagePath = image;
			shaderPath = shader;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e : Event) : void
		{
			stage.quality = StageQuality.LOW;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			imageLoader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			imageLoader.load(new URLRequest(imagePath));
			addChild(imageLoader);
		}

		private function onImageLoaded(e : Event) : void
		{
			imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);
			
			shaderLoader = new URLLoader();
			shaderLoader.dataFormat = URLLoaderDataFormat.BINARY;
			shaderLoader.addEventListener(Event.COMPLETE, onShaderLoaded);
			shaderLoader.load(new URLRequest(shaderPath));
		}

		private function onShaderLoaded(e : Event) : void
		{
			shaderLoader.removeEventListener(Event.COMPLETE, onShaderLoaded);
			
			shader = new Shader(e.currentTarget.data as ByteArray);
			shaderFilter = new ShaderFilter(shader);
			shader.data.imgSize.value = [imageLoader.width,imageLoader.height];
			imageLoader.filters = [shaderFilter];

			easeX = imageLoader.mouseX;
			easeY = imageLoader.mouseY;
			
			onStageResized(null);
			stage.addEventListener(Event.RESIZE, onStageResized);
			addEventListener(Event.ENTER_FRAME, loop);
		}

		private function loop(e : Event) : void
		{
			offsetU = getTimer() * 0.0001;
			offsetV = getTimer() * 0.0002;
			
			easeX += (imageLoader.mouseX - easeX) * .1;
			easeY += (imageLoader.mouseY - easeY) * .1;
			
			shader.data.center.value = [easeX,easeY];
			shader.data.offset.value = [offsetU,offsetV]
			imageLoader.filters = [shaderFilter];
		}

		private function onStageResized(e : Event) : void
		{
			imageLoader.x = (stage.stageWidth >> 1) - (imageLoader.width >> 1);
			imageLoader.y = (stage.stageHeight >> 1) - (imageLoader.height >> 1);
		}		
	}
}