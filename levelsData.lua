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
    playerPos={1,1},
    walls={
      {0,0,5,0, "Stone"},
      {5,1,5,5, "Stone"},
      {0,1,0,5, "Stone"},
      {0,5,4,5, "Stone"},
      {1,2,3,5, "Stone"},
    },
    masks={
      {2,1,"Gold"},
    },
    traps={
      {4,3,"Gold"},
    },
    exit={4,4},
	},

	{
    id=2,
		name = "Level2",
    playerPos={1,1},
    walls={
      {0,0,6,0, "Stone"},
      {6,1,6,5, "Stone"},
      {0,1,0,5, "Stone"},
      {0,5,5,5, "Stone"},
      {1,2,3,5, "Stone"},
      {4,3,4,5, "Stone"},
    },
    masks={
      {2,1,"Gold"},
    },
    traps={
      {5,3,"Gold"},
    },
    exit={5,4},
	},
	{
    id=3,
		name = "Level3",
    playerPos={1,1},
    walls={
      {0,0,6,0, "Stone"},
      {6,1,6,5, "Stone"},
      {0,1,0,5, "Stone"},
      {0,5,5,5, "Stone"},
      {1,2,2,5, "Stone"},
      {3,3,3,5, "Stone"},
      {5,2,5,5, "Stone"},
    },
    masks={
      {2,1,"Gold"},
      {5,1,"Stone"},
    },
    traps={
      {4,3,"Fire"},
    },
    exit={4,4},
	},
	{
    id=4,
		name = "Level4",
    playerPos={1,1},
    walls={
      {0,0,4,0, "Stone"},
      {4,1,4,7, "Stone"},
      {0,1,0,7, "Stone"},
      {0,7,4,7, "Stone"},
      {1,3,2,6, "Stone"},
    },
    masks={
      {3,1,"Gold"},
      {2,1,"Stone"},
    },
    traps={
      {3,5,"Fire"},
      {3,3,"Gold"},
    },
    exit={3,6},
	},
	{
    id=5,
		name = "Level5",
    playerPos={1,1},
    walls={
      {0,0,6,0, "Stone"},
      {5,2,6,4, "Stone"},
      {6,1,6,1, "Stone"},
      {0,1,0,4, "Stone"},
      {1,4,5,4, "Stone"},
      {0,6,5,5, "Stone"},
      {4,1,4,1, "Wood"},
      {1,2,2,2, "Stone"},
    },
    masks={
      {2,1,"Stone"},
    },
    traps={
      {2,3,"Fire"},
    },
    exit={5,1},
	},
	{
    id=6,
		name = "Level6",
    playerPos={1,1},
    walls={
      {0,0,6,0, "Stone"},
      {6,1,6,3, "Ice"},
      {0,1,0,3, "Stone"},
      {0,4,2,5, "Stone"},
      {3,5,4,5, "Stone"},
      {5,4,6,5, "Stone"},
      {1,2,4,2, "Stone"},
    },
    masks={
      {2,1,"Gold"},
      {3,1,"Wood"},
    },
    traps={
      {2,3,"Water"},
      {5,3,"Water"},
    },
    exit={1,3},
	},
	{
    id=7,
		name = "Level7",
    playerPos={3,1},
    walls={
      {0,0,7,0, "Stone"},
      {7,1,7,5, "Stone"},
      {0,1,0,4, "Ice"},
      {0,5,6,5, "Stone"},
      {1,4,2,4, "Stone"},
      {2,3,2,3, "Ice"},
      {1,2,5,2, "Stone"},
    },
    masks={
      {4,1,"Gold"},
      {5,3,"Stone"},
      {5,4,"Wood"},
    },
    traps={
      {6,3,"Fire"},
      {6,4,"Fire"},
    },
    exit={1,3},
	},
	{
    id=8,
		name = "Level8",
    playerPos={4,3},
    walls={
      {0,0,9,0, "Stone"},
      {9,1,9,5, "Stone"},
      {0,1,0,5, "Stone"},
      {1,5,8,5, "Stone"},

      {3,2,4,2, "Ice"},
      {7,2,7,2, "Wood"},
      {8,1,8,1, "Stone"},

      {1,3,1,4, "Stone"},
      {5,3,5,4, "Stone"},
      {6,3,7,3, "Stone"},
    },
    masks={
      {6,1,"Gold"},
      {4,4,"Stone"},
    },
    traps={
      {2,2,"Fire"},
      {7,4,"Gold"},
    },
    exit={6,4},
	},
	test={
    id=0,
		name = "test",
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
      {4,4,"Gold"},
      {5,5,"Fire"},
      {3,5,"Water"},
    },
    exit={7,8},
	},
}
