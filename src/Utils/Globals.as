package Utils
{
	public class Globals
	{
		public static const TILE_SIZE:int = 30;
		
		// So we can ape normal enum behavior
		private static var enumVal:uint = 0;
		
		// values to identify cell types
		public static const EMPTY_TYPE:uint = enumVal++;
		public static const ROCK_TYPE:uint = enumVal++;
		// values for water
		public static const WATER_TYPE:uint = enumVal++;
		public static const WATER_UP_TYPE:uint = WATER_TYPE;
		public static const WATER_RIGHT_TYPE:uint = enumVal++;
		public static const WATER_DOWN_TYPE:uint = enumVal++;
		public static const WATER_LEFT_TYPE:uint = enumVal++;
		public static const WATER_END:uint = WATER_LEFT_TYPE;
		
		// The soil, which exists as both a tile and an object (I know, weird!)
		public static const SOIL_TYPE:uint = enumVal++;
		
		// Values for tree stuff
		public static const TREE_TYPE:uint = enumVal++;
		public static const SEED_TYPE:uint = enumVal++;
		public static const HAPPY_TREE_TYPE:uint = enumVal++;
		
		
		
		// 
		
		
		
	}
}