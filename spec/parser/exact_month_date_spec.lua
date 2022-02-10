local exact = require('todo-prompt.parser.exact_month_date')
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
	local d = exact.parse(task, date)
	local parse_time = os.date("*t", d)
	assert.are.equal(base_time.year, parse_time.year)
	assert.are.equal(base_time.month, parse_time.month)
	assert.are.equal(base_time.day, parse_time.day)
	assert.are.equal(base_time.hour, parse_time.hour)
	assert.are.equal(base_time.min, parse_time.min)
	assert.are.equal(base_time.sec, parse_time.sec)
end

describe("Exact month date parser", function()
	describe("without any date", function()
		local task = "Take out trash"

		it("should not modify date", function()
			assert_unchanged_date(task, sdate)
		end)

		it("should not return substring indexes", function()
			local _, start, stop = exact.parse(task, sdate)
			assert.falsy(start)
			assert.falsy(stop)
		end)
	end)

	describe("with integer date", function()
		describe("prefix", function()
			local task = "Take out trash 12 march"

			it("should modify date accordingly", function()
				local d = exact.parse(task, sdate)
				local parse_time = os.date("*t", d)
				assert.are.equal(base_time.year, parse_time.year)
				assert.are.equal(3, parse_time.month)
				assert.are.equal(12, parse_time.day)
				assert.are.equal(base_time.hour, parse_time.hour)
				assert.are.equal(base_time.min, parse_time.min)
				assert.are.equal(base_time.sec, parse_time.sec)
			end)

			it("should return correct substring indexes", function()
				local _, start, stop = exact.parse(task, sdate)
				local substr = string.sub(task, start, stop)
				assert.are.same("12 march", substr)
			end)
		end)

		describe("suffix", function()
			local task = "Take out trash march 25"

			it("should modify date accordingly", function()
				local d = exact.parse(task, sdate)
				local parse_time = os.date("*t", d)
				assert.are.equal(base_time.year, parse_time.year)
				assert.are.equal(3, parse_time.month)
				assert.are.equal(25, parse_time.day)
				assert.are.equal(base_time.hour, parse_time.hour)
				assert.are.equal(base_time.min, parse_time.min)
				assert.are.equal(base_time.sec, parse_time.sec)
			end)

			it("should return correct substring indexes", function()
				local _, start, stop = exact.parse(task, sdate)
				local substr = string.sub(task, start, stop)
				assert.are.same("march 25", substr)
			end)
		end)
	end)

	describe("with word date", function()
		describe("prefix", function()
			describe("without 'of'", function()
				local task = "Take out trash twelfth march"

				it("should modify date accordingly", function()
					local d = exact.parse(task, sdate)
					local parse_time = os.date("*t", d)
					assert.are.equal(base_time.year, parse_time.year)
					assert.are.equal(3, parse_time.month)
					assert.are.equal(12, parse_time.day)
					assert.are.equal(base_time.hour, parse_time.hour)
					assert.are.equal(base_time.min, parse_time.min)
					assert.are.equal(base_time.sec, parse_time.sec)
				end)

				it("should return correct substring indexes", function()
					local _, start, stop = exact.parse(task, sdate)
					local substr = string.sub(task, start, stop)
					assert.are.same("twelfth march", substr)
				end)
			end)

			describe("with 'of'", function()
				local task = "Take out trash 25th of march"

				it("should modify date accordingly", function()
					local d = exact.parse(task, sdate)
					local parse_time = os.date("*t", d)
					assert.are.equal(base_time.year, parse_time.year)
					assert.are.equal(3, parse_time.month)
					assert.are.equal(25, parse_time.day)
					assert.are.equal(base_time.hour, parse_time.hour)
					assert.are.equal(base_time.min, parse_time.min)
					assert.are.equal(base_time.sec, parse_time.sec)
				end)

				it("should return correct substring indexes", function()
					local _, start, stop = exact.parse(task, sdate)
					local substr = string.sub(task, start, stop)
					assert.are.same("25th of march", substr)
				end)
			end)
		end)

		describe("suffix", function()
			local task = "Take out trash march twenty first"

			it("should modify date accordingly", function()
				local d = exact.parse(task, sdate)
				local parse_time = os.date("*t", d)
				assert.are.equal(base_time.year, parse_time.year)
				assert.are.equal(3, parse_time.month)
				assert.are.equal(21, parse_time.day)
				assert.are.equal(base_time.hour, parse_time.hour)
				assert.are.equal(base_time.min, parse_time.min)
				assert.are.equal(base_time.sec, parse_time.sec)
			end)

			it("should return correct substring indexes", function()
				local _, start, stop = exact.parse(task, sdate)
				local substr = string.sub(task, start, stop)
				assert.are.same("march twenty first", substr)
			end)
		end)
	end)
end)
