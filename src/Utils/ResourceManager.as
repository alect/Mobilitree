package Utils
{
	public class ResourceManager
	{
		
		// Art resources
		[Embed(source="assets/art/tree.png")]
		public static var treeArt:Class;
		[Embed(source="assets/art/deadtree.png")]
		public static var deadTreeArt:Class;
		[Embed(source="assets/art/seed.png")]
		public static var seedArt:Class;
		
		[Embed(source="assets/art/cactus.png")]
		public static var cactusArt:Class;
		
		[Embed(source="assets/art/deadcactus.png")]
		public static var deadCactusArt:Class;
		
		
		[Embed(source="assets/art/goldtree.png")]
		public static var goldTreeArt:Class;
		
		[Embed(source="assets/art/tiles.png")]
		public static var tileArt:Class;
		
		[Embed(source="assets/art/title.png")]
		public static var titleArt:Class;
		
		[Embed(source="assets/art/button.png")]
		public static var buttonArt:Class;
		
		
		// Audio resources
		[Embed(source="assets/audio/Planty_Plants.mp3")]
		public static var bgMusic:Class;
		
		[Embed(source="assets/audio/Tree_moving.mp3")]
		public static var treeMovingSound:Class;
		
		[Embed(source="assets/audio/Tree_drying_up.mp3")]
		public static var treeDyingSound:Class;
		
		[Embed(source="assets/audio/UI_clunk_button.mp3")]
		public static var plantingSeedSound:Class;
		
		[Embed(source="assets/audio/Seed_growth.mp3")]
		public static var seedGrowingSound:Class;
		
		[Embed(source="assets/audio/Seed_through_water_2.mp3")]
		public static var seedFloatingSound:Class;
		
		[Embed(source="assets/audio/Victory_sound_individual.mp3")]
		public static var happyTreeGrowingSound:Class;
		
		[Embed(source="assets/audio/Victory_sound_level.mp3")]
		public static var levelWinSound:Class;
		
		// Level resources
		
		
		[Embed(source="assets/levels/testlevel.oel", mimeType="application/octet-stream")]
		public static var testLevel:Class;
		
		[Embed(source="assets/levels/testlevel2.oel", mimeType="application/octet-stream")]
		public static var testLevel2:Class;
		
		[Embed(source="assets/levels/testsoil.oel", mimeType="application/octet-stream")]
		public static var testSoil:Class;
		
		[Embed(source="assets/levels/level2sand.oel", mimeType="application/octet-stream")]
		public static var testSand:Class;
		
		
		[Embed(source="assets/levels/level1.oel", mimeType="application/octet-stream")]
		public static var level1:Class;
		
		[Embed(source="assets/levels/level2.oel", mimeType="application/octet-stream")]
		public static var level2:Class;
		
		[Embed(source="assets/levels/level3.oel", mimeType="application/octet-stream")]
		public static var level3:Class;
		
		[Embed(source="assets/levels/level4.oel", mimeType="application/octet-stream")]
		public static var level4:Class;
		
		[Embed(source="assets/levels/level5.oel", mimeType="application/octet-stream")]
		public static var level5:Class;
		
		[Embed(source="assets/levels/level6.oel", mimeType="application/octet-stream")]
		public static var level6:Class;
		
		[Embed(source="assets/levels/level7.oel", mimeType="application/octet-stream")]
		public static var level7:Class;
		
		[Embed(source="assets/levels/level8.oel", mimeType="application/octet-stream")]
		public static var level8:Class;
		
		[Embed(source="assets/levels/level9.oel", mimeType="application/octet-stream")]
		public static var level9:Class;
		
		[Embed(source="assets/levels/level10.oel", mimeType="application/octet-stream")]
		public static var level10:Class;
		
		[Embed(source="assets/levels/level11.oel", mimeType="application/octet-stream")]
		public static var level11:Class;
		
		[Embed(source="assets/levels/level12.oel", mimeType="application/octet-stream")]
		public static var level12:Class;


		[Embed(source="assets/levels/level13.oel", mimeType="application/octet-stream")]
		public static var level13:Class;
		
		[Embed(source="assets/levels/level14.oel", mimeType="application/octet-stream")]
		public static var level14:Class;
		
		[Embed(source="assets/levels/level15.oel", mimeType="application/octet-stream")]
		public static var level15:Class;
		
		[Embed(source="assets/levels/level16.oel", mimeType="application/octet-stream")]
		public static var level16:Class;
		
		[Embed(source="assets/levels/level17.oel", mimeType="application/octet-stream")]
		public static var level17:Class;
		
		[Embed(source="assets/levels/level18.oel", mimeType="application/octet-stream")]
		public static var level18:Class;
		
		[Embed(source="assets/levels/level19.oel", mimeType="application/octet-stream")]
		public static var level19:Class;
		
		[Embed(source="assets/levels/level20.oel", mimeType="application/octet-stream")]
		public static var level20:Class;
		
		public static var levelList:Array = [level1, level2, level3, level5, level4, level7, level8, level13, level10, level6, level11, level12, level14, level15, level16, level17, level18, level20];		
	}
}
