package Procedural
{

	import GameObjects.CellObject;
	
	import GameStates.PlayState;
	
	import flash.utils.getQualifiedClassName;
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxU;

	public class RandomWalk
	{
		protected var _possibleInputs:Vector.<uint> = new Vector.<uint>();
		public var repeatInputProbability:Number = 0.5;
		public var LastInput:uint = FlxObject.UP;
		
		public function RandomWalk()
		{
			_possibleInputs.push(FlxObject.UP, FlxObject.DOWN, FlxObject.RIGHT, FlxObject.LEFT);
		}
		
		protected function getRandomInput():uint
		{
			var index:uint = FlxG.random() * _possibleInputs.length;
			if (index >= _possibleInputs.length)
				index = _possibleInputs.length;
			
			return _possibleInputs[index];
		}
		
		// Returns true if it did something
		public function walk(num_steps:int, playstate:PlayState):Boolean
		{
			var did_something:Boolean = false;
			
			for (var i:int = 0; i < num_steps; ++i)
			{
				// Should we keep doing what we did last time?
				if (FlxG.random() > repeatInputProbability)
					LastInput = getRandomInput();  //  No!  Randomize.
				
				did_something = step(LastInput, playstate) || did_something;
			}
			
			return did_something;
		}

		public function step( direction_from_flx_object:uint, playstate:PlayState):Boolean
		{
			fakeInput(direction_from_flx_object);
			
			if (playstate.isTimeToAdvanceTurn())
			{
				playstate.advanceTurn();
				playstate.doneAdvancingTurn();  // this probably does nothing, but we'll call it just in case.
				FlxG.keys.reset();
				
				// Where is the tree?
				var avatar:CellObject = playstate.getAvatar();
				if (null == avatar)
				{
					//trace("Could not find avatar");
				}
				else
				{
					//trace("Player at " + avatar.gridX + "," + avatar.gridY + " is " + getQualifiedClassName(avatar));
				}
				return true;
			}
			
			FlxG.keys.reset();
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