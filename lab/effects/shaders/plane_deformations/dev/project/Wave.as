package  
{

	/**
	 * @author mrdoob
	 */
	[SWF(width="512",height="512",frameRate="60",backgroundColor="#000000")]

	public class Wave extends ShaderAbstract
	{
		private var image : String = "textures/disturb.jpg";
		private var shader : String = "shaders/waves.pbj";

		public function Wave() : void
		{
			super(image, shader);
		}
	}
}
