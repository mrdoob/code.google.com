package  
{
	/**
	 * @author mrdoob
	 */
	[SWF(width="512",height="512",frameRate="60",backgroundColor="#000000")]
	public class Hypno extends ShaderAbstract
	{
		private var image : String = "textures/disturb2.jpg";
		private var shader : String = "shaders/hypno.pbj";

		public function Hypno() : void
		{
			super(image, shader);
		}
	}
}
