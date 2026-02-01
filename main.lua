require("dice")
require("helpFun")
require("gameStage")
require("levelsData")
require("UI")

-- Load some default values for our rectangle.
function love.load()
	font = love.graphics.newFont("assets/pixel.ttf", 30)
	love.window.setTitle("Le Dé Masqué")
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.window.setMode(800, 600, { resizable = true })
	TileSize = 64
	ImgScale = TileSize / 32

	SFX = {
		step = love.audio.newSource("assets/step.wav", "static"),
		wall_hit = love.audio.newSource("assets/wall_hit.ogg", "static"),
		metal_hit = love.audio.newSource("assets/metal_hit.wav", "static"),
		pick = love.audio.newSource("assets/pick.wav", "static"),
		pike = love.audio.newSource("assets/pike.wav", "static"),
		broken = love.audio.newSource("assets/broken.flac", "static"),
		fire = love.audio.newSource("assets/fire.ogg", "static"),
		cool = love.audio.newSource("assets/cool.mp3", "static"),
		ice = love.audio.newSource("assets/ice.wav", "static"),
		water = love.audio.newSource("assets/water.flac", "static"),
		sank = love.audio.newSource("assets/sank.mp3", "static"),
		undo = love.audio.newSource("assets/undo.mp3", "static"),
	}
	Bkg = love.graphics.newImage("assets/bkg.png")

	--{"Game","MainMenu","LevelMenu","Pause","Fini","GameOver"}
	State = "MainMenu"

	-- State = "Game"
	-- GameLevel:setData(Levels.test)
	RdTable = {}
	for x = 0, 9, 1 do
		local x_lst = {}
		for y = 0, 9, 1 do
			local r_id = math.random(3)
			table.insert(x_lst, r_id)
		end
		table.insert(RdTable, x_lst)
	end

	UI:addLevels()
	Logs = {}
end

-- Increase the size of the rectangle every frame.
function love.update(dt)
	gameUpd()
end

-- GScale = 1
-- GoX, GoY = 0, 0
-- Draw a coloured rectangle.
function love.draw()
	-- local wW, wH = love.graphics.getWidth(), love.graphics.getHeight()
	-- GScale = math.min(wW / 1000, wH / 800)
	-- GoX, GoY = (wW - GScale * 1000) / 2, (wH - GScale * 800) / 2
	-- love.graphics.translate(GoX, GoY)
	-- love.graphics.scale(GScale)
	local wW, wH = love.graphics.getWidth(), love.graphics.getHeight()
	love.graphics.setColor(0.2, 0.3, 0.4)
	love.graphics.rectangle("fill", 0, 0, wW, wH)
	love.graphics.reset()
	--Game Draw
	if State ~= "MainMenu" and State ~= "LevelMenu" then
		GameLevel:drawStage()
		-- PlayDice:draw()
		PlayDice:drawFaces()
	else
		love.graphics.draw(Bkg, 250, 70, 0, 5)
	end

	--UI
	if UI[State] then
		for index, value in ipairs(UI[State]) do
			value:draw()
		end
	end

	--debug
	-- local logText = ""
	-- for key, value in pairs(Logs) do
	-- 	logText = logText .. key .. ":" .. value .. "\n"
	-- end
	-- love.graphics.print(logText)
end

function love.mousereleased(x, y, btn)
	UI_mouseprsd(UI[State], x, y, btn)
end

function love.keypressed(key)
	Logs.keydown = key
	if State ~= "MainMenu" and State ~= "LevelMenu" then
		if key == "r" then
			GameLevel:restart()
			State = "Game"
		end
		if key == "z" then
			GameLevel:undo()
			State = "Game"
		end
	end
	if State == "Game" then
		if key == "escape" then
			State = "Pause"
		end
		if key == "left" or key == "a" then
			PlayDice:tryMove(-1, 0)
		end
		if key == "right" or key == "d" then
			PlayDice:tryMove(1, 0)
		end
		if key == "down" or key == "s" then
			PlayDice:tryMove(0, 1)
		end
		if key == "up" or key == "w" then
			PlayDice:tryMove(0, -1)
		end
	elseif State == "Pause" and key == "escape" then
		State = "Game"
	elseif State == "Fini" and key == "escape" then
		GameLevel:nextLevel()
		State = "Game"
	end
end

function gameUpd()
	PlayDice:upd()
end
