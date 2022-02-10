local dmy_parser = require('todo-prompt.parser.slash_dmy')
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
	local d = dmy_parser.parse(task, date)
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
			local _, start, stop = dmy_parser.parse(task, sdate)
			assert.falsy(start)
			assert.falsy(stop)
		end)
	end)

	describe("with d/m/y", function()
		local task = "Take out trash 3/4/2023"

		it("should modify date accordingly", function()
			local d = dmy_parser.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(2023, parse_time.year)
			assert.are.equal(4, parse_time.month)
			assert.are.equal(3, parse_time.day)
		end)

		it("should return correct substring indexes", function()
			local _, start, stop = dmy_parser.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same("3/4/2023", substr)
		end)
	end)

	describe("with date and month", function()
		describe("in d/m", function()
			local task = "Take out trash 3/4"

			it("should modify date accordingly", function()
				local d = dmy_parser.parse(task, sdate)
				local parse_time = os.date("*t", d)
				assert.are.equal(2022, parse_time.year)
				assert.are.equal(4, parse_time.month)
				assert.are.equal(3, parse_time.day)
			end)

			it("should return correct substring indexes", function()
				local _, start, stop = dmy_parser.parse(task, sdate)
				local substr = string.sub(task, start, stop)
				assert.are.same("3/4", substr)
			end)
		end)

		describe("in d/m/", function()
			local task = "Take out trash 3/4/"

			it("should not modify date", function()
				assert_unchanged_date(task, sdate)
			end)

			it("should not return substring indexes", function()
				local _, start, stop = dmy_parser.parse(task, sdate)
				assert.falsy(start)
				assert.falsy(stop)
			end)
		end)

		describe("in d/m/yyy", function()
			local task = "Take out trash 3/4/123"

			it("should not modify date", function()
				assert_unchanged_date(task, sdate)
			end)

			it("should not return substring indexes", function()
				local _, start, stop = dmy_parser.parse(task, sdate)
				assert.falsy(start)
				assert.falsy(stop)
			end)
		end)
	end)

	describe("with day out of bounds", function()
		local task = "Take out trash 31/2/2024"

		it("should not modify date", function()
			assert_unchanged_date(task, sdate)
		end)

		it("should not return substring indexes", function()
			local _, start, stop = dmy_parser.parse(task, sdate)
			assert.falsy(start)
			assert.falsy(stop)
		end)
	end)

	describe("with month out of bounds", function()
		local task = "Take out trash 16/13/2024"

		it("should not modify date", function()
			assert_unchanged_date(task, sdate)
		end)

		it("should not return substring indexes", function()
			local _, start, stop = dmy_parser.parse(task, sdate)
			assert.falsy(start)
			assert.falsy(stop)
		end)
	end)
end)
