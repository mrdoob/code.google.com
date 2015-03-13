package  
{
	import jp.maaash.ObjectDetection.ObjectDetector;
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	import jp.maaash.ObjectDetection.ObjectDetectorOptions;
	
	import com.mrdoob.tools.threedoob.cameras.Camera3D;
	import com.mrdoob.tools.threedoob.core.Vector3D;
	import com.mrdoob.tools.threedoob.events.Scene3DEvent;
	import com.mrdoob.tools.threedoob.objects.Bitmap3D;
	import com.mrdoob.tools.threedoob.renderers.CommonRenderer;
	import com.mrdoob.tools.threedoob.scenes.Scene3D;
	import com.quasimondo.bitmapdata.CameraBitmap;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.media.Camera;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;	

	/**
	 * @author mrdoob
	 */
	[SWF(width="800",height="600",backgroundColor="#000000",frameRate="30")]	 

	public class Main extends Sprite 
	{
		[Embed(source="assets/ball.png")]
		private var ballAsset : Class;

		private var texture : BitmapData;

		public var camera : Camera3D;
		public var scene : Scene3D;
		public var renderer : CommonRenderer;

		public var mouse_delta : int = 150;
		
		private var detector : ObjectDetector;
		private var options : ObjectDetectorOptions;		
		
		private var webCamera : CameraBitmap;
		private var detectionMap : BitmapData;
		private var drawMatrix : Matrix;		
		private var scaleFactor : int = 4;		
		
		private var w : int = 640;
		private var h : int = 480;

		private var webcam : Sprite;
		private var faceSprite : Sprite;
		private var faceRect : Vector3D;
		
		private var message : TextField;

		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e : Event) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			stage.quality = StageQuality.MEDIUM;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			if (!Camera.names.length)
			{
				message = new TextField();
				message.defaultTextFormat = new TextFormat("Arial", 13, 0xffffff);
				message.text = "Please, connect a webcam and refresh the browser. It's worth it :)";
				message.autoSize = TextFieldAutoSize.CENTER;
				
				message.x = (stage.stageWidth >> 1) - (message.width >> 1);
				message.y = (stage.stageHeight >> 1);
				
				addChild(message);
				
				return;				
			}
			
			init();
			initDetector();
			setupScene();
			
			webcam = new Sprite;
			webcam.scaleX = webcam.scaleY = .2;			
			webcam.buttonMode = true;
			webcam.addEventListener(MouseEvent.CLICK, onClickOnWebcam);
			webcam.addChild(new Bitmap(webCamera.bitmapData));
			addChild(webcam);
			
			// flip
			webcam.scaleX = -.2;
			webcam.x += webcam.width;			

			faceSprite = new Sprite;
			webcam.addChild(faceSprite);

			onStageResize(null);
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			//addChild(new Stats());
		}

		public function init() : void
		{
			webCamera = new CameraBitmap(w, h, 15);			
			webCamera.addEventListener(Event.RENDER, cameraReadyHandler);
			
			faceRect = new Vector3D();			
		}
		
		// Face tracking
		
		private function initDetector() : void
		{
			detectionMap = new BitmapData(w / scaleFactor, h / scaleFactor, false, 0);
			drawMatrix = new Matrix(1 / scaleFactor, 0, 0, 1 / scaleFactor);
						
			detector = new ObjectDetector();
			
			options = new ObjectDetectorOptions();
			options.min_size = 30;
			detector.options = options;
			detector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, detectionHandler);
		}

		private function cameraReadyHandler( event : Event ) : void
		{
			detectionMap.draw(webCamera.bitmapData, drawMatrix);
			detector.detect(detectionMap);
			
			onStageResize(null);
		}
		
		private function detectionHandler( e : ObjectDetectorEvent ) : void
		{
			faceSprite.graphics.clear();
			
			if( !e.rects[0] )
				return;
				
			faceRect.x = (e.rects[0].x * 2) - 100;
			faceRect.y = (e.rects[0].y * 2) - 100;
			//faceRect.z = e.rects[0].width * 10 - 350;
			
			faceSprite.graphics.beginFill(0xff0000,.5);
			faceSprite.graphics.drawRect( e.rects[0].x * scaleFactor, e.rects[0].y * scaleFactor, e.rects[0].width * scaleFactor, e.rects[0].height * scaleFactor );
		}		

		//

		public function setupScene() : void
		{
			// renderer

			renderer = new CommonRenderer();

			//onStageResize(null);
			
			// camera

			camera = new Camera3D();
			camera.z = -1000;
			
			// scene

			scene = new Scene3D();
			scene.addEventListener(Scene3DEvent.DISPLAYOBJECT3D_ADDED, renderer.onSceneUpdated);
			scene.addEventListener(Scene3DEvent.DISPLAYOBJECT3D_REMOVED, renderer.onSceneUpdated);
			
			// objects

			texture = new ballAsset().bitmapData;			

			var r : Number, g : Number, b : Number, d : Number;
			
			for (var i : int = 0;i < 10; i++)
			{
				for (var j : int = 0;j < 10; j++)
				{
					for (var k : int = 0;k < 10; k++)
					{
						var particle : Bitmap3D = new Bitmap3D(texture, true);
						particle.x = i * 200 - 1000;
						particle.y = j * 200 - 1000;
						particle.z = k * -50;
						particle.bitmap.scaleX = particle.bitmap.scaleY = .4;
						
						d = k / 10;
						
						r = (i / 10) * 256 - 128 - (d * 255);
						g = (j / 10) * 256 - 128 - (d * 255);
						b = 64 - (d * 255);
						
						particle.bitmap.transform.colorTransform = new ColorTransform(1, 1, 1, 1, r, g, b, 0);
						
						scene.add(particle);
					}
				}
			}

			camera.target.z = camera.z - 200;
			
			renderer.render(scene, camera);
			renderer.sort(scene);
			
			addChild(renderer);			
			
			addEventListener(Event.ENTER_FRAME, loop);
		}

		private function onClickOnWebcam( e : MouseEvent ) : void
		{
			webcam.alpha = webcam.alpha == 1 ? 0 : 1;			
		}

		public function loop(e : Event) : void
		{
			camera.x += (-faceRect.x - camera.x) * .05;
			camera.y += (-faceRect.y - camera.y) * .05;
			camera.z += (50 - camera.z) * .01;

			//camera.target.x = camera.x;
			//camera.target.y = camera.y;
			camera.target.z = camera.z - 200;
			
			renderer.render(scene, camera);
		}

		//

		public function onStageResize( e : Event ) : void
		{
			renderer.x = stage.stageWidth >> 1;
			renderer.y = stage.stageHeight >> 1;
		}			
	}
}