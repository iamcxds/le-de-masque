require("levelsData")
require("dice")
UI = {}

BtnImg = {
	l = love.graphics.newImage("assets/btn_l.png"),
	m = love.graphics.newImage("assets/btn_m.png"),
	r = love.graphics.newImage("assets/btn_r.png"),
}

local cyan = { 37 / 255, 253 / 255, 233 / 255 }
--win= {x,y,w,h,draw(),is_over(x,y):bool,click()}

function newWin(x, y, w, h, _draw, _click)
	local win = { x = x, y = y, w = w, h = h, draw = _draw or function() end, click = _click or function() end }
	win.is_over = function(self, _x, _y)
		local rx, ry = _x, _y --(_x - GoX) / GScale, (_y - GoY) / GScale
		return (self.x <= rx and rx <= self.x + self.w) and (self.y <= ry and ry <= self.y + self.h)
	end
	return win
end

function newBtn(x, y, w, h, text, _sc, _click)
	local sc = _sc or 1
	local btn_w, btn_h = BtnImg.m:getDimensions()
	local btn_sc_w = w / btn_w
	local btn_sc_h = h / btn_h
	local function _draw(self)
		love.graphics.reset()
		local ox_l = BtnImg.l:getWidth() * btn_sc_h
		local ox_r = BtnImg.r:getWidth() * btn_sc_h
		love.graphics.draw(BtnImg.l, self.x - ox_l, self.y, 0, btn_sc_h)
		love.graphics.draw(BtnImg.m, self.x, self.y, 0, btn_sc_w, btn_sc_h)
		love.graphics.draw(BtnImg.r, self.x + self.w, self.y, 0, btn_sc_h)
		love.graphics.setColor({ 0, 0, 0 })
		love.graphics.printf(text, font, self.x - ox_l, self.y, (ox_l + ox_r + self.w) / sc, "center", nil, sc, sc)
		love.graphics.reset()
	end

	return newWin(x, y, w, h, _draw, _click)
end

UI.MainMenu = {
	--Title
	-- newBtn(200, 150, 500, 80, "Le Dé Masqué", 2),

	newBtn(350, 400, 100, 40, "Start", 1, function()
		State = "LevelMenu"
	end),
	newBtn(350, 500, 100, 40, "Exit", 1, function()
		love.window.close()
	end),
	-- newWin(200, 400, 100, 50, function(self)
	--    local img =PlayBubAnim[1]
	--    local sc=0.5
	--    love.graphics.setColor(1,1,1)
	-- 	love.graphics.draw(img, self.x, self.y, nil, sc,sc, img:getWidth() / 2, img:getHeight() / 2)
	-- end),
	-- newWin(800, 400, 100, 50, function(self)
	--    local img =TurnerAnim[1]
	--    local sc=3
	--    love.graphics.setColor(1,1,1)
	-- 	love.graphics.draw(img, self.x, self.y, nil, sc,sc, img:getWidth() / 2, img:getHeight() / 2)
	-- end),
}

UI.LevelMenu = {

	newBtn(450, 400, 100, 40, "Back", 1, function()
		State = "MainMenu"
	end),
}

function UI:addLevels()
	for index, level in ipairs(Levels) do
		index = index - 1
		local btn = newBtn(
			100 + 150 * (index % 4),
			200 + 100 * math.floor(index / 4),
			100,
			40,
			level.name,
			1,
			function()
				GameLevel:setData(level)
				State = "Game"
			end
		)
		table.insert(self.LevelMenu, btn)
	end
	for dir, pos in pairs(FaceMap) do
		local px, py = Dice_UI_x + TileSize * pos[1], Dice_UI_y + TileSize * pos[2]
		local btn = nil
		if dir == "d" then
			btn = newWin(px, py, TileSize, TileSize, nil, function()
				GameLevel:undo()
			end)
		elseif dir ~= "u" then
			btn = newWin(px, py, TileSize, TileSize, nil, function()
				PlayDice:tryMove(pos[1] - 1, pos[2] - 1)
			end)
		end
		table.insert(UI.Game, btn)
	end
end

UI.Game = {
	--level name
	newWin(600, 300, 200, 40, function(self)
		love.graphics.setColor(0.5, 0.5, 0.5)
		love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
		love.graphics.setColor(cyan)
		love.graphics.printf(GameLevel.initData.name, font, self.x, self.y, self.w, "center")
	end),
	newWin(600, 350, 200, 120, function(self)
		love.graphics.setColor(0.5, 0.5, 0.5, 0.7)
		love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
		love.graphics.setColor(cyan)
		love.graphics.printf("arrow move\n 'z' undo\n 'r' reset", font, self.x, self.y, self.w, "center")
	end),
}
UI.Pause = {

	newBtn(350, 100, 300, 40, "Resume", 1, function()
		State = "Game"
	end),
	newBtn(350, 200, 300, 40, "Restart", 1, function()
		GameLevel:restart()
		State = "Game"
	end),
	newBtn(350, 300, 300, 40, "Back to Levels", 1, function()
		State = "LevelMenu"
	end),
	newBtn(350, 400, 300, 40, "Back to Menu", 1, function()
		State = "MainMenu"
	end),
}
UI.GameOver = {

	newWin(300, 50, 400, 120, function(self)
		love.graphics.setColor(0.5, 0.5, 0.5, 0.7)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
		love.graphics.setColor({ 1, 1, 1 })
		love.graphics.printf("You Dead! \n" .. UI.GameOver.rmk, font, self.x, self.y, self.w, "center")
	end),
	newBtn(350, 200, 300, 40, "Undo", 1, function()
		GameLevel:undo()
		State = "Game"
	end),
	newBtn(350, 300, 300, 40, "Restart", 1, function()
		GameLevel:restart()
		State = "Game"
	end),
	newBtn(350, 400, 300, 40, "Back to Levels", 1, function()
		State = "LevelMenu"
	end),
	newBtn(350, 500, 300, 40, "Back to Menu", 1, function()
		State = "MainMenu"
	end),
}
UI.Fini = {

	newWin(300, 50, 400, 120, function(self)
		love.graphics.setColor(0.5, 0.5, 0.5, 0.7)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
		love.graphics.setColor(cyan)
		love.graphics.printf("You Escaped! \n", font, self.x, self.y, self.w, "center")
	end),
	newBtn(350, 200, 300, 40, "Next Level", 1, function()
		if GameLevel:nextLevel() then
			State = "Game"
		end
	end),
	newBtn(350, 300, 300, 40, "Restart", 1, function()
		GameLevel:restart()
		State = "Game"
	end),
	newBtn(350, 400, 300, 40, "Back to Levels", 1, function()
		State = "LevelMenu"
	end),
	newBtn(350, 500, 300, 40, "Back to Menu", 1, function()
		State = "MainMenu"
	end),
}

function UI_mouseprsd(winList, x, y, button)
	if button == 1 and winList then
		for index, win in ipairs(winList) do
			if win.click and win:is_over(x, y) then
				win.click()
			end
		end
	end
end
