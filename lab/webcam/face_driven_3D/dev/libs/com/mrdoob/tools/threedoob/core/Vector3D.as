package com.mrdoob.tools.threedoob.core 
{
	public class Vector3D 
	{
		public var x : Number, y : Number, z : Number;
		public var sx : Number, sy : Number, sz : Number;
		public var userData : Object = new Object();
		
		private var dx : Number, dy : Number, dz : Number;
		private var tx : Number, ty : Number, tz : Number;
		private var ool : Number;
		public function Vector3D(x : Number = 0, y : Number = 0, z : Number = 0) 
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}

		public function copy( v : Vector3D ) : void
		{
			x = v.x; y = v.y; z = v.z;
		}
		
		public function add(v : Vector3D) : void
		{
			x += v.x; y += v.y; z += v.z; 
		}

		public function sub(v : Vector3D) : void 
		{
			x -= v.x; y -= v.y; z -= v.z;
		}		

		public function cross(v : Vector3D) : void 
		{
			tx = x; ty = y; tz = z;
			
			x = ty * v.z - tz * v.y;
			y = tz * v.x - tx * v.z;
			z = tx * v.y - ty * v.x;
		}
		
		public function multiply(s : Number) : void 
		{
			x *= s; y *= s; z *= s;
		}		
				public function distanceTo( v : Vector3D ) : Number 		{
			dx = x - v.x;
			dy = y - v.y;
			dz = z - v.z;

			return Math.sqrt( dx * dx + dy * dy + dz * dz );
		}				public function distanceToSquared( v : Vector3D ) : Number 		{
			dx = x - v.x;
			dy = y - v.y;
			dz = z - v.z;

			return dx * dx + dy * dy + dz * dz;
		}
		public function length() : Number 
		{
			return Math.sqrt( x * x + y * y + z * z );
		}
		public function lengthSq() : Number 
		{
			return x * x + y * y + z * z;
		}
		public function negate() : void 
		{
			x = -x; y = -y; z = -z;
		}
		public function normalize() : Vector3D 
		{
			ool = 1.0 / length( );
			x *= ool;
			y *= ool;
			z *= ool;
			return this;
		}

		public function dot(v : Vector3D) : Number 
		{
			return x * v.x + y * v.y + z * v.z;
		}
		
		public function clone() : Vector3D 
		{
			return new Vector3D( x, y, z );
		}		
		public function toString() : String 
		{
			return "(" + x + ", " + y + ", " + z + ")";
		}
		
		// Static
		public static function add(a : Vector3D, b : Vector3D) : Vector3D 
		{
			return new Vector3D( a.x + b.x, a.y + b.y, a.z + b.z );
		}
		public static function sub(a : Vector3D, b : Vector3D) : Vector3D 
		{
			return new Vector3D( a.x - b.x, a.y - b.y, a.z - b.z );
		}		

		public static function multiply(a : Vector3D, s : Number) : Vector3D 
		{
			return new Vector3D( a.x * s, a.y * s, a.z * s );
		}
				public static function cross(a : Vector3D, b : Vector3D) : Vector3D 
		{
			return new Vector3D( a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x );
		}
		public static function dot(a : Vector3D, b : Vector3D) : Number 
		{
			return a.x * b.x + a.y * b.y + a.z * b.z;
		}
		
	}
}