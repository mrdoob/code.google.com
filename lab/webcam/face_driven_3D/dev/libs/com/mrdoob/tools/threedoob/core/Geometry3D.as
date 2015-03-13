package com.mrdoob.tools.threedoob.core 
{

	/**
	 * @author rcabello
	 */
	public class Geometry3D 
	{
		public var vertices : Array = new Array();
		public var triangles : Array = new Array();

		public function flipNormals() : void 
		{        
			var triangle : Triangle3D;
		        
			for(var i : Number = 0;i < triangles.length; i++) 
			{
				triangle = triangles[i];
		                
				var tmpVertex : Vertex3D = triangle.a;
				triangle.a = triangle.b;
				triangle.b = tmpVertex;
				
				if (triangle.uv)
				{
					var tmpUV : Object = triangle.uv[0];
					triangle.uv[0] = triangle.uv[1];
					triangle.uv[1] = tmpUV;
				}
			}
		}
	}
}
