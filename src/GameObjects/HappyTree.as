package GameObjects
{
	import Utils.*;
	
	public class HappyTree extends DeadTree
	{
		public function HappyTree(x:Number, y:Number)
		{
			super(x, y);
			this.loadGraphic(ResourceManager.treeArt);
			_type = Globals.HAPPY_TREE_TYPE;
		}
		
		public override function gameWon():Boolean 
		{
			return true;
		}
	}
}