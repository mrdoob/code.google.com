package com.mrdoob.tools.threedoob.objects.primitives 
{
	import com.mrdoob.tools.threedoob.core.Geometry3D;
	import com.mrdoob.tools.threedoob.core.Triangle3D;
	import com.mrdoob.tools.threedoob.core.Vertex3D;	

	/**
	 * @author rcabello
	 * 
	 * Adapted from Papervision3D's Plane
	 */
	
	public class Plane extends Geometry3D 
	{
		public var segmentsW : Number;
		public var segmentsH : Number;

		public function Plane( width : Number = 0, height : Number = 0, segmentsW : Number = 0, segmentsH : Number = 0 )
		{
			this.segmentsW = segmentsW;
			this.segmentsH = segmentsH;
			buildPlane(width, height);
		}

		private function buildPlane( width : Number, height : Number ) : void
		{
			var gridX : Number = this.segmentsW;
			var gridY : Number = this.segmentsH;
			var gridX1 : Number = gridX + 1;
			var gridY1 : Number = gridY + 1;

			var textureX : Number = width / 2;
			var textureY : Number = height / 2;

			var iW : Number = width / gridX;
			var iH : Number = height / gridY;

			// Points
			for( var ix : int = 0;ix < gridX1; ix++ )
			{
				for( var iy : int = 0;iy < gridY1; iy++ )
				{
					var x : Number = ix * iW - textureX;
					var y : Number = iy * iH - textureY;

					vertices.push(new Vertex3D(x, y, 0));
				}
			}

			// Triangles
			var uvA : Object;
			var uvC : Object;
			var uvB : Object;

			for(  ix = 0;ix < gridX; ix++ )
			{
				for(  iy = 0;iy < gridY; iy++ )
				{
					// Triangle A
					var a : Vertex3D = vertices[ ix * gridY1 + iy     ];
					var c : Vertex3D = vertices[ ix * gridY1 + (iy + 1) ];
					var b : Vertex3D = vertices[ (ix + 1) * gridY1 + iy     ];

					uvA = {u : ix / gridX, v: iy / gridY };
					uvC = {u : ix / gridX, v: (iy + 1) / gridY };
					uvB = {u : (ix + 1) / gridX, v: iy / gridY };

					triangles.push(new Triangle3D(a, b, c, [uvA, uvB, uvC]));

					// Triangle B
					a = vertices[ (ix + 1) * gridY1 + (iy + 1) ];
					c = vertices[ (ix + 1) * gridY1 + iy     ];
					b = vertices[ ix * gridY1 + (iy + 1) ];

					uvA = {u : (ix + 1) / gridX, v: (iy + 1) / gridY };
					uvC = {u : (ix + 1) / gridX, v: iy / gridY };
					uvB = {u : ix / gridX, v: (iy + 1) / gridY };
                                
					triangles.push(new Triangle3D(a, b, c, [uvA, uvB, uvC]));
				}
			}
		}			
	}
}
