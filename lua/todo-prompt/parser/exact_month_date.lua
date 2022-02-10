local util = require('todo-prompt.parser.util')
local isolated = util.isolated
local include_suffix = util.include_suffix

local month_patterns = {
	jan = { num = 1, suffix = "uary" },
	feb = { num = 2, suffix = "ruary" },
	mar = { num = 3, suffix = "ch" },
	apr = { num = 4, suffix = "il" },
	may = { num = 5, suffix = nil },
	jun = { num = 6, suffix = "e" },
	jul = { num = 7, suffix = "y" },
	aug = { num = 8, suffix = "ust" },
	sep = { num = 9, suffix = "tember" },
	oct = { num = 10, suffix = "tobe" },
	nov = { num = 11, suffix = "ember" },
	dec = { num = 12, suffix = "ember" },
}

local ordinal_words = {
	{ patt = "first", num = 1 },
	{ patt = "1st", num = 1 },
	{ patt = "second", num = 2 },
	{ patt = "2nd", num = 2 },
	{ patt = "third", num = 3 },
	{ patt = "3rd", num = 3 },
	{ patt = "fourth", num = 4 },
	{ patt = "4th", num = 4 },
	{ patt = "fifth", num = 5 },
	{ patt = "5th", num = 5 },
	{ patt = "sixth", num = 6 },
	{ patt = "6th", num = 6 },
	{ patt = "seventh", num = 7 },
	{ patt = "7th", num = 7 },
	{ patt = "eighth", num = 8 },
	{ patt = "8th", num = 8 },
	{ patt = "ninth", num = 9 },
	{ patt = "9th", num = 9 },
	{ patt = "tenth", num = 10 },
	{ patt = "10th", num = 10 },
	{ patt = "eleventh", num = 11 },
	{ patt = "11th", num = 11 },
	{ patt = "twelfth", num = 12 },
	{ patt = "12th", num = 12 },
	{ patt = "thirteenth", num = 13 },
	{ patt = "13th", num = 13 },
	{ patt = "fourteenth", num = 14 },
	{ patt = "14th", num = 14 },
	{ patt = "fifteenth", num = 15 },
	{ patt = "15th", num = 15 },
	{ patt = "sixteenth", num = 16 },
	{ patt = "16th", num = 16 },
	{ patt = "seventeenth", num = 17 },
	{ patt = "17th", num = 17 },
	{ patt = "eighteenth", num = 18 },
	{ patt = "18th", num = 18 },
	{ patt = "nineteenth", num = 19 },
	{ patt = "19th", num = 19 },
	{ patt = "twentieth", num = 20 },
	{ patt = "20th", num = 20 },
	{ patt = "twenty first", num = 21 },
	{ patt = "twenty-first", num = 21 },
	{ patt = "21st", num = 21 },
	{ patt = "twenty second", num = 22 },
	{ patt = "twenty-second", num = 22 },
	{ patt = "22nd", num = 22 },
	{ patt = "twenty third", num = 23 },
	{ patt = "twenty-third", num = 23 },
	{ patt = "23rd", num = 23 },
	{ patt = "twenty fourth", num = 24 },
	{ patt = "twenty-fourth", num = 24 },
	{ patt = "24th", num = 24 },
	{ patt = "twenty fifth", num = 25 },
	{ patt = "twenty-fifth", num = 25 },
	{ patt = "25th", num = 25 },
	{ patt = "twenty sixth", num = 26 },
	{ patt = "twenty-sixth", num = 26 },
	{ patt = "26th", num = 26 },
	{ patt = "twenty seventh", num = 27 },
	{ patt = "twenty-seventh", num = 27 },
	{ patt = "27th", num = 27 },
	{ patt = "twenty eighth", num = 28 },
	{ patt = "twenty-eighth", num = 28 },
	{ patt = "28th", num = 28 },
	{ patt = "twenty ninth", num = 29 },
	{ patt = "twenty-ninth", num = 29 },
	{ patt = "29th", num = 29 },
	{ patt = "thirtieth", num = 30 },
	{ patt = "30th", num = 30 },
	{ patt = "thirty first", num = 31 },
	{ patt = "thirty-first", num = 31 },
	{ patt = "31st", num = 31 },
}

local function check_th_suffix(str)
	if type(str) == "string" then
		return #str == 0 or string.match(str, "^th$")
	end

	return true
end

local function look_for_surrounding(str, start, stop)
	local num, sta, sto
	local found_word = string.sub(str, start, stop)
	-- look for integers
	local before, after = string.match(str, "(%d*)%*"..found_word.."%s*(%d*)")
	-- prefix
	local prefix_num, prefix_th = string.match(str, "(%d+)%s+"..found_word)
	local suffix_num, suffix_th = string.match(str, found_word.."%s+(%d+)([th]*)")
	if prefix_num ~= nil and check_th_suffix(prefix_th) then
		sta = string.find(str, "%d+%s+"..found_word)
		num = tonumber(prefix_num)
	elseif suffix_num ~= nil and check_th_suffix(suffix_th) then
		_, sto = string.find(str, found_word.."%s+%d+")
		num = tonumber(suffix_num)
	end

	-- look for number words
	if sta == nil and sto == nil then
		for _, word in ipairs(ordinal_words) do
			-- check for prefix
			local p_patt = "("..word.patt..")%s+([of%s]*)"..found_word
			local num_str, of = string.match(str, p_patt)
			-- if ([of%s]*) was found we want to make sure it's actually "of%s+"
			if of and #of > 0 and not string.match(of, "^of%s+$") then
				-- discard result
				num_str = nil
			end
			if num_str ~= nil and isolated(str, num_str) then	
				sta = string.find(str, p_patt)
				num = word.num
				break
			end
			-- check for suffix
			local s_patt = found_word.."%s+("..word.patt..")"
			local num_str = string.match(str, s_patt)
			if num_str ~= nil and isolated(str, num_str) then
				_, sto = string.find(str, s_patt)
				num = word.num
				break
			end
		end
	end

	start = sta or start
	stop = sto or stop

	-- include 'on' prefix
	local prefix = string.sub(str, 1, start-1)
	local on = string.match(prefix, "(on%s+)$")
	if type(on) == "string" then
		start = start - #on
	end

	return start, stop, num
end

local M = {}

M.parse = function(str, d)
	local start = nil
	local stop = nil
	local month = nil

	-- look for month
	for patt, m in pairs(month_patterns) do
		local sta, sto = string.find(str, patt)
		-- check if suffix is also present
		if sto ~= nil and m.suffix ~= nil then
			sto = include_suffix(str, m.suffix, (sto+1))
		end

		if sta ~= nil and isolated(str, string.sub(str, sta, sto)) then
			month = m.num
			start = sta
			stop = sto
		end
	end

	-- found nothing
	if start == nil or stop == nil then
		return d, nil, nil
	end

	-- check for day of the month
	start, stop, num = look_for_surrounding(str, start, stop)

	-- mutate date
	local temp = os.date("*t", d)

	-- since it doesn't make sense to schedule stuff in the past
	-- I mmake the assumption that the user meant next year of the
	-- specified month already happened this year
	if temp.month > month then
		temp.year = temp.year + 1
	end

	temp.month = month

	if type(num) == "number" then
		temp.day = num
	end

	return os.time(temp), start, stop
end

return M
