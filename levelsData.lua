Levels = {

	--  {
	--   name="Demo",
	-- 	playDice = { 2, 3 },
	-- 	walls = {
	-- 	--{x1,y1,x2,y2,material}
	-- 		{ 1, 4, 5, 0, "Stone" },
	-- 		{ 140, 102, 520, 10, "Wood" },
	-- 	},
	--  traps={
	--  --{x,y,material}
  --
	--  },
	-- 	masks = {
	--  --{x,y,material}
	-- 		{ 200, 300, "Gold" },
	-- 		{ 300, 500 },
	-- 		{ 700, 200 },
	-- 	},
	--   minScore=2
	-- },
	{
    id=1,
		name = "Level1",
    playerPos={2,3},
    walls={
      {0,0,0,5, "Stone"},
      {1,0,5,0, "Stone"},
      {2,5,2,5,"Ice"},
      {2,8,2,9,"Wood"},
    },
    masks={
      {3,3,"Gold"},
      {3,4,"Stone"},
      {2,2,"Wood"},
    },
    traps={
      {4,4,"Stone"},
      {5,5,"Fire"},
      {3,5,"Water"},
    },
    exit={7,8},
	},
}
