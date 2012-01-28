package GameStates
{
	import GameObjects.CellObject;
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
	
		// Test the tilemap out a bit
		private var _testCSV:String =  
			"0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0\n" +
			"0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0\n" +
			"0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0\n" +
			"0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0\n" +
			"0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0\n" +
			"0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0\n" +
			"0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0\n" +
			"0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0\n" +
			"0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0\n" +
			"0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0\n" +
			"0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0\n" +
			"0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0\n" +
			"0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0\n" +
			"0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0";
		
		
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
			_tilemap = new FlxTilemap();
			_tilemap.loadMap(_testCSV, ResourceManager.tileArt, Globals.TILE_SIZE, Globals.TILE_SIZE, FlxTilemap.OFF, 0, 0, 1);
			_tilemap.x = 90;
			_tilemap.y = 60;
			this.add(_tilemap);
			
			// create our convenient grid
			_gridValues = [];
			for(var i:int = 0; i < _tilemap.widthInTiles; i++) {
				var column:Array = [];
				for(var j:int = 0; j < _tilemap.heightInTiles; j++) {
					column.push(_tilemap.getTile(i, j));
				}
				_gridValues.push(column);
			}
			
			
			_cellObjects = new FlxGroup();
			
			
			_currentTree = new Tree(90, 60, 3);
			_gridValues[_currentTree.gridX][_currentTree.gridY] = _currentTree.type;
			_cellObjects.add(_currentTree);
			
			this.add(_cellObjects);
			
			
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
			_gridValues[oldX][oldY] = Globals.EMPTY_TYPE;
			
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
		
		public override function update():void
		{
			super.update();
			
			// If we're not currently advancing the turn, need to check if we should advance
			if(!_advancingTurn) {
				for each(var cell:CellObject in _cellObjects.members) {
					_advancingTurn = _advancingTurn ? true : cell.timeToAdvanceTurn();
				}
				if(_advancingTurn)
				{
					for each(var cell:CellObject in _cellObjects.members) 
						cell.advanceTurn();
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