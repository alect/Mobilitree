package GameObjects
{
	import GameStates.PlayState;
	
	import Utils.*;
	
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	/**
	 * Main class from which all the objects that can occupy cells inherit
	 * (examples include the player tree and wind etc.) 
	 * Might be a good idea to make a normal FlxTilemap inherit form this class 
	 * so objects that don't move (such as water) can also "update"
	 */ 
	public class CellObject extends FlxSprite
	{
		
		// The value identifying the type of cell object
		protected var _type:uint;
		
		public function get type():uint
		{
			return _type;
		}
		
		public function CellObject(x:Number, y:Number, graphic:Class) 
		{
			super(x, y, graphic);
		}

		public function advanceTurn():void
		{
			// TODO: Implement code to advance the turn	
		}
		
		public function doneAdvancingTurn():Boolean
		{
			return true;
		}
		
		public function get gridX():uint
		{
			return (uint)((this.x-PlayState.Instance.Tilemap.x)/Globals.TILE_SIZE);
		}
		
		public function get gridY():uint
		{
			return (uint)((this.y-PlayState.Instance.Tilemap.y)/Globals.TILE_SIZE);
		}
		
		public function timeToAdvanceTurn():Boolean
		{
			return false;
		}
		
		public function gameWon():Boolean
		{
			return true;
		}
		
		protected static function cellSuitableForSeed(cell:uint):Boolean
		{
			return (cell == Globals.EMPTY_TYPE || cell == Globals.SOIL_TYPE || cell >= Globals.WATER_TYPE && cell <= Globals.WATER_LEFT_TYPE);
		}
		
		public override function update():void
		{
			if(pathSpeed == 0)
				this.velocity = new FlxPoint();
			super.update();
		}
		
		public function isAvatar():Boolean
		{
			return false;
		}
	}
}
