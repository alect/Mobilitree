package GameObjects
{
	import GameStates.PlayState;
	
	import Utils.*;
	
	import org.flixel.FlxTilemap;

	public class Seed extends CellObject
	{
		// We don't want the seed to have a turn the moment it's spawned, so we use this flag
		private var _canHaveTurn:Boolean;
		private var _growing:Boolean;
		
		public function Seed(x:Number, y:Number)
		{
			super(x, y, null);
			this.loadGraphic(ResourceManager.seedArt, true, false, Globals.TILE_SIZE);
			this.addAnimation("grow", [0, 1, 2, 3, 4], 3, false);
			this.addAnimation("idle", [0], 6, true);
			
			_type = Globals.SEED_TYPE;
			_canHaveTurn = false;
			_growing = false;
			
			this.play("idle");
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
				this.play("grow");	
				_growing = true;
			}
		}
		
		public override function timeToAdvanceTurn():Boolean
		{
			// seeds advance the turn automatically
			return true;
		}
		
		public override function doneAdvancingTurn():Boolean 
		{
			// if we're done growing, replace ourselves with a tree and return true
			if(_growing) {
				if(this.frame == 4) {
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
				maybeDrainWater(gridX-1, gridY);
				maybeDrainWater(gridX+1, gridY);
				maybeDrainWater(gridX, gridY-1);
				maybeDrainWater(gridX, gridY+1);
				
				if(PlayState.Instance.Tilemap.getTile(gridX, gridY) == Globals.SOIL_TYPE)
					PlayState.Instance.replaceCell(this, new HappyTree(this.x, this.y));
				else
					PlayState.Instance.replaceCell(this, new Tree(this.x, this.y, 3));
			}
		}
		
		private function maybeDrainWater(waterX:int, waterY:int):void
		{
			var tilemap:FlxTilemap = PlayState.Instance.Tilemap;
			// First check if the given tile is even a water tile or on the tilemap
			if (waterX <= 0 || waterX >= tilemap.widthInTiles ||
				waterY <= 0 || waterY >= tilemap.heightInTiles )
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
			PlayState.Instance.addCell(dirt);
			
			
		}
		
		public override function getArrowContext():String
		{
			if(_growing)
				return "Growing";
			else
				return "Floating";

		}
		public override function isAvatar():Boolean
		{
			return true;
		}
		
	}
}
