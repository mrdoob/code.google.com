package  
{

	/**
	 * @author mrdoob
	 */
	[SWF(width="512",height="512",frameRate="60",backgroundColor="#000000")]

	public class Rays2 extends ShaderAbstract
	{
		private var image : String = "textures/disturb2.jpg";
		private var shader : String = "shaders/rays2.pbj";

		public function Rays2() : void
		{
			super(image, shader);
		}
	}
}
