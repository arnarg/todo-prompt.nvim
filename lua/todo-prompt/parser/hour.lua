local util = require('todo-prompt.parser.util')
local isolated = util.isolated

local hour_patterns = { "a%.?m?%.?", "p%.?m?%.?" }

local M = {}

M.parse = function(str, d)
	local start = nil
	local stop = nil

	-- Look for hour
	for _, patt in ipairs(hour_patterns) do
		local sta, sto = string.find(str, "%d%d?%s*" .. patt)

		if sta ~= nil and isolated(str, string.sub(str, sta, sto)) then
			start = sta
			stop = sto
			break
		end
	end

	if start == nil or stop == nil then
		return d, nil, nil
	end

	-- Mutate date
	local substr = string.sub(str, start, stop)
	local hour, ampm = string.match(substr, "^(%d%d?)%s*([ap])")
	local temp = os.date("*t", d)

	hour = tonumber(hour)

	if ampm == "a" then
		temp.hour = hour
	elseif ampm == "p" then
		if hour < 12 then
			hour = hour + 12
		end
		temp.hour = hour
	end

	temp.min = 0
	temp.sec = 0

	-- "at" prefix should be included
	local prefix = string.sub(str, 1, start-1)
	local sta, sto = string.find(prefix, "at%s*$")
	if sta ~= nil  then
		start = sta
	end

	return os.time(temp), start, stop
end

return M
