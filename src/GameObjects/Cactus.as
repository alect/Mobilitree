package GameObjects
{
	import Utils.*;
	import GameStates.PlayState;
	public class Cactus extends Tree
	{
		public function Cactus(x:Number, y:Number, totalTurns:int, id:uint)
		{
			super(x, y, totalTurns, id);
			this.loadGraphic(ResourceManager.cactusArt);
			_deadTransparency.loadGraphic(ResourceManager.deadCactusArt);
		}
		
		protected override function killSelf():void
		{
			var deadSelf:DeadCactus = new DeadCactus(this.x, this.y,  _id);
			PlayState.Instance.replaceCell(this, deadSelf);
		}
		
		public override function getArrowContext():String
		{
			if(!canMove())
				return _id + "Cactus " + _id + ": Stuck. Turns until death: " + _turnsLeft;
			else
				return _id + "Cactus " + _id + ": Use Arrow Keys to Move. Moves until death: " + _turnsLeft;
		}
	}
	
}