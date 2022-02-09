local M = {}

M.isolated = function(str, word)
	local match = string.match
	local prefix = match(str, "^" .. word) or match(str, "%s" .. word)
	local suffix = match(str, word .. "$") or match(str, word .. "%s")
	return prefix and suffix
end

return M
