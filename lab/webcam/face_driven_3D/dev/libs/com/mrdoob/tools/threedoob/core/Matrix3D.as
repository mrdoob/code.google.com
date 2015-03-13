package com.mrdoob.tools.threedoob.core 
{
	import com.mrdoob.tools.threedoob.core.Vector3D;	

	public class Matrix3D 
	{
		public var n11 : Number, n12 : Number, n13 : Number, n14 : Number;
		public var n21 : Number, n22 : Number, n23 : Number, n24 : Number;
		public var n31 : Number, n32 : Number, n33 : Number, n34 : Number;
		
		private var x : Vector3D, y : Vector3D, z : Vector3D;

		public function Matrix3D() 
		{
			identity( );
		}

		public function identity() : void 
		{
			n11 = 1; 
			n12 = 0; 
			n13 = 0; 
			n14 = 0;
			n21 = 0; 
			n22 = 1; 
			n23 = 0; 
			n24 = 0;
			n31 = 0; 
			n32 = 0; 
			n33 = 1; 
			n34 = 0;
			
			x = new Vector3D();
			y = new Vector3D();
			z = new Vector3D();
		}

		public function lookAt(eye : Vector3D, center : Vector3D, up : Vector3D) : void 
		{
			//var z : Vector3D = Vector3D.sub( center, eye );
			z.copy( center );
			z.sub( eye );
			z.normalize( );

			//var x : Vector3D = Vector3D.cross( z, up );
			x.copy(z);
			x.cross(up);
			x.normalize( );

			//var y : Vector3D = Vector3D.cross( x, z );
			y.copy(x);
			y.cross(z);
			y.normalize( );
			
			n11 = x.x; 
			n12 = x.y; 
			n13 = x.z; 
			n14 = -x.dot(eye); //-Vector3D.dot( x, eye ); // negated
			n21 = y.x; 
			n22 = y.y; 
			n23 = y.z; 
			n24 = -y.dot(eye); //-Vector3D.dot( y, eye );
			n31 = z.x; 
			n32 = z.y; 
			n33 = z.z; 
			n34 = -z.dot(eye); //-Vector3D.dot( z, eye );
		}

		public function transform(v : Vector3D) : void
		{
			var vx : Number = v.x, vy : Number = v.y, vz : Number = v.z;
			
			v.x = n11 * vx + n12 * vy + n13 * vz + n14;
			v.y = n21 * vx + n22 * vy + n23 * vz + n24;
			v.z = n31 * vx + n32 * vy + n33 * vz + n34;
		}

		public function transformVector(v : Vector3D) : void 
		{
			var vx : Number = v.x, vy : Number = v.y, vz : Number = v.z;

			v.x = n11 * vx + n12 * vy + n13 * vz;
			v.y = n21 * vx + n22 * vy + n23 * vz;
			v.z = n31 * vx + n32 * vy + n33 * vz;
		}

		public function multiply( a : Matrix3D, b : Matrix3D ) : void
		{
			var a11 : Number = a.n11; 
			var b11 : Number = b.n11;
			var a21 : Number = a.n21; 
			var b21 : Number = b.n21;
			var a31 : Number = a.n31; 
			var b31 : Number = b.n31;
			var a12 : Number = a.n12; 
			var b12 : Number = b.n12;
			var a22 : Number = a.n22; 
			var b22 : Number = b.n22;
			var a32 : Number = a.n32; 
			var b32 : Number = b.n32;
			var a13 : Number = a.n13; 
			var b13 : Number = b.n13;
			var a23 : Number = a.n23; 
			var b23 : Number = b.n23;
			var a33 : Number = a.n33; 
			var b33 : Number = b.n33;
			var a14 : Number = a.n14; 
			var b14 : Number = b.n14;
			var a24 : Number = a.n24; 
			var b24 : Number = b.n24;
			var a34 : Number = a.n34; 
			var b34 : Number = b.n34;

			this.n11 = a11 * b11 + a12 * b21 + a13 * b31;
			this.n12 = a11 * b12 + a12 * b22 + a13 * b32;
			this.n13 = a11 * b13 + a12 * b23 + a13 * b33;
			this.n14 = a11 * b14 + a12 * b24 + a13 * b34 + a14;

			this.n21 = a21 * b11 + a22 * b21 + a23 * b31;
			this.n22 = a21 * b12 + a22 * b22 + a23 * b32;
			this.n23 = a21 * b13 + a22 * b23 + a23 * b33;
			this.n24 = a21 * b14 + a22 * b24 + a23 * b34 + a24;

			this.n31 = a31 * b11 + a32 * b21 + a33 * b31;
			this.n32 = a31 * b12 + a32 * b22 + a33 * b32;
			this.n33 = a31 * b13 + a32 * b23 + a33 * b33;
			this.n34 = a31 * b14 + a32 * b24 + a33 * b34 + a34;
		}		        

		public function toString() : String
		{
			return 	"11: " + n11 + ", 12: " + n12 + ", 13: " + n13 + ", 14: " + n14 + "\n" +
					"21: " + n21 + ", 22: " + n22 + ", 23: " + n23 + ", 24: " + n24 + "\n" +
					"31: " + n31 + ", 32: " + n32 + ", 33: " + n33 + ", 34: " + n34;
		}
		
		// STATIC		

		public static function translationMatrix( x : Number, y : Number, z : Number ) : Matrix3D
		{
			var m : Matrix3D = new Matrix3D( );
			
			m.n14 = x;
			m.n24 = y;
			m.n34 = z;
			
			return m;
		}

		public static function scaleMatrix( x : Number, y : Number, z : Number ) : Matrix3D
		{
			var m : Matrix3D = new Matrix3D( );
			
			m.n11 = x;
			m.n22 = y;
			m.n33 = z;
			
			return m;
		}

		
		// Apply Rotation about X to Matrix
		public static function rotationXMatrix( theta : Number ) : Matrix3D
		{
			var rot : Matrix3D = new Matrix3D( );
			
			rot.n22 = rot.n33 = Math.cos( theta );
			rot.n32 = Math.sin( theta );
			rot.n23 = -rot.n32;
			
			return rot;
		}

		// Apply Rotation about Y to Matrix
		public static function rotationYMatrix( theta : Number ) : Matrix3D
		{
			var rot : Matrix3D = new Matrix3D( );
			
			rot.n11 = rot.n33 = Math.cos( theta );
			rot.n13 = Math.sin( theta );
			rot.n31 = -rot.n13;
			
			return rot;
		}

		// Apply Rotation about Z to Matrix
		public static function rotationZMatrix( theta : Number ) : Matrix3D
		{
			var rot : Matrix3D = new Matrix3D( );
			
			rot.n11 = rot.n22 = Math.cos( theta );
			rot.n21 = Math.sin( theta );
			rot.n12 = -rot.n21;
			
			return rot;
		}
		
		public static function rotationMatrix( ry : Number, rx : Number, rz : Number ) : Matrix3D
		{
			var sx : Number, sy : Number, sz : Number;
			var cx : Number, cy : Number, cz : Number;			

			sx = Math.sin(rx); sy = Math.sin(ry); sz = Math.sin(rz);
			cx = Math.cos(rx); cy = Math.cos(ry); cz = Math.cos(rz);

			var rot : Matrix3D = new Matrix3D( );

			rot.n11 = cx * cz - sx * sy * sz; rot.n12 = -cy * sz; rot.n13 = sx * cz + cx * sy * sz;
			rot.n21 = cx * sz + sx * sy * cz; rot.n22 = cy * cz; rot.n23 = sx * sz - cx * sy * cz;
			rot.n31 = -sx * cy; rot.n32 = sy; rot.n33 = cx * cy;
						
			return rot;
		}
		
		/*
 initEuler(Matrix4f m, float ry, rx, rz) {
      float cx,cy,cz;
      float sx,sy,sz;

      cx = cos(rx);
      cy = cos(ry);
      cz = cos(rz);
      sx = sin(rx);
      sy = sin(ry);
      sz = sin(rz);
      m = [cx*cz - sx*sy*sz , -cy*sz, sx*cz + cx*sy*sz, 0,
           cx*sz + sx*sy*cz , cy*cz , sx*sz - cx*sy*cz, 0,
           -sx*cy           , sy    , cx*cy           , 0,
           0                , 0     , 0               , 1
      ];
   }
    */		
		      
	}
}