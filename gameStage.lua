-- environment component: position, type, passable
--

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
  Ice ={
    0,1,1
  }
}
---@class Component
---@field componentType ComponentType
---@field materialType MaterialType
---@field passable boolean

GameLevel = {
	--componets[x][y]
  initData=nil,
	components = { {} },
  exit={ 1,1}
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
function GameLevel:getComponent(_x,_y)
  return GameLevel.components[_x] and GameLevel.components[_x][_y]
end
function GameLevel:setData(data) 
  if not self.initData then
    self.initData=data
  end
  GameLevel:loadData(data)
end
function GameLevel:loadData(data)
	if data.playerPos then
    PlayDice:reset()
		PlayDice.pos.x = data.playerPos[1]
		PlayDice.pos.y = data.playerPos[2]
	end
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
   self:setComponent(mskData[1],mskData[2],"Mask",mskData[3])
  end
  for _, trpData in pairs(data.traps) do
   self:setComponent(trpData[1],trpData[2],"Trap",trpData[3])
  end
  self.exit=data.exit
end
function GameLevel:restart()
  if self.initData then
    self:loadData(self.initData)
  end
end
function GameLevel:win()
Logs.win="You win"
end
function GameLevel:gameOver()  GameLevel:restart() end
function GameLevel:drawOneComponent(comp, x, y)
	love.graphics.reset()
	local material = comp.materialType
	local bkg_color = material and MaterialColorMap[material] or { 1, 1, 1 }
	love.graphics.setColor(bkg_color)
	local type = comp.componentType
	if type == "Wall" then
		love.graphics.rectangle("fill", x * TileSize, y * TileSize, TileSize, TileSize)
	elseif type == "Trap" then
		love.graphics.polygon(
			"fill",
			(x + 0.5) * TileSize,
			y * TileSize,
			(x + 1) * TileSize,
			(y + 1) * TileSize,
			x * TileSize,
			(y + 1) * TileSize
		)
  elseif type == "Mask" then

		love.graphics.circle("fill", (x+0.5) * TileSize, (y+0.5) * TileSize, 0.5*TileSize)
	end
end
function GameLevel:drawStage()
	for x, listy in pairs(self.components) do
		for y, comp in pairs(listy) do
			self:drawOneComponent(comp, x, y)
			Logs.comp = comp.materialType
		end
	end
 --exit
	love.graphics.setColor({0,1,0})
		love.graphics.rectangle("fill", self.exit[1] * TileSize, self.exit[2] * TileSize, TileSize, TileSize)
end
