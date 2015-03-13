package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;	

	public class Config
	{
		public static var cm : ContextMenu;
		private static var projectName : String = "PV3D Previewer";
		private static var projectVer : String = "1.3";
		private static var projectURL : String = "http://code.google.com/p/mrdoob/";

		public static function setup( target : Sprite ) : void
		{
			// CONFIG STAGE
			target.stage.align = StageAlign.TOP_LEFT;
			target.stage.scaleMode = StageScaleMode.NO_SCALE;
			target.stage.quality = StageQuality.MEDIUM;
			
			// CONTEXT MENU SETUP
			cm = new ContextMenu();
			cm.hideBuiltInItems();
			target.contextMenu = cm;
			
			// CONTEXT MENU: INFO
			var cmiInfo : ContextMenuItem = new ContextMenuItem(projectName + " " + projectVer);
			cmiInfo.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e : Event) : void 
			{ 
				navigateToURL(new URLRequest(projectURL), "_blank"); 
			});
			cm.customItems.push(cmiInfo);
		}
	}
}