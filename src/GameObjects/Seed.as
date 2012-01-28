package GameObjects
{
	import GameStates.PlayState;
	
	import Utils.*;
	public class Seed extends CellObject
	{
		// We don't want the seed to have a turn the moment it's spawned, so we use this flag
		private var _canHaveTurn:Boolean;
		private var _growing:Boolean;
		
		public function Seed(x:Number, y:Number)
		{
			super(x, y, null);
			this.loadGraphic(ResourceManager.seedArt, true, false, Globals.TILE_SIZE);
			this.addAnimation("grow", [0, 1, 2], 6, false);
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
			
			// TODO: the actual code for a seed's turn
			// Need to check if we're on solid ground before doing this but...
			// The moment we begin growing, become a tree
			_type = Globals.TREE_TYPE;
			this.play("grow");	
			_growing = true;
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
				if(this.frame == 2) {
					PlayState.Instance.replaceCell(this, new Tree(this.x, this.y, 3));
					return true;
				}
				return false;
			}
			
			return true;
		}
	}
}