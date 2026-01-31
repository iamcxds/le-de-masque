require("dice")
require("helpFun")
require("gameStage")
require("levelsData")
require("UI")

-- Load some default values for our rectangle.
function love.load()
	font = love.graphics.newFont(30)
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.window.setMode(800, 600, { resizable = true })
	TileSize = love.graphics.getHeight() / 10

	--{"Game","MainMenu","LevelMenu","Pause","Fini"}
	State = "Game"
	GameLevel:setData(Levels[1])
	Logs = {}
end

-- Increase the size of the rectangle every frame.
function love.update(dt)
	TileSize = love.graphics.getHeight() / 10
	gameUpd()
end

-- Draw a coloured rectangle.
function love.draw()
	GameLevel:drawStage()
	PlayDice:draw()
	PlayDice:drawFaces()

	local logText = ""
	for key, value in pairs(Logs) do
		logText = logText .. key .. ":" .. value .. "\n"
	end
	love.graphics.print(logText)
end

function love.keypressed(key)
	Logs.keydown = key
	if key == "left" or key == "h" then
		PlayDice:tryMove(-1, 0)
	end
	if key == "right" or key == "l" then
		PlayDice:tryMove(1, 0)
	end
	if key == "down" or key == "j" then
		PlayDice:tryMove(0, 1)
	end
	if key == "up" or key == "k" then
		PlayDice:tryMove(0, -1)
	end
end

function gameUpd()
	PlayDice:upd()
end
