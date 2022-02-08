local integer_words = {
	one = 1,
	two = 2,
	three = 3,
	four = 4,
	five = 5,
	six = 6,
	seven = 7,
	eight = 8,
	nine = 9,
	ten = 10,
	eleven = 11,
	twelve = 12,
}

local word_quantity = {
	{ pattern = "an?", optional_suffix = "%s*few" },
	{ pattern = "half", optional_suffix = "%s*an?" },
}

local unit_words = {
	"secs?",
	"seconds?",
	"mins?",
	"minutes?",
	"hours?",
	"days?",
	"weeks?",
	"months?",
	"years?",
}

local function look_for_suffix(str)
	local start, stop, word

	for _, patt in ipairs(unit_words) do
		local sta, sto = string.find(str, "^%s*" .. patt)
		if sta ~= nil and sto ~= nil then
			word = string.match(str, "^%s*" .. patt)
			start = sta
			stop = sto
			break
		end
	end

	return word, start, stop
end

local function find_pattern(str)
	-- Look for decimals
	local sta, sto = string.find(str, "in%s*%d+")
	if sta ~= nil and sto ~= nil then
		local w, a, b = look_for_suffix(string.sub(str, sto+1))
		if w ~= nil then
			num_str = find.match(str, "^in%s*(%d+)", sta-1)
			return tonumber(num_str), w, sta, sto + b
		end
	end

	-- Look for integer words
	for patt, n in pairs(integer_words) do
		local sta, sto = string.find(str, "in%s*" .. patt)
		if sta ~= nil and sto ~= nil then
			local w, a, b = look_for_suffix(string.sub(str, sto+1))
			if w ~= nil then
				return n, w, sta, sto + b
			end
		end
	end

	-- Look for quantity words
	for _, word in ipairs(word_quantity) do
		local sta, sto = string.find(str, "in%s*" .. word.pattern)
		if sta ~= nil and sto ~= nil then
			local suffix = string.sub(str, sto+1)
			local _, b = string.find(suffix, "^%s*" .. word.optional_suffix)
			if b ~= nil then
				sto = sto + b
			end
			local w, a, b = look_for_suffix(string.sub(str, sto+1))

			if w ~= nil then
				local substr = string.sub(str, sta, sto)
				return string.match(substr, "^in%s*(.*)"), w, sta, sto + b
			end
		end
	end

	return nil
end

local M = {}

M.parse = function(str, d)
	local num, exp, start, stop = find_pattern(str)

	if start == nil or stop == nil then
		return d, nil, nil
	end

	-- figure out number to use
	local n
	if type(num) == "number" then
		n = num
	elseif string.match(num, "^an?$") then
		n = 1
	elseif string.match(num, "^a%s*few$") then
		n = 3
	elseif string.match(num, "^half%s*an?$") then
		n = 0.5
	else
		-- couldn't find a number
		return d, nil, nil
	end

	-- Mutate date
	local temp = os.date("*t", d)

	if n == 0.5 then
		if string.match(exp, "sec") then
			-- We can hardly add half a second!
			temp.sec = temp.sec + 1
		elseif string.match(exp, "min") then
			temp.sec = temp.sec + 30
		elseif string.match(exp, "hour") then
			temp.min = temp.min + 30
		elseif string.match(exp, "day") then
			temp.hour = temp.hour + 12
		elseif string.match(exp, "week") then
			temp.day = temp.day + 4
		elseif string.match(exp, "month") then
			temp.day = temp.day + 14
		elseif string.match(exp, "year") then
			-- TODO: this mutates hour for some reason
			temp.month = temp.month + 6
		end
	else
		-- TODO: write tests!
		if string.match(exp, "sec") then
			temp.sec = temp.sec + n
		elseif string.match(exp, "min") then
			temp.sec = temp.min + n
		elseif string.match(exp, "hour") then
			temp.min = temp.hour + n
		elseif string.match(exp, "day") then
			temp.hour = temp.day + n
		elseif string.match(exp, "week") then
			temp.day = temp.day + (n*7)
		elseif string.match(exp, "month") then
			temp.day = temp.month + n
		elseif string.match(exp, "year") then
			temp.month = temp.year + n
		end
	end

	return os.time(temp), start, stop
end

return M
