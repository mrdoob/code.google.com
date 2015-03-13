package  
{
	import flash.geom.Rectangle;	
	import flash.display.Bitmap;
	import flash.display.BitmapData;	

	/**
	 * @author mrdoob
	 */
	public class Screen extends Bitmap 
	{
		public function Screen(w : int, h : int)
		{
			var rect : Rectangle = new Rectangle(0, 0, w, 1);
			var bd : BitmapData = new BitmapData(w, h, false, 0x000000);
			
			for (var i : int = 0; i < bd.height; i+=2)
			{
				rect.y = i;
				bd.fillRect(rect, 0xffffff);
			}
			
			super(bd, "auto", true);
		}
	}
}
