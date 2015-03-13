package com.mrdoob.tools.threedoob.core {

	/**
	 * @author rcabello
	 */
	public class Vertex3D extends Vector3D
	{
		public var nx : Number, ny : Number, nz : Number;
		public var u : Number, v : Number;
		public var color : uint, alpha : Number;

		public var visible : Boolean;

		public function Vertex3D( x : Number, y : Number , z : Number) 
		{
			super(x,y,z);
		}
	}
}
