package  
{
	/**
	 * @author mrdoob
	 */
	[SWF(width="512",height="512",frameRate="60",backgroundColor="#000000")]
	public class Sphere extends ShaderAbstract
	{
		private var image : String = "textures/gold.jpg";
		private var shader : String = "shaders/sphere.pbj";

		public function Sphere() : void
		{
			super(image, shader);
		}
	}
}
