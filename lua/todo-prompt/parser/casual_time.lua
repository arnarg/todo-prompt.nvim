local casual_times = { "morning", "afternoon", "evening", "noon" }

local M = {}

M.parse = function(str, d)
	local start = nil
	local stop = nil

	-- Look for casual times
	for _, time in ipairs(casual_times) do
		local sta, sto = string.find(str, time)

		if sta ~= nil then
			start = sta
			stop = sto
			break
		end
	end

	if start == nil or stop == nil then
		return d, nil, nil
	end

	-- "this" prefix should be included
	local prefix = string.sub(str, 1, start-1)
	local sta, sto = string.find(prefix, "this%s*$")
	if sta ~= nil  then
		start = sta
	end

	-- Mutate date
	local substr = string.sub(str, start, stop)
	temp = os.date("*t", d)

	if string.match(substr, "morning") then
		temp.hour = 8
		temp.min = 0
		temp.sec = 0
	elseif string.match(substr, "afternoon") then
		temp.hour = 15
		temp.min = 0
		temp.sec = 0
	elseif string.match(substr, "evening") then
		temp.hour = 18
		temp.min = 0
		temp.sec = 0
	elseif string.match(substr, "noon") then
		temp.hour = 12
		temp.min = 0
		temp.sec = 0
	end

	return os.time(temp), start, stop
end

return M
