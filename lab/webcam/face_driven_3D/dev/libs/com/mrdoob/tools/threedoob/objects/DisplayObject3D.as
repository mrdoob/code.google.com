package com.mrdoob.tools.threedoob.objects {	import com.mrdoob.tools.threedoob.core.Vector3D;
	import flash.display.DisplayObject;
	import flash.display.Sprite;	
	/**	 * @author mrdoob	 */	public class DisplayObject3D extends Vector3D
	{
		public var content : DisplayObject;
		public var container : Sprite;		public var layer : int = 0;
		public var scaleX : Number = 1, scaleY : Number = 1, scaleZ : Number = 1;		public function DisplayObject3D(source : DisplayObject = null)
		{
			container = new Sprite( );
			container.mouseEnabled = false;
			
			if (source)
				container.addChild( content = source );							visible = false;
		}
		public function set visible(value : Boolean) : void
		{
			container.visible = value;
		}
		public function get visible() : Boolean
		{
			return container.visible;
		}
		public function unload() : void
		{			if (content)
				container.removeChild( content );				
			container = null;			content = null;		}
	}}