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
		public var SpacesWeWalkedThrough:Vector.<FlxPoint> = new Vector.<FlxPoint>();
		
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
		public function walk(num_steps:int, playstate:PlayState, probability_that_tree_is_goal:Number):Boolean
		{
			var did_something:Boolean = false;
			
			for (var i:int = 0; i < num_steps; ++i)
			{
				// Should we keep doing what we did last time?
				if (FlxG.random() > repeatInputProbability)
					LastInput = getRandomInput();  //  No!  Randomize.
				
				if ( i < _testDirections.length)
					LastInput = _testDirections[i];
				
				did_something = step(LastInput, playstate, probability_that_tree_is_goal) || did_something;
			}
			
			return did_something;
		}
		
		
		// Returns true if it did something
		public function walkSkip(num_steps:int, playstate:PlayState, skip_count:int):void
		{
			var avatar:CellObject = playstate.getAvatar();
			if (null != avatar)
			{
				if (!(avatar is Seed))
				{
					SpacesWeWalkedThrough.push( new FlxPoint( avatar.gridX, avatar.gridY ) );
				}
			}
			
			
			
			var did_something:Boolean = false;
			var current_skip:int = skip_count;
			
			for (var i:int = 0; i < num_steps; ++i)
			{
				// Should we keep doing what we did last time?
				if (FlxG.random() > repeatInputProbability)
					LastInput = getRandomInput();  //  No!  Randomize.
				
				if ( i < _testDirections.length)
					LastInput = _testDirections[i];
				
				if (current_skip < 0)
					current_skip = skip_count;
				
				var prev_num_goals:int = PossibleGoalLocations.length;
				did_something = step(LastInput, playstate, 1-current_skip) || did_something;
				
				if (prev_num_goals < PossibleGoalLocations.length)
					--current_skip;
			}
			
	//		return did_something;
		}
		
		public function step( direction_from_flx_object:uint, playstate:PlayState, probability_of_creating_goal:Number):Boolean
		{
			var print:Boolean = false;
			
			fakeInput(direction_from_flx_object);
			
			if (!playstate.isTimeToAdvanceTurn())
			{
				if (print && false)
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
					if (print && false)
						trace("   Player at " + avatar.gridX + "," + avatar.gridY + " is " + getQualifiedClassName(avatar));
					// Is it possible that we have a seed in a win-candidate position?>
					if (avatar is Seed)
					{
						var location:FlxPoint =  new FlxPoint( avatar.gridX, avatar.gridY );
						
						if (Seed.couldGrowAt(avatar.gridX, avatar.gridY))
						{
							if (walkedThereAlready(location))
							{
								if (print)
									trace("Discarding " + toString(location) + " because we already walked there");
							}
							else
							{
							
								PossibleGoalLocations.push(location );
								if (print)
								{
									trace("     Found reachable seed location: " + toString(PossibleGoalLocations[ PossibleGoalLocations.length-1 ]));
									trace("    goal P = " + probability_of_creating_goal);
								}
								
								// Hack it up!
								if (probability_of_creating_goal > FlxG.random())
								{
									playstate.Tilemap.setTile(avatar.gridX, avatar.gridY, Globals.SOIL_TYPE);
									if (print)
										trace("    Made a new goal!");
								}
							}
						}
					}
					else
					{
						SpacesWeWalkedThrough.push( new FlxPoint( avatar.gridX, avatar.gridY ) );
					}
				}
				return true;
			}
			
			FlxG.keys.reset();
			return false;
		}
		
		public function walkedThereAlready(location:FlxPoint):Boolean
		{
			for each (var trail:FlxPoint in SpacesWeWalkedThrough)
			{
				if (trail.x == location.x && trail.y == location.y)
					return true;
			}
			
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
		
		public static function removeAllGoals(playstate:PlayState):void
		{
			playstate.currentLevel.removeAllGoals();
			
			// Remove all goal soils:
			for (var x:uint = 0; x < playstate.Tilemap.widthInTiles; ++x)
			{
				for (var y:uint = 0; y < playstate.Tilemap.heightInTiles; ++y)
				{
					if (playstate.Tilemap.getTile(x,y) == Globals.SOIL_TYPE)
						playstate.Tilemap.setTile(x,y, Globals.EMPTY_TYPE);
				}
			}
		}
		
		public static function rebuild(playstate:PlayState, goal_percentage:Number):Boolean
		{
			// Snag the Level object
			var level:Level = playstate.currentLevel;
			
			removeAllGoals(playstate);
			removeAllGoals(playstate);
			
			// Run the random walk.
			var walk:RandomWalk = new RandomWalk();
			walk.walk(1000, playstate, goal_percentage);
			
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
			
			
			if (walk.PossibleGoalLocations.length >0)
			{
				var point:FlxPoint = walk.PossibleGoalLocations[ walk.PossibleGoalLocations.length-1 ];
				
				
				level.forceGoalTile(uint(point.x), uint(point.y));
				
				level.copyGoalTiles( playstate.Tilemap );
				
				return true;
			}
			
			return false;
			
		}
		
		public static function rebuildWithSkip(playstate:PlayState, skip_between:int):Boolean
		{
			// Snag the Level object
			var level:Level = playstate.currentLevel;
			
			removeAllGoals(playstate);
			removeAllGoals(playstate);
			
			// Run the random walk.
			var walk:RandomWalk = new RandomWalk();
			walk.walkSkip(1000, playstate, skip_between);
			
			// Did we find ANY goal locations?
			if (walk.PossibleGoalLocations.length >0)
			{
				// Yes! Use the last one as a cap stone to our level.
				var point:FlxPoint = walk.PossibleGoalLocations[ walk.PossibleGoalLocations.length-1 ];
				level.forceGoalTile(uint(point.x), uint(point.y));

				// And then copy the goal tiles.
				//  (We were creating some on the way) 
				level.copyGoalTiles( playstate.Tilemap );
				
				return true;
			}
			
			return false;
			
		}

	}
}
