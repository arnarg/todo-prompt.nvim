local M = {}

M.isolated = function(str, word)
	local match = string.match
	local prefix = match(str, "^" .. word) or match(str, "%s" .. word)
	local suffix = match(str, word .. "$") or match(str, word .. "%s")
	return prefix and suffix
end

M.include_suffix = function(str, suffix, start)
	local sta, sto = string.find(str, "^" .. suffix, start)
	return sto or start
end

return M
