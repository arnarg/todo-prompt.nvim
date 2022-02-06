local parser = require "todo.parser"

local res = parser.parse_task("Pick up medicine tomorrow at 1pm")
print(res.task .. " " .. type(res.task))
print(res.date .. " " .. type(res.date))
print(res.start .. " " .. type(res.start))
print(res.stop .. " " .. type(res.stop))
