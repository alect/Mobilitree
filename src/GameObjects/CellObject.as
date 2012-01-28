package GameObjects
{
	/**
	 * Main class from which all the objects that can occupy cells inherit
	 * (examples include the player tree and wind etc.) 
	 * Might be a good idea to make a normal FlxTilemap inherit form this class 
	 * so objects that don't move (such as water) can also "update"
	 */ 
	public class CellObject
	{
		public function CellObject()
		{
		}
		
		public function advanceTurn():void
		{
			// TODO: Implement code to advance the turn	
		}
	}
}