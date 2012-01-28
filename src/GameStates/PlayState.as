package GameStates
{
	import GameObjects.CellObject;
	import GameObjects.Soil;
	import GameObjects.Tree;
	
	import Utils.*;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	
	public class PlayState extends FlxState
	{
	
		
		// The currently loaded level
		private var _currentLevel:Level;
		
		// A two dimensional array of cell object type values used by the advance turn functions for convenient access to what's on the board
		private var _gridValues:Array;
		
		// Tilemap used to easily represent non-moving objects (such as rocks, water, etc.)
		private var _tilemap:FlxTilemap;
		
		// A group representing the movable cell objects
		private var _cellObjects:FlxGroup;
		
		// Tree representing the current tree that has control
		private var _currentTree:Tree;
		
		// Boolean representing whether we're currently advancing the turn (moving the objects)
		private var _advancingTurn:Boolean = false;
		
		// Used for a poor-man's singleton pattern
		private static var _instance:PlayState;
		
		public static function get Instance():PlayState
		{
			return _instance;
		}
		
		public function get Tilemap():FlxTilemap
		{
			return _tilemap;
		}
		
		public function get typeGrid():Array
		{
			return _gridValues;
		}
		
		
		public override function create():void 
		{
			_instance = this;
			
			_currentLevel = new Level(ResourceManager.testSoil);
			loadFromLevel(_currentLevel);
			
		}
		
		/**
		 * Function that initializes the state based on a loaded level. 
		 */
		private function loadFromLevel(level:Level):void
		{
			_tilemap = new FlxTilemap();
			_tilemap.loadMap(level.tilemapCSV, ResourceManager.tileArt, Globals.TILE_SIZE, Globals.TILE_SIZE, FlxTilemap.OFF, 0, 0, 1);
			_tilemap.x = 90;
			_tilemap.y = 60;
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
					}
					else if(levelGrid[i][j] == Globals.SOIL_TYPE) {
						var soil:Soil = new Soil(_tilemap.x+i*Globals.TILE_SIZE, _tilemap.y+j*Globals.TILE_SIZE);
						_cellObjects.add(soil);
					}
				}
				_gridValues.push(column);
			}
			
			this.add(_cellObjects);
		}
		
		/**
		 * In case we get stuck, might want to reset the level
		 */
		private function resetLevel():void
		{
			this.clear();
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
			// remove the cell from its old location
			_gridValues[oldX][oldY] = _tilemap.getTile(oldX, oldY);
			
			// Move the cell to the relevant location on the grid
			var movePoint:FlxPoint = new FlxPoint(_tilemap.x+x*Globals.TILE_SIZE+Globals.TILE_SIZE/2, _tilemap.y+y*Globals.TILE_SIZE+Globals.TILE_SIZE/2);
			
			cell.followPath(new FlxPath([movePoint]));
			
		}
		
		public function replaceCell(originalCell:CellObject, newCell:CellObject):void
		{
			// Change the grid
			_gridValues[originalCell.gridX][originalCell.gridY] = newCell.type;
			_cellObjects.remove(originalCell);
			_cellObjects.add(newCell);
		}
		
		public function addCell(newCell:CellObject):void
		{
			_gridValues[newCell.gridX][newCell.gridY] = newCell.type;
			_cellObjects.add(newCell);
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
		
		public override function update():void
		{
			super.update();
			
			if(FlxG.keys.justPressed("R")) {
				this.resetLevel();
				return;
			}
			
			// If we're not currently advancing the turn, need to check if we should advance
			if(!_advancingTurn) {
				
				_advancingTurn = isTimeToAdvanceTurn();
				
				if(_advancingTurn)
				{
					advanceTurn();
				}
			}
			// Otherwise, see if everything is done moving (indicating that the turn advance is done)
			else {
				_advancingTurn = false;
				for each(var cell:CellObject in _cellObjects.members) {
					if(!cell.doneAdvancingTurn())
						_advancingTurn = true;
				}
			}
			
		}
	}
}