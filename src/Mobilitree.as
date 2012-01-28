package
{
	import flash.display.Sprite;
	
	import org.flixel.*;
	import GameStates.MainMenuState;
	
	[SWF(width="800", height="600", backgroundColor="#808080")]
	
	public class Mobilitree extends FlxGame
	{
		public function Mobilitree()
		{
			super(400, 300, MainMenuState, 2);
		}
	}
}