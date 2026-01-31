-- environment component: position, type, passable
--

---@enum (key) ComponentType
ComponentType={Trap=1,Wall=0,Mask=2}
MaterialType={"Fire","Water","Wood","Gold","Earth","Stone"}

---@enum ( key ) MaterialType
MaterialColorMap={Fire={1,0,0},Water={0,0,1},Wood={0.25,0,0},Gold={1,1,0},Earth={0.5,0.5,0},Stone={0.5,0.5,0.5}}
---@class Component
---@field componentType ComponentType
---@field materialType MaterialType

GameLevel={ 
  --componets[x][y]
components={{}}
}
---@type fun(self,_x:number,_y:number,cT:ComponentType,mT:MaterialType)
function GameLevel:newComponent(_x,_y,cT,mT)
  local comp={
    componentType=cT,
    materialType=mT,
    passable=true,
  }
  if cT=="Wall" then
    comp.passable=false
  end
  if self.components[_x] then
  self.components[_x][_y]=comp
  else
  self.components[_x]={[_y]=comp}
  end
end

function GameLevel:loadData(data)
  if data.playerPos then
    PlayDice.pos.x=data.playerPos[1]
    PlayDice.pos.y=data.playerPos[2]
  end
  for _, wallLst in pairs(data.walls) do
    for x = wallLst[1], wallLst[3] do
    for y = wallLst[2], wallLst[4] do
     self:newComponent(x,y,"Wall",wallLst[5])
    end
    end
  end
end

function GameLevel:drawOneComponent(comp,x,y)

	love.graphics.reset()
  local material= comp.materialType
  local bkg_color= material and  MaterialColorMap[material] or {1,1,1}
	love.graphics.setColor(bkg_color)
	love.graphics.rectangle(
		"fill",
    (x)*TileSize,
    (y)*TileSize,
		TileSize,
		TileSize
	)
end
function GameLevel:drawComponents()
  for x, listy in pairs(self.components) do
    for y, comp in pairs(listy) do
     self:drawOneComponent(comp,x,y)
      Logs.comp=comp.materialType
    end
  end
end
