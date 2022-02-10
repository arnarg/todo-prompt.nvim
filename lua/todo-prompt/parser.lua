local weekday = require('todo-prompt.parser.weekday')
local casual_date = require('todo-prompt.parser.casual_date')
local casual_time = require('todo-prompt.parser.casual_time')
local hour = require('todo-prompt.parser.hour')
local hour_minute = require('todo-prompt.parser.hour_minute')
local deadline = require('todo-prompt.parser.deadline')
local exact_month_date = require('todo-prompt.parser.exact_month_date')

local parsers = {
	weekday,
	casual_date,
	casual_time,
	hour,
	hour_minute,
	deadline,
	exact_month_date,
}

local M = {}

M.parse_task = function(str, date)
	local task = str
	local start = nil
	local stop = nil
	local lower = string.lower(str)
	
	if date == nil then
		date = os.time()
	end

	for _, parser in ipairs(parsers) do
		local d, sta, sto = parser.parse(lower, date)
		if sta ~= nil and sto ~= nil then
			if start == nil or start > sta then
				start = sta
			end
			if stop == nil or stop < sto then
				stop = sto
			end
			date = d
		end
	end

	if start ~= nil and stop ~= nil then
		task = string.sub(str, 1, start-1) .. string.sub(str, stop+1)
	end


	-- Trim whitespace from task
	return string.match(task, "^%s*(.-)%s*$"), date, start or 0, stop or 0
end

return M
