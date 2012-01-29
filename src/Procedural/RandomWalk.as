package Procedural
{

	import GameObjects.CellObject;
	import GameObjects.Seed;
	
	import GameStates.PlayState;
	
	import Utils.Globals;
	import Utils.Level;
	
	import flash.utils.getQualifiedClassName;
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;

	public class RandomWalk
	{
		protected var _possibleInputs:Vector.<uint> = new Vector.<uint>();
		public var repeatInputProbability:Number = 0.5;
		public var LastInput:uint = FlxObject.UP;
		public var PossibleGoalLocations:Vector.<FlxPoint> = new Vector.<FlxPoint>();
		
		protected var _testDirections:Vector.<uint> = new Vector.<uint>();
		
		public function RandomWalk()
		{
			_possibleInputs.push(FlxObject.UP, FlxObject.DOWN, FlxObject.RIGHT, FlxObject.LEFT);
			
			_testDirections.push(
				
				FlxObject.UP,
				FlxObject.RIGHT,
				FlxObject.UP,
				FlxObject.DOWN,
				FlxObject.DOWN,
				
				FlxObject.RIGHT,
				
				FlxObject.RIGHT,
				
				FlxObject.LEFT,
				FlxObject.RIGHT,
				FlxObject.LEFT,
				FlxObject.UP,
				FlxObject.UP,
				FlxObject.LEFT,
				FlxObject.DOWN,
				FlxObject.LEFT,
				FlxObject.LEFT,
				FlxObject.LEFT,
				FlxObject.RIGHT,
				FlxObject.DOWN,
				FlxObject.UP,
				FlxObject.DOWN
				);
			_testDirections.length = 0;

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
			
				if ( i < _testDirections.length)
					LastInput = _testDirections[i];
				
				did_something = step(LastInput, playstate) || did_something;
			}
			
			return did_something;
		}

		public function step( direction_from_flx_object:uint, playstate:PlayState):Boolean
		{
			var print:Boolean = false;
			
			fakeInput(direction_from_flx_object);
			
			if (!playstate.isTimeToAdvanceTurn())
			{
				if (print)
					trace("   no result");
			}
			else
			{
				playstate.advanceTurn();
				playstate.doneAdvancingTurn();  // this probably does nothing, but we'll call it just in case.
				playstate.postTurn();
				FlxG.keys.reset();
				
				// Where is the tree?
				var avatar:CellObject = playstate.getAvatar();
				if (null == avatar)
				{
					if (print)
						trace("   Could not find avatar");
				}
				else
				{
					if (print)
						trace("   Player at " + avatar.gridX + "," + avatar.gridY + " is " + getQualifiedClassName(avatar));
					// Is it possible that we have a seed in a win-candidate position?>
					if (avatar is Seed)
					{
						if (playstate.getGridCellType(avatar.gridX, avatar.gridY))
						{
							PossibleGoalLocations.push( new FlxPoint( avatar.gridX, avatar.gridY ) );
							if (print)
								trace("     Found reachable seed location: " + toString(PossibleGoalLocations[ PossibleGoalLocations.length-1 ]));
						}
					}
				}
				return true;
			}
			
			FlxG.keys.reset();
			return false;
		}
		
		public static function toString(point:FlxPoint):String
		{
			return "[FlxPoint " + point.x + "," + point.y + "]";
		}
		
		public static function fakeInput( direction_from_flx_object:uint):void
		{
			var print:Boolean = false;	
		
			FlxG.keys.reset();
			
			switch (direction_from_flx_object)
			{
				case FlxObject.UP:
					FlxG.keys.UP = true;
					if (print)
						trace("Faking UP"); 
					break;
				case FlxObject.DOWN:
					FlxG.keys.DOWN = true;
					if (print)
						trace("Faking DOWN"); 

					break;
				case FlxObject.LEFT:
					FlxG.keys.LEFT = true;
					if (print)
						trace("Faking LEFT"); 

					break;
				case FlxObject.RIGHT:
					FlxG.keys.RIGHT = true;
					if (print)
						trace("Faking RIGHT"); 
					break;
			}
		}
		
		public static function rebuild(playstate:PlayState, goal_percentage:Number):Boolean
		{
			// Snag the Level object
			var level:Level = playstate.currentLevel;
			
			level.removeAllGoals();
			
			// Run the random walk.
			var walk:RandomWalk = new RandomWalk();
			walk.walk(1000, playstate);
			
			/*
			// Try the possibilities....
			var got_one:Boolean = false;
			for each(var goal:FlxPoint in walk.PossibleGoalLocations)
			{
				if (FlxG.random() <= goal_percentage)
				{
					level.forceGoalTile(goal.x, goal.y);
					got_one = true;
				}
			}
			*/
			
		//	if (!got_one && walk._possibleInputs.length >0)
			{
				var point:FlxPoint = walk.PossibleGoalLocations[ walk.PossibleGoalLocations.length-1 ];
				level.forceGoalTile(uint(point.x), uint(point.y));
				return true;
			}
			
			return got_one;
			
		}
	}
}