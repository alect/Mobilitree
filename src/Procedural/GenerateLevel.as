package Procedural
{
	import Utils.Globals;
	import Utils.Level;
	import Utils.ResourceManager;
	
	import flash.display.BitmapData;
	
	import org.flixel.FlxG;

	public class GenerateLevel
	{
		public function GenerateLevel()
		{
		}
		
		public static function createLevel():Level
		{
			// First, just do terrain.
			var level:Level = new Level(ResourceManager.levelList[0]);
			var seed:uint = 99999 * FlxG.random();
			
			level._tilemapArray = perlinArray(9,9, seed, basicTerrainConverter);
			level._typeArray = makeArray(9, 9, Globals.EMPTY_TYPE);
			
			// Pick random location for player start as tree.
			var x:uint = FlxG.random()*9;
			var y:uint = FlxG.random()*9;
			level._typeArray[x][y] = Globals.TREE_TYPE;
			
			//trace("Min: " + minPerlin);
			//trace("Max " + maxPerlin );
			
			return level;
			
		}

		public static function makeArray(width:int, height:int,  value:*):Array
		{
			var result:Array = new Array();
			
			for (var y:int = 0; y < height; ++y)
			{
				var row:Array = new Array();
				result.push(row);
				
				for (var x:int = 0; x < width; ++x)
				{
					row.push(value);
				}
			}

			return result;
		}
		
		public static function Red(c:uint):uint {
			return (( c >> 16 ) & 0xFF);
		}
		
		public static function Green(c:uint):uint {
			return ( (c >> 8) & 0xFF );
		}
		
		public static function Blue(c:uint):uint {
			return ( c & 0xFF );
		}
		
		
		protected static var minPerlin:uint = 9999;
		protected  static var maxPerlin:uint = 0;
		
		public static function basicTerrainConverter(pixel:uint):uint
		{
			var red:uint = Red(pixel);
			var blue:uint = Blue(pixel);
			var green:uint = Green(pixel);
			
			
			if (red < minPerlin)
				minPerlin = red;
			if (red > maxPerlin)
				maxPerlin = red;
			
			// Colors go roughly 72 - 180
			
			if (blue > 110)
			{
				// Normal terrain!				
				if (red < 128)
					return Globals.SAND_TYPE;
				else
					return Globals.EMPTY_TYPE;
			}
			else
			{
				// Water!
				if (green < 128)
				{
					if (red < 128)
						return Globals.WATER_DOWN_TYPE;
					else 
						return Globals.WATER_LEFT_TYPE;
				}
				else
				{
					if (red < 128)
						return Globals.WATER_UP_TYPE;
					else 
						return Globals.WATER_RIGHT_TYPE;
				}
			}
		}
		
		
		public static function perlinArray( width:uint, height:int, seed:uint, convertToDatum:Function):Array
		{
			var perlin:BitmapData = new BitmapData(width, height, false, 0x808080);
			perlin.perlinNoise(width/2,height/2, 3, seed, true, true, 7, false);
			
			var result:Array = new Array();
			
			for (var y:int = 0; y < height; ++y)
			{
				var row:Array = new Array();
				result.push(row);
				
				for (var x:int = 0; x < width; ++x)
				{
					var pixel:uint = perlin.getPixel( x,y ); 
					if (null == convertToDatum)
						row.push( pixel );
					else
						row.push( convertToDatum(pixel) );
				}
			}
			
			return result;
		}
		
	}
}