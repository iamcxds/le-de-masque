MasksType = { "Zorro", "Earth", "Gold" }
---@enum (key) DiceFace
FaceMap={
  n={1,0},
  w={0,1},
  u={1,1},
  e={2,1},
  s={1,2},
  d={1,3},
}
PlayDice = {

	color = { 0.7, 0.4, 0.5 },
	--anime

	ox = 0,
	oy = 0,
	pos = { x = 0, y = 0 },

	faces = {
		--up,down,north,south,east,west
		u = 1,
		d = 6,
		n = 2,
		s = 5,
		w = 4,
		e = 3,
	},
	masks = {
		[1] = "Earth",

    [6]="Gold"
	},
}

--dx,dy= +-1 or 0
function PlayDice:move(_dx, _dy)
	if _dx ~= 0 then
		--east,west
		self.pos.x = self.pos.x + _dx
		--change face
		--
		local new_u
		local new_d
		local new_e
		local new_w
		if _dx > 0 then
			--east
			new_u = self.faces.w
			new_d = self.faces.e
			new_e = self.faces.u
			new_w = self.faces.d
		else
			--west
			new_u = self.faces.e
			new_d = self.faces.w
			new_e = self.faces.d
			new_w = self.faces.u
		end
		self.faces.u = new_u
		self.faces.d = new_d
		self.faces.e = new_e
		self.faces.w = new_w
		self.aniCor = coroutine.create(self:moveAni(-_dx, -_dy))
	elseif _dy ~= 0 then
		--north,south
		self.pos.y = self.pos.y + _dy
		--change face
		--
		local new_u
		local new_d
		local new_n
		local new_s
		if _dy > 0 then
			--south
			new_u = self.faces.n
			new_d = self.faces.s
			new_s = self.faces.u
			new_n = self.faces.d
		else
			--north
			new_u = self.faces.s
			new_d = self.faces.n
			new_s = self.faces.d
			new_n = self.faces.u
		end
		self.faces.u = new_u
		self.faces.d = new_d
		self.faces.n = new_n
		self.faces.s = new_s

		self.aniCor = coroutine.create(self:moveAni(-_dx, -_dy))
	end
end

function PlayDice:moveAni(_ox, _oy)
	return function()
		local prog = 1
		repeat
			prog = math.max(prog - 0.1, 0)
			self.ox = prog * _ox
			self.oy = prog * _oy
			coroutine.yield()
		until prog <= 0
		self.ox = 0
		self.oy = 0
	end
end

function PlayDice:drawOneFace(dir,x,y) 

  local face= PlayDice.faces[dir]
	love.graphics.reset()
  local msk =self.masks[face]
  local bkg_color= msk and  MaterialColorMap[msk] or self.color
	love.graphics.setColor(bkg_color)
	love.graphics.rectangle(
		"fill",
    x,
    y,
		TileSize,
		TileSize
	)
  
	love.graphics.setColor({ 1, 1, 1 })
	love.graphics.print(
    msk or face,
    x,
    y,
		0,
		TileSize / 30,
		TileSize / 30
	)
	love.graphics.reset()
end

function PlayDice:draw()
  PlayDice:drawOneFace("u",
		TileSize * (self.pos.x + self.ox),
		TileSize * (self.pos.y + self.oy))
end
function PlayDice:drawFaces()
  local pos_x= 600
  local pos_y= 0
	love.graphics.reset()
  
  for key, face in pairs(PlayDice.faces) do
   PlayDice:drawOneFace(key,
		pos_x+TileSize * (FaceMap[key][1]),
		pos_y+TileSize * (FaceMap[key][2])
    ) 
  end
	love.graphics.reset()
end
function PlayDice:upd()
	coRun(PlayDice.aniCor)
end
