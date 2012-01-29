package GameStates
{
	import GameObjects.Cactus;
	import GameObjects.CellObject;
	import GameObjects.Seed;
	import GameObjects.Soil;
	import GameObjects.Tree;
	
	import Procedural.RandomWalk;
	
	import Utils.*;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	
	public class PlayState extends FlxState
	{
	
		// The index into the level list of our current level
		private var _currentLevelIndex:int = 0;
		
		// The currently loaded level
		private var _currentLevel:Level;
		
		// A two dimensional array of cell object type values used by the advance turn functions for convenient access to what's on the board
		private var _gridValues:Array;
		
		// Tilemap used to easily represent non-moving objects (such as rocks, water, etc.)
		private var _tilemap:FlxTilemap;
		
		// A group representing the movable cell objects
		private var _cellObjects:FlxGroup;
		// Cells to remove at the end of the turn
		private var _cellsToRemove:Array;
		
		// Tree representing the current cell that has control
		private var _controlCell:CellObject;
		
		// Boolean representing whether we're currently advancing the turn (moving the objects)
		private var _advancingTurn:Boolean = false;
		
		// Whether we've won the level or not
		private var _gameWon:Boolean = false;
		
		// To display to the player when the level is complete
		private var _gameWonText:FlxText;
		private var _pressEnterText:FlxText;
		
		// Used as a guide for the player and the controls
		private var _uiGuideText:FlxText;
		
		// Used for a poor-man's singleton pattern
		private static var _instance:PlayState;

		protected var _walkDemo:RandomWalk = new RandomWalk();

		
		public static function get Instance():PlayState
		{
			return _instance;
		}

		public function get currentLevel():Level
		{
			return _currentLevel;
		}
		
		public function get Tilemap():FlxTilemap
		{
			return _tilemap;
		}
		
		public function get typeGrid():Array
		{
			return _gridValues;
		}
		
		public function get gameWon():Boolean
		{
			return _gameWon;
		}
		
		public function get controlCell():CellObject
		{
			return _controlCell;
		}
		
		public function set controlCell(value:CellObject):void
		{
			_controlCell = value;
		}
		
		public function PlayState(levelIndex:int)
		{
			_currentLevelIndex = levelIndex;
		}
		
		public override function create():void 
		{
			FlxG.mouse.hide();
			_instance = this;
			
			var _uiGuideString:String = "Use Arrow Keys to *Context Dependent*\n" +
				"Press R to Reset Level\n" +
				"Press Escape to Return to Menu";
			
			_uiGuideText = new FlxText(0, 0, FlxG.width, _uiGuideString);
			_uiGuideText.size = 16;
			_uiGuideText.alignment = "center";
			_uiGuideText.y = FlxG.height-_uiGuideText.height-30;
			
			_currentLevel = new Level(ResourceManager.levelList[_currentLevelIndex]);
			loadFromLevel(_currentLevel);
			
			_gameWonText = new FlxText(0, 0, FlxG.width, "Level Complete!");
			_gameWonText.alignment = "center";
			_gameWonText.size = 32;
			_pressEnterText = new FlxText(0, _gameWonText.height, FlxG.width, "press enter for next level");
			_pressEnterText.alignment = "center";
			_pressEnterText.size = 16;
			
			
	
			
		}
		
		/**
		 * Function that initializes the state based on a loaded level. 
		 */
		private function loadFromLevel(level:Level):void
		{
			_tilemap = new FlxTilemap();
			_tilemap.loadMap(level.tilemapCSV, ResourceManager.tileArt, Globals.TILE_SIZE, Globals.TILE_SIZE, FlxTilemap.OFF, 0, 0, 1);
			_tilemap.x = FlxG.width/2-_tilemap.width/2;
			_tilemap.y = FlxG.height/2-_tilemap.height/2;
			this.add(_tilemap);
			
			
			_cellObjects = new FlxGroup();
			_gridValues = [];
			var levelGrid:Array = level.typeArray;
			for(var i:int = 0; i < levelGrid.length; i++) {
				var column:Array = [];
				for (var j:int = 0; j < (levelGrid[0] as Array).length; j++) {
					column.push(levelGrid[i][j]);
					if(levelGrid[i][j] == Globals.TREE_TYPE) {
						var tree:Tree = new Tree(_tilemap.x+i*Globals.TILE_SIZE, _tilemap.y+j*Globals.TILE_SIZE, 3);
						_cellObjects.add(tree);
						trace(_tilemap.getTile(tree.gridX, tree.gridY));
						_controlCell = tree;
					}
					else if(levelGrid[i][j] == Globals.CACTUS_TYPE) {
						var cactus:Cactus = new Cactus(_tilemap.x+i*Globals.TILE_SIZE, _tilemap.y+j*Globals.TILE_SIZE, 3);
						_cellObjects.add(cactus);
						_controlCell = cactus;
						column[column.length-1] = Globals.TREE_TYPE;
					}
					else if(levelGrid[i][j] == Globals.SOIL_TYPE) {
						var soil:Soil = new Soil(_tilemap.x+i*Globals.TILE_SIZE, _tilemap.y+j*Globals.TILE_SIZE);
						_cellObjects.add(soil);
					}
				}
				_gridValues.push(column);
			}
			
			this.add(_cellObjects);
			
			this.add(_uiGuideText);
		}
		
		/**
		 * In case we get stuck, might want to reset the level
		 */
		private function resetLevel():void
		{
			this.clear();
			_advancingTurn = false;
			_gameWon = false;
			this.loadFromLevel(_currentLevel);
		}
		
		
		/**
		 * Nice utility function that handles bounds checking for finding the value of a 
		 * particular tile
		 */
		public function getGridCellType(gridX:int, gridY:int):uint
		{
			if(gridX < 0 || gridX >= _gridValues.length || gridY < 0 || gridY >= (_gridValues[0] as Array).length)
				return Globals.ROCK_TYPE; // substitute for invalid location
			return _gridValues[gridX][gridY];
		}
		
		/**
		 * Function called by advanceTurn that moves a cell in the grid to another location 
		 * in the grid and begins moving the cell via the followPath method
		 */
		public function moveCell(cell:CellObject, x:uint, y:uint):void
		{
			var oldX:uint = cell.gridX;
			var oldY:uint = cell.gridY;
			
			// place the cell in its new location
			_gridValues[x][y] = cell.type;
			cell.gridX = x;
			cell.gridY = y;
			
			// remove the cell from its old location
			_gridValues[oldX][oldY] = _tilemap.getTile(oldX, oldY);
			
			// Move the cell to the relevant location on the grid
			var movePoint:FlxPoint = new FlxPoint(_tilemap.x+x*Globals.TILE_SIZE+Globals.TILE_SIZE/2, _tilemap.y+y*Globals.TILE_SIZE+Globals.TILE_SIZE/2);
			
			cell.followPath(new FlxPath([movePoint]), 200);
			
		}
		
		public function toFlixelCoordsFromGridCoords(x:int, y:int):FlxPoint
		{
			var point:FlxPoint = new FlxPoint(_tilemap.x+x*Globals.TILE_SIZE, _tilemap.y+y*Globals.TILE_SIZE);
			return point;
		}
		
		public function setFlixelCoords(cell:CellObject):void
		{
			var point:FlxPoint = toFlixelCoordsFromGridCoords(cell.gridX, cell.gridY);
			cell.x = point.x;
			cell.y = point.y;
		}
		
		public function replaceCell(originalCell:CellObject, newCell:CellObject):void
		{
			// Change the grid
			
			if(_gridValues[originalCell.gridX][originalCell.gridY] == originalCell.type)
				_gridValues[originalCell.gridX][originalCell.gridY] = _tilemap.getTile(originalCell.gridX, originalCell.gridY);
			_cellObjects.remove(originalCell);
			
			addCell(newCell, originalCell.gridX, originalCell.gridY);

			//if(newCell.type == Globals.TREE_TYPE)
			//s	_gridValues[newCell.gridX][newCell.gridY] = Globals.TREE_TYPE;
			
			if(originalCell == _controlCell)
				_controlCell = newCell;
		}
		
		public function addCell(newCell:CellObject, grid_x:int, grid_y:int):void
		{
			newCell.gridX = grid_x;
			newCell.gridY = grid_y;
			if(_gridValues[newCell.gridX][newCell.gridY] != Globals.TREE_TYPE)
				_gridValues[newCell.gridX][newCell.gridY] = newCell.type;
			setFlixelCoords(newCell);
			
			_cellObjects.add(newCell);
			if(newCell is Seed)
				_controlCell = newCell;
		}
		
		public function removeCell(cellToRemove:CellObject):void
		{
			if(_gridValues[cellToRemove.gridX][cellToRemove.gridY] == cellToRemove.type)
				_gridValues[cellToRemove.gridX][cellToRemove.gridY] = _tilemap.getTile(cellToRemove.gridX, cellToRemove.gridY);
			_cellsToRemove.push(cellToRemove);
		}
		
		public function isTimeToAdvanceTurn():Boolean
		{
			var please_advance:Boolean = false;
			
			
			for each(var cell:CellObject in _cellObjects.members) 
				please_advance = cell.timeToAdvanceTurn() || please_advance;  // call everyone's timeToAdvance turn.
				
			return please_advance;
		}
		
		public function advanceTurn():void
		{
			for each(var cell:CellObject in _cellObjects.members) 
			cell.advanceTurn();
		}
		
		public function doneAdvancingTurn():Boolean
		{
			var done:Boolean = true;
			for each(var cell:CellObject in _cellObjects.members) {
				if(!cell.doneAdvancingTurn())
					done = false;
			}
			
			return done;
		}
		
		public function postTurn():void
		{
			// first, perform the postTurn
			for each(var cell:CellObject in _cellObjects.members)
			cell.postTurn();
			
			// If we are actually done advancing the turn, see if we have won
			_gameWon = true;
			for each(cell in _cellObjects.members) {
				if(!cell.gameWon())
					_gameWon = false;
			}
		}

		// returns true if a reset happened
		protected function checkForReset():Boolean
		{
			if(FlxG.keys.justPressed("ESCAPE")) {
				FlxG.switchState(new LevelSelectState());
			}
			
			if(FlxG.keys.justPressed("R")) {
				this.resetLevel();
				return true;
			}

			// Go back to variation 0
			if (FlxG.keys.justPressed("ZERO")) {
				reloadLevel();
				return true;
			}
			
			// Try variation type 1
			if (FlxG.keys.justPressed("ONE")) {
				reloadLevel();
				//RandomWalk.rebuild(this, 1);
				RandomWalk.rebuildWithSkip(this, 0);
				this.resetLevel();
				return true;
			}
			
			// Try variation type 1
			if (FlxG.keys.justPressed("TWO")) {
				reloadLevel();
				//RandomWalk.rebuild(this, 0.8);
				RandomWalk.rebuildWithSkip(this, 1);
				this.resetLevel();
				return true;
			}
			
			// Try variation type 1
			if (FlxG.keys.justPressed("THREE")) {
				reloadLevel();
				//RandomWalk.rebuild(this, 0.6);
				RandomWalk.rebuildWithSkip(this, 2);
				this.resetLevel();
				return true;
			}
			
			// Try variation type 1
			if (FlxG.keys.justPressed("FOUR")) {
				reloadLevel();
				//RandomWalk.rebuild(this, 0.4);
				RandomWalk.rebuildWithSkip(this, 3);
				this.resetLevel();
				return true;
			}
			
			// Try variation type 1
			if (FlxG.keys.justPressed("FIVE")) {
				reloadLevel();
				//RandomWalk.rebuild(this, 0.2);
				RandomWalk.rebuildWithSkip(this, 4);
				this.resetLevel();
				return true;
			}
			

			
			return false;
		}
		
		// Reloads the current level from embedded data, discarding all variations
		public function reloadLevel():void
		{
			_currentLevel = new Level(ResourceManager.levelList[_currentLevelIndex]);
			this.resetLevel();
		}
		
		public override function update():void
		{
			super.update();
			_cellsToRemove = [];
			
			
			if(_gameWon && FlxG.keys.justPressed("ENTER")) {
				if(_currentLevelIndex+1 < ResourceManager.levelList.length) {
					_currentLevelIndex++;
					_currentLevel = new Level(ResourceManager.levelList[_currentLevelIndex]);
					this.resetLevel();
					return;
				}
				else
					trace("OUT OF LEVELS!");
			}
			
			// did the user request a reset/reload/variant?
			if (checkForReset())
				return;
			
			if(!_gameWon) {
				var newUIText:String = _controlCell.getArrowContext() + "\r" +
					"Press R to Reset Level\r" +
					"Press Escape to Return to Menu";
				if(newUIText != _uiGuideText.text)
					_uiGuideText.text = newUIText;
			}
			
			// If we're not currently advancing the turn, need to check if we should advance
			if(!_advancingTurn && !_gameWon) {
				
				_advancingTurn = isTimeToAdvanceTurn();
				
				if(_advancingTurn)
				{
					advanceTurn();
				}
				else
				{
					if (FlxG.keys.SPACE)
					{
						_walkDemo.repeatInputProbability = 0;
						_advancingTurn = _walkDemo.walk(1, this, 0);
					}
				}
			}
			// Otherwise, see if everything is done moving (indicating that the turn advance is done)
			else if (!_gameWon) {
				
				_advancingTurn = !doneAdvancingTurn();
				if(!_advancingTurn) {
					postTurn();
					
					if(_gameWon) {
						trace("Game won!!");
						this.add(_gameWonText);
						this.add(_pressEnterText);
					}
				}
			}
			
			for each(var cell:CellObject in _cellsToRemove) {
				this.remove(cell, true);
			}
		}
		
		public function getAvatar():CellObject
		{
			// Find a tree or seed in the cell objects
			for each (var guy:CellObject in _cellObjects.members)
			{
				if (guy.isAvatar())
					return guy;
			}
			
			return null;
		}
	}
}
