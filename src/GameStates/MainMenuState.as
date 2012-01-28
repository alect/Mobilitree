package GameStates
{
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class MainMenuState extends FlxState
	{
		public override function create():void 
		{
			var text:FlxText = new FlxText(0, 0, FlxG.width, "Mobilitree!");
			text.size = 16;
			text.alignment = "center";
			this.add(text);
		}
		
		public override function update():void
		{
			if (FlxG.mouse.justPressed()) 
				FlxG.switchState(new PlayState());
		}
	}
}

// Andrew modified this
