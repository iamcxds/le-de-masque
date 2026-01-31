MasksType = { "Zorro", "Stone", "Gold" }
---@enum (key) DiceDir
FaceMap = {
	n = { 1, 0 },
	w = { 0, 1 },
	u = { 1, 1 },
	e = { 2, 1 },
	s = { 1, 2 },
	d = { 1, 3.5 },
}
---@type fun(dx:number,dy:number):DiceDir
function Vect2Dir(dx, dy)
	if dx == 0 and dy == 0 then
		return "d"
	elseif dx > 0 then
		return "e"
	elseif dx < 0 then
		return "w"
	elseif dy > 0 then
		return "s"
	elseif dy < 0 then
		return "n"
	end
end
---@enum (key) Temperature
TemperatureColorMap = {
	Cold = {0,1,1},
	Normal = {0.5,0.5,0.5},
	Hot = {1,0,0},
}

PlayDice = {}
function PlayDice:reset()
	self.aniCor = nil
	self.color = { 0.7, 0.4, 0.5 }

	--anime

	self.ox = 0
	self.oy = 0
	self.pos = { x = 0, y = 0 }

	self.faces = {
		--up,down,north,south,east,west
		u = 1,
		d = 6,
		n = 2,
		s = 5,
		w = 4,
		e = 3,
	}
	self.masks = {
		-- [1] = { "Zorro", "Normal" },
	}
end
function PlayDice:interact(dx, dy, isMove)
	local dir = Vect2Dir(dx, dy)
	if dir then
		local d_face = self.faces[dir]
		local d_msk = self.masks[d_face]
		local tx = self.pos.x + dx
		local ty = self.pos.y + dy
		local tgComp = GameLevel:getComponent(tx, ty)
		if tgComp then
			--under
			if dir == "d" then
				--pick mask
				if tgComp.componentType == "Mask" and not d_msk then
					self.masks[d_face] = { tgComp.materialType, "Normal" }
					GameLevel:setComponent(tx, ty)
				--Step on trap
				elseif tgComp.componentType == "Trap" then
					if d_msk then
            --only normal temp mask defense
						if tgComp.materialType == "Gold"  and (d_msk[1] == "Gold" ) then
						elseif tgComp.materialType == "Fire" then
							--cold stone cool fire
							if d_msk[2] == "Cold" then
								GameLevel:setComponent(tx, ty)
								d_msk[2] = "Normal"
							--otherwise heat stone
							else
								d_msk[2] = "Hot"
								if d_msk[1] ~= "Stone" then
									GameLevel:gameOver()
								end
							end
						elseif tgComp.materialType == "Water" and (d_msk[1] == "Wood") then
						else
							GameLevel:gameOver()
						end
					else
						GameLevel:gameOver()
					end
				end
				--mask interact with surroundings
			elseif d_msk then
				if tgComp.componentType == "Wall" then
					if tgComp.materialType == "Ice" then
						if d_msk[2] == "Hot" then
							GameLevel:setComponent(tx, ty, "Trap", "Water")
							d_msk[2] = "Normal"
						else
							d_msk[2] = "Cold"
						end
					elseif tgComp.materialType == "Wood" and d_msk[2] == "Hot" then
						GameLevel:setComponent(tx, ty, "Trap", "Fire")
					elseif tgComp.materialType == "Stone" then
						d_msk[2] = "Normal"
					end
				end
				--mask has momentum to the direction
				if isMove then
					if tgComp.materialType == "Water" and d_msk[2] == "Cold" then
						GameLevel:setComponent(tx, ty, "Wall", "Ice")
					end
				end
			end
		end
	end
end

--dx,dy= +-1 or 0
function PlayDice:tryMove(_dx, _dy)
  GameLevel:saveState()
	local tx = self.pos.x + _dx
	local ty = self.pos.y + _dy
	if tx == GameLevel.exit[1] and ty == GameLevel.exit[2] then
		GameLevel:win()
	end
	PlayDice:interact(_dx, _dy, true)
	local tgComp = GameLevel:getComponent(self.pos.x + _dx, self.pos.y + _dy)
	if (not tgComp) or tgComp.passable then
		PlayDice:move(_dx, _dy)
		PlayDice:interact(0, 0)
		PlayDice:interact(1, 0)
		PlayDice:interact(0, 1)
		PlayDice:interact(-1, 0)
		PlayDice:interact(0, -1)
	end
end
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
function PlayDice:drawOneFace(dir, x, y, sy)
  sy=sy or 1
	local face = PlayDice.faces[dir]
	love.graphics.reset()
	love.graphics.rectangle("line", x, y, TileSize, TileSize*sy)
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", x, y, TileSize, TileSize*sy)
  --face num
	love.graphics.setColor({ 1, 1, 1 })
	love.graphics.print(face, x, y, 0, TileSize / 30, TileSize / 30)
	love.graphics.reset()
	local msk = self.masks[face]
	if msk then
		local msk_color = MaterialColorMap[msk[1]] or {0.7,0,0}
		love.graphics.setColor(msk_color)
		love.graphics.ellipse("fill", x + 0.5 * TileSize, y + 0.5 * TileSize*sy, 0.5 * TileSize,0.5 * TileSize*sy)
		love.graphics.setColor(TemperatureColorMap[msk[2]])
		love.graphics.print(msk[1], x, y  , 0, TileSize / 40, TileSize / 40)
		love.graphics.print(msk[2], x, y +   TileSize / 3, 0, TileSize / 40, TileSize / 40)
	end

end

function PlayDice:draw()
	PlayDice:drawOneFace("u", TileSize * (self.pos.x + self.ox), TileSize * (self.pos.y-0.5 + self.oy))
	PlayDice:drawOneFace("s", TileSize * (self.pos.x + self.ox), TileSize * (0.5+self.pos.y + self.oy),0.5)
end
function PlayDice:drawFaces()
	local pos_x = 610
	local pos_y = 0
	love.graphics.reset()

	for key, face in pairs(PlayDice.faces) do
		PlayDice:drawOneFace(key, pos_x + TileSize * FaceMap[key][1], pos_y + TileSize * FaceMap[key][2])
	end
	love.graphics.reset()
end
function PlayDice:upd()
	coRun(PlayDice.aniCor)
end
