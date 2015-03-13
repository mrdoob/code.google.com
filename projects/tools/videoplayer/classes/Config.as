package
{
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;	
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;	
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	
	public class Config
	{
		
		public static var cm				:ContextMenu;
		
		private static var projectName		:String = "Mr.doob's videoplayer";
		private static var projectLink		:String = "http://code.google.com/p/mrdoob/wiki/videoplayer";
		private static var projectVer		:String = "1.0";
		
		
		public static function setup( target:Sprite )
		{
			
			// CONFIG STAGE
			target.stage.align = StageAlign.TOP_LEFT;
			target.stage.scaleMode = StageScaleMode.NO_SCALE;		
			
			// CONTEXT MENU SETUP
			cm = new ContextMenu();
			cm.hideBuiltInItems();
			target.contextMenu = cm;
			
			// CONTEXT MENU: INFO
			var cmiInfo:ContextMenuItem = new ContextMenuItem( projectName + " " + projectVer);
			cmiInfo.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e) { navigateToURL(new URLRequest(projectLink), "_blank") } );
			cm.customItems.push(cmiInfo);
			
		}
	}
}