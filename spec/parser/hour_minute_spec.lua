local hm_parser = require('todo-prompt.parser.hour_minute')
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
	local d = hm_parser.parse(task, date)
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
			local _, start, stop = hm_parser.parse(task, sdate)
			assert.falsy(start)
			assert.falsy(stop)
		end)
	end)

	describe("without am/pm", function()
		it("should set the right time before noon", function()
			local task = "Take out trash 9:12"
			local d, start, stop = hm_parser.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(base_time.day, parse_time.day)
			assert.are.equal(9, parse_time.hour)
			assert.are.equal(12, parse_time.min)
			assert.are.equal(0, parse_time.sec)
		end)

		it("should set the right time after noon", function()
			local task = "Take out trash 14:32"
			local d, start, stop = hm_parser.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(base_time.day, parse_time.day)
			assert.are.equal(14, parse_time.hour)
			assert.are.equal(32, parse_time.min)
			assert.are.equal(0, parse_time.sec)
		end)

		it("should find the correct substring", function()
			local task = "Take out trash 8:00"
			local _, start, stop = hm_parser.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same("8:00", substr)
		end)
	end)

	describe("with am/pm", function()
		it("should set the right time before noon", function()
			local task = "Take out trash 9:43 am"
			local d, start, stop = hm_parser.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(base_time.day, parse_time.day)
			assert.are.equal(9, parse_time.hour)
			assert.are.equal(43, parse_time.min)
			assert.are.equal(0, parse_time.sec)
		end)

		it("should set the right hour after noon", function()
			local task = "Take out trash 2:52 pm"
			local d, start, stop = hm_parser.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(base_time.day, parse_time.day)
			assert.are.equal(14, parse_time.hour)
			assert.are.equal(52, parse_time.min)
			assert.are.equal(0, parse_time.sec)
		end)

		it("should find the correct substring", function()
			local task = "Take out trash 8:00 am"
			local _, start, stop = hm_parser.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same("8:00 am", substr)
		end)
	end)

	describe("with 'at' prefix", function()
		it("should set the right time after noon", function()
			local task = "Take out trash at 2:31 pm"
			local d, start, stop = hm_parser.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(base_time.day, parse_time.day)
			assert.are.equal(14, parse_time.hour)
			assert.are.equal(31, parse_time.min)
			assert.are.equal(0, parse_time.sec)
		end)

		it("should find the correct substring", function()
			local task = "Take out trash at 8:00 am"
			local _, start, stop = hm_parser.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same("at 8:00 am", substr)
		end)
	end)

	describe("with illegal numbers", function()
		it("should not find a match with hour out of bounds", function()
			local task = "Take out trash at 54:00"
			local _, start, stop = hm_parser.parse(task, sdate)
			assert.are.equal(nil, start)
			assert.are.equal(nil, stop)
		end)

		it("should not find a match with minute out of bounds", function()
			local task = "Take out trash at 13:74"
			local _, start, stop = hm_parser.parse(task, sdate)
			assert.are.equal(nil, start)
			assert.are.equal(nil, stop)
		end)
	end)
end)
