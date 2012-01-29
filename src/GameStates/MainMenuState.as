package GameStates
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	import Utils.*;
	public class MainMenuState extends FlxState
	{
		public override function create():void 
		{
			var titleImage:FlxSprite = new FlxSprite(0, 0, ResourceManager.titleArt);
			this.add(titleImage);
		}
		
		public override function update():void
		{
			if (FlxG.mouse.justPressed()) 
				FlxG.switchState(new LevelSelectState());
		}
	}
}

