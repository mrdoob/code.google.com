/*
 * Copyright 2008 (c) Mr.doob, http://mrdoob.com.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

package
{
	
	import flash.display.LoaderInfo;	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
	import flash.events.ContextMenuEvent;	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Keyboard;
	import flash.text.TextField;
	
	import caurina.transitions.Tweener;
	
	import net.hires.controllers.VideoController;
	import net.hires.utils.SpriteUtils;
	
	import Config;
	import VideoNav;
	
	public class Main extends Sprite
	{
		
		public var file				:String; // = "http://www.dvein.com/videos/Montage_2008.flv";
		public var bg				:Sprite;
		public var vc				:VideoController;
		public var vn				:VideoNav;
		
		
		public function Main()
		{
			Config.setup(this);
			init();
		}
		
		public function init()
		{
			
			// CONTEXT MENU: PLAY/STOP
			var cmiPlayStop:ContextMenuItem = new ContextMenuItem( "Play / Stop", true, false );
			cmiPlayStop.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, vcOnClick );
			Config.cm.customItems.push(cmiPlayStop);
			
			// CONTEXT MENU: DOWNLOAD
			var cmiDownload:ContextMenuItem = new ContextMenuItem( "Download video", false, false );
			cmiDownload.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e){ navigateToURL(new URLRequest(file),"_blank") } );
			Config.cm.customItems.push(cmiDownload);
			
			// GET FILE TO PLAY
			var paramObj:Object = LoaderInfo(this.root.loaderInfo).parameters;
			if (paramObj.file)
				file = String(paramObj.file);
				
			if (!file)
			{
				msg_missingfile.x = (stage.stageWidth * .5) - (msg_missingfile.width * .5) << 0;
				msg_missingfile.y = (stage.stageHeight * .5) - (msg_missingfile.height * .5) << 0;
				return;
			}
			
			// CONTEXT MENU: UPDATE ITEMS
			Config.cm.customItems[1].enabled = Config.cm.customItems[2].enabled = true;
			
			// BG BUTTON
			bg = new Sprite();
			bg.graphics.beginFill(0x000000, 1);
			bg.graphics.drawRect(0, 0, 5, 5);
			bg.graphics.endFill();
			addChild(bg);

			bg.mouseChildren = false;
			bg.doubleClickEnabled = true;
			bg.addEventListener( MouseEvent.CLICK, vcOnClick );
			bg.addEventListener( MouseEvent.DOUBLE_CLICK, vcOnDoubleClik );				
			
			// VIDEO CONTAINER
			vc = new VideoController( 320, 240, { smoothing:true, autoSize:true } );
			vc.load( file );
		
			vc.mouseEnabled = false;
			vc.addEventListener( VideoController.METADATA, setup );
			vc.addEventListener( VideoController.COMPLETE, reset );
			vc.visible = false;
			
			addChild(vc);
			
			symbol_play.mouseEnabled = false;
			addChild(symbol_play);
			
			// VIDEO NAV
			vn = new VideoNav();
			vn.connectToVideo(vc);
			addChild(vn);
			
			stage.addEventListener( Event.RESIZE, onStageResize );
			stage.addEventListener( MouseEvent.MOUSE_OVER, onStageMouseOver );
			stage.addEventListener( MouseEvent.MOUSE_OUT, onStageMouseOut );
			stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyboardDown );
		}
		
		public function reset( e:Event = null )
		{
			vc.play(0);
			vc.pause();
			Tweener.addTween(symbol_play, { alpha:1, scaleX:1, scaleY:1, time:1 } );
		}
		
		public function setup( e:Event = null )
		{			
			onStageResize();
			vc.visible = true;
		}	
		
		
		// .. LISTENER ACTIONS ........................................................................................
		
		
		public function onStageResize( e:Event = null )
		{
			bg.width = stage.stageWidth;
			bg.height = stage.stageHeight;
			
			symbol_play.x = (stage.stageWidth * .5);
			symbol_play.y = (stage.stageHeight * .5);
			
			vn.updateSize();
			
			SpriteUtils.resize(vc, vc.videoWidth, vc.videoHeight, stage.stageWidth, stage.stageHeight, "fit");
			vc.x = (stage.stageWidth * .5) - (vc.width * .5);
			vc.y = (stage.stageHeight * .5) - (vc.height * .5);
			
			Tweener.removeTweens(vn);
			vn.y = stage.stageHeight - vn.height;
		}
		
		public function onStageMouseOver( e:Event = null )
		{
			Tweener.addTween(vn, { y:stage.stageHeight - vn.height, time:1 } );	
		}

		public function onStageMouseOut( e:Event = null )
		{
			Tweener.addTween(vn, { y:stage.stageHeight, time:1 } );	
		}		
		
		public function onKeyboardDown( e:KeyboardEvent )
		{
			switch(e.keyCode)
			{
				case Keyboard.RIGHT:
					vc.jumpTime(1);
				break;
				case Keyboard.LEFT:
					vc.jumpTime(-3);
				break;
				case Keyboard.SPACE:
					handleVideoStatus();
				break;
			}
		}
		
		
		// .....................................................................................................
		
		
		public function vcOnClick( e:Event )
		{
			Tweener.addTween(this, { time:.4, onComplete:handleVideoStatus } );
		}
		
		public function vcOnDoubleClik( e:Event )
		{
			Tweener.removeTweens(this);
			
			switch(stage.displayState)
			{
				case StageDisplayState.NORMAL:
					stage.displayState = StageDisplayState.FULL_SCREEN;
				break;
				case StageDisplayState.FULL_SCREEN:
					stage.displayState = StageDisplayState.NORMAL;
				break;
			}
		}
		
		public function handleVideoStatus()
		{
			switch(vc.status)
			{
				case VideoController.PLAYING:
					vc.pause();
					Tweener.addTween(symbol_play, { alpha:1, scaleX:1, scaleY:1, time:1 } );
				break;
				case VideoController.PAUSED:
				case VideoController.STOPPED:
					vc.resume();
					Tweener.addTween(symbol_play, { alpha:0, scaleX:1.5, scaleY:1.5, time:1 } );
				break;
			}
		}		
		
	}
}