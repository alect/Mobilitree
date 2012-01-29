package GameObjects
{
	import Utils.*;
	
	public class DeadCactus extends DeadTree
	{
		public function DeadCactus(x:Number, y:Number)
		{
			super(x, y);
			this.loadGraphic(ResourceManager.deadCactusArt);
		}
	}
}