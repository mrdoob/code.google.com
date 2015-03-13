package com.mrdoob.tools.threedoob.renderers 
{
	import com.mrdoob.tools.threedoob.cameras.Camera3D;
	import com.mrdoob.tools.threedoob.core.Vector3D;
	import com.mrdoob.tools.threedoob.objects.Bitmap3D;
	import com.mrdoob.tools.threedoob.objects.BitmapDof3D;
	import com.mrdoob.tools.threedoob.objects.DisplayObject3D;
	import com.mrdoob.tools.threedoob.scenes.Scene3D;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;	

	public class BitmapRenderer extends AbstractRenderer
	{
		private var bitmap : Bitmap;
		private var bitmapdata : BitmapData;
		private var backgroundColor : int;
		
		private var p : Point = new Point();
		private var mtx : Matrix = new Matrix();
		public function BitmapRenderer( width : int, height : int, backgroundColor : int = 0x000000 )
		{
			super();
			bitmap = new Bitmap(bitmapdata);
			setViewport(width, height, backgroundColor);
		}

		public function getBitmapData() : BitmapData
		{
			return bitmapdata;
		}

		public function setViewport( width : int, height : int, backgroundColor : int = 0x000000 ) : void
		{
			if (bitmapdata)
				bitmapdata.dispose();

			this.backgroundColor = backgroundColor;
				
			bitmapdata = new BitmapData(width, height, false, backgroundColor);
			bitmap.bitmapData = bitmapdata;
			bitmap.x = -bitmap.width >> 1;
			bitmap.y = -bitmap.height >> 1;
			addChild(bitmap);			
		}
		public override function sort(scene : Scene3D) : void
		{
			for (var i : int = 0;i < scene.objects.length; i++)
			{
				var object : Bitmap3D = scene.objects[i];
				object.sz = object.x * view.n31 + object.y * view.n32 + object.z * view.n33 + view.n34;
			}
			
			scene.objects.sortOn("sz", Array.DESCENDING | Array.NUMERIC);
		}
		public override function render(scene : Scene3D, camera : Camera3D) : void
		{
			var focus : Number = camera.focus;
			var focuszoom : Number = camera.focus * camera.zoom;	

			view.lookAt(camera, camera.target, camera.up);			

			bitmapdata.lock();
			bitmapdata.fillRect(bitmapdata.rect, backgroundColor);

			for (var i : int = 0;i < scene.objects.length; i++)
			{
				if (scene.objects[i] is Bitmap3D)
				{
					var object : Bitmap3D = scene.objects[i];
					
					if (focus + object.sz > 0)
					{
						var ow : Number = focuszoom / (focus + object.sz);
	
						p.x = (object.x * view.n11 + object.y * view.n12 + object.z * view.n13 + view.n14) * ow;
						p.y = (object.x * view.n21 + object.y * view.n22 + object.z * view.n23 + view.n24) * -ow;

						mtx.identity();
						mtx.translate( -object.bitmap.bitmapData.width / 2, -object.bitmap.bitmapData.height / 2);
						mtx.rotate(object.bitmap.rotation * 0.017453292519943295);
						mtx.scale(ow * object.scaleX, ow * object.scaleY);
						
						mtx.translate(
										p.x + (bitmapdata.width >> 1) ,
										p.y + (bitmapdata.height >> 1)
									);

						if (scene.objects[i] is BitmapDof3D )
							scene.objects[i].setBlur( Math.abs( 4 - ow ) * 0.02 );							
						
						bitmapdata.draw(object.bitmap.bitmapData, mtx);
					}					
				}				
			}
			
			bitmapdata.unlock();
		}		
	}
}
