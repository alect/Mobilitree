package GameStates
{
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	
	public class PlayState extends FlxState
	{
		public override function create():void 
		{
			var text:FlxText = new FlxText(0, 0, FlxG.width, "Play here!");
			text.alignment = "center";
			this.add(text);
		}
	}
}