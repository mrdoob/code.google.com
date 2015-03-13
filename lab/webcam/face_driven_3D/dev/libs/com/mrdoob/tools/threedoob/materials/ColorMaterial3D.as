package com.mrdoob.tools.threedoob.materials 
{
	import flash.display.BitmapData;		
	/**
	 * @author rcabello
	 */
	public class ColorMaterial3D extends Material3D
	{
		public function ColorMaterial3D( color : uint ) : void
		{
			bitmap = new BitmapData(10, 10, false, color); 
		}
	}
}
