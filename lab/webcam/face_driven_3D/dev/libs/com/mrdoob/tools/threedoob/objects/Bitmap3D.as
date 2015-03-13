package com.mrdoob.tools.threedoob.objects 
{	import flash.display.Bitmap;	import flash.display.BitmapData;		/**	 * @author mrdoob	 */	public class Bitmap3D extends DisplayObject3D
	{
		public var bitmap : Bitmap;

		public function Bitmap3D(texture : BitmapData, smooth : Boolean = false)
		{
			container.mouseChildren = false;
			bitmap = new Bitmap(texture, "auto", smooth);
			container.addChild(bitmap);
		}
	}}