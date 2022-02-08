local deadline = require('todo-prompt.parser.deadline')
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
	local d = deadline.parse(task, date)
	local parse_time = os.date("*t", d)
	assert.are.equal(base_time.year, parse_time.year)
	assert.are.equal(base_time.month, parse_time.month)
	assert.are.equal(base_time.day, parse_time.day)
	assert.are.equal(base_time.hour, parse_time.hour)
	assert.are.equal(base_time.min, parse_time.min)
	assert.are.equal(base_time.sec, parse_time.sec)
end

describe("Deadline parser", function()
	describe("without any date", function()
		local task = "Take out trash"

		it("should not modify date", function()
			assert_unchanged_date(task, sdate)
		end)

		it("should not return substring indexes", function()
			local _, start, stop = deadline.parse(task, sdate)
			assert.falsy(start)
			assert.falsy(stop)
		end)
	end)

	describe("with half number", function()
		describe("with half an hour", function()
			local task = "Take out trash in half an hour"

			it("should change date correctly", function()
				local d = deadline.parse(task, sdate)
				local parse_time = os.date("*t", d)
				assert.are.equal(base_time.year, parse_time.year)
				assert.are.equal(base_time.month, parse_time.month)
				assert.are.equal(base_time.day, parse_time.day)
				assert.are.equal(base_time.hour, parse_time.hour)
				assert.are.equal(base_time.min + 30, parse_time.min)
				assert.are.equal(base_time.sec, parse_time.sec)
			end)

			it("should find the correct substring", function()
				local _, start, stop = deadline.parse(task, sdate)
				local substr = string.sub(task, start, stop)
				assert.are.same("in half an hour", substr)
			end)
		end)

		describe("with half a day", function()
			local task = "Take out trash in half a day"

			it("should change date correctly", function()
				local d = deadline.parse(task, sdate)
				local parse_time = os.date("*t", d)
				assert.are.equal(base_time.year, parse_time.year)
				assert.are.equal(base_time.month, parse_time.month)
				assert.are.equal(base_time.day, parse_time.day)
				assert.are.equal(base_time.hour + 12, parse_time.hour)
				assert.are.equal(base_time.min, parse_time.min)
				assert.are.equal(base_time.sec, parse_time.sec)
			end)

			it("should find the correct substring", function()
				local _, start, stop = deadline.parse(task, sdate)
				local substr = string.sub(task, start, stop)
				assert.are.same("in half a day", substr)
			end)
		end)

		describe("with half a week", function()
			local task = "Take out trash in half a week"

			it("should change date correctly", function()
				local d = deadline.parse(task, sdate)
				local parse_time = os.date("*t", d)
				assert.are.equal(base_time.year, parse_time.year)
				assert.are.equal(base_time.month, parse_time.month)
				assert.are.equal(base_time.day + 4, parse_time.day)
				assert.are.equal(base_time.hour, parse_time.hour)
				assert.are.equal(base_time.min, parse_time.min)
				assert.are.equal(base_time.sec, parse_time.sec)
			end)

			it("should find the correct substring", function()
				local _, start, stop = deadline.parse(task, sdate)
				local substr = string.sub(task, start, stop)
				assert.are.same("in half a week", substr)
			end)
		end)

		describe("with half a month", function()
			local task = "Take out trash in half a month"

			it("should change date correctly", function()
				local d = deadline.parse(task, sdate)
				local parse_time = os.date("*t", d)
				assert.are.equal(base_time.year, parse_time.year)
				assert.are.equal(base_time.month, parse_time.month)
				assert.are.equal(base_time.day + 14, parse_time.day)
				assert.are.equal(base_time.hour, parse_time.hour)
				assert.are.equal(base_time.min, parse_time.min)
				assert.are.equal(base_time.sec, parse_time.sec)
			end)

			it("should find the correct substring", function()
				local _, start, stop = deadline.parse(task, sdate)
				local substr = string.sub(task, start, stop)
				assert.are.same("in half a month", substr)
			end)
		end)

		describe("with half a year", function()
			local task = "Take out trash in half a year"

			it("should change date correctly", function()
				local d = deadline.parse(task, sdate)
				local parse_time = os.date("*t", d)
				print(parse_time.year)
				print(parse_time.hour)
				assert.are.equal(base_time.year, parse_time.year)
				assert.are.equal(base_time.month + 6, parse_time.month)
				assert.are.equal(base_time.day, parse_time.day)
				assert.are.equal(base_time.hour, parse_time.hour)
				assert.are.equal(base_time.min, parse_time.min)
				assert.are.equal(base_time.sec, parse_time.sec)
			end)

			it("should find the correct substring", function()
				local _, start, stop = deadline.parse(task, sdate)
				local substr = string.sub(task, start, stop)
				assert.are.same("in half a year", substr)
			end)
		end)
	end)
end)
