--Give obj in table index
function updTableId(table)
	for index, value in ipairs(table) do
		value.id = index
	end
end
function shallowcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in pairs(orig) do
			copy[orig_key] = orig_value
		end
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end
function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end
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
	else 
		return "n"
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
