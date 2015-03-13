package  
{
	/**
	 * @author mrdoob
	 */
	[SWF(width="512",height="512",frameRate="60",backgroundColor="#000000")]
	public class Planes extends ShaderAbstract
	{
		private var image : String = "textures/rocks.jpg";
		private var shader : String = "shaders/planes.pbj";

		public function Planes() : void
		{
			super(image, shader);
		}
	}
}
