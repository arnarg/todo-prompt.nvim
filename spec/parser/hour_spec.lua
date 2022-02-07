local hour_parser = require('todo-prompt.parser.hour')
local base_time = {
	year = 2022,
	month = 1,
	day = 1,
	hour = 10,
	min = 0,
	sec = 0,
}
local sdate = os.time(base_time)

local assert_unchanged_date = function(task, date)
	local d = hour_parser.parse(task, date)
	local parse_time = os.date("*t", d)
	assert.are.equal(base_time.year, parse_time.year)
	assert.are.equal(base_time.month, parse_time.month)
	assert.are.equal(base_time.day, parse_time.day)
	assert.are.equal(base_time.hour, parse_time.hour)
	assert.are.equal(base_time.min, parse_time.min)
	assert.are.equal(base_time.sec, parse_time.sec)
end

describe("Hour parser", function()
	describe("without any date", function()
		local task = "Take out trash"

		it("should not modify date", function()
			assert_unchanged_date(task, sdate)
		end)

		it("should not return substring indexes", function()
			local _, start, stop = hour_parser.parse(task, sdate)
			assert.falsy(start)
			assert.falsy(stop)
		end)
	end)

	describe("with am", function()
		local task = "Take out trash 9 am"

		it("should set the right hour before noon", function()
			local d, start, stop = hour_parser.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(base_time.day, parse_time.day)
			assert.are.equal(9, parse_time.hour)
			assert.are.equal(0, parse_time.min)
			assert.are.equal(0, parse_time.sec)
		end)

		it("should find the correct substring", function()
			local _, start, stop = hour_parser.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same("9 am", substr)
		end)
	end)

	describe("with pm", function()
		local task = "Take out trash 9 pm"

		it("should set the right hour after noon", function()
			local d, start, stop = hour_parser.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(base_time.day, parse_time.day)
			assert.are.equal(21, parse_time.hour)
			assert.are.equal(0, parse_time.min)
			assert.are.equal(0, parse_time.sec)
		end)

		it("should find the correct substring", function()
			local _, start, stop = hour_parser.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same("9 pm", substr)
		end)
	end)

	describe("with 'at' prefix", function()
		local task = "Take out trash at 9 pm"

		it("should set the right hour after noon", function()
			local d, start, stop = hour_parser.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(base_time.day, parse_time.day)
			assert.are.equal(21, parse_time.hour)
			assert.are.equal(0, parse_time.min)
			assert.are.equal(0, parse_time.sec)
		end)

		it("should find the correct substring", function()
			local _, start, stop = hour_parser.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same("at 9 pm", substr)
		end)
	end)
end)
