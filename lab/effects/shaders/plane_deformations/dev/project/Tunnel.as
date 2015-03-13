package  
{

	/**
	 * @author mrdoob
	 */
	[SWF(width="512",height="512",frameRate="60",backgroundColor="#000000")]

	public class Tunnel extends ShaderAbstract
	{
		private var image : String = "textures/metal.jpg";
		private var shader : String = "shaders/tunnel.pbj";

		public function Tunnel() : void
		{
			super(image, shader);
		}
	}
}
