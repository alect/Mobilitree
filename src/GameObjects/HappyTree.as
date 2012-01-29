package GameObjects
{
	import Utils.*;
	
	public class HappyTree extends DeadTree
	{
		public function HappyTree(x:Number, y:Number, id:uint)
		{
			super(x, y, id);
			this.loadGraphic(ResourceManager.goldTreeArt, true);
			this.addAnimation("flourish", [4, 0, 1, 2, 3], 3);
			_type = Globals.HAPPY_TREE_TYPE;
			this.play("flourish");
		}
		
		public override function gameWon():Boolean 
		{
			return true;
		}
		
		public override function getArrowContext():String
		{
			if(!_plantedSeed) {
				if(!canMove())
					return _id + "Flourishing Tree " + _id + ": Done";
				else
					return _id + "Flourishing Tree " + _id + ": Use Arrow Keys to Plant Seed"; 
			}
			else
				return "";
		}
	}
}