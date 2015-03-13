package  
{

	/**
	 * @author mrdoob
	 */
	[SWF(width="512",height="512",frameRate="60",backgroundColor="#000000")]

	public class Tunnel2 extends ShaderAbstract
	{
		private var image : String = "textures/disturb.jpg";
		private var shader : String = "shaders/tunnel2.pbj";

		public function Tunnel2() : void
		{
			super(image, shader);
		}
	}
}
