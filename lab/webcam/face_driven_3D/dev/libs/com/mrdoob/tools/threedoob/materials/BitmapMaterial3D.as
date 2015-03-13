package com.mrdoob.tools.threedoob.materials 
{
	import flash.display.BitmapData;		
	/**
	 * @author rcabello
	 */
	public class BitmapMaterial3D extends Material3D
	{
		public var smoothing : Boolean;
		
		public function BitmapMaterial3D( bitmap : BitmapData, smoothing : Boolean = false ) : void
		{
			this.bitmap = bitmap;
			this.smoothing = smoothing;
		}
	}
}
