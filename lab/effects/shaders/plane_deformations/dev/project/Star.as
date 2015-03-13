package  
{

	/**
	 * @author mrdoob
	 */
	[SWF(width="512",height="512",frameRate="60",backgroundColor="#000000")]

	public class Star extends ShaderAbstract
	{
		private var image : String = "textures/clouds.jpg";
		private var shader : String = "shaders/star.pbj";

		public function Star() : void
		{
			super(image, shader);
		}
	}
}
