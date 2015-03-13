package com.mrdoob.tools.threedoob.renderers {	import com.mrdoob.tools.threedoob.core.Vector3D;		import com.mrdoob.tools.threedoob.cameras.Camera3D;
	import com.mrdoob.tools.threedoob.core.Matrix3D;
	import com.mrdoob.tools.threedoob.scenes.Scene3D;
	
	import flash.display.Sprite;	

	/**	 * @author mrdoob	 */	public class AbstractRenderer extends Sprite	{		protected static var view : Matrix3D = new Matrix3D();		protected static var projected : Vector3D = new Vector3D();		public function AbstractRenderer()		{			mouseEnabled = false;		}		public function sort(scene : Scene3D) : void		{		}			public function render( scene : Scene3D, camera : Camera3D ) : void		{		}	}}