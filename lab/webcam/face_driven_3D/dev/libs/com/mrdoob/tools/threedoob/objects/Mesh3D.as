package com.mrdoob.tools.threedoob.objects 
{
	import com.mrdoob.tools.threedoob.core.Geometry3D;
	import com.mrdoob.tools.threedoob.core.Matrix3D;
	import com.mrdoob.tools.threedoob.materials.Material3D;	

	public class Mesh3D extends DisplayObject3D
	{
		public var geometry : Geometry3D;
		public var material : Material3D;
		public var scale : Number = 1;
		
		public var transform : Matrix3D = new Matrix3D();
		public var rotationX : Number = 0, rotationY : Number = 0, rotationZ : Number = 0;
		
		public function Mesh3D( geometry : Geometry3D, material : Material3D = null )
		{
			this.geometry = geometry;
			this.material = material;
			
			visible = true;
		}
		
		public function updateTransform() : void
		{
			transform = Matrix3D.translationMatrix(x, y, z);
			
			//transform.multiply( transform, Matrix3D.rotationXMatrix( rotationX ) );
			//transform.multiply( transform, Matrix3D.rotationYMatrix( rotationY ) );
			//transform.multiply( transform, Matrix3D.rotationZMatrix( rotationZ ) );
			
			transform.multiply( transform, Matrix3D.rotationMatrix( rotationX, rotationY, rotationZ ) );
			
			transform.multiply( transform, Matrix3D.scaleMatrix( scale, scale, scale ) );
		
		}
	}
}