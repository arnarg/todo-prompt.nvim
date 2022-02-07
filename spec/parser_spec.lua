local parser = require('todo-prompt.parser')

describe("Task parser", function()
	it("should parse dates from tasks correctly", function()
		local task = "Take out trash tomorrow evening"
		local now = os.date("*t", os.time())
		res = parser.parse_task(task)

		local parsed_date = os.date("*t", res.date)

		assert.are.same(res.task, "Take out trash")
		assert.are.equal(parsed_date.year, now.year)
		assert.are.equal(parsed_date.month, now.month)
		assert.are.equal(parsed_date.day, now.day+1)
		assert.are.equal(parsed_date.hour, 18)
		assert.are.equal(parsed_date.min, 0)
	end)
end)
