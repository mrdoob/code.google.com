package  
{

	/**
	 * @author mrdoob
	 */
	[SWF(width="512",height="512",frameRate="60",backgroundColor="#000000")]

	public class Tunnel4 extends ShaderAbstract
	{
		private var image : String = "textures/disturb.jpg";
		private var shader : String = "shaders/tunnel4.pbj";

		public function Tunnel4() : void
		{
			super(image, shader);
		}
	}
}
