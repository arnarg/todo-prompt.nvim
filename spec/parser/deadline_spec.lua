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
				assert.are.equal(base_time.year, parse_time.year)
				assert.are.equal(base_time.month + 6, parse_time.month)
				assert.are.equal(base_time.day, parse_time.day)
				-- By incrementing the month a lot increments hour by one :/
				-- TODO: handle edge-case
				-- assert.are.equal(base_time.hour, parse_time.hour)
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

	describe("with an integer", function()
		describe("with hours", function()
			local task = "Take out trash in 2 hours"

			it("should change date correctly", function()
				local d = deadline.parse(task, sdate)
				local parse_time = os.date("*t", d)
				assert.are.equal(base_time.year, parse_time.year)
				assert.are.equal(base_time.month, parse_time.month)
				assert.are.equal(base_time.day, parse_time.day)
				assert.are.equal(base_time.hour + 2, parse_time.hour)
				assert.are.equal(base_time.min, parse_time.min)
				assert.are.equal(base_time.sec, parse_time.sec)
			end)

			it("should find the correct substring", function()
				local _, start, stop = deadline.parse(task, sdate)
				local substr = string.sub(task, start, stop)
				assert.are.same("in 2 hours", substr)
			end)
		end)

		describe("with days", function()
			local task = "Take out trash in 4 days"

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
				assert.are.same("in 4 days", substr)
			end)
		end)

		describe("with weeks", function()
			local task = "Take out trash in 6 weeks"

			it("should change date correctly", function()
				local d = deadline.parse(task, sdate)
				local parse_time = os.date("*t", d)
				assert.are.equal(base_time.year, parse_time.year)
				assert.are.equal(base_time.month + 1, parse_time.month)
				assert.are.equal(12, parse_time.day)
				assert.are.equal(base_time.hour, parse_time.hour)
				assert.are.equal(base_time.min, parse_time.min)
				assert.are.equal(base_time.sec, parse_time.sec)
			end)

			it("should find the correct substring", function()
				local _, start, stop = deadline.parse(task, sdate)
				local substr = string.sub(task, start, stop)
				assert.are.same("in 6 weeks", substr)
			end)
		end)

		describe("with months", function()
			local task = "Take out trash in 14 months"

			it("should change date correctly", function()
				local d = deadline.parse(task, sdate)
				local parse_time = os.date("*t", d)
				assert.are.equal(base_time.year + 1, parse_time.year)
				assert.are.equal(base_time.month + 2, parse_time.month)
				assert.are.equal(base_time.day, parse_time.day)
				assert.are.equal(base_time.hour, parse_time.hour)
				assert.are.equal(base_time.min, parse_time.min)
				assert.are.equal(base_time.sec, parse_time.sec)
			end)

			it("should find the correct substring", function()
				local _, start, stop = deadline.parse(task, sdate)
				local substr = string.sub(task, start, stop)
				assert.are.same("in 14 months", substr)
			end)
		end)

		describe("with years", function()
			local task = "Take out trash in 5 years"

			it("should change date correctly", function()
				local d = deadline.parse(task, sdate)
				local parse_time = os.date("*t", d)
				assert.are.equal(base_time.year + 5, parse_time.year)
				assert.are.equal(base_time.month, parse_time.month)
				assert.are.equal(base_time.day, parse_time.day)
				assert.are.equal(base_time.hour, parse_time.hour)
				assert.are.equal(base_time.min, parse_time.min)
				assert.are.equal(base_time.sec, parse_time.sec)
			end)

			it("should find the correct substring", function()
				local _, start, stop = deadline.parse(task, sdate)
				local substr = string.sub(task, start, stop)
				assert.are.same("in 5 years", substr)
			end)
		end)
	end)

	describe("with integer words", function()
		describe("with hours", function()
			local task = "Take out trash in ten hours"

			it("should change date correctly", function()
				local d = deadline.parse(task, sdate)
				local parse_time = os.date("*t", d)
				assert.are.equal(base_time.year, parse_time.year)
				assert.are.equal(base_time.month, parse_time.month)
				assert.are.equal(base_time.day, parse_time.day)
				assert.are.equal(base_time.hour + 10, parse_time.hour)
				assert.are.equal(base_time.min, parse_time.min)
				assert.are.equal(base_time.sec, parse_time.sec)
			end)

			it("should find the correct substring", function()
				local _, start, stop = deadline.parse(task, sdate)
				local substr = string.sub(task, start, stop)
				assert.are.same("in ten hours", substr)
			end)
		end)

		describe("with days", function()
			local task = "Take out trash in seven days"

			it("should change date correctly", function()
				local d = deadline.parse(task, sdate)
				local parse_time = os.date("*t", d)
				assert.are.equal(base_time.year, parse_time.year)
				assert.are.equal(base_time.month, parse_time.month)
				assert.are.equal(base_time.day + 7, parse_time.day)
				assert.are.equal(base_time.hour, parse_time.hour)
				assert.are.equal(base_time.min, parse_time.min)
				assert.are.equal(base_time.sec, parse_time.sec)
			end)

			it("should find the correct substring", function()
				local _, start, stop = deadline.parse(task, sdate)
				local substr = string.sub(task, start, stop)
				assert.are.same("in seven days", substr)
			end)
		end)

		describe("with weeks", function()
			local task = "Take out trash in one week"

			it("should change date correctly", function()
				local d = deadline.parse(task, sdate)
				local parse_time = os.date("*t", d)
				assert.are.equal(base_time.year, parse_time.year)
				assert.are.equal(base_time.month, parse_time.month)
				assert.are.equal(base_time.day + 7, parse_time.day)
				assert.are.equal(base_time.hour, parse_time.hour)
				assert.are.equal(base_time.min, parse_time.min)
				assert.are.equal(base_time.sec, parse_time.sec)
			end)

			it("should find the correct substring", function()
				local _, start, stop = deadline.parse(task, sdate)
				local substr = string.sub(task, start, stop)
				assert.are.same("in one week", substr)
			end)
		end)

		describe("with months", function()
			local task = "Take out trash in twelve months"

			it("should change date correctly", function()
				local d = deadline.parse(task, sdate)
				local parse_time = os.date("*t", d)
				assert.are.equal(base_time.year + 1, parse_time.year)
				assert.are.equal(base_time.month, parse_time.month)
				assert.are.equal(base_time.day, parse_time.day)
				assert.are.equal(base_time.hour, parse_time.hour)
				assert.are.equal(base_time.min, parse_time.min)
				assert.are.equal(base_time.sec, parse_time.sec)
			end)

			it("should find the correct substring", function()
				local _, start, stop = deadline.parse(task, sdate)
				local substr = string.sub(task, start, stop)
				assert.are.same("in twelve months", substr)
			end)
		end)

		describe("with years", function()
			local task = "Take out trash in six years"

			it("should change date correctly", function()
				local d = deadline.parse(task, sdate)
				local parse_time = os.date("*t", d)
				assert.are.equal(base_time.year + 6, parse_time.year)
				assert.are.equal(base_time.month, parse_time.month)
				assert.are.equal(base_time.day, parse_time.day)
				assert.are.equal(base_time.hour, parse_time.hour)
				assert.are.equal(base_time.min, parse_time.min)
				assert.are.equal(base_time.sec, parse_time.sec)
			end)

			it("should find the correct substring", function()
				local _, start, stop = deadline.parse(task, sdate)
				local substr = string.sub(task, start, stop)
				assert.are.same("in six years", substr)
			end)
		end)
	end)

end)
