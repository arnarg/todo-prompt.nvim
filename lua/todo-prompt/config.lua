local config = {}

config.options = {
	prompt = "> ",
	width = "75%",
	position = "50%",
	_popup_options = {
		relative = "editor",
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
	},
}


function config.set_options(opts)
	config.options = vim.tbl_deep_extend("force", config.options, opts or {})

	-- configure user options into popup_options
	config.options._popup_options.size = config.options.width
	config.options._popup_options.position = config.options.position
end

return config
