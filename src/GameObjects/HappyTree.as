package GameObjects
{
	import Utils.*;
	
	public class HappyTree extends DeadTree
	{
		public function HappyTree(x:Number, y:Number)
		{
			super(x, y);
			this.loadGraphic(ResourceManager.goldTreeArt, true);
			this.addAnimation("flourish", [4, 0, 1, 2, 3], 3);
			_type = Globals.HAPPY_TREE_TYPE;
			this.play("flourish");
		}
		
		public override function gameWon():Boolean 
		{
			return true;
		}
	}
}