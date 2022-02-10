local parser = require('todo-prompt.parser')
local config = require('todo-prompt.config')
local has_nui, Input = pcall(require, 'nui.input')
if not has_nui then
	error "This plugin requires nui.nvim (https://github.com/MunifTanjim/nui.nvim)."
end

local opts

local todo_prompt = {}

function todo_prompt.setup(custom_opts)
	config.set_options(custom_opts)
	opts = require('todo-prompt.config').options

	vim.cmd("command! ToDoPrompt lua require('todo-prompt').add_task()")
end

function todo_prompt.add_task(cb)
	if opts == nil then
		error "Setup has not been called."
	end

	local ns = vim.api.nvim_create_namespace("todo_prompt")
	local mark_id = 0
	local last_start = 0
	local last_stop = 0
	local prompt = "> "

	vim.api.nvim_command("hi todo_prompt_date cterm=underline gui=underline")
	vim.api.nvim_command("hi todo_prompt_extmark ctermfg=gray guifg=gray")

	local input = Input(opts._popup_options, {
		prompt = opts.prompt,
		on_submit = function(val)
			local task, date = parser.parse_task(val)
			if cb ~= nil then
				cb(task, date)
			elseif opts.callback ~= nil then
				opts.callback(task, date)
			end
		end,
		on_change = function(val, b)
			local d = os.time()
			local _, date, start, stop = parser.parse_task(val, d)
			start = start + #prompt
			stop = stop + #prompt
			-- matched indexes have changed
			if start ~= last_start or stop ~= last_stop then
				vim.api.nvim_buf_clear_namespace(b, ns, 0, -1)
				if start ~= stop then
					-- nvim must expect some different indexing because start is always
					-- off by one
					vim.api.nvim_buf_add_highlight(b, ns, "todo_prompt_date", 0, start-1, stop)
				end
				last_start = start
				last_stop = stop
			end
			-- parsed date is not the same as we passed to parse_task
			if date ~= d then
				mopts = {
					virt_text = {{os.date("%d/%m/%y %H:%M", date), "todo_prompt_extmark"}},
					virt_text_pos = "right_align",
					hl_mode = "blend",
				}
				if mark_id ~= 0 then
					mopts.id = mark_id
				end
				_id = vim.api.nvim_buf_set_extmark(b, ns, 0, 0, mopts)
				if mark_id == 0 then
					mark_id = _id
				end
			elseif date == d and mark_id ~= 0 then
				vim.api.nvim_buf_del_extmark(b, ns, mark_id)
				mark_id = 0
			end
		end,
	})
	input:mount()

	input:map("n", "<Esc>", input.input_props.on_close, { noremap = true })
end

return todo_prompt
