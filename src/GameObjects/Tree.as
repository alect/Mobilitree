package GameObjects
{
	import GameStates.PlayState;
	
	import Utils.*;
	
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	
	public class Tree extends CellObject
	{
		
		private var _turnsLeft:int;
		private var _totalTurns:int;
		
		private var _dead:Boolean = false;
		
		private var _moveDirection:uint;
		
		
		public function Tree(x:Number, y:Number, totalTurns:int)
		{
			super(x, y, ResourceManager.treeArt);
			_type = Globals.TREE_TYPE;
			_totalTurns = _turnsLeft = totalTurns;
			
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
				if(this.gridY > 0 && grid[this.gridX][this.gridY-1] == Globals.EMPTY_TYPE) {
					_moveDirection = UP;
					return true;
				}
			}
			if(FlxG.keys.RIGHT) {
				if(this.gridX < grid.length-1 && grid[this.gridX+1][this.gridY] == Globals.EMPTY_TYPE) {
					_moveDirection = RIGHT;
					return true;
				}
			}
			if(FlxG.keys.DOWN) {
				if(this.gridY < (grid[0] as Array).length-1 && grid[this.gridX][this.gridY+1] == Globals.EMPTY_TYPE) {
					_moveDirection = DOWN;
					return true;
				}
			}
			if(FlxG.keys.LEFT) {
				if(this.gridX > 0 && grid[this.gridX-1][this.gridY] == Globals.EMPTY_TYPE) {
					_moveDirection = LEFT;
					return true;
				}
			}
			
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
		
		public override function doneAdvancingTurn():Boolean
		{
			return this.pathSpeed == 0;
		}
		
		public override function isAvatar():Boolean
		{
			return !_dead;
		}

		public override function gameWon():Boolean
		{
			return false;
		}
		
	}
}
