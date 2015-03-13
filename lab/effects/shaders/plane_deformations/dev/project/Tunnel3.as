package  
{

	/**
	 * @author mrdoob
	 */
	[SWF(width="512",height="512",frameRate="60",backgroundColor="#000000")]

	public class Tunnel3 extends ShaderAbstract
	{
		private var image : String = "textures/gold.jpg";
		private var shader : String = "shaders/tunnel3.pbj";

		public function Tunnel3() : void
		{
			super(image, shader);
		}
	}
}
