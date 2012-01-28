package Procedural
{

	import GameStates.PlayState;

	import org.flixel.FlxG;
	import org.flixel.FlxObject;

	public class RandomWalk
	{
		public function RandomWalk()
		{
		}
		
		public function walk(num_steps:int):void
		{
			for (var i:int = 0; i < num_steps; ++i)
			{
				//step();
			}
		}

		public function step( direction_from_flx_object:uint, playstate:PlayState):Boolean
		{
			fakeInput(direction_from_flx_object);
			
			if (playstate.isTimeToAdvanceTurn())
			{
				playstate.advanceTurn();
				return true;
			}
			
			return false;
		}
		
		public static function fakeInput( direction_from_flx_object:uint):void
		{
			FlxG.keys.reset();
			
			switch (direction_from_flx_object)
			{
				case FlxObject.UP:
					FlxG.keys.UP = true;
					break;
				case FlxObject.DOWN:
					FlxG.keys.DOWN = true;
					break;
				case FlxObject.LEFT:
					FlxG.keys.LEFT = true;
					break;
				case FlxObject.RIGHT:
					FlxG.keys.RIGHT = true;
					break;
			}
		}
	}
}