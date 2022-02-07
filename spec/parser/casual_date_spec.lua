local casual_date = require('todo-prompt.parser.casual_date')
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
	local d = casual_date.parse(task, date)
	local parse_time = os.date("*t", d)
	assert.are.equal(base_time.year, parse_time.year)
	assert.are.equal(base_time.month, parse_time.month)
	assert.are.equal(base_time.day, parse_time.day)
	assert.are.equal(base_time.hour, parse_time.hour)
	assert.are.equal(base_time.min, parse_time.min)
	assert.are.equal(base_time.sec, parse_time.sec)
end

describe("Casual date parser", function()
	describe("without any date", function()
		local task = "Take out trash"

		it("should not modify date", function()
			assert_unchanged_date(task, sdate)
		end)

		it("should not return substring indexes", function()
			local _, start, stop = casual_date.parse(task, sdate)
			assert.falsy(start)
			assert.falsy(stop)
		end)
	end)

	describe("with now", function()
		local task = "Take out trash now"

		it("should not modify date", function()
			assert_unchanged_date(task, sdate)
		end)

		it("should find the correct substring", function()
			local _, start, stop = casual_date.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same("now", substr)
		end)
	end)

	describe("with today", function()
		local task = "Take out trash today"

		it("should not modify date", function()
			assert_unchanged_date(task, sdate)
		end)

		it("should find the correct substring", function()
			local _, start, stop = casual_date.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same("today", substr)
		end)
	end)

	describe("with tonight", function()
		local task = "Take out trash tonight"

		it("should modify date correctly", function()
			local d = casual_date.parse(task, sdate)
			local parse_time = os.date("*t", d)
			assert.are.equal(base_time.year, parse_time.year)
			assert.are.equal(base_time.month, parse_time.month)
			assert.are.equal(base_time.day, parse_time.day)
			assert.are.equal(23, parse_time.hour)
			assert.are.equal(0, parse_time.min)
			assert.are.equal(0, parse_time.sec)
		end)

		it("should find the correct substring", function()
			local _, start, stop = casual_date.parse(task, sdate)
			local substr = string.sub(task, start, stop)
			assert.are.same("tonight", substr)
		end)
	end)

	for _, str in ipairs({"tomorrow", "tmr"}) do
		describe("with " .. str, function()
			local task = "Take out trash " .. str

			it("should modify date correctly", function()
				local d = casual_date.parse(task, sdate)
				local parse_time = os.date("*t", d)
				assert.are.equal(base_time.year, parse_time.year)
				assert.are.equal(base_time.month, parse_time.month)
				assert.are.equal(base_time.day+1, parse_time.day)
				assert.are.equal(base_time.hour, parse_time.hour)
				assert.are.equal(base_time.min, parse_time.min)
				assert.are.equal(base_time.sec, parse_time.sec)
			end)

			it("should find the correct substring", function()
				local _, start, stop = casual_date.parse(task, sdate)
				local substr = string.sub(task, start, stop)
				assert.are.same(str, substr)
			end)
		end)
	end
end)
