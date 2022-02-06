local Input = require "nui.input"
local parser = require "todo-prompt.parser"

local popup_options = {
	position = "50%",
	relative = "editor",
	size = 65,
	border = {
		style = "rounded",
		text = {
			top = "[Add Task]",
			top_align = "center",
		},
	},
	win_options = {
		winhighlight = "Normal:Normal",
	},
}

local M = {}

M.AddTask = function(cb)
	local ns = vim.api.nvim_create_namespace("ToDoPrompt")
	local last_start = 0
	local last_stop = 0
	local prompt = "> "

	vim.api.nvim_command("hi ToDoPromptDate cterm=underline gui=underline")

	local input = Input(popup_options, {
		prompt = prompt,
		on_submit = function(val)
			if cb ~= nil then
				local out = parser.parse_task(val)
				cb(out.task, out.date)
			end
		end,
		on_change = function(val, b)
			local out = parser.parse_task(val)
			local start = out.start + #prompt
			local stop = out.stop + #prompt
			if start ~= last_start or stop ~= last_stop then
				vim.api.nvim_buf_clear_namespace(b, ns, 0, -1)
				vim.api.nvim_buf_add_highlight(b, ns, "ToDoPromptDate", 0, start, stop)
				last_start = start
				last_stop = stop
			end
		end,
	})
	input:mount()

	-- input:map("i", "<Esc>", input.input_props.on_close, { noremap = true })
end

return M
