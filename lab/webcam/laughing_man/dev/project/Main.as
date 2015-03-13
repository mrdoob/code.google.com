package 
{
	import jp.maaash.ObjectDetection.ObjectDetector;
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	import jp.maaash.ObjectDetection.ObjectDetectorOptions;
	
	import com.quasimondo.bitmapdata.CameraBitmap;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;	

	/**
	 * @author mrdoob
	 */
	[SWF(width="640",height="480",backgroundColor="#000000",frameRate="30")]
	public class Main extends Sprite 
	{
		private var screen : Screen;
		private var lmIcon : LaughingManIcon;

		private var detector : ObjectDetector;
		private var options : ObjectDetectorOptions;

		private var view : Sprite;
		private var viewPost : Sprite;

		private var camera : CameraBitmap;
		private var detectionMap : BitmapData;
		private var drawMatrix : Matrix;		
		private var scaleFactor : int = 4;
		private var w : int = 640;
		private var h : int = 480;

		private var faceRect : Rectangle;

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

			onStageResized(null);		
			stage.addEventListener(Event.RESIZE, onStageResized);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);			
		}

		private function init() : void
		{
			view = new Sprite;
			addChild(view);
			
			viewPost = new Sprite;
			addChild(viewPost);

			camera = new CameraBitmap(w, h, 15);			
			camera.addEventListener(Event.RENDER, cameraReadyHandler);
			
			var cameraBitmap : Bitmap = new Bitmap(camera.bitmapData);
			cameraBitmap.scaleX = -1;
			cameraBitmap.x += cameraBitmap.width;			
			view.addChild(cameraBitmap);
			
			detectionMap = new BitmapData(w / scaleFactor, h / scaleFactor, false, 0);
			drawMatrix = new Matrix(1 / scaleFactor, 0, 0, 1 / scaleFactor);
			
			faceRect = new Rectangle();
			
			lmIcon = new LaughingManIcon;
			lmIcon.buttonMode = true;
			lmIcon.addEventListener(MouseEvent.CLICK, onClickOnIcon);
			lmIcon.filters = [new DropShadowFilter(0, 0, 0x000000, .5, 32, 32, .5)];
			lmIcon.visible = false;
			viewPost.addChild(lmIcon);

			screen = new Screen(w, h);
			screen.alpha = .5;
			screen.blendMode = BlendMode.OVERLAY;
			viewPost.addChild(screen);
			
			//addChild(new Stats);
		}

		private function initDetector() : void
		{
			detector = new ObjectDetector();
			
			options = new ObjectDetectorOptions();
			options.min_size = 30;
			detector.options = options;
			detector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, detectionHandler);
		}

		private function cameraReadyHandler( event : Event ) : void
		{
			detectionMap.draw(camera.bitmapData, drawMatrix);
			detector.detect(detectionMap);
			
			onStageResized(null);
		}		

		private function detectionHandler( e : ObjectDetectorEvent ) : void
		{
			if( !e.rects[0] )
			{
				lmIcon.hide();
				return;
			}
				
			faceRect.x = e.rects[0].x * scaleFactor;
			faceRect.y = e.rects[0].y * scaleFactor;
			faceRect.width = e.rects[0].width * scaleFactor;
			faceRect.height = e.rects[0].height * scaleFactor;

			lmIcon.scaleX = lmIcon.scaleY = faceRect.width / 180;			
			lmIcon.show();
			
			/*
			if( e.rects ){
				g.lineStyle( 2 );	// black 2pix
				e.rects.forEach( function( r :Rectangle, idx :int, arr :Array ) :void {
					g.drawRect( r.x * scaleFactor, r.y * scaleFactor, r.width * scaleFactor, r.height * scaleFactor );
				});
			}
			*/
		}

		private function onClickOnIcon( e : MouseEvent ) : void
		{
			navigateToURL(new URLRequest("http://en.wikipedia.org/wiki/Laughing_Man_(Ghost_in_the_Shell)"),"_blank");			
		}

		private function onEnterFrame( e : Event ) : void
		{
			// flipping X
			lmIcon.x = (w  - faceRect.width) - faceRect.x + (faceRect.width >> 1) + (Math.random() * 8 - 4); // flipping X
			lmIcon.y = faceRect.y + (faceRect.height * .3) + (Math.random() * 8 - 4);
			
			screen.alpha = Math.random() * .5 + .2;
		}

		private function onStageResized( e : Event ) : void
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
			view.scaleX < view.scaleY ? view.scaleX = view.scaleY : view.scaleY = view.scaleX;
			
			viewPost.scaleX = view.scaleX;
			viewPost.scaleY = view.scaleY;
		}
	}
}