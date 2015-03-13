package com.mrdoob.tools.threedoob.core 
{

	/**
	 * @author rcabello
	 */
	public class Triangle3D 
	{
		public var a : Vertex3D, b : Vertex3D, c : Vertex3D;
		
		public var uv : Array;
		public var normal : Vector3D;		
		
		//public var uvMatrx : Matrix = new Matrix();
		public var sz : Number = 0;

		public function Triangle3D(a : Vertex3D, b : Vertex3D, c : Vertex3D, uv : Array = null, normal : Vector3D = null ) 
		{
			this.a = a;
			this.b = b;
			this.c = c;
			
			this.uv = uv;
			this.normal = normal;			
		}		
	}
}
