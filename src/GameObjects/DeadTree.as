package GameObjects
{
	import GameStates.PlayState;
	
	import Utils.*;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class DeadTree extends CellObject
	{
		
		// Used to highlight the spaces where a seed can be planted
		private var _seedHighlight:FlxSprite;
		
		// Whether or not we've planted our seed yet (affects the turn system)
		private var _plantedSeed:Boolean;
		
		public function DeadTree(x:Number, y:Number)
		{
			super(x, y, ResourceManager.deadTreeArt);
			// For all intents and purposes, other objects should treat us like a tree
			_type = Globals.TREE_TYPE;
			
			_seedHighlight = new FlxSprite();
			_seedHighlight.makeGraphic(Globals.TILE_SIZE, Globals.TILE_SIZE, 0x80f665f1);
		}
		
		public override function draw():void
		{
			super.draw();
			
			// Draw our seed highlight image over appropriate places if we haven't planted a seed yet
			if(!_plantedSeed && !PlayState.Instance.gameWon) {
				var grid:Array = PlayState.Instance.typeGrid;
				if(this.gridY > 0 && cellSuitableForSeed(grid[this.gridX][this.gridY-1])) {
					_seedHighlight.x = this.x;
					_seedHighlight.y = this.y-_seedHighlight.height;
					_seedHighlight.draw();
				}
				
				if(this.gridX < grid.length-1 && cellSuitableForSeed(grid[this.gridX+1][this.gridY])) {
					_seedHighlight.x = this.x+this.width;
					_seedHighlight.y = this.y;
					_seedHighlight.draw();
				}
				
				if(this.gridY < (grid[0] as Array).length-1 && cellSuitableForSeed(grid[this.gridX][this.gridY+1])) {
					_seedHighlight.x = this.x;
					_seedHighlight.y = this.y+this.height;
					_seedHighlight.draw();
				}
				
				if(this.gridX > 0 && cellSuitableForSeed(grid[this.gridX-1][this.gridY])) {
					_seedHighlight.x = this.x - _seedHighlight.width;
					_seedHighlight.y = this.y;
					_seedHighlight.draw();
				}
					
				
			}
		}
		
		
		
		
		public override function timeToAdvanceTurn():Boolean 
		{
			// Don't want to unnecessarily advance the turn if we already planted a seed
			if(_plantedSeed)
				return false;
			
			var grid:Array = PlayState.Instance.typeGrid;
			if(FlxG.keys.UP) { 
				if(this.gridY > 0 && cellSuitableForSeed(grid[this.gridX][this.gridY-1])) {
					PlayState.Instance.addCell( new Seed(0,0), gridX, gridY-1);
					_plantedSeed = true;
					return true;
				}
			}
			if(FlxG.keys.RIGHT) {	
				if(this.gridX < grid.length-1 && cellSuitableForSeed(grid[this.gridX+1][this.gridY])) {
					PlayState.Instance.addCell(new Seed(0,0), this.gridX+1, this.gridY);
					_plantedSeed = true;
					return true;
				}
			}
			if(FlxG.keys.DOWN) {
				if(this.gridY < (grid[0] as Array).length-1 && cellSuitableForSeed(grid[this.gridX][this.gridY+1])) {
					PlayState.Instance.addCell(new Seed(0,0), this.gridX, this.gridY+1);
					_plantedSeed = true;
					return true;
				}
			}
			if(FlxG.keys.LEFT) {
				if(this.gridX > 0 && cellSuitableForSeed(grid[this.gridX-1][this.gridY])) {
					PlayState.Instance.addCell(new Seed(0,0), this.gridX-1, this.gridY);
					_plantedSeed = true;
					return true;
				}
			}
			
			return false;
		}
		
		public override function isAvatar():Boolean
		{
			return !_plantedSeed;
		}

		
	}
}
