local casual_dates = { "now", "today", "tonight", "tomorrow", "tmr" }

local M = {}

M.parse = function(str, d)
	local start = nil
	local stop = nil

	-- Look for casual dates
	for _, date in ipairs(casual_dates) do
		local sta, sto = string.find(str, date)

		if sta ~= nil then
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
	temp = os.date("*t", d)

	if string.match(substr, "tonight") then
		temp.hour = 23
		temp.min = 0
		temp.sec = 0
	end

	if string.match(substr, "tomorrow") or string.match(substr, "tmr") then
		temp.day = temp.day + 1
	end

	return os.time(temp), start, stop
end

return M
