package GameStates
{
	import Procedural.GenerateLevel;
	
	import Utils.*;
	
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class ProceduralInstructionsState extends FlxState
	{
		private var _seedInput:FlxText;
		private var _levelSelectText:FlxText;
		
		
		public override function create():void
		{
			FlxG.mouse.show();
			_levelSelectText = new FlxText(0, 0, FlxG.width, "Level Select2");
			_levelSelectText.alignment = "center";
			_levelSelectText.size = 32;
			
			this.add(_levelSelectText);
			
			var _backButton:FlxButton = new FlxButton(5, FlxG.height-30, "Back", function():void {FlxG.switchState(new MainMenuState());});
			this.add(_backButton);
			
			
			var basics:String = "Every level has oodles of procedural variants!\n\n" +
				"On any level, press 1,2,3,4, or 5 to generate a new variant.\n\n" +
				"Press 0 to return to the original version.\n\n";
			
			var _variantText:FlxText = new FlxText(0, 60, FlxG.width, basics);
			_variantText .alignment = "center";
			_variantText .size = 20;
			add(_variantText);
			
			var tryIt:FlxText =  new FlxText(0, _variantText.y +  _variantText.height + 60, FlxG.width, "Or go full procedural:");
			var currentX:int = FlxG.width/2-30;
			var currentY:int = tryIt.y +  tryIt.height + 40;
			tryIt.alignment = "center";
			tryIt.size = 20;
			add(tryIt);
			
			_seedInput = new FlxText(currentX, currentY, FlxG.width, "Random Seed");
			add(_seedInput);
			currentY = _seedInput.y + _seedInput.height + 40;
			
			this.add( new FlxButton(currentX, currentY, "GO!", fullProcedural) );
		}

		public override function update():void
		{
			super.update();
			
			if (FlxG.keys.justPressed("BACKSPACE") ||
				FlxG.keys.justPressed("DELETE"))
			{
				if (_seedInput.text.length > 0)
					_seedInput.text = _seedInput.text.substring(0, _seedInput.text.length-1);
			}
			
			//var character:Str
		}
	
		
		
		private function gotoProceduralState():void
		{
			FlxG.switchState(new ProceduralInstructionsState());
		}
		
		
		
		public function fullProcedural():void
		{
			var playstate:PlayState = new PlayState(0, 0);
			
			playstate._baseLevel = GenerateLevel.createLevel();
			playstate.proceduralLevel = true;
			
			FlxG.switchState(playstate);
		}
		
		public function backButton():void
		{
			FlxG.switchState(new LevelSelectState());
		}
		
	}
	
	
}
