package GameStates
{
	import Utils.*;
	
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class LevelSelectState extends FlxState
	{
		private var _levelSelectText:FlxText;
		
		public override function create():void
		{
			FlxG.mouse.show();
			_levelSelectText = new FlxText(0, 0, FlxG.width, "Level Select");
			_levelSelectText.alignment = "center";
			_levelSelectText.size = 32;
			
			this.add(_levelSelectText);
			
			var _backButton:FlxButton = new FlxButton(5, FlxG.height-50, "Back", function():void {FlxG.switchState(new MainMenuState());});
			this.add(_backButton);
			
			var currentX:int = FlxG.width/2-30;
			var currentY:int = _levelSelectText.y+_levelSelectText.height+50;
			
			for(var i:int = 0; i < ResourceManager.levelList.length; i++) {
				var buttonNormal:FlxSprite = new FlxSprite();
				buttonNormal.makeGraphic(80, 20, 0xff000000);
				
				//var buttonSelect:FlxSprite = new FlxSprite();
				//buttonSelect.makeGraphic(80, 20, 0xff0000ff);
				
				
				
				if(currentY+buttonNormal.height > FlxG.height) {
					currentX += buttonNormal.width+5;
					currentY = _levelSelectText.y+_levelSelectText.height+5;
				}
				var levelIndex:int = i;
				var iButton:FlxButton = new FlxButton(currentX, currentY, "Level " + (i+1).toString(), createButtonFunction(i));
				this.add(iButton);
				
				
				currentY += buttonNormal.height+5;
				
			}
		}
		private function createButtonFunction(i:int):Function {
			return function():void {FlxG.switchState(new PlayState(i));};
		}
	}
	
	
}