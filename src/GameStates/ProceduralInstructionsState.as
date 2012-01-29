package GameStates
{
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;

	public class ProceduralInstructionsState extends FlxState
	{
		protected var _variantText:FlxText;
		protected var _titleText:FlxText;
		protected var _backButton:FlxButton;
		
		public override function create():void 
		{
			FlxG.mouse.show();

			_titleText= new FlxText(0, 0, FlxG.width, "Procedural Levels");
			_titleText.alignment = "center";
			_titleText .size = 32;
			add(_titleText);

			
			var basics:String = "Every level has oodles of procedural variants!\n\n" +
				"On any level, press 1,2,3,4, or 5 to generate a new variant.\n\n" +
				"Press 0 to return to the original version.\n\n";
				
			_variantText = new FlxText(0, 60, FlxG.width, basics);
			_variantText .alignment = "center";
			_variantText .size = 20;
			add(_variantText);
			
			var currentX:int = FlxG.width/2-30;
			var currentY:int = _variantText.y+_variantText.height+50;
			var iButton:FlxButton = new FlxButton(currentX, currentY, "Back", backButton); 
			this.add(iButton);
		}
		
		public function backButton():void
		{
			FlxG.switchState(new LevelSelectState());
		}
		
		public override function update():void
		{
			if (FlxG.mouse.justPressed()) 
				FlxG.switchState(new LevelSelectState());
		}
	}
}


