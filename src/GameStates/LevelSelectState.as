package GameStates
{
	import Utils.*;
	
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxPoint;
	
	public class LevelSelectState extends FlxState
	{
		private var _levelSelectText:FlxText;
		
		private static var _groupIndex:int = 0;
		private static var _groupArrays:Array = [];
		
		public override function create():void
		{
			_groupIndex = 0;
			_groupArrays = [];
			
			FlxG.mouse.show();
			_levelSelectText = new FlxText(0, 0, FlxG.width, "Level Select");
			_levelSelectText.alignment = "center";
			_levelSelectText.size = 32;
			
			this.add(_levelSelectText);
			
			var _backButton:FlxButton = new FlxButton(5, FlxG.height-30, "Back", function():void {FlxG.switchState(new MainMenuState());});
			this.add(_backButton);
			
			
			var _procButton:FlxButton = new FlxButton(FlxG.width - 80 - 5, FlxG.height-30, "Procedural", gotoProceduralState);
			this.add(_procButton);
			
			var allLevels:Array = [];
			for(var i:int = 0; i < ResourceManager.levelList.length; i++)
				allLevels.push(i);
			createLevelGroup(FlxG.width/2-200, _levelSelectText.y + _levelSelectText.height+50, "All Levels", allLevels);
			
			createLevelGroup(FlxG.width * 3/4 - 150, 25*5, "Tree", [0, 1, 2, 3, 4]);
			createLevelGroup(FlxG.width * 3/4 - 150, 25*8 + 5*35, "DoubleTree", [5, 6, 7, 8, 9, 10, 11]);
			createLevelGroup(FlxG.width * 3/4, 25*5, "Cacti", [12, 13, 14, 15]);
			createLevelGroup(FlxG.width * 3/4, 25*8 + 4*35, "Cactree", [16, 17]);
		}
		
		private function createLevelGroup(x:Number, y:Number, name:String, levels:Array):void
		{
			var groupLabel:FlxText = new FlxText(x, y, FlxG.width, name);
			groupLabel.size = 16;
			this.add(groupLabel);
			var currentY:Number = groupLabel.y+groupLabel.height;
			trace(levels);
			var n:int = 0;
			for each(var i:int in levels) {
				var iButton:FlxButton = new FlxButton(x+5, currentY, "Level " + (i+1).toString(), createButtonFunction(_groupIndex, n));
				iButton.loadGraphic(ResourceManager.buttonArt, true, false, 32, 32);
				var label:FlxText = new FlxText(0, 0, FlxG.width, "Level " + (i+1).toString());
				label.size = 16;
				iButton.label = label;
				iButton.labelOffset = new FlxPoint(iButton.width, iButton.height/2-label.height/2);
				this.add(iButton);
				currentY+=iButton.height+5;
				n++;
			}
			
			_groupIndex++;
			_groupArrays.push(levels);
		}
		
		public static function getTrueLevelIndex(groupIndex:int, levelIndex:int):int
		{
			var group:Array = _groupArrays[groupIndex] as Array;
			if (levelIndex >= group.length)
				return -1;
			else
				return group[levelIndex];
		}
		
		private function gotoProceduralState():void
		{
			FlxG.switchState(new ProceduralInstructionsState());
		}
		
		
		
		private function createButtonFunction(groupIndex:int,  levelIndex:int):Function {
			return function():void {FlxG.switchState(new PlayState(groupIndex, levelIndex));};
		}
	}
	
	
}
