local util = require('todo-prompt.parser.util')
local isolated = util.isolated
local include_suffix = util.include_suffix

local weekday_patterns = {
	sun = { wday = 1, suffix = "day" },
	mon = { wday = 2, suffix = "day" },
	tue = { wday = 3, suffix = "sday" },
	wed = { wday = 4, suffix = "nesday" },
	thu = { wday = 5, suffix = "rsday" },
	fri = { wday = 6, suffix = "day" },
	sat = { wday = 7, suffix = "urday" },
}

local prefixes = { "on", "this", "next" }
local suffixes = { "this", "next" }

local M = {}

M.parse = function(str, d)
	local start = nil
	local stop = nil
	local wday = nil
	local next_week = false
	local extra_days = 0

	-- look for weekdays
	for patt, day in pairs(weekday_patterns) do
		local sta, sto = string.find(str, patt)
		-- Check if suffix is also present
		if sto ~= nil then
			sto = include_suffix(str, day.suffix, (sto+1))
		end

		-- Make sure day is an isolated word (no alphanumeric character around)
		if sta ~= nil and isolated(str, string.sub(str, sta, sto)) then
			wday = day.wday
			start = sta
			stop = sto
			break
		end
	end

	-- found nothing
	if start == nil or stop == nil then
		return d, nil, nil
	end

	-- check if next week is wanted
	local prefix = string.sub(str, 1, start-1)
	local suffix = string.sub(str, stop+1)
	local temp = os.date("*t", d)
	if string.match(prefix, "next%s*$") or string.match(suffix, "^%s*next%s*week") or wday <= temp.wday then
		extra_days = 7
	end

	-- Mutate date
	local diff = wday - temp.wday
	temp.day = temp.day + (extra_days+diff)
	
	-- include prefixes
	for _, patt in ipairs(prefixes) do
		local sta = string.find(prefix, patt .. "%s*$")
		if sta ~= nil then
			start = sta
			break
		end
	end

	-- include suffixes
	for _, patt in ipairs(suffixes) do
		local _, sto = string.find(suffix, "^%s*" .. patt .. "%s*week")
		if sto ~= nil then
			stop = stop + sto
			break
		end
	end

	return os.time(temp), start, stop
end

return M
