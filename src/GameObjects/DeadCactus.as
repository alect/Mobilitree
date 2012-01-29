package GameObjects
{
	import Utils.*;
	import GameStates.PlayState;
	
	public class DeadCactus extends DeadTree
	{
		private var _dir:uint;
		
		public function DeadCactus(x:Number, y:Number, id:uint, dir:uint)
		{
			super(x, y, id);
			this.loadGraphic(ResourceManager.deadCactusArt);
			_dir = dir;
		}
		
		public override function postTurn():void
		{
			if(_plantedSeed) {
				// If we planted a seed, turn into water facing our current direction
				var waterType:uint;
				switch(_dir) {
					case UP:
						waterType = Globals.WATER_UP_TYPE;
						break;
					case RIGHT:
						waterType = Globals.WATER_RIGHT_TYPE;
						break;
					case DOWN:
						waterType = Globals.WATER_DOWN_TYPE;
						break;
					case LEFT:
						waterType = Globals.WATER_LEFT_TYPE;
						break;
					default:
						waterType = Globals.WATER_UP_TYPE;
						break;
				}
				PlayState.Instance.Tilemap.setTile(gridX, gridY, waterType);
				PlayState.Instance.removeCell(this);
				
			}
		}
		
		public override function getArrowContext():String
		{
			if(!_plantedSeed) {
				if(!canMove())
					return _id + "Dead Cactus " + _id + ": Stuck";
				else
					return _id + "Dead Cactus " + _id + ": Use Arrow Keys to Plant Seed";
			}
			else
				return "";
		}
	}
}