package com.mrdoob.tools.threedoob.objects {	import com.mrdoob.tools.threedoob.utils.DofTexture;
	
	import flash.display.Bitmap;		

	/**	 * @author mrdoob	 */	public class BitmapDof3D extends Bitmap3D	{		private var texture : DofTexture;		public function BitmapDof3D(images_array : DofTexture, smooth : Boolean = false)		{			super(images_array.images[0], smooth);			texture = images_array;		}		public function setBlur(level : Number) : void		{			level = (level > 1) ? 1 : level;			level = (level < 0) ? 0 : level;			bitmap.bitmapData = texture.images[level * (texture.levels - 1) << 0];		}	}}