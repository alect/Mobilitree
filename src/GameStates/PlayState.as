package GameStates
{
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class PlayState extends FlxState
	{
		
		// A two dimensional array of 
		private var gridValues:Array;
		
		public override function create():void 
		{
			var text:FlxText = new FlxText(0, 0, FlxG.width, "Play here!");
			text.alignment = "center";
			this.add(text);
		}
		
		//public function 
	}
}