package GameObjects
{
	import Utils.*;
	import GameStates.PlayState;
	public class Cactus extends Tree
	{
		public function Cactus(x:Number, y:Number, totalTurns:int)
		{
			super(x, y, totalTurns);
			this.loadGraphic(ResourceManager.cactusArt);
			_deadTransparency.loadGraphic(ResourceManager.deadCactusArt);
		}
		
		protected override function killSelf():void
		{
			var deadSelf:DeadCactus = new DeadCactus(this.x, this.y);
			PlayState.Instance.replaceCell(this, deadSelf);
		}
	}
	
}