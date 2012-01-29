package
{
	import flash.display.Sprite;
	
	import org.flixel.*;
	import GameStates.MainMenuState;
	
	[SWF(width="1024", height="768", backgroundColor="#808080")]
	
	public class Mobilitree extends FlxGame
	{
		public function Mobilitree()
		{
			super(1024, 768, MainMenuState, 1);
		}
	}
}