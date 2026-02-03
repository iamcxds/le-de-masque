-- environment component: position, type, passable
--game asset
EnvAsset = {
	Floor = {
		love.graphics.newImage("assets/floor1.png"),
		love.graphics.newImage("assets/floor2.png"),
		love.graphics.newImage("assets/floor3.png"),
	},
	Wall = {
		Stone = {
			love.graphics.newImage("assets/stone_wall.png"),
			love.graphics.newImage("assets/stone_wall1.png"),
			love.graphics.newImage("assets/stone_wall2.png"),
		},
		Ice = love.graphics.newImage("assets/ice_wall.png"),
		Wood = love.graphics.newImage("assets/wood_wall.png"),
	},
	Trap = {
		Water = love.graphics.newImage("assets/water.png"),
		Gold = love.graphics.newImage("assets/pike.png"),
		Fire = love.graphics.newImage("assets/fire.png"),
		Ice = love.graphics.newImage("assets/ice_floor.png"),
	},
	Mask = {
		Stone = love.graphics.newImage("assets/stone_mask.png"),
		Gold = love.graphics.newImage("assets/gold_mask.png"),
		Wood = love.graphics.newImage("assets/wood_mask.png"),
	},
	Temp = {
		Cold = love.graphics.newImage("assets/cold.png"),
		Hot = love.graphics.newImage("assets/hot.png"),
	},

	Exit = love.graphics.newImage("assets/exit.png"),
}
---@enum (key) ComponentType
ComponentType = { Trap = 1, Wall = 0, Mask = 2 }

---@enum ( key ) MaterialType
MaterialColorMap = {
	Fire = { 1, 0, 0 },
	Water = { 0, 0, 1 },
	Wood = { 0.25, 0, 0 },
	Gold = { 1, 1, 0 },
	Earth = {
		0.5,
		0.5,
		0,
	},
	Stone = {
		0.5,
		0.5,
		0.5,
	},
	Ice = {
		54 / 256,
		139 / 256,
		193 / 256,
	},
}
---@class Component
---@field componentType ComponentType
---@field materialType MaterialType
---@field passable boolean

GameLevel = {
	--componets[x][y]
	initData = nil,
	components = { {} },
	exit = { 1, 1 },
	history = {
		--{pos,face,mask, components}
	},
	time = 0,
}
---@type fun(self,_x:number,_y:number,cT:ComponentType?,mT:MaterialType?)
function GameLevel:setComponent(_x, _y, cT, mT)
	local comp = cT and mT and {
		componentType = cT,
		materialType = mT,
		passable = true,
	}
	if comp and cT == "Wall" then
		comp.passable = false
	end
	if self.components[_x] then
		self.components[_x][_y] = comp
	else
		self.components[_x] = { [_y] = comp }
	end
end
---@type fun(self,_x:number,_y:number): Component
function GameLevel:getComponent(_x, _y)
	return GameLevel.components[_x] and GameLevel.components[_x][_y]
end
function GameLevel:setData(data)
	self.initData = data
	GameLevel:loadData(data)
end
function GameLevel:loadData(data)
	if not data then
		return
	end
	if data.playerPos then
		PlayDice:reset()
		PlayDice.pos.x = data.playerPos[1]
		PlayDice.pos.y = data.playerPos[2]
	end
	GameLevel.components = { {} }
	-- self:setComponent(4,4,"Trap","Stone")
	-- self:setComponent(3,4,"Mask","Gold")
	for _, wallLst in pairs(data.walls) do
		for x = wallLst[1], wallLst[3] do
			for y = wallLst[2], wallLst[4] do
				self:setComponent(x, y, "Wall", wallLst[5])
			end
		end
	end
	for _, mskData in pairs(data.masks) do
		self:setComponent(mskData[1], mskData[2], "Mask", mskData[3])
	end
	for _, trpData in pairs(data.traps) do
		self:setComponent(trpData[1], trpData[2], "Trap", trpData[3])
	end
	self.exit = data.exit
end
function GameLevel:restart()
	if self.initData then
		self:loadData(self.initData)
	end
end
function GameLevel:nextLevel()
	local next_id = GameLevel.initData.id + 1
	if Levels[next_id] then
		GameLevel:setData(Levels[next_id])
		return true
	else
		return false
	end
end
function GameLevel:win()
	State = "Fini"
end
function GameLevel:gameOver(text)
	PlayDice.alive = false
	State = "GameOver"
	UI.GameOver.rmk = text or ""
end
function GameLevel:saveState()
	local id = #GameLevel.history
	local now = {}
	now.components = deepcopy(self.components)
	now.pos = shallowcopy(PlayDice.pos)
	now.faces = shallowcopy(PlayDice.faces)
	now.masks = deepcopy(PlayDice.masks)
	table.insert(GameLevel.history, id + 1, now)
end
function GameLevel:undo()
	-- love.audio.stop()
	local id = #GameLevel.history
	if id > 0 then
		local last = table.remove(GameLevel.history, id)

		GameLevel.components = last.components
		PlayDice.pos = last.pos
		PlayDice.faces = last.faces
		PlayDice.masks = last.masks
		PlayDice.alive = true
	end
  SFX.undo:stop()
	SFX.undo:play()
end
function GameLevel:drawOneComponent(comp, x, y)
	love.graphics.reset()
	local material = comp.materialType
	local ctype = comp.componentType
	if ctype == "Wall" then
		local wall_t = EnvAsset.Wall[material]
		if type(wall_t) == "table" then
			love.graphics.draw(wall_t[RdTable[x + 1][y + 1]], x * TileSize, (y - 0.5) * TileSize, 0, ImgScale)
		else
			love.graphics.draw(wall_t, x * TileSize, (y - 0.5) * TileSize, 0, ImgScale)
		end
	elseif ctype == "Trap" then
		love.graphics.draw(EnvAsset.Trap[material], x * TileSize, y * TileSize, 0, ImgScale)
	elseif ctype == "Mask" then
		love.graphics.draw(EnvAsset.Mask[material], x * TileSize, y * TileSize, 0, ImgScale)
	end
end
function GameLevel:drawStage()
	love.graphics.reset()
	--draw floor
	for y = 0, 9, 1 do
		for x = 0, 9, 1 do
			love.graphics.draw(EnvAsset.Floor[RdTable[x + 1][y + 1]], x * TileSize, y * TileSize, 0, ImgScale)
			local comp = self:getComponent(x, y)
			if comp and comp.componentType~="Wall" then
				self:drawOneComponent(comp, x, y)
			end
		end
	end
	--exit
	love.graphics.draw(EnvAsset.Exit, self.exit[1] * TileSize, self.exit[2] * TileSize, 0, ImgScale)
	-- walls and player
	for y = 0, 9, 1 do
		for x = 0, 9, 1 do
			local comp = self:getComponent(x, y)
			if comp and comp.componentType== "Wall" then
				self:drawOneComponent(comp, x, y)
			end
		end
		--draw player
		if y == PlayDice.pos.y then
			PlayDice:draw()
		end
	end
end
