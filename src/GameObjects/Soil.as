package GameObjects
{
	import Utils.*;
	import GameStates.PlayState;
	
	public class Soil extends CellObject
	{
		public function Soil(x:Number, y:Number)
		{
			super(x, y, null);
			_type = Globals.SOIL_TYPE;
		}
		
		public override function gameWon():Boolean
		{
			// Want to know if we currently house a tree
			return PlayState.Instance.getGridCellType(gridX, gridY) == Globals.HAPPY_TREE_TYPE;
		}
		public override function draw():void
		{
			
		}
	}
}