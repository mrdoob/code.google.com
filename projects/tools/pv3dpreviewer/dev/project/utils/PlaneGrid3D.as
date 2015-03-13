package utils
{	
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.materials.special.LineMaterial;	

	public class PlaneGrid3D extends Lines3D
	{
		public function PlaneGrid3D() : void
		{
			var i : int = 0;
			var xx : Number = 0;
			var yy : Number = 0;
			var dist : Number = 80;
			
			var v1 : Vertex3D;
			var v2 : Vertex3D;
			var l : Line3D;
			var lm : LineMaterial = new LineMaterial(0xFFFFFF, .5);
			
			super(lm);
			
			for (i = 0;i < 11; i++)
			{
				v1 = new Vertex3D(i * dist, 0, 0);
				v2 = new Vertex3D(i * dist, 0, 10 * dist);
				l = new Line3D(this, lm, 1, v1, v2);
				addLine(l);
			}
			
			for (i = 0;i < 11; i++)
			{
				v1 = new Vertex3D(0, 0, i * dist);
				v2 = new Vertex3D(10 * dist, 0, i * dist);
				l = new Line3D(this, lm, 1, v1, v2);
				addLine(l);
			}
			
			x = -400;
			z = -400;
		}		
	}
}