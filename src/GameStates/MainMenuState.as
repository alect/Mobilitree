package GameStates
{
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	
	public class MainMenuState extends FlxState
	{
		public override function create():void 
		{
			var text:FlxText = new FlxText(0, 0, FlxG.width, "Mobilitree!");
			text.size = 16;
			text.alignment = "center";
			this.add(text);
		}
	}
}