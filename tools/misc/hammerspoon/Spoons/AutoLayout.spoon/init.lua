--- === AUTOLAYOUT ===
---
--- This is largely stolen from @megalithic's epic work. This lets
--- application's - windows automatically re-settle depending on whether I'm on
--- a single laptop - or a dock with an external (and now primary) monitor.

function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k, v in pairs(o) do
			if type(k) ~= 'number' then
				k = '"' .. k .. '"'
			end
			s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end

local m = {}
m.stack = {}

m.numOfScreens = 0
m.numOfSpaces = 0

-- whichScreen(num) :: hs.screen
-- Method
-- Tries to find a screen at that number but falls back to your primaryScreen.
-- TODO: Should this recursively try the previous number until primary?
function m.whichScreen(num)
	local displays = hs.screen.allScreens()
	if displays[num] ~= nil then
		return displays[num]
	else
		return hs.screen.primaryScreen()
	end
end

-- autoLayout() :: self
function m:autoLayout()
	hs.layout.apply(m.layouts(), string.match)

	return self
end

function m:setDefault(layouts)
	m.stack = { layouts }

	return self
end

function m:push(t)
	table.insert(m.stack, t)

	return self
end

function m:pop()
	-- prevent from popping the "default"
	if #m.stack > 1 then
		table.remove(m.stack)
	end

	return self
end

function m.layouts()
	-- TODO: figure out how to "flatten" the stack such that higher numbers get
	-- higher precedence... potentially are "later" on the table.
	return hs.fnutils.reduce(m.stack, function(choice, option)
		return hs.fnutils.concat(choice, option)
	end)
end

-- initialize watchers
function m:start()
	m.watcher = hs.screen.watcher
		.new(function()
			if m.numOfScreens ~= #hs.screen.allScreens() then
				m:autoLayout()
				m.numOfScreens = #hs.screen.allScreens()
			end
		end)
		:start()
end

function m:stop()
	m.watcher:stop()
	m.watcher = nil
end

return m
