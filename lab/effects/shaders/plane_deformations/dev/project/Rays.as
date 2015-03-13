package  
{

	/**
	 * @author mrdoob
	 */
	[SWF(width="512",height="512",frameRate="60",backgroundColor="#000000")]

	public class Rays extends ShaderAbstract
	{
		private var image : String = "textures/disturb.jpg";
		private var shader : String = "shaders/rays.pbj";

		public function Rays() : void
		{
			super(image, shader);
		}
	}
}
