package com.mrdoob.tools.threedoob.events {
	import flash.events.Event;			/**
	 * @author Mr.doob
	 */
	public class Scene3DEvent extends Event	{		public static var DISPLAYOBJECT3D_ADDED : String = "com.mrdoob.tools.threedoob.events.SceneEvent.displayobject3d_added";		public static var DISPLAYOBJECT3D_REMOVED : String = "com.mrdoob.tools.threedoob.events.SceneEvent.displayobject3d_removed";				private var _item : *; 						public function Scene3DEvent(type : String, item : *)		{			this.item = item;			super(type, false, true);		}						override public function clone() : Event		{			return new Scene3DEvent(type, item);		}				public function set item(item : *) : void		{			_item = item;		}				public function get item() : *		{			return _item;		}		
	}
}
