package GameObjects
{
	import Utils.*;
	
	public class DeadTree extends CellObject
	{
		public function DeadTree(x:Number, y:Number)
		{
			super(x, y, ResourceManager.deadTreeArt);
			_type = Globals.TREE_TYPE;
		}
		
		
	}
}