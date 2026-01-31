--Give obj in table index
function updTableId(table)
	for index, value in ipairs(table) do
		value.id = index
	end
end


function coRun(_co, _then)
	if _co and coroutine.status(_co) ~= "dead" then
		coroutine.resume(_co)
	else
		_co = nil
		if _then then
			_then()
		end
	end
end
function DrawImg(img, x, y, r, _sc)
		local sc = _sc / img:getWidth()
		love.graphics.draw(img, x, y, r, sc, sc, img:getWidth() / 2, img:getHeight() / 2)
end
