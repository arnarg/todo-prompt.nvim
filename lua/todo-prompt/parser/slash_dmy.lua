local util = require('todo-prompt.parser.util')
local isolated = util.isolated

local month_lengths = {
	31,
	29,
	31,
	30,
	31,
	30,
	31,
	31,
	30,
	31,
	30,
	31,
}

local function day_in_month(d, m)
	return d <= month_lengths[m]
end

local function parse_date(d, m, y)
	local month = tonumber(m)
	if month > 12 then
		return nil
	end

	local day = tonumber(d)
	if not day_in_month(day, month) then
		return nil
	end

	local year
	if type(y) == "string" then
		year = string.match(y, "^/(%d%d%d%d)$")
		if not (#y == 0 or year ~= nil) then
			return nil
		end
		if year ~= nil then
			year = tonumber(year)
		end
	end

	return day, month, year
end

local M = {}

M.parse = function(str, date)
	local start, stop
	local day, month, year

	-- look for date, month and optional year
	local d, m, y = string.match(str, "(%d+)/(%d+)(/?%d*)")
	if d ~= nil and m ~= nil then
		day, month, year = parse_date(d, m, y)
	end

	if day ~= nil and month ~= nil then
		start, stop = string.find(str, d.."/"..m..(y or ""))
	end

	-- found nothing
	if start == nil or stop == nil then
		return date, nil, nil
	end

	-- Mutate date
	local temp = os.date("*t", date)

	temp.day = day
	temp.month = month

	if type(year) == "number" then
		temp.year = year
	end

	return os.time(temp), start, stop
end

return M
