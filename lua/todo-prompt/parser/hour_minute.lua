local util = require('todo-prompt.parser.util')
local isolated = util.isolated

local ampm_patterns = { "a%.?m?%.?", "p%.?m?%.?" }

local M = {}

M.parse = function(str, d)
	local start = nil
	local stop = nil

	-- look for hour and minute
	local sta, sto = string.find(str, "%d%d?:%d%d")
	if sta ~= nil and isolated(str, string.sub(str, sta, sto))  then
		start = sta
		stop = sto
	end

	-- found nothing
	if start == nil or stop == nil then
		return d, nil, nil
	end

	-- look for am/pm suffix
	local suffix = string.sub(str, stop)
	for _, patt in ipairs(ampm_patterns) do
		local sta, sto = string.find(suffix, "%s*" .. patt)
		if sto ~= nil then
			stop = stop + sto
		end
	end

	-- Mutate date
	local substr = string.sub(str, start, stop)
	local hour, minute, ampm = string.match(substr, "^(%d%d?):(%d%d)%s*([ap]?%.?m?%.?)")
	local temp = os.date("*t", d)

	hour = tonumber(hour)
	minute = tonumber(minute)

	if hour > 24 or minute > 59 then
		return d, nil, nil
	end

	if ampm == "" or string.match(ampm, "^a") then
		temp.hour = hour
	elseif string.match(ampm, "^p") then
		if hour < 12 then
			hour = hour + 12
		end
		temp.hour = hour
	end

	temp.min = minute
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
