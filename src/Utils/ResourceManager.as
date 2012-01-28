package Utils
{
	public class ResourceManager
	{
		
		// Art resources
		[Embed(source="assets/art/placeholder-tree.png")]
		public static var treeArt:Class;
		[Embed(source="assets/art/placeholder-deadtree.png")]
		public static var deadTreeArt:Class;
		[Embed(source="assets/art/placeholder-seed.png")]
		public static var seedArt:Class;
		[Embed(source="assets/art/placeholder-soil.png")]
		public static var soilArt:Class;
		
		[Embed(source="assets/art/placeholder-tiles.png")]
		public static var tileArt:Class;
		
		// Audio resources
		
		
		// Level resources
		[Embed(source="assets/levels/testlevel.oel", mimeType="application/octet-stream")]
		public static var testLevel:Class;
		
		[Embed(source="assets/levels/testsoil.oel", mimeType="application/octet-stream")]
		public static var testSoil:Class;
		
	}
}