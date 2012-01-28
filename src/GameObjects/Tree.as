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
		
		private var _dead:Boolean;
		
		private var _moveDirection:uint;
		
		
		public function Tree(x:Number, y:Number, totalTurns:int)
		{
			super(x, y, ResourceManager.treeArt);
			_type = Globals.TREE_TYPE;
			_totalTurns = _turnsLeft = totalTurns;
			
		}
		
		public function timeToAdvanceTurn():Boolean
		{
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
		}
		
		public override function doneAdvancingTurn():Boolean
		{
			return this.pathSpeed == 0;
		}
		
		public override function update():void
		{
			if(pathSpeed == 0)
				this.velocity = new FlxPoint();
			
			super.update();
		}
		
	}
}