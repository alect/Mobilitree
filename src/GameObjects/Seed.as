package GameObjects
{
	import GameStates.PlayState;
	
	import Utils.*;
	
	import org.flixel.FlxSound;
	import org.flixel.FlxTilemap;

	public class Seed extends CellObject
	{
		// We don't want the seed to have a turn the moment it's spawned, so we use this flag
		private var _canHaveTurn:Boolean;
		private var _growing:Boolean;
		private var _id:uint;
		
		protected static var _seedGrowthSound:FlxSound = new FlxSound();
		_seedGrowthSound.loadEmbedded(ResourceManager.seedGrowingSound);
		_seedGrowthSound.volume = 0.3;
		
		protected static var _happyTreeGrowSound:FlxSound = new FlxSound();
		_happyTreeGrowSound.loadEmbedded(ResourceManager.happyTreeGrowingSound);
		
		public function Seed(x:Number, y:Number, id:uint)
		{
			super(x, y, null);
			this.loadGraphic(ResourceManager.seedArt, true, false, Globals.TILE_SIZE);
			this.addAnimation("grow", [0, 1, 2, 3, 4], 3, false);
			this.addAnimation("goldGrow", [5, 6, 7, 8, 9], 3, false);
			this.addAnimation("cactusGrow", [10, 11, 12, 13, 14], 3, false);
			this.addAnimation("idle", [0], 6, true);
			
			_type = Globals.SEED_TYPE;
			_canHaveTurn = false;
			_growing = false;
			_id = id;
			this.play("idle");
		}
		
		
		public static function couldGrowAt(grid_x:uint, grid_y:uint):Boolean
		{
			// If we're on top of water
			var tile:uint = PlayState.Instance.Tilemap.getTile(grid_x, grid_y);
			if(tile >= Globals.WATER_TYPE && tile <= Globals.WATER_END)
				return false;
			else
				return true;
			
		}

		
		public override function advanceTurn():void 
		{
			if(!_canHaveTurn) {
				_canHaveTurn = true;
				return;
			}
			
			// If we're on top of water
			var tile:uint = PlayState.Instance.Tilemap.getTile(gridX, gridY);
			
			if(tile >= Globals.WATER_TYPE && tile <= Globals.WATER_END) 
			{
				if(tile == Globals.WATER_UP_TYPE && cellSuitableForSeed(PlayState.Instance.getGridCellType(gridX, gridY-1)))
					PlayState.Instance.moveCell(this, gridX, gridY-1);
				else if(tile == Globals.WATER_RIGHT_TYPE && cellSuitableForSeed(PlayState.Instance.getGridCellType(gridX+1, gridY)))
					PlayState.Instance.moveCell(this, gridX+1, gridY);
				else if(tile == Globals.WATER_DOWN_TYPE && cellSuitableForSeed(PlayState.Instance.getGridCellType(gridX, gridY+1)))
					PlayState.Instance.moveCell(this, gridX, gridY+1);
				else if(tile == Globals.WATER_LEFT_TYPE && cellSuitableForSeed(PlayState.Instance.getGridCellType(gridX-1, gridY)))
					PlayState.Instance.moveCell(this, gridX-1, gridY);
			}
			else {
			// TODO: the actual code for a seed's turn
			// Need to check if we're on solid ground before doing this but...
				// The moment we begin growing, become a tree in essence
				_type = Globals.TREE_TYPE;
				PlayState.Instance.replaceCell(this, this);
				if(PlayState.Instance.Tilemap.getTile(gridX, gridY) == Globals.SOIL_TYPE) {
					this.play("goldGrow");
					_happyTreeGrowSound.play();
				}
				else if(PlayState.Instance.Tilemap.getTile(gridX, gridY) == Globals.SAND_TYPE) {
					this.play("cactusGrow");
					_seedGrowthSound.play();
				}
				else {
					this.play("grow");
					_seedGrowthSound.play();
				}
				
				_growing = true;
			}
		}
		
		public override function timeToAdvanceTurn():Boolean
		{
			// seeds advance the turn automatically if they can move
			return canMove();
		}
		
		public override function canMove():Boolean
		{
			var tile:uint = PlayState.Instance.Tilemap.getTile(gridX, gridY);
			if(tile >= Globals.WATER_TYPE && tile <= Globals.WATER_END)
			{
				if(tile == Globals.WATER_UP_TYPE && !cellSuitableForSeed(PlayState.Instance.getGridCellType(gridX, gridY-1)))
					return false;
				else if(tile == Globals.WATER_RIGHT_TYPE && !cellSuitableForSeed(PlayState.Instance.getGridCellType(gridX+1, gridY)))
					return false;
				else if(tile == Globals.WATER_DOWN_TYPE && !cellSuitableForSeed(PlayState.Instance.getGridCellType(gridX, gridY+1)))
					return false;
				else if(tile == Globals.WATER_LEFT_TYPE && !cellSuitableForSeed(PlayState.Instance.getGridCellType(gridX-1, gridY)))
					return false;
			}
			return true;
		}
		
		public override function doneAdvancingTurn():Boolean 
		{
			// if we're done growing, replace ourselves with a tree and return true
			if(_growing) {
				if(this.frame == 4 || this.frame == 9 || this.frame == 14)  {
					return true;
				}
				return false;
			}
			// don't end if we're moving
			if(pathSpeed != 0) 
				return false;
			
			return true;
		}
		
		public override function postTurn():void
		{
			if(_growing) {
				// See if we want to transform any neighboring water cells into dirt
				// If we're on sand anyways
				if(PlayState.Instance.Tilemap.getTile(gridX, gridY) == Globals.SAND_TYPE) {
				
					maybeDrainWater(gridX-1, gridY);
					maybeDrainWater(gridX+1, gridY);
					maybeDrainWater(gridX, gridY-1);
					maybeDrainWater(gridX, gridY+1);
					PlayState.Instance.replaceCell(this, new Cactus(this.x, this.y, 3, _id));
				}
				else if(PlayState.Instance.Tilemap.getTile(gridX, gridY) == Globals.SOIL_TYPE)
					PlayState.Instance.replaceCell(this, new HappyTree(this.x, this.y, _id));
				else
					PlayState.Instance.replaceCell(this, new Tree(this.x, this.y, 3, _id));
			}
		}
		
		private function maybeDrainWater(waterX:int, waterY:int):void
		{
			var tilemap:FlxTilemap = PlayState.Instance.Tilemap;
			// First check if the given tile is even a water tile or on the tilemap
			if (waterX < 0 || waterX >= tilemap.widthInTiles ||
				waterY < 0 || waterY >= tilemap.heightInTiles )
				return;
			var tile:uint = tilemap.getTile(waterX, waterY);
			if(tile < Globals.WATER_TYPE || tile > Globals.WATER_END)
				return;
			
			// Okay, we have a hit, let's figure out what it is
			var dirt:Dirt;
			var dirtX:Number = tilemap.x+waterX*Globals.TILE_SIZE;
			var dirtY:Number = tilemap.y+waterY*Globals.TILE_SIZE;
			if(tile == Globals.WATER_UP_TYPE)
				dirt = new Dirt(dirtX, dirtY, UP);
			if(tile == Globals.WATER_RIGHT_TYPE)
				dirt = new Dirt(dirtX, dirtY, RIGHT);
			if(tile == Globals.WATER_DOWN_TYPE)
				dirt = new Dirt(dirtX, dirtY, DOWN);
			if(tile == Globals.WATER_LEFT_TYPE)
				dirt = new Dirt(dirtX, dirtY, LEFT);
			tilemap.setTile(waterX, waterY, Globals.DIRT_TYPE);
			PlayState.Instance.addCell(dirt, dirt.gridX, dirt.gridY);
			
			
		}
		
		
		
		public override function getArrowContext():String
		{
			if(_growing)
				return _id + "Seed " + _id + ": Growing";
			else if(canMove())
				return _id + "Seed " + _id + ": Floating";
			else 
				return _id + "Seed " + _id + ": Stuck";

		}
		public override function isAvatar():Boolean
		{
			return true;
		}
		
	}
}
