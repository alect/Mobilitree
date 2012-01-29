package GameObjects
{
	import GameStates.PlayState;
	
	import Utils.*;
	
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	public class Tree extends CellObject
	{
		
		protected var _turnsLeft:int;
		protected var _totalTurns:int;
		
		private var _dead:Boolean = false;
		
		protected var _moveDirection:uint;
		
		protected var _id:uint = 0;
		
		
		// for overlaying a transparency 
		protected var _deadTransparency:FlxSprite;
		
		public function Tree(x:Number, y:Number, totalTurns:int, id:uint)
		{
			super(x, y, ResourceManager.treeArt);
			_type = Globals.TREE_TYPE;
			_totalTurns = _turnsLeft = totalTurns;
			_deadTransparency = new FlxSprite(0, 0, ResourceManager.deadTreeArt);	
			_id = id;
		}
		
		protected function killSelf():void
		{
			var deadSelf:DeadTree = new DeadTree(this.x, this.y, _id);
			PlayState.Instance.replaceCell(this, deadSelf);
		}
		
		public override function timeToAdvanceTurn():Boolean
		{
			// first, if we're dead, take care of some business. 
			if(_dead) {
				killSelf();
				return false;
			}
			
			var grid:Array = PlayState.Instance.typeGrid;
			if(FlxG.keys.UP) {
				// now check if the value above us is empty
				if(this.gridY > 0 && treeCanWalkOn(grid[this.gridX][this.gridY-1])) {
					_moveDirection = UP;
					return true;
				}
			}
			if(FlxG.keys.RIGHT) {
				if(this.gridX < grid.length-1 && treeCanWalkOn(grid[this.gridX+1][this.gridY])) {
					_moveDirection = RIGHT;
					return true;
				}
			}
			if(FlxG.keys.DOWN) {
				if(this.gridY < (grid[0] as Array).length-1 && treeCanWalkOn(grid[this.gridX][this.gridY+1])) {
					_moveDirection = DOWN;
					return true;
				}
			}
			if(FlxG.keys.LEFT) {
				if(this.gridX > 0 && treeCanWalkOn(grid[this.gridX-1][this.gridY])) {
					_moveDirection = LEFT;
					return true;
				}
			}
			// :P
			_moveDirection = 22;
			return false;
		}
		
		public override function canMove():Boolean
		{
			var grid:Array = PlayState.Instance.typeGrid;
			return ( (this.gridY > 0 && treeCanWalkOn(grid[gridX][gridY-1])) ||
					(this.gridX < grid.length-1 && treeCanWalkOn(grid[gridX+1][gridY])) ||
					(this.gridY < (grid[0] as Array).length-1 && treeCanWalkOn(grid[gridX][gridY+1])) ||
					(this.gridX > 0 && treeCanWalkOn(grid[gridX-1][gridY])) );
		}
		
		public override function advanceTurn():void
		{
			if(_dead) {
				
			}
			else {
				switch(_moveDirection) 
				{
					case UP:
						PlayState.Instance.moveCell(this, this.gridX, this.gridY-1);
						break;
					case RIGHT:
						PlayState.Instance.moveCell(this, this.gridX+1, this.gridY);
						break;
					case DOWN:
						PlayState.Instance.moveCell(this, this.gridX, this.gridY+1);
						break;
					case LEFT:
						PlayState.Instance.moveCell(this, this.gridX-1, this.gridY);
				}
				
				_turnsLeft--;
				if(_turnsLeft == 0)
					_dead = true;
			}
			
		}
		
		private function treeCanWalkOn(cell:uint):Boolean
		{
			return (cell == Globals.EMPTY_TYPE || cell == Globals.DIRT_TYPE || cell == Globals.MUD_TYPE || cell == Globals.SAND_TYPE);
		}
		
		public override function getArrowContext():String
		{
			if(!canMove())
				return _id + "Tree " + _id + ": Stuck. Turns until death: " + _turnsLeft;
			else
				return _id + "Tree " + _id + ": Use Arrow Keys to Move. Moves until death: " + _turnsLeft;
		}
		
		public override function doneAdvancingTurn():Boolean
		{
			return this.pathSpeed == 0;
		}
		
		public override function isAvatar():Boolean
		{
			return !_dead;
		}
		
		public override function draw():void
		{
			super.draw();
			var deathLevel:Number = 1 - _turnsLeft/Number(_totalTurns);
			_deadTransparency.x = this.x;
			_deadTransparency.y = this.y;
			_deadTransparency.alpha = deathLevel;
			_deadTransparency.draw();
		}

		
	}
}
