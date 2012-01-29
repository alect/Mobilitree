package GameObjects
{
	import Utils.*;
	
	public class DeadCactus extends DeadTree
	{
		public function DeadCactus(x:Number, y:Number, id:uint)
		{
			super(x, y, id);
			this.loadGraphic(ResourceManager.deadCactusArt);
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