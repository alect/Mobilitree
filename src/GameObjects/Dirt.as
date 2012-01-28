package GameObjects
{
	import GameStates.PlayState;
	
	import Utils.*;
	
	import org.flixel.FlxTilemap;
	
	public class Dirt extends CellObject
	{
		// Dirt remembers the direction of water it represented
		private var _dir:uint;
		private var _canHaveTurn:Boolean = false;
		private var _doneTurn:Boolean = false;
		
		public function Dirt(x:Number, y:Number, dir:uint)
		{
			super(x, y, ResourceManager.dirtArt);
			_type = Globals.DIRT_TYPE;
			_dir = dir;
		}
		
		public override function postTurn():void 
		{
			if(!_canHaveTurn) {
				_canHaveTurn = true;
				return;
			}
			// Whether water is flowing in these directions
			var upFlow:Boolean=false, rightFlow:Boolean = false, downFlow:Boolean = false, leftFlow:Boolean = false;
			
			var gridWidth:int = PlayState.Instance.typeGrid.length;
			var gridHeight:int = (PlayState.Instance.typeGrid[0] as Array).length;
			var tilemap:FlxTilemap = PlayState.Instance.Tilemap;
			downFlow = (gridY > 0 && tilemap.getTile(gridX, gridY-1) == Globals.WATER_DOWN_TYPE);
			leftFlow = (gridX < gridWidth-1 && tilemap.getTile(gridX+1, gridY) == Globals.WATER_LEFT_TYPE);
			upFlow = (gridY < gridHeight-1 && tilemap.getTile(gridX, gridY+1) == Globals.WATER_UP_TYPE);
			rightFlow = (gridX > 0 && tilemap.getTile(gridX-1, gridY) == Globals.WATER_RIGHT_TYPE);
			
			var mud:Mud = null;
			// First, try to change based on our original direction
			switch(_dir) {
				case UP:
					if(upFlow) 
						mud = new Mud(this.x, this.y, _dir);
					break;
				case RIGHT:
					if(rightFlow)
						mud = new Mud(this.x, this.y, _dir);
					break;
				case DOWN:
					if(downFlow)
						mud = new Mud(this.x, this.y, _dir);
					break;
				case LEFT:
					if(leftFlow)
						mud = new Mud(this.x, this.y, _dir);
					break;
			}
			// If our original direction was a no go, just pick one
			if(mud == null) {
				if(upFlow) 
					mud = new Mud(this.x, this.y, _dir);
				else if(rightFlow)
					mud = new Mud(this.x, this.y, _dir);
				else if(downFlow)
					mud = new Mud(this.x, this.y, _dir);
				else if(leftFlow)
					mud = new Mud(this.x, this.y, _dir);
			}
			
			// If we still don't have anything, stay dirt
			if(mud != null) {
				PlayState.Instance.Tilemap.setTile(gridX, gridY, Globals.MUD_TYPE);
				PlayState.Instance.replaceCell(this, mud);
			}
		}
		
		public override function draw():void
		{
			
		}
	}
}