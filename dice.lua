MasksType = { "Zorro", "Stone", "Gold" }
DiceImg = {
	love.graphics.newImage("assets/d1.png"),
	love.graphics.newImage("assets/d2.png"),
	love.graphics.newImage("assets/d3.png"),
	love.graphics.newImage("assets/d4.png"),
	love.graphics.newImage("assets/d5.png"),
	love.graphics.newImage("assets/d6.png"),
	die = love.graphics.newImage("assets/die.png"),
	cube = love.graphics.newImage("assets/cube.png"),
}
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
	Cold = { 0, 1, 1 },
	Normal = { 0.5, 0.5, 0.5 },
	Hot = { 1, 0, 0 },
}

PlayDice = {
	faces = {
		--up,down,north,south,east,west
		u = 1,
		d = 6,
		n = 2,
		s = 5,
		w = 4,
		e = 3,
	},
}
function PlayDice:reset()
	self.aniCor = nil
	self.color = { 0.7, 0.4, 0.5 }

	--anime

	self.ox = 0
	self.oy = 0
	self.pos = { x = 0, y = 0 }

	self.alive = true
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
		--under
		if dir == "d" then
			if tgComp then
				--pick mask
				if tgComp.componentType == "Mask" and not d_msk then
					self.masks[d_face] = { tgComp.materialType, "Normal" }
					GameLevel:setComponent(tx, ty)
					SFX.pick:play()
				--Step on trap
				elseif tgComp.componentType == "Trap" then
					if tgComp.materialType == "Gold" then
						if not d_msk then
							GameLevel:gameOver("Because of being pierced.")
							SFX.pike:play()
						elseif d_msk[1] ~= "Gold" then
							GameLevel:gameOver("Because being pierced with the mask.")
							SFX.broken:play()
						else
							SFX.metal_hit:play()
						end
					elseif tgComp.materialType == "Fire" then
						if not d_msk then
							GameLevel:gameOver("Because of burning in the fire.")
							SFX.fire:play()
						elseif d_msk[2] == "Cold" then
							GameLevel:setComponent(tx, ty)
							d_msk[2] = "Normal"
							SFX.cool:play()
							--otherwise heat stone
						else
							d_msk[2] = "Hot"
							SFX.fire:play()
							if d_msk[1] == "Gold" then
								GameLevel:gameOver("Because of being cooked by the mask.")
							elseif d_msk[1] == "Wood" then
								GameLevel:gameOver("Because the mask was burned.")
							end
						end
					elseif tgComp.materialType == "Water" then
						if (not d_msk) or d_msk[1] ~= "Wood" then
							GameLevel:gameOver("Because of sinking into the water.")
							SFX.sank:play()
						else
							SFX.water:play()
						end
					end
				end
			else
				SFX.step:play()
			end
			--mask interact with surroundings
		elseif d_msk and tgComp then
			if tgComp.componentType == "Wall" then
				if tgComp.materialType == "Ice" then
					if d_msk[2] == "Hot" then
						GameLevel:setComponent(tx, ty, "Trap", "Water")
						d_msk[2] = "Normal"
						SFX.cool:play()
					elseif d_msk[2] ~= "Cold" then
						d_msk[2] = "Cold"
						SFX.ice:play()
					end
				elseif tgComp.materialType == "Wood" and d_msk[2] == "Hot" then
					GameLevel:setComponent(tx, ty, "Trap", "Fire")
					SFX.fire:play()
				--cooldown to normal
				elseif d_msk[2] ~= "Normal" then
					d_msk[2] = "Normal"
					SFX.cool:play()
				end
			end
			--mask has momentum to the direction
			if isMove then
				if tgComp.materialType == "Water" and d_msk[2] == "Cold" then
					GameLevel:setComponent(tx, ty, "Wall", "Ice")
					SFX.ice:play()
				end
			end
		end
	end
end

--dx,dy= +-1 or 0
function PlayDice:tryMove(_dx, _dy)
	GameLevel:saveState()
	love.audio.stop()
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
	else
		self.aniCor = coroutine.create(self:bumpAni(-_dx, -_dy))
		SFX.wall_hit:play()
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
function PlayDice:bumpAni(_ox, _oy)
	return function()
		local prog = 1
		repeat
			prog = math.max(prog - 0.1, 0)
			self.ox = (math.abs(prog - 0.5) - 0.5) * _ox
			self.oy = (math.abs(prog - 0.5) - 0.5) * _oy
			coroutine.yield()
		until prog <= 0
		self.ox = 0
		self.oy = 0
	end
end
function PlayDice:drawOneFace(dir, x, y, sy)
	sy = sy or 1
	local face = PlayDice.faces[dir]
	love.graphics.reset()
	--face
	if not self.alive and face == 1 then
		love.graphics.draw(DiceImg.die, x, y, 0, ImgScale, sy * ImgScale)
	else
		love.graphics.draw(DiceImg[face], x, y, 0, ImgScale, sy * ImgScale)
	end
	--mask
	local msk = self.masks[face]
	if msk then
		love.graphics.draw(EnvAsset.Mask[msk[1]], x, y, 0, ImgScale, sy * ImgScale)
		--temp
		if msk[2] ~= "Normal" then
			love.graphics.draw(EnvAsset.Temp[msk[2]], x, y, 0, ImgScale, sy * ImgScale)
		end
	end
end

function PlayDice:draw()
	love.graphics.draw(
		DiceImg.cube,
		TileSize * (self.pos.x + self.ox),
		TileSize * (self.pos.y - 0.5 + self.oy),
		0,
		ImgScale
	)
	PlayDice:drawOneFace("u", TileSize * (self.pos.x + self.ox), TileSize * (self.pos.y - 0.5 + self.oy))
	PlayDice:drawOneFace("s", TileSize * (self.pos.x + self.ox), TileSize * (0.5 + self.pos.y + self.oy), 0.5)
end

Dice_UI_x = 610
Dice_UI_y = 0
function PlayDice:drawFaces()
	love.graphics.reset()

	for key, face in pairs(PlayDice.faces) do
		PlayDice:drawOneFace(key, Dice_UI_x + TileSize * FaceMap[key][1], Dice_UI_y + TileSize * FaceMap[key][2])
	end
	love.graphics.reset()
end
function PlayDice:upd()
	coRun(PlayDice.aniCor)
end
