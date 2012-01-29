package Utils
{
	import flash.utils.ByteArray;
	
	import org.flixel.FlxTilemap;

	/**
	 * A simple class representing a level that can be loaded from a file and 
	 * loaded into the game state again and again
	 */
	public class Level
	{
		// The Tile coordinates for our level editor tilemap
		private static const ROCK_X:uint = 0;
		
		private static const WATER_X:uint = 30;
		private static const WATER_UP_Y:uint = 0;
		private static const WATER_RIGHT_Y:uint = 30;
		private static const WATER_DOWN_Y:uint = 60;
		private static const WATER_LEFT_Y:uint = 90;
		
		private static const TREE_X:uint = 90;
		private static const TREE_Y:uint = 0;
		private static const SOIL_Y:uint = 30;
		private static const SAND_Y:uint = 60;
		
		
		// Levels can be really simple, they basically only need to consist of a tilemap csv
		// and a two dimensional array of objects to go above the tilemap (such as trees)
		
		//private var _tilemapCSV:String;
		private var _typeArray:Array;
		
		public function get tilemapCSV():String
		{
			return arrayToCSV(_typeArray);
		}
		
		public function get typeArray():Array 
		{
			return _typeArray;
		}
		
		// Loads a level from an oel xml file 
		public function Level(xml:Class)
		{
			var rawData:ByteArray = new xml;
			var dataString:String = rawData.readUTFBytes(rawData.length);
			var xmlData:XML = new XML(dataString);
			
			var dataList:XMLList;
			var dataElement:XML;
			dataList = xmlData.grid.tile;
			
			// first, grab the width and the height
			var width:int = xmlData.width;
			var height:int = xmlData.height;
			var widthInTiles:int = Math.floor(width/Globals.TILE_SIZE);
			var heightInTiles:int = Math.floor(height/Globals.TILE_SIZE);
			
			// first initialize two arrays, one for the tilemap (that'll be turned into a CSV in the last step)
			// and one for the cell objects. Both are the same size so we can do this in one go
			var tilemapArray:Array = [];
			_typeArray = [];
			
			var i:int, j:int;
			for (i = 0; i < widthInTiles; i++) {
				var tilemapColumn:Array = [];
				var typeArrayColumn:Array = [];
				for (j = 0; j < heightInTiles; j++) {
					tilemapColumn.push(Globals.EMPTY_TYPE);
					typeArrayColumn.push(Globals.EMPTY_TYPE);
				}
				tilemapArray.push(tilemapColumn);
				_typeArray.push(typeArrayColumn);
			}
			
			// Now iterate through the data list to fill out these two arrays
			for each(dataElement in dataList) {
				var tileX:int = dataElement.@x / Globals.TILE_SIZE;
				var tileY:int = dataElement.@y / Globals.TILE_SIZE;
				
				// Look for tilemap elements first
				if (dataElement.@tx == ROCK_X) {
					tilemapArray[tileX][tileY] = Globals.ROCK_TYPE;
					_typeArray[tileX][tileY] = Globals.ROCK_TYPE;
				}
				if (dataElement.@tx == WATER_X && dataElement.@ty == WATER_UP_Y) {
					tilemapArray[tileX][tileY] = Globals.WATER_UP_TYPE;
					_typeArray[tileX][tileY] = Globals.WATER_UP_TYPE;
				}
				if (dataElement.@tx == WATER_X && dataElement.@ty == WATER_RIGHT_Y) {
					tilemapArray[tileX][tileY] = Globals.WATER_RIGHT_TYPE;
					_typeArray[tileX][tileY] = Globals.WATER_RIGHT_TYPE;
				}
				if (dataElement.@tx == WATER_X && dataElement.@ty == WATER_DOWN_Y) {
					tilemapArray[tileX][tileY] = Globals.WATER_DOWN_TYPE;
					_typeArray[tileX][tileY] = Globals.WATER_DOWN_TYPE;
				}
				if (dataElement.@tx == WATER_X && dataElement.@ty == WATER_LEFT_Y) {
					tilemapArray[tileX][tileY] = Globals.WATER_LEFT_TYPE;
					_typeArray[tileX][tileY] = Globals.WATER_LEFT_TYPE;
				}
				if (dataElement.@tx == TREE_X && dataElement.@ty == SOIL_Y) {
					tilemapArray[tileX][tileY] = Globals.SOIL_TYPE;
					_typeArray[tileX][tileY] = Globals.SOIL_TYPE;
				}
				if (dataElement.@tx == TREE_X && dataElement.@ty == SAND_Y) {
					tilemapArray[tileX][tileY] = Globals.SAND_TYPE;
					_typeArray[tileX][tileY] = Globals.SAND_TYPE;
				}
				
				// Now look for non-tilemap objects
				if (dataElement.@tx == TREE_X && dataElement.@ty == TREE_Y) {
					_typeArray[tileX][tileY] = Globals.TREE_TYPE;
				}
			}
			
			
		}
		private static function arrayToCSV(array:Array):String 
		{
			var csv:String = "";
			// Scan through row by row
			for(var j:int = 0; j < array[0].length; j++) {
				for(var i:int = 0; i < array.length; i++) {
					csv += (array[i][j] as int).toString() + ((i < array.length-1) ? ",":"\n");
				}
			}
			return csv;
		}
		
		public function forceGoalTile(x:int, y:int):void
		{
			_typeArray[x][y] = Globals.SOIL_TYPE;	
		}
		
		public function removeAllGoals():void
		{
			// Remove all goal soils:
			for (var x:uint = 0; x < typeArray.length; ++x)
			{
				for (var y:uint = 0; y < typeArray[x].length; ++y)
				{
					if (typeArray[x][y] == Globals.SOIL_TYPE)
						typeArray[x][y] = Globals.EMPTY_TYPE;
				}
			}
		}
	}
	
	
}
