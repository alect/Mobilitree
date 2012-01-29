package GameObjects
{
	import Utils.*;
	public class Cactus extends Tree
	{
		public function Cactus(x:Number, y:Number, totalTurns:int)
		{
			super(x, y, totalTurns);
			this.makeGraphic(Globals.TILE_SIZE, Globals.TILE_SIZE, 0xff00ff00);
		}
	}
}