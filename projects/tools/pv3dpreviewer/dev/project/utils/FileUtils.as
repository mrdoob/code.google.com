package utils
{

	public class FileUtils
	{
		public static function getFileType(_file : String) : String
		{
			var file : Array = _file.split('.');
			return '.' + file[file.length - 1];
		}
	}
}
