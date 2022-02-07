local casual_time = require('todo-prompt.parser.casual_time')
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
	local d = casual_time.parse(task, date)
	local parse_time = os.date("*t", d)
	assert.are.equal(base_time.year, parse_time.year)
	assert.are.equal(base_time.month, parse_time.month)
	assert.are.equal(base_time.day, parse_time.day)
	assert.are.equal(base_time.hour, parse_time.hour)
	assert.are.equal(base_time.min, parse_time.min)
	assert.are.equal(base_time.sec, parse_time.sec)
end

describe("Casual time parser", function()
	describe("without any date", function()
		local task = "Take out trash"

		it("should not modify date", function()
			assert_unchanged_date(task, sdate)
		end)

		it("should not return substring indexes", function()
			local _, start, stop = casual_time.parse(task, sdate)
			assert.falsy(start)
			assert.falsy(stop)
		end)
	end)

	describe("with morning", function()
		local task = "Take out trash morning"

		it("should modify date correctly", function()
			local d = casual_time.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(base_time.day, parse_time.day)
			assert.are.equal(8, parse_time.hour)
			assert.are.equal(0, parse_time.min)
			assert.are.equal(0, parse_time.sec)
		end)

		it("should find the correct substring", function()
			local _, start, stop = casual_time.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same("morning", substr)
		end)
	end)

	describe("with afternoon", function()
		local task = "Take out trash afternoon"

		it("should modify date correctly", function()
			local d = casual_time.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(base_time.day, parse_time.day)
			assert.are.equal(15, parse_time.hour)
			assert.are.equal(0, parse_time.min)
			assert.are.equal(0, parse_time.sec)
		end)

		it("should find the correct substring", function()
			local _, start, stop = casual_time.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same("afternoon", substr)
		end)
	end)

	describe("with evening", function()
		local task = "Take out trash evening"

		it("should modify date correctly", function()
			local d = casual_time.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(base_time.day, parse_time.day)
			assert.are.equal(18, parse_time.hour)
			assert.are.equal(0, parse_time.min)
			assert.are.equal(0, parse_time.sec)
		end)

		it("should find the correct substring", function()
			local _, start, stop = casual_time.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same("evening", substr)
		end)
	end)

	describe("with noon", function()
		local task = "Take out trash noon"

		it("should modify date correctly", function()
			local d = casual_time.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(base_time.day, parse_time.day)
			assert.are.equal(12, parse_time.hour)
			assert.are.equal(0, parse_time.min)
			assert.are.equal(0, parse_time.sec)
		end)

		it("should find the correct substring", function()
			local _, start, stop = casual_time.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same("noon", substr)
		end)
	end)

	describe("with 'this' prefix", function()
		local task = "Take out trash this afternoon"

		it("should modify date correctly", function()
			local d = casual_time.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(base_time.day, parse_time.day)
			assert.are.equal(15, parse_time.hour)
			assert.are.equal(0, parse_time.min)
			assert.are.equal(0, parse_time.sec)
		end)

		it("should find the correct substring", function()
			local _, start, stop = casual_time.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same("this afternoon", substr)
		end)
	end)
end)
