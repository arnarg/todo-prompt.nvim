local weekday = require('todo-prompt.parser.weekday')
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
	local d = weekday.parse(task, date)
	local parse_time = os.date("*t", d)
	assert.are.equal(base_time.year, parse_time.year)
	assert.are.equal(base_time.month, parse_time.month)
	assert.are.equal(base_time.day, parse_time.day)
	assert.are.equal(base_time.hour, parse_time.hour)
	assert.are.equal(base_time.min, parse_time.min)
	assert.are.equal(base_time.sec, parse_time.sec)
end

describe("Weekday parser", function()
	describe("without any date", function()
		local task = "Take out trash"

		it("should not modify date", function()
			assert_unchanged_date(task, sdate)
		end)

		it("should not return substring indexes", function()
			local _, start, stop = weekday.parse(task, sdate)
			assert.falsy(start)
			assert.falsy(stop)
		end)
	end)

	describe("with just weekday", function()
		local task = "Take out trash monday"

		it("should modify date accordingly", function()
			local d = weekday.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(3, parse_time.day)
			assert.are.equal(base_time.hour, parse_time.hour)
			assert.are.equal(base_time.min, parse_time.min)
			assert.are.equal(base_time.sec, parse_time.sec)
			assert.are.equal(2, parse_time.wday)
		end)

		it("should return correct substring indexes", function()
			local _, start, stop = weekday.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same("monday", substr)
		end)
	end)

	describe("with 'this' prefix", function()
		local task = "Take out trash this tuesday"

		it("should not change the date to next week", function()
			local d = weekday.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(4, parse_time.day)
			assert.are.equal(base_time.hour, parse_time.hour)
			assert.are.equal(base_time.min, parse_time.min)
			assert.are.equal(base_time.sec, parse_time.sec)
			assert.are.equal(3, parse_time.wday)
		end)

		it("should return correct substring indexes", function()
			local _, start, stop = weekday.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same('this tuesday', substr)
		end)
	end)

	describe("with 'on' prefix", function()
		local task = "Take out trash on tuesday"

		it("should not change the date to next week", function()
			local d = weekday.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(4, parse_time.day)
			assert.are.equal(base_time.hour, parse_time.hour)
			assert.are.equal(base_time.min, parse_time.min)
			assert.are.equal(base_time.sec, parse_time.sec)
			assert.are.equal(3, parse_time.wday)
		end)

		it("should return correct substring indexes", function()
			local _, start, stop = weekday.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same('on tuesday', substr)
		end)
	end)

	describe("with 'next' prefix", function()
		local task = "Take out trash next tuesday"

		it("should change the date to next week", function()
			local d = weekday.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(11, parse_time.day)
			assert.are.equal(base_time.hour, parse_time.hour)
			assert.are.equal(base_time.min, parse_time.min)
			assert.are.equal(base_time.sec, parse_time.sec)
			assert.are.equal(3, parse_time.wday)
		end)

		it("should return correct substring indexes", function()
			local _, start, stop = weekday.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same('next tuesday', substr)
		end)
	end)

	describe("with 'this week' suffix", function()
		local task = "Take out trash tuesday this week"

		it("should not change the date to next week", function()
			local d = weekday.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(4, parse_time.day)
			assert.are.equal(base_time.hour, parse_time.hour)
			assert.are.equal(base_time.min, parse_time.min)
			assert.are.equal(base_time.sec, parse_time.sec)
			assert.are.equal(3, parse_time.wday)
		end)

		it("should return correct substring indexes", function()
			local _, start, stop = weekday.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same('tuesday this week', substr)
		end)
	end)

	describe("with 'next week' suffix", function()
		local task = "Take out trash tuesday next week"

		it("should change the date to next week", function()
			local d = weekday.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(11, parse_time.day)
			assert.are.equal(base_time.hour, parse_time.hour)
			assert.are.equal(base_time.min, parse_time.min)
			assert.are.equal(base_time.sec, parse_time.sec)
			assert.are.equal(3, parse_time.wday)
		end)

		it("should return correct substring indexes", function()
			local _, start, stop = weekday.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same('tuesday next week', substr)
		end)
	end)

	describe("with both prefix and suffix", function()
		local task = "Take out trash on tuesday next week"
		
		it("should change the date to next week", function()
			local d = weekday.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(11, parse_time.day)
			assert.are.equal(base_time.hour, parse_time.hour)
			assert.are.equal(base_time.min, parse_time.min)
			assert.are.equal(base_time.sec, parse_time.sec)
			assert.are.equal(3, parse_time.wday)
		end)

		it("should return correct substring indexes", function()
			local _, start, stop = weekday.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same('on tuesday next week', substr)
		end)
	end)
end)
