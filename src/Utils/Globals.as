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
		public static const TREE_TYPE:uint = enumVal++;
		public static const SEED_TYPE:uint = enumVal++;
		
		// values for water
		public static const WATER_TYPE:uint = enumVal++;
		public static const WATER_UP_TYPE:uint = WATER_TYPE;
		public static const WATER_RIGHT_TYPE:uint = enumVal++;
		public static const WATER_DOWN_TYPE:uint = enumVal++;
		public static const WATER_LEFT_TYPE:uint = enumVal++;
		
		// 
		
		
		
	}
}