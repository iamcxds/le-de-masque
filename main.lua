require("dice")
require("helpFun")
require("envComp")
require("levelsData")

-- Load some default values for our rectangle.
function love.load()

  love.graphics.setDefaultFilter("nearest", "nearest")
	love.window.setMode(800, 600, { resizable = true })
	TileSize = love.graphics.getHeight() / 10
	Player = {
	}
 GameLevel:loadData(Levels[1])
	Logs = {}
end

-- Increase the size of the rectangle every frame.
function love.update(dt)
	TileSize = love.graphics.getHeight() / 10
  gameUpd()
end

-- Draw a coloured rectangle.
function love.draw()
  GameLevel:drawComponents()
	PlayDice:draw()
  PlayDice:drawFaces()

  local logText=""
	for key, value in pairs(Logs) do
	  logText=logText..key..":"..value.."\n"
	end
		love.graphics.print(logText)
end

function love.keypressed(key)
	Logs.keydown = key
  if key =="left" or key =="h"  then
    PlayDice:move(-1,0)
  end
  if key =="right" or key =="l"  then
    PlayDice:move(1,0)
  end
  if key =="down" or key =="j"  then
    PlayDice:move(0,1)
  end
  if key =="up" or key =="k"  then
    PlayDice:move(0,-1)
  end
end


function gameUpd()
  PlayDice:upd()
end

