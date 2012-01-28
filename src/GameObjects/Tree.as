package GameObjects
{
	import GameStates.PlayState;
	
	import Utils.*;
	
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	public class Tree extends CellObject
	{
		
		private var _turnsLeft:int;
		private var _totalTurns:int;
		
		private var _dead:Boolean = false;
		
		private var _moveDirection:uint;
		
		// for overlaying a transparency 
		private var _deadTransparency:FlxSprite;
		
		public function Tree(x:Number, y:Number, totalTurns:int)
		{
			super(x, y, ResourceManager.treeArt);
			_type = Globals.TREE_TYPE;
			_totalTurns = _turnsLeft = totalTurns;
			_deadTransparency = new FlxSprite(0, 0, ResourceManager.deadTreeArt);	
		}
		
		public override function timeToAdvanceTurn():Boolean
		{
			// first, if we're dead, take care of some business. 
			if(_dead) {
				var deadSelf:DeadTree = new DeadTree(this.x, this.y);
				PlayState.Instance.replaceCell(this, deadSelf);
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
			return (cell == Globals.EMPTY_TYPE || cell == Globals.DIRT_TYPE || cell == Globals.MUD_TYPE);
		}
		
		public override function getArrowContext():String
		{
			return "Use Arrow Keys to Move. Moves until death: " + _turnsLeft;
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
