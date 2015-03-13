package com.mrdoob.tools.threedoob.materials 
{

	/**
	 * @author rcabello
	 */
	public class WireframeMaterial3D extends Material3D
	{
		public var color : uint;
		
		public function WireframeMaterial3D( color : uint ) : void
		{
			this.color = color; 
		}
	}
}
