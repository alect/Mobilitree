package GameObjects
{
	import GameStates.PlayState;
	
	import Utils.*;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	
	public class DeadTree extends CellObject
	{
		
		protected static var _plantingSound:FlxSound = new FlxSound();
		_plantingSound.loadEmbedded(ResourceManager.plantingSeedSound);
		
		// Used to highlight the spaces where a seed can be planted
		private var _seedHighlight:FlxSprite;
		
		// Whether or not we've planted our seed yet (affects the turn system)
		protected var _plantedSeed:Boolean;
		protected var _id:uint = 0;
		
		public function DeadTree(x:Number, y:Number, id:uint)
		{
			super(x, y, ResourceManager.deadTreeArt);
			// For all intents and purposes, other objects should treat us like a tree
			_type = Globals.TREE_TYPE;
			
			_seedHighlight = new FlxSprite();
			_seedHighlight.loadGraphic(ResourceManager.seedArt, true);
			_seedHighlight.alpha = 0.4;
			_id = id;
			//_seedHighlight.makeGraphic(Globals.TILE_SIZE, Globals.TILE_SIZE, 0x80f665f1);
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
					PlayState.Instance.addCell( new Seed(0,0, _id), gridX, gridY-1);
					_plantedSeed = true;
					_plantingSound.play();
					return true;
				}
			}
			if(FlxG.keys.RIGHT) {	
				if(this.gridX < grid.length-1 && cellSuitableForSeed(grid[this.gridX+1][this.gridY])) {
					PlayState.Instance.addCell(new Seed(0,0, _id), this.gridX+1, this.gridY);
					_plantedSeed = true;
					_plantingSound.play();
					return true;
				}
			}
			if(FlxG.keys.DOWN) {
				if(this.gridY < (grid[0] as Array).length-1 && cellSuitableForSeed(grid[this.gridX][this.gridY+1])) {
					PlayState.Instance.addCell(new Seed(0,0, _id), this.gridX, this.gridY+1);
					_plantedSeed = true;
					_plantingSound.play();
					return true;
				}
			}
			if(FlxG.keys.LEFT) {
				if(this.gridX > 0 && cellSuitableForSeed(grid[this.gridX-1][this.gridY])) {
					PlayState.Instance.addCell(new Seed(0,0, _id), this.gridX-1, this.gridY);
					_plantedSeed = true;
					_plantingSound.play();
					return true;
				}
			}
			
			return false;
		}
		
		public override function canMove():Boolean
		{
			var grid:Array = PlayState.Instance.typeGrid;
			return ( (this.gridY > 0 && cellSuitableForSeed(grid[gridX][gridY-1])) ||
				(this.gridX < grid.length-1 && cellSuitableForSeed(grid[gridX+1][gridY])) ||
				(this.gridY < (grid[0] as Array).length-1 && cellSuitableForSeed(grid[gridX][gridY+1])) ||
				(this.gridX > 0 && cellSuitableForSeed(grid[gridX-1][gridY])) );
		}
		
		public override function getArrowContext():String
		{
			if(!_plantedSeed) {
				if(!canMove())
					return _id + "Dead Tree " + _id + ": Stuck";
				else
					return _id + "Dead Tree " + _id + ": Use Arrow Keys to Plant Seed";		
			}
			else
				return "";
		}
		public override function isAvatar():Boolean
		{
			return !_plantedSeed;
		}

		
	}
}
