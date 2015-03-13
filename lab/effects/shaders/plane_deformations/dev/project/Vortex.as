package  
{

	/**
	 * @author mrdoob
	 */
	[SWF(width="512",height="512",frameRate="60",backgroundColor="#000000")]

	public class Vortex extends ShaderAbstract
	{
		private var image : String = "textures/disturb2.jpg";
		private var shader : String = "shaders/vortex.pbj";

		public function Vortex() : void
		{
			super(image, shader);
		}		
	}
}
