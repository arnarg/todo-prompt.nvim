local ffi = require "ffi"

local library_path = (function()
	local dirname = string.sub(debug.getinfo(1).source, 2, #"/parser.lua" * -1)
	return dirname .. "../../build/parser.so"
end)()
local native = ffi.load(library_path)

ffi.cdef [[
typedef struct { const char *p; ptrdiff_t n; } GoString;

extern char* ParseTask(GoString task);
extern void Free(char* cptr);
]]

local typeString = ffi.metatype("GoString", {})

-- To not having to depend on cjson I simply serialize each field on
-- newline
local deserialize = function(task)
	t = {}
	for k, v in string.gmatch(task, "(%w+)=([^\n]+)") do
		vNum = tonumber(v)
		if vNum ~= nil then
			t[k] = vNum
		else
			t[k] = v
		end
	end
	return t
end

local parser = {}

parser.parse_task = function(task)
	local go_str = typeString(task, #task)
	c_str = native.ParseTask(go_str)
	str = ffi.string(c_str)
	native.Free(c_str)
	return deserialize(str)
end

return parser
