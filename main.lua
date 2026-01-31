require("dice")
require("helpFun")
require("gameStage")
require("levelsData")
require("UI")

-- Load some default values for our rectangle.
function love.load()
	font = love.graphics.newFont(30)
	love.window.setTitle("Le Dé Masqué")
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.window.setMode(800, 600, { resizable = true })
	TileSize = love.graphics.getHeight() / 10
  ImgScale= TileSize/32

	--{"Game","MainMenu","LevelMenu","Pause","Fini","GameOver"}
	State = "MainMenu"
	-- GameLevel:setData(Levels[8])
	UI:addLevels()
	Logs = {}
end

-- Increase the size of the rectangle every frame.
function love.update(dt)
	TileSize = love.graphics.getHeight() / 10
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
	--Game Draw
	if State ~= "MainMenu" and State ~= "LevelMenu" then
		GameLevel:drawStage()
		-- PlayDice:draw()
		PlayDice:drawFaces()
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

function love.mousepressed(x, y, btn)
	UI_mouseprsd(UI[State], x, y, btn)
end

function love.keypressed(key)
	Logs.keydown = key
	if State == "Game" then
		if key == "r" then
			GameLevel:restart()
		end
		if key == "z" then
			GameLevel:undo()
		end
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
		State = "LevelMenu"
	end
end

function gameUpd()
	PlayDice:upd()
end
