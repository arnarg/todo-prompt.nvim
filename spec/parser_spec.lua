local parser = require('todo-prompt.parser')
local base_time = {
	year = 2022,
	month = 1,
	day = 2, -- Sunday
	hour = 10,
	min = 0,
	sec = 0,
}
local sdate = os.time(base_time)

local assert_unchanged_date = function(task, date)
	local _, d = parser.parse_task(task, date)
	local parse_time = os.date("*t", d)
	assert.are.equal(base_time.year, parse_time.year)
	assert.are.equal(base_time.month, parse_time.month)
	assert.are.equal(base_time.day, parse_time.day)
	assert.are.equal(base_time.hour, parse_time.hour)
	assert.are.equal(base_time.min, parse_time.min)
	assert.are.equal(base_time.sec, parse_time.sec)
end

describe("Task parser", function()
	describe("without any date", function()
		local task = "Take out trash"

		it("should not modify date", function()
			assert_unchanged_date(task, sdate)
		end)

		it("should return the original task", function()
			local t = parser.parse_task(task, sdate)
			assert.are.same(task, t)
		end)
	end)

	describe("with weekday and casual time", function()
		local task = "Take out trash on monday evening"

		it("should modify the date and time accordingly", function()
			local _, d = parser.parse_task(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(3, parse_time.day)
			assert.are.equal(18, parse_time.hour)
			assert.are.equal(0, parse_time.min)
			assert.are.equal(0, parse_time.sec)
		end)

		it("should return the correct task", function()
			local t = parser.parse_task(task, sdate)
			assert.are.same("Take out trash", t)
		end)

		it("should return correct start and stop indexes", function()
			local _, _, start, stop = parser.parse_task(task, sdate)
			assert.are.same("on monday evening", string.sub(task, start, stop))
		end)
	end)

	describe("with casual date and casual time", function()
		local task = "Take out trash tomorrow morning"

		it("should modify the date and time accordingly", function()
			local _, d = parser.parse_task(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(3, parse_time.day)
			assert.are.equal(8, parse_time.hour)
			assert.are.equal(0, parse_time.min)
			assert.are.equal(0, parse_time.sec)
		end)

		it("should return the correct task", function()
			local t = parser.parse_task(task, sdate)
			assert.are.same("Take out trash", t)
		end)

		it("should return correct start and stop indexes", function()
			local _, _, start, stop = parser.parse_task(task, sdate)
			assert.are.same("tomorrow morning", string.sub(task, start, stop))
		end)
	end)

	describe("with weekday and hour and minute", function()
		local task = "Take out trash on Tuesday at 13:20"

		it("should modify the date and time accordingly", function()
			local _, d = parser.parse_task(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(4, parse_time.day)
			assert.are.equal(13, parse_time.hour)
			assert.are.equal(20, parse_time.min)
			assert.are.equal(0, parse_time.sec)
		end)

		it("should return the correct task", function()
			local t = parser.parse_task(task, sdate)
			assert.are.same("Take out trash", t)
		end)

		it("should return correct start and stop indexes", function()
			local _, _, start, stop = parser.parse_task(task, sdate)
			assert.are.same("on Tuesday at 13:20", string.sub(task, start, stop))
		end)
	end)

	describe("with casual date and hour", function()
		local task = "Take out trash tomorrow at 1pm"

		it("should modify the date and time accordingly", function()
			local _, d = parser.parse_task(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(3, parse_time.day)
			assert.are.equal(13, parse_time.hour)
			assert.are.equal(0, parse_time.min)
			assert.are.equal(0, parse_time.sec)
		end)

		it("should return the correct task", function()
			local t = parser.parse_task(task, sdate)
			assert.are.same("Take out trash", t)
		end)

		it("should return correct start and stop indexes", function()
			local _, _, start, stop = parser.parse_task(task, sdate)
			assert.are.same("tomorrow at 1pm", string.sub(task, start, stop))
		end)
	end)
end)
