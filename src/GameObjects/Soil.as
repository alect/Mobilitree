package GameObjects
{
	import Utils.*;
	
	public class Soil extends CellObject
	{
		public function Soil(x:Number, y:Number)
		{
			super(x, y, ResourceManager.soilArt);
			_type = Globals.SOIL_TYPE;
		}
	}
}