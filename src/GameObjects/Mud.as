package GameObjects
{
	import GameStates.PlayState;
	
	import Utils.*;
	
	public class Mud extends CellObject
	{
		private var _dir:uint;
		private var _canHaveTurn:Boolean = false;
		private var _doneTurn:Boolean = false;
		
		public function Mud(x:Number, y:Number, dir:uint)
		{
			super(x, y, ResourceManager.mudArt);
			_type = Globals.MUD_TYPE;
			_dir = dir;
		}
		
		
		public override function postTurn():void
		{
			// don't change if we've got a tree on top of us
			trace(PlayState.Instance.getGridCellType(gridX, gridY));
			if(PlayState.Instance.getGridCellType(gridX, gridY) == Globals.TREE_TYPE)
				return;
			
			// When we're done advancing turns, switch to the correct directional water
			switch(_dir) {
				case UP:
					PlayState.Instance.Tilemap.setTile(gridX, gridY, Globals.WATER_UP_TYPE);
					PlayState.Instance.removeCell(this);
					break;
				case RIGHT:
					PlayState.Instance.Tilemap.setTile(gridX, gridY, Globals.WATER_RIGHT_TYPE);
					PlayState.Instance.removeCell(this);
					break;
				case DOWN:
					PlayState.Instance.Tilemap.setTile(gridX, gridY, Globals.WATER_DOWN_TYPE);
					PlayState.Instance.removeCell(this);
					break;
				case LEFT:
					PlayState.Instance.Tilemap.setTile(gridX, gridY, Globals.WATER_LEFT_TYPE);
					PlayState.Instance.removeCell(this);
					break;
			}
		}
		
		public override function draw():void
		{
			
		}
		
	}
}